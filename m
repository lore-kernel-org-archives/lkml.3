Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114Ab3LFBIv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 20:08:51 -0500
Received: from mga09.intel.com ([134.134.136.24]:18515 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010Ab3LFBIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 20:08:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,837,1378882800"; 
   d="scan'208";a="439444421"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC: "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] SFI: fix compilation warnings
Thread-Topic: [PATCH] SFI: fix compilation warnings
Thread-Index: AQHO8d8+yYF2tylyh0GJxpNBoquqVZpFqw+AgACvotA=
Date: Fri, 6 Dec 2013 01:08:45 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E8802494B32@SHSMSX101.ccr.corp.intel.com>
References: <1386264397-27319-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <4771886.zcelg2hCiB@vostro.rjw.lan>
In-Reply-To: <4771886.zcelg2hCiB@vostro.rjw.lan>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rB618ss0013825

> From: Rafael J. Wysocki [mailto:rjw@rjwysocki.net]
> Sent: Friday, December 06, 2013 6:37 AM
> 
> On Thursday, December 05, 2013 07:26:37 PM Andy Shevchenko wrote:
> > When build kernel with make W=1 we get the following compiler error.
> >
> > In file included from drivers/sfi/sfi_acpi.c:66:0:
> > include/linux/sfi_acpi.h: In function â€˜acpi_sfi_table_parseâ€™:
> > include/linux/sfi_acpi.h:72:2: error: implicit declaration of function â€˜acpi_table_parseâ€™ [-Werror=implicit-function-declaration]
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

No, I think Andy's patch is wrong.
This warning is existing before merging my fixes.

Either we fix this warning or leave it as is.

To fix it, you need to add 1 line in sfi_acpi.h rather than change the line.
Let me post a fix for this.

Thanks
-Lv

> 
> Thanks!
> 
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
> --
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
