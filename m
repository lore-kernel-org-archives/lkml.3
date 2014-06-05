Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbaFEErI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:47:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:30947 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754088AbaFEErC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:47:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,978,1392192000"; 
   d="scan'208";a="522973823"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: Hanjun Guo <hanjun.guo@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "wsa@the-dreams.de" <wsa@the-dreams.de>,
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
Thread-Index: AQHPf+4KU6l0YPi7HkGxvvNa/8AWq5tgXPuAgAAEfoCAAVM9IP//rbuAgACOjqA=
Date: Thu, 5 Jun 2014 04:46:31 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E8802621528@SHSMSX101.ccr.corp.intel.com>
References: <1401883796-17841-1-git-send-email-lee.jones@linaro.org>
 <1401883796-17841-2-git-send-email-lee.jones@linaro.org>
 <3061297.feg5DGUjIt@vostro.rjw.lan> <20140604125137.GA18171@lee--X1>
 <1AE640813FDE7649BE1B193DEA596E880262042C@SHSMSX101.ccr.corp.intel.com>
 <538FEDE9.4010603@linaro.org>
In-Reply-To: <538FEDE9.4010603@linaro.org>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s554lILH023089

Hi, 

> From: Hanjun Guo [mailto:hanjun.guo@linaro.org]
> Sent: Thursday, June 05, 2014 12:11 PM
> To: Zheng, Lv; Lee Jones; Rafael J. Wysocki
> 
> On 2014-6-5 9:14, Zheng, Lv wrote:
> > Hi, Lee
> >
> >> From: Lee Jones [mailto:lee.jones@linaro.org]
> >> Sent: Wednesday, June 04, 2014 8:52 PM
> >> To: Rafael J. Wysocki
> >>
> >> On Wed, 04 Jun 2014, Rafael J. Wysocki wrote:
> >>
> >>> On Wednesday, June 04, 2014 01:09:50 PM Lee Jones wrote:
> >>>> Any drivers which support ACPI and Device Tree probing need to include
> >>>> both respective header files.  Without this patch, if a driver is being
> >>>> used on a platform which does not support ACPI and subsequently does not
> >>>> have the config option enabled, but includes linux/acpi.h the build
> >>>> breaks with:
> >>>>
> >>>>   In file included from ../include/acpi/platform/acenv.h:150:0,
> >>>>                    from ../include/acpi/acpi.h:56,
> >>>>                    from ../include/linux/match.h:2,
> >>>>                    from ../drivers/i2c/i2c-core.c:43:
> >>>>   ../include/acpi/platform/aclinux.h:73:23:
> >>>>    fatal error: asm/acenv.h: No such file or directory
> >>>>    #include <asm/acenv.h>
> >>>>                        ^
> >
> > Note that:
> > In our tree:
> > <asm/acenv.h> is only included by <acpi/acpi.h>.
> > And <acpi/acpi.h> is only included by
> > 1. <linux/acpi.h> when CONFIG_ACPI enabled
> > 2. <linux/sfi_acpi.h> - this is x86 specific, we'll clean it up by implementing stubs for all ACPI external interfaces.
> > So there is no case we need to exclude <asm/acenv.h> when CONFIG_ACPI is not enabled.
> >
> > I cannot find linux/match.h here.
> > If <linux/match.h> want to include ACPI features, it shouldn't include <acpi/acpi.h>, but should include <linux/acpi.h>.
> > Please refer to:
> > https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=8b48463f
> > And stop including <acpi/acpi.h> directly in any cases.
> 
> Ah, I agree, please ignore my previous email,
> sorry for the noise.
> 
> Since it is very important to include <linux/acpi.h> but not <acpi/acpi.h>,
> can we document it somewhere as the guidance? Then people will not
> make such mistake :)

After I test the ACPICA stubs and remove the only abnormal direct <acpi/acpi.h> inclusion from <linux/sfi_acpi.h>.
We could have a commit to add something like:

#ifndef _LINUX_ACPI_H
#error ....
#endif
To the <acpi/platform/aclinux.h> (the Linux OSL for ACPICA headers, it is included by <acpi/acpi.h>).
Hope this can be the hint to prevent future mistakes.

Thanks and best regards
-Lv


> 
> Thanks
> Hanjun

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
