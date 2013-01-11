Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317Ab3AKOWg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 09:22:36 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:47990 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313Ab3AKOWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 09:22:35 -0500
Date: Fri, 11 Jan 2013 06:23:13 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Ozan =?utf-8?B?w4dhxJ9sYXlhbg==?= <ozancag@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel driver vs libusb performance
Message-ID: <20130111142313.GA30912@kroah.com>
References: <CAFub=KQK9Qm1vDAetJc53O+mTZCgnaGDw9hYgeSZ76KCX_XSyQ@mail.gmail.com>
 <20130111134118.GB19224@kroah.com>
 <CAFub=KQuD_pBE-6yPV8dQOkbPC6ndi+6gO+MDJW+6iEPjZNBRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFub=KQuD_pBE-6yPV8dQOkbPC6ndi+6gO+MDJW+6iEPjZNBRw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2013 at 04:10:30PM +0200, Ozan Çağlayan wrote:
> > Ah, my sympathies, USB on a rpi is horrible, and you will have all sorts
> > of nasty issues, no matter how you end up doing this (in the kernel or
> > userspace).
> 
> What kind of issues? Currently I can read from the device without
> problem. But, I had very weird problems with 2 uvc cameras, you're
> right.

High cpu usage is one problem, and low overall USB bandwidth is another,
combined with slow response times.  The hardware really is bad for USB,
and the driver is a whole other beast, something that no one in the
community can, or will, touch at all.

> > Test it out and see.  I really don't think that user vs. kernel space is
> > going to be the issue here, I think you are going to see some very real
> > problems with the hardware itself in this area.
> >
> > Best of luck,
> 
> Well If I were you I would probably write that simple driver in a few
> hours but seen that I am not you, I wanted to learn will the effort
> worth the result :)

It all depends on what you want to do, but I really think that user vs.
kernelspace is not going to be the real problem here.  Start with libusb
and if you find that you are having problems, use 'perf' to see if the
kernel part is really the problem.  I think you will find all of your
time is going to be spent in the USB hardware itself, and the USB
driver, once you get the data out of that, user vs. kernel is not going
to be noticable at all.

Best of luck, and I bet you, in the end, you pick a better hardware
platform for your project (hint, go buy a Beaglebone, it actually works
and the tiny increase in cost more than makes up for the time you will
waste fighting the RPI hardware.)

greg k-h
