Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423438Ab3FUXuv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 19:50:51 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:43373 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423151Ab3FUXuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 19:50:50 -0400
Date: Sat, 22 Jun 2013 02:50:39 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH staging-next] zram: remove zram_sysfs file
Message-ID: <20130621235037.GA2191@swordfish>
References: <20130621152914.GA2371@swordfish.minsk.epam.com>
 <20130621221005.GA1842@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130621221005.GA1842@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (06/21/13 15:10), Greg Kroah-Hartman wrote:
> > Move zram sysfs code to zram drv and remove zram_sysfs file.
> > This gives ability to make static a number of previously exported
> > zram functions, used from zram sysfs, e.g. internal zram
> > zram_meta_alloc/free(). We also can drop several zram_drv wrapper
> > functions, used from zram sysfs:
> > e.g. zram_reset_device()/__zram_reset_device() pair.
> > 
> > Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> > 
> > ---
> >  drivers/staging/zram/Makefile     |   2 +-
> >  drivers/staging/zram/zram_drv.c   | 524 +++++++++++++++++++++++++-------------
> >  drivers/staging/zram/zram_drv.h   |  10 -
> >  drivers/staging/zram/zram_sysfs.c | 209 ---------------
> >  4 files changed, 354 insertions(+), 391 deletions(-)
> > 
> > diff --git a/drivers/staging/zram/Makefile b/drivers/staging/zram/Makefile
> > index 7f4a301..cb0f9ce 100644
> > --- a/drivers/staging/zram/Makefile
> > +++ b/drivers/staging/zram/Makefile
> > @@ -1,3 +1,3 @@
> > -zram-y	:=	zram_drv.o zram_sysfs.o
> > +zram-y	:=	zram_drv.o
> >  
> >  obj-$(CONFIG_ZRAM)	+=	zram.o
> > diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
> > index ec2b2b5..f32fcca 100644
> > --- a/drivers/staging/zram/zram_drv.c
> > +++ b/drivers/staging/zram/zram_drv.c
> > @@ -42,6 +42,111 @@ static struct zram *zram_devices;
> >  /* Module params (documentation at end) */
> >  static unsigned int num_devices = 1;
> >  
> > +module_param(num_devices, uint, 0);
> > +MODULE_PARM_DESC(num_devices, "Number of zram devices");
> > +
> > +MODULE_LICENSE("Dual BSD/GPL");
> > +MODULE_AUTHOR("Nitin Gupta <ngupta@vflare.org>");
> > +MODULE_DESCRIPTION("Compressed RAM Block Device");
> 
> This is usually best put at the bottom of the file, not at the top.
> 
> Why did you move it?
> 

Hello Greg,
That's a good question, thanks. I was pretty sure that such information
is usually put at the top of the file. At least what I saw (to name a
few)

 arch/ia64/kernel/salinfo.c
 drivers/ata/ata_piix.c
 drivers/ata/ata_generic.c
 drivers/ata/libata-core.c
[..]

MODULE_LICENSE and MODULE_AUTHOR are at the top. Of course I can move
it back to original place, will resend soon.

	-ss

> thanks,
> 
> greg k-h
> 
