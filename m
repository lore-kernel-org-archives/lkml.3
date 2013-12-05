Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825Ab3LEW16 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 17:27:58 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:51093 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750877Ab3LEW15 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 17:27:57 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        linux-acpi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] SFI: fix compilation warnings
Date: Thu, 05 Dec 2013 23:40:57 +0100
Message-ID: <2894493.n5DTvIrPJs@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <4771886.zcelg2hCiB@vostro.rjw.lan>
References: <1386264397-27319-1-git-send-email-andriy.shevchenko@linux.intel.com> <4771886.zcelg2hCiB@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 05, 2013 11:36:37 PM Rafael J. Wysocki wrote:
> On Thursday, December 05, 2013 07:26:37 PM Andy Shevchenko wrote:
> > When build kernel with make W=1 we get the following compiler error.
> > 
> > In file included from drivers/sfi/sfi_acpi.c:66:0:
> > include/linux/sfi_acpi.h: In function ‘acpi_sfi_table_parse’:
> > include/linux/sfi_acpi.h:72:2: error: implicit declaration of function ‘acpi_table_parse’ [-Werror=implicit-function-declaration]
> >   if (!acpi_table_parse(signature, handler))
> >   ^
> >   cc1: some warnings being treated as errors
> > 
> > The patch changes acpi/acpi.h inclusion to linux/acpi.h.
> > 
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> 
> OK
> 
> Lv, I'm dropping your patch cleaning up the inclusions, please sort that thing
> out entirely for the next cycle.

Or rather I'll keep it in bleeding-edge and wait for follow-up patches to
fix build problems like this one (then we can merge it into 3.14 hopefully).

Thanks!

> > ---
> >  drivers/sfi/sfi_acpi.c   | 2 +-
> >  include/linux/sfi_acpi.h | 2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/sfi/sfi_acpi.c b/drivers/sfi/sfi_acpi.c
> > index 0c9f419..d4dfcbe 100644
> > --- a/drivers/sfi/sfi_acpi.c
> > +++ b/drivers/sfi/sfi_acpi.c
> > @@ -60,7 +60,7 @@
> >  #define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
> >  
> >  #include <linux/kernel.h>
> > -#include <acpi/acpi.h>	/* FIXME: inclusion should be removed */
> > +#include <linux/acpi.h>
> >  
> >  #include <linux/sfi.h>
> >  #include <linux/sfi_acpi.h>
> > diff --git a/include/linux/sfi_acpi.h b/include/linux/sfi_acpi.h
> > index 2cfcb79..c9cab82 100644
> > --- a/include/linux/sfi_acpi.h
> > +++ b/include/linux/sfi_acpi.h
> > @@ -60,7 +60,7 @@
> >  #define _LINUX_SFI_ACPI_H
> >  
> >  #ifdef CONFIG_SFI
> > -#include <acpi/acpi.h>	/* FIXME: inclusion should be removed */
> > +#include <linux/acpi.h>
> >  
> >  extern int sfi_acpi_table_parse(char *signature, char *oem_id,
> >  				char *oem_table_id,
> > 
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
