Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450AbaFEBCH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 21:02:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:58108 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121AbaFEBCF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 21:02:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,976,1392192000"; 
   d="scan'208";a="551781963"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Lee Jones <lee.jones@linaro.org>
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
Thread-Index: AQHPf+4KU6l0YPi7HkGxvvNa/8AWq5tgXPuAgAAEfoCAAJC1gIAAwBvg
Date: Thu, 5 Jun 2014 01:01:17 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E88026203F6@SHSMSX101.ccr.corp.intel.com>
References: <1401883796-17841-1-git-send-email-lee.jones@linaro.org>
 <3061297.feg5DGUjIt@vostro.rjw.lan> <20140604125137.GA18171@lee--X1>
 <1603851.9SBouhvdWS@vostro.rjw.lan>
In-Reply-To: <1603851.9SBouhvdWS@vostro.rjw.lan>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s5512G3b021251

Hi,

> From: linux-i2c-owner@vger.kernel.org [mailto:linux-i2c-owner@vger.kernel.org] On Behalf Of Rafael J. Wysocki
> Sent: Thursday, June 05, 2014 5:30 AM
> 
> On Wednesday, June 04, 2014 01:51:37 PM Lee Jones wrote:
> > On Wed, 04 Jun 2014, Rafael J. Wysocki wrote:
> >
> > > On Wednesday, June 04, 2014 01:09:50 PM Lee Jones wrote:
> > > > Any drivers which support ACPI and Device Tree probing need to include
> > > > both respective header files.  Without this patch, if a driver is being
> > > > used on a platform which does not support ACPI and subsequently does not
> > > > have the config option enabled, but includes linux/acpi.h the build
> > > > breaks with:
> > > >
> > > >   In file included from ../include/acpi/platform/acenv.h:150:0,
> > > >                    from ../include/acpi/acpi.h:56,
> > > >                    from ../include/linux/match.h:2,
> > > >                    from ../drivers/i2c/i2c-core.c:43:
> > > >   ../include/acpi/platform/aclinux.h:73:23:
> > > >    fatal error: asm/acenv.h: No such file or directory
> > > >    #include <asm/acenv.h>
> > > >                        ^
> > >
> > > Which kernel does this happen with?
> >
> > a0a962d (tag: refs/tags/next-20140602, refs/remotes/next/master)
> >   Add linux-next specific files for 20140602
> 
> It looks like the problem is with include/linux/match.h that should not
> include acpi/acpi.h directly.

This is another example that many mis-ordered inclusions are caused by the mis-ordered <asm/acpi.h> inclusion.

> 
> But I can't find this file in the Linus' next branch even, so I guess it's
> on its way to that branch?
> 

I guess,
In their tree, they have CONFIG_ACPI enabled for ARM, but we've changed to make:
1. <asm/acenv.h> the architecture specific layer for ACPICA, and
2. <asm/acpi.h> is now the architecture specific layer for Linux ACPI.
So they need to follow this.

Thanks and best regards
-Lv

> Rafael
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-i2c" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
