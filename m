Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758741Ab3BKSOc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 13:14:32 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:57598 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758709Ab3BKSOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 13:14:31 -0500
Date: Mon, 11 Feb 2013 10:14:28 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: devel <devel@driverdev.osuosl.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: Remove unnecessary OOM messages
Message-ID: <20130211181428.GA21288@kroah.com>
References: <1360604489.2028.25.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360604489.2028.25.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 09:41:29AM -0800, Joe Perches wrote:
> alloc failures already get standardized OOM
> messages and a dump_stack.
> 
> For the affected mallocs around these OOM messages:
> 
> Converted kzallocs with multiplies to kcalloc.
> Converted kmallocs with multiplies to kmalloc_array.
> Converted a kmalloc/strlen/strncpy to kstrdup.
> Moved a spin_lock below a removed OOM message and
> removed a now unnecessary spin_unlock.
> Neatened alignment and whitespace.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/staging/asus_oled/asus_oled.c              | 15 ++-----
>  drivers/staging/bcm/InterfaceInit.c                | 14 ++----
>  drivers/staging/ced1401/usb1401.c                  |  4 +-
>  drivers/staging/comedi/drivers.c                   |  5 +--
>  drivers/staging/comedi/drivers/amplc_dio200.c      |  9 ++--
>  drivers/staging/comedi/drivers/comedi_bond.c       |  5 +--
>  drivers/staging/comedi/drivers/dt9812.c            |  5 +--
>  drivers/staging/comedi/drivers/ni_labpc.c          | 10 ++---
>  drivers/staging/comedi/drivers/pcmuio.c            | 11 ++---
>  drivers/staging/comedi/drivers/unioxx5.c           |  6 +--
>  drivers/staging/comedi/drivers/usbdux.c            | 27 ++----------
>  drivers/staging/comedi/drivers/usbduxfast.c        |  6 ---
>  drivers/staging/comedi/drivers/usbduxsigma.c       | 31 +++----------
>  drivers/staging/cptm1217/clearpad_tm1217.c         |  5 +--
>  drivers/staging/et131x/et131x.c                    | 20 +++------
>  drivers/staging/frontier/alphatrack.c              | 51 +++++++++-------------
>  drivers/staging/frontier/tranzport.c               | 26 +++++------
>  drivers/staging/ft1000/ft1000-usb/ft1000_usb.c     |  5 +--
>  drivers/staging/gdm72xx/gdm_sdio.c                 |  8 +---
>  drivers/staging/gdm72xx/sdio_boot.c                |  9 +---
>  drivers/staging/gdm72xx/usb_boot.c                 |  8 +---
>  drivers/staging/iio/accel/lis3l02dq_ring.c         |  5 +--
>  drivers/staging/keucr/usb.c                        |  5 +--
>  drivers/staging/line6/driver.c                     | 25 ++---------
>  drivers/staging/line6/pcm.c                        |  6 ---
>  drivers/staging/media/as102/as102_usb_drv.c        |  4 +-
>  drivers/staging/media/go7007/go7007-fw.c           | 24 +++-------
>  drivers/staging/media/go7007/s2250-loader.c        |  5 +--
>  drivers/staging/media/lirc/lirc_imon.c             |  3 --
>  drivers/staging/media/lirc/lirc_sasem.c            |  6 ---

I cut the drivers/staging/media/* patches out of this larger patch as
those need to go through Mauro's tree, not mine (they also don't apply
to mine because of that.)

thanks,

greg k-h
