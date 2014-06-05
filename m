Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbaFEA45 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:56:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:14361 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829AbaFEA4z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 20:56:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,976,1392192000"; 
   d="scan'208";a="551780284"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "wsa@the-dreams.de" <wsa@the-dreams.de>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "devel@acpica.org" <devel@acpica.org>
Subject: RE: [PATCH 1/7] ACPICA: Only include ACPI asm files if ACPI is
 enabled
Thread-Topic: [PATCH 1/7] ACPICA: Only include ACPI asm files if ACPI is
 enabled
Thread-Index: AQHPf+4KU6l0YPi7HkGxvvNa/8AWq5thsJEw
Date: Thu, 5 Jun 2014 00:56:51 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E88026203D0@SHSMSX101.ccr.corp.intel.com>
References: <1401883796-17841-1-git-send-email-lee.jones@linaro.org>
 <1401883796-17841-2-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1401883796-17841-2-git-send-email-lee.jones@linaro.org>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Lee

> From: Lee Jones [mailto:lee.jones@linaro.org]
> Sent: Wednesday, June 04, 2014 8:10 PM
> 
> Any drivers which support ACPI and Device Tree probing need to include
> both respective header files.  Without this patch, if a driver is being
> used on a platform which does not support ACPI and subsequently does not
> have the config option enabled, but includes linux/acpi.h the build
> breaks with:
> 
>   In file included from ../include/acpi/platform/acenv.h:150:0,
>                    from ../include/acpi/acpi.h:56,
>                    from ../include/linux/match.h:2,
>                    from ../drivers/i2c/i2c-core.c:43:
>   ../include/acpi/platform/aclinux.h:73:23:
>    fatal error: asm/acenv.h: No such file or directory
>    #include <asm/acenv.h>
>                        ^
> Cc: Lv Zheng <lv.zheng@intel.com>
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Cc: linux-acpi@vger.kernel.org
> Cc: devel@acpica.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  include/acpi/platform/aclinux.h | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/include/acpi/platform/aclinux.h b/include/acpi/platform/aclinux.h
> index cd1f052..fdf7663 100644
> --- a/include/acpi/platform/aclinux.h
> +++ b/include/acpi/platform/aclinux.h
> @@ -70,9 +70,10 @@
>  #ifdef EXPORT_ACPI_INTERFACES
>  #include <linux/export.h>
>  #endif
> -#include <asm/acenv.h>
> 
> -#ifndef CONFIG_ACPI
> +#ifdef CONFIG_ACPI
> +#include <asm/acenv.h>
> +#else

This is exactly what I want to do in the next step.
But you are a bit faster here.
I believe:
The miss-ordered inclusions of <asm/acpi.h> is the culprit of all of the miss-ordered inclusions in arch/x86/include/asm.
You should have noted that <asm/acpi.h> was originally unexpected included by some x86 specific headers.
Simply doing <asm/acenv.h> exlusion in this way might be able to fix your issue for your architecture, but it could be very likely breaking x86 builds.
You might be able to find another way to solve your build issue - for example, creating an empty <asm/acenv.h> for arch/arm.

Thanks and best regards
-Lv

> 
>  /* External globals for __KERNEL__, stubs is needed */
> 
> --
> 1.8.3.2

