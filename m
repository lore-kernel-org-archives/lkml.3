Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994Ab3LJBbL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 20:31:11 -0500
Received: from mga14.intel.com ([143.182.124.37]:35625 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992Ab3LJBbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 20:31:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,861,1378882800"; 
   d="scan'208";a="441373288"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-acpi @ vger . kernel . org" <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] SFI: fix compilation warnings
Thread-Topic: [PATCH v2] SFI: fix compilation warnings
Thread-Index: AQHO9L54/JL6fa5i6Eyqhkbdmc6PdJpMpBHQ
Date: Tue, 10 Dec 2013 01:30:58 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E88024969FB@SHSMSX101.ccr.corp.intel.com>
References: <1386580161-27718-1-git-send-email-andriy.shevchenko@linux.intel.com>
In-Reply-To: <1386580161-27718-1-git-send-email-andriy.shevchenko@linux.intel.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rBA1VGgD010133

Hi, Andy

IMO:
1. sfi_acpi.h should include both <linux/acpi.h> and <linux/sfi.h> and it should include <acpi/acpi.h> for !CONFIG_ACPI builds.
2. then we should include sfi_acpi.h instead of <linux/acpi.h>, <linux/sfi.h> and <acpi/acpi.h> for all of its users.

I think the patch in the linux-pm/bleeding-edge queue can fix the issue you've reported:
https://git.kernel.org/cgit/linux/kernel/git/rafael/linux-pm.git/commit/?h=bleeding-edge&id=c099eacbcaec4475936fbf73e499507728ce47e1

I made it a part of my header cleanup series.
The story can be found in this mailing list thread:
http://www.spinics.net/lists/linux-acpi/msg47510.html

Thanks and best regards
-Lv


> -----Original Message-----
> From: Andy Shevchenko [mailto:andriy.shevchenko@linux.intel.com]
> Sent: Monday, December 09, 2013 5:09 PM
> To: Wysocki, Rafael J; linux-acpi @ vger . kernel . org; LKML; Zheng, Lv
> Cc: Andy Shevchenko
> Subject: [PATCH v2] SFI: fix compilation warnings
> 
> When build kernel with make W=1 we get the following compiler error.
> 
> In file included from drivers/sfi/sfi_acpi.c:66:0:
> include/linux/sfi_acpi.h: In function â€˜acpi_sfi_table_parseâ€™:
> include/linux/sfi_acpi.h:72:2: error: implicit declaration of function â€˜acpi_table_parseâ€™ [-Werror=implicit-function-declaration]
>   if (!acpi_table_parse(signature, handler))
>   ^
>   cc1: some warnings being treated as errors
> 
> The patch add linux/acpi.h to the top of file.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
> Changes to v2:
> - fix for build when ACPI=n, SFI=y
>  drivers/sfi/sfi_acpi.c   | 2 +-
>  include/linux/sfi_acpi.h | 4 +++-
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/sfi/sfi_acpi.c b/drivers/sfi/sfi_acpi.c
> index 5e753d7..5589ec5 100644
> --- a/drivers/sfi/sfi_acpi.c
> +++ b/drivers/sfi/sfi_acpi.c
> @@ -60,7 +60,7 @@
>  #define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
> 
>  #include <linux/kernel.h>
> -#include <acpi/acpi.h>	/* FIXME: inclusion should be removed */
> +#include <linux/acpi.h>
> 
>  #include <linux/sfi.h>
>  #include "sfi_core.h"
> diff --git a/include/linux/sfi_acpi.h b/include/linux/sfi_acpi.h
> index 2cfcb79..ecc2344 100644
> --- a/include/linux/sfi_acpi.h
> +++ b/include/linux/sfi_acpi.h
> @@ -60,7 +60,9 @@
>  #define _LINUX_SFI_ACPI_H
> 
>  #ifdef CONFIG_SFI
> -#include <acpi/acpi.h>	/* FIXME: inclusion should be removed */
> +
> +#include <acpi/acpi.h>
> +#include <linux/acpi.h>
> 
>  extern int sfi_acpi_table_parse(char *signature, char *oem_id,
>  				char *oem_table_id,
> --
> 1.8.4.4

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
