Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932257Ab3J1XKa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 19:10:30 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:50811 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932207Ab3J1XK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 19:10:28 -0400
Date: Mon, 28 Oct 2013 16:10:26 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/8] watchdog: w83627hf: Convert to watchdog
 infrastructure
Message-ID: <20131028231026.GA16758@roeck-us.net>
References: <1376773126-2717-1-git-send-email-linux@roeck-us.net>
 <1376773126-2717-2-git-send-email-linux@roeck-us.net>
 <20131028215755.GA13226@spo001.leaseweb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131028215755.GA13226@spo001.leaseweb.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 10:57:55PM +0100, Wim Van Sebroeck wrote:
> Hi Guenter,
> 
> > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > ---
> >  drivers/watchdog/Kconfig        |    1 +
> >  drivers/watchdog/w83627hf_wdt.c |  225 +++++++++------------------------------
> >  2 files changed, 51 insertions(+), 175 deletions(-)
> > 
> > diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
> > index 362085d..c73db85 100644
> > --- a/drivers/watchdog/Kconfig
> > +++ b/drivers/watchdog/Kconfig
> > @@ -858,6 +858,7 @@ config VIA_WDT
> >  config W83627HF_WDT
> >  	tristate "W83627HF/W83627DHG Watchdog Timer"
> >  	depends on X86
> > +	select WATCHDOG_CORE
> >  	---help---
> >  	  This is the driver for the hardware watchdog on the W83627HF chipset
> >  	  as used in Advantech PC-9578 and Tyan S2721-533 motherboards
> > diff --git a/drivers/watchdog/w83627hf_wdt.c b/drivers/watchdog/w83627hf_wdt.c
> > index 92f1326..51a22ab 100644
> > --- a/drivers/watchdog/w83627hf_wdt.c
> > +++ b/drivers/watchdog/w83627hf_wdt.c
> > @@ -1,6 +1,9 @@
> >  /*
> >   *	w83627hf/thf WDT driver
> >   *
> > + *	(c) Copyright 2013 Guenter Roeck
> > + *		converted to watchdog infrastructure
> > + *
> >   *	(c) Copyright 2007 Vlad Drukker <vlad@storewiz.com>
> >   *		added support for W83627THF.
> >   *
> > @@ -31,42 +34,27 @@
> >  #include <linux/module.h>
> >  #include <linux/moduleparam.h>
> >  #include <linux/types.h>
> > -#include <linux/miscdevice.h>
> >  #include <linux/watchdog.h>
> > -#include <linux/fs.h>
> >  #include <linux/ioport.h>
> >  #include <linux/notifier.h>
> >  #include <linux/reboot.h>
> >  #include <linux/init.h>
> > -#include <linux/spinlock.h>
> >  #include <linux/io.h>
> > -#include <linux/uaccess.h>
> > -
> >  
> >  #define WATCHDOG_NAME "w83627hf/thf/hg/dhg WDT"
> >  #define WATCHDOG_TIMEOUT 60		/* 60 sec default timeout */
> >  
> > -static unsigned long wdt_is_open;
> > -static char expect_close;
> > -static DEFINE_SPINLOCK(io_lock);
> > -
> >  /* You must set this - there is no sane way to probe for this board. */
> >  static int wdt_io = 0x2E;
> >  module_param(wdt_io, int, 0);
> >  MODULE_PARM_DESC(wdt_io, "w83627hf/thf WDT io port (default 0x2E)");
> >  
> > -static int timeout = WATCHDOG_TIMEOUT;	/* in seconds */
> > +static int timeout;			/* in seconds */
> >  module_param(timeout, int, 0);
> >  MODULE_PARM_DESC(timeout,
> >  		"Watchdog timeout in seconds. 1 <= timeout <= 255, default="
> >  				__MODULE_STRING(WATCHDOG_TIMEOUT) ".");
> >  
> > -static bool nowayout = WATCHDOG_NOWAYOUT;
> > -module_param(nowayout, bool, 0);
> > -MODULE_PARM_DESC(nowayout,
> > -		"Watchdog cannot be stopped once started (default="
> > -				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
> > -
> 
> Why do you remove the nowayout module param?
> 
Hi Wim,

sorry, that is too long ago. I simply don't remember what drove me to do that.
Looking at other drivers, that doesn't seem to make much sense, does it ?

I'll be happy to resubmit the patch with the parameter restored, or submit
a patch on top of it to restore it. Please let me know what you prefer.

Thanks,
Guenter
