Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab3AKOp7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 09:45:59 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:45193 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341Ab3AKOp6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 09:45:58 -0500
X-Greylist: delayed 341 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Jan 2013 09:45:58 EST
MIME-Version: 1.0
In-Reply-To: <20130111142313.GA30912@kroah.com>
References: <CAFub=KQK9Qm1vDAetJc53O+mTZCgnaGDw9hYgeSZ76KCX_XSyQ@mail.gmail.com>
	<20130111134118.GB19224@kroah.com>
	<CAFub=KQuD_pBE-6yPV8dQOkbPC6ndi+6gO+MDJW+6iEPjZNBRw@mail.gmail.com>
	<20130111142313.GA30912@kroah.com>
Date: Fri, 11 Jan 2013 16:40:06 +0200
Message-ID: <CAFub=KQLGgORnfjUga2jBGmGTg2hRQPNDJZ+u7PQRFPKJJH4Dg@mail.gmail.com>
Subject: Re: Kernel driver vs libusb performance
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozancag@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It all depends on what you want to do, but I really think that user vs.
> kernelspace is not going to be the real problem here.  Start with libusb
> and if you find that you are having problems, use 'perf' to see if the
> kernel part is really the problem.  I think you will find all of your
> time is going to be spent in the USB hardware itself, and the USB
> driver, once you get the data out of that, user vs. kernel is not going
> to be noticable at all.
>
> Best of luck, and I bet you, in the end, you pick a better hardware
> platform for your project (hint, go buy a Beaglebone, it actually works
> and the tiny increase in cost more than makes up for the time you will
> waste fighting the RPI hardware.)

My mainloop is sth like this actually:

(I never thought of multi-processing & multi-threading but I may give
a chance on cooperative multitasking using Python greenlets)

1. [Simultaneously]
  {Fetch 32bytes in 128Hz + Decrypt + Queue them} AND
  {Flicker 2 LEDs with 10Hz/7.5Hz respectively using GPIO}
    (This is the step I'm afraid off, I expect jitters of course but
up to a limit. I also think about trying RT-patched kernel if that
will help at all...)

2. Take FFT of the signal queued using SciPy (I timed this: It takes
230~ uS for FFT of 128 integers on Rpi)

3. Do some simple math on FFT'ed signal &&
    Send a command to another device over a USB-FTDI channel if some
threshold is attained.

You are right that Beaglebone brings a huge improvement with
acceptable increase in the price but what I'm trying to do is to show
people that
"Hey what you are doing on your decent 1000$ i7 desktop with Matlab
over Windows works on my 30$ Linux box using Python" and that is
exactly why I'm pushing the limits of the device.

Thank you very much :)

-- 
Ozan Çağlayan
Research Assistant
Galatasaray University - Computer Engineering Dept.
http://www.ozancaglayan.com
