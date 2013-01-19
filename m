Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560Ab3ASArh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 19:47:37 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:45565 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab3ASArg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 19:47:36 -0500
Date: Fri, 18 Jan 2013 16:47:32 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>, Peter Korsgaard <jacmet@sunsite.dk>,
        Alan Cox <alan@linux.intel.com>,
        Preston Fick <preston.fick@silabs.com>
Subject: Re: 3.7.3, ttyUSB0 serial problem - devices stop working and only
 reboot helps (Inappropriate ioctl for device)
Message-ID: <20130119004732.GA32311@kroah.com>
References: <201301182328.43455.a.miskiewicz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201301182328.43455.a.miskiewicz@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 11:28:43PM +0100, Arkadiusz Miskiewicz wrote:
> Hi.
> 
> Using 3.7.3 kernel and connecting two rs232 usb adapters, CP2102 and FT232RL, 
> one after disconnecting another.
> 
> After few cycles of reconnecting and using socat (below) I'm getting problems 
> accessing ttyUSB0:
> ioctl(3, SNDCTL_TMR_TIMEBASE or SNDRV_TIMER_IOCTL_NEXT_DEVICE or TCGETS, 
> 0x7fffb70c6ae0) = -1 ENOTTY (Inappropriate ioctl for device)
> 
> Unloading and reloading (by udev) modules ftdio_sio, cp210x, usbserial doesn't 
> help. I have to reboot to get ttyUSB0 working (regardless of which driver, 
> ftdio_sio or cp210x is handling ttyUSB0 - both stop working).
> 
> Any clues?

The kernel log shows the device getting removed a bunch and then coming
back, which implies electrical issues (flaky connection, low power,
etc.)  Are you really removing it and plugging it back in?  Or is it
doing it all by itself?

Can you try better cables?

thanks,

greg k-h
