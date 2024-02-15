close all
clear all
clc

pkg load signal
pkg load audio

frecs = [82.41,110,146.83,196,246.94,329.63];
names = ['6ta(E)';'5ta(A)';'4ta(D)';'3ra(G)';'2da(B)';'1ra(E)'];

for i = 1:6

  istune = false;
  while (istune == false)

    h = msgbox ([names(i,:) ': ' num2str(frecs(i)) 'Hz'], 'Afina');
    pause (1.5);
    close(h);
    Fs = 44000;
    y = record(3.5, Fs);

    L = length(y)-1;
    t = (0:L)/Fs;

    Y = fft(y);
    Y = abs(Y(1:frecs(i)*1.5*L/Fs));
    Y = Y/max(Y);
    f = Fs*(1:frecs(i)*1.5*L/Fs)/(L-1);
    [pks,loc]  = findpeaks(Y,"MinPeakHeight",0.2,"MinPeakDistance",round(frecs(i)/2));

    [p l] = max(pks);
    tune = Fs*loc(l)/(L-1);
    tol= 0.5;
    minim = frecs(i)-tol;
    maxim = frecs(i)+tol;

##    figure(i); hold on;
##    plot(f,Y,'b');
##    plot(Fs*loc/(L-1),pks,"g*");

    if (tune >= minim && tune <= maxim)
      istune=true;
      h = msgbox (['Listo! FRECUENCIA: ' num2str(tune)], 'Afinado');
      pause (1.5);
      close(h);
    elseif (tune < minim)
      e = fix((frecs(i)-tune)/0.25);
      h = msgbox (['Tensa mas!- ' num2str(e)], [num2str(frecs(i)) 'Hz'])
      pause (1.5);
      close(h);

    else

      e = fix((tune-frecs(i))/0.25);
      h = msgbox (['Tensa menos!+ ' num2str(e)], [num2str(frecs(i)) 'Hz'])
      pause (2);
      close(h);

    endif
  endwhile
endfor
