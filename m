Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184AbaJUKaR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 06:30:17 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:50968 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412AbaJUKaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 06:30:14 -0400
Date: Tue, 21 Oct 2014 11:30:07 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Johan Hovold <johan@kernel.org>
Cc: Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Alan Cox <gnomes@lxorguk.ukuu.org.uk>,
        Alexander Graf <agraf@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Heiko Stuebner <heiko@sntech.de>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>,
        Philippe =?iso-8859-1?Q?R=E9tornaz?= 
	<philippe.retornaz@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Romain Perier <romain.perier@gmail.com>
Subject: Re: [PATCH v2 01/47] kernel: Add support for poweroff handler call
 chain
Message-ID: <20141021103007.GI26842@x1>
References: <1413864783-3271-1-git-send-email-linux@roeck-us.net>
 <1413864783-3271-2-git-send-email-linux@roeck-us.net>
 <20141021093405.GA2113@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141021093405.GA2113@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Oct 2014, Johan Hovold wrote:

> On Mon, Oct 20, 2014 at 09:12:17PM -0700, Guenter Roeck wrote:
> 
> > v2:
> > - poweroff -> power_off
> 
> Do you want to stick to power[-_ ]off consistently throughout?

I guess you'll want to fix all of these before I review the MFD
patches?

> > - Add defines for default priorities
> > - Use raw notifiers protected by spinlocks instead of atomic notifiers
> > - Add register_poweroff_handler_simple
> > - Add devm_register_power_off_handler
> > 
> >  include/linux/pm.h              |  22 ++++
> >  kernel/power/Makefile           |   1 +
> >  kernel/power/poweroff_handler.c | 252 ++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 275 insertions(+)
> >  create mode 100644 kernel/power/poweroff_handler.c
> > 
> > diff --git a/include/linux/pm.h b/include/linux/pm.h
> > index 383fd68..7e0cb36 100644
> > --- a/include/linux/pm.h
> > +++ b/include/linux/pm.h
> > @@ -34,7 +34,29 @@
> >  extern void (*pm_power_off)(void);
> >  extern void (*pm_power_off_prepare)(void);
> >  
> > +/*
> > + * Callbacks to manage poweroff handlers
> 
> power-off

power_off, no?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
