Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751748Ab3ASISp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 03:18:45 -0500
Received: from mail-ea0-f179.google.com ([209.85.215.179]:34136 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545Ab3ASISn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 03:18:43 -0500
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Subject: Re: 3.7.3, ttyUSB0 serial problem - devices stop working and only reboot helps (Inappropriate ioctl for device)
Date: Sat, 19 Jan 2013 09:18:36 +0100
User-Agent: KMail/1.13.7 (Linux/3.7.3; KDE/4.9.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>, Peter Korsgaard <jacmet@sunsite.dk>,
        Alan Cox <alan@linux.intel.com>,
        Preston Fick <preston.fick@silabs.com>
References: <201301182328.43455.a.miskiewicz@gmail.com> <20130119004732.GA32311@kroah.com>
In-Reply-To: <20130119004732.GA32311@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201301190918.37001.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 19 of January 2013, Greg Kroah-Hartman wrote:
> On Fri, Jan 18, 2013 at 11:28:43PM +0100, Arkadiusz Miskiewicz wrote:
> > Hi.
> > 
> > Using 3.7.3 kernel and connecting two rs232 usb adapters, CP2102 and
> > FT232RL, one after disconnecting another.
> > 
> > After few cycles of reconnecting and using socat (below) I'm getting
> > problems accessing ttyUSB0:
> > ioctl(3, SNDCTL_TMR_TIMEBASE or SNDRV_TIMER_IOCTL_NEXT_DEVICE or TCGETS,
> > 0x7fffb70c6ae0) = -1 ENOTTY (Inappropriate ioctl for device)
> > 
> > Unloading and reloading (by udev) modules ftdio_sio, cp210x, usbserial
> > doesn't help. I have to reboot to get ttyUSB0 working (regardless of
> > which driver, ftdio_sio or cp210x is handling ttyUSB0 - both stop
> > working).
> > 
> > Any clues?
> 
> The kernel log shows the device getting removed a bunch and then coming
> back, which implies electrical issues (flaky connection, low power,
> etc.)  Are you really removing it and plugging it back in?  Or is it
> doing it all by itself?

I was doing plug in CP2102, remove it, plug in FT232RL after few seconds, 
remove it, plug in CP... (and various variations, several times) and testing 
with socat before removing devices. After some iteration the problem appears 
and only reboot helps.




Reproducible. suspend to ram/resume cycle didn't change anything, device still 
has a problem, even after reconnection of device.

> 
> thanks,
> 
> greg k-h


-- 
Arkadiusz Miśkiewicz, arekm / maven.pl
