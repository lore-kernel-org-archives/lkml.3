Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716AbaBQEni (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 23:43:38 -0500
Received: from fallback1.mail.ru ([94.100.176.18]:45715 "EHLO
	fallback1.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbaBQEng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 23:43:36 -0500
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?UGF1bCBCb2xsZQ==?= <pebolle@tiscali.nl>
Cc: =?UTF-8?B?UnVzc2VsbCBLaW5n?= <linux@arm.linux.org.uk>,
        =?UTF-8?B?UmljaGFyZCBXZWluYmVyZ2Vy?= <richard@nod.at>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?B?U2FzY2hhIEhhdWVy?= <kernel@pengutronix.de>,
        =?UTF-8?B?U2hhd24gR3Vv?= <shawn.guo@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: =?UTF-8?B?UmU6IFtQQVRDSF0gYXJtOiBpbXg6IHJlbW92ZSBNQUNIX01YTEFEUw==?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [188.134.40.128]
Date: Mon, 17 Feb 2014 08:43:07 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1392612187.657010375@f87.i.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Mras: Ok
X-Spam: undefined
In-Reply-To: <1392582900.28866.85.camel@x220>
References: <1392573811.28866.22.camel@x220>
 <1392578464.996901773@f49.i.mail.ru>
 <1392582900.28866.85.camel@x220>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s1H4hgFf014679

Ğ’Ğ¾ÑĞºÑ€ĞµÑĞµĞ½ÑŒĞµ, 16 Ñ„ĞµĞ²Ñ€Ğ°Ğ»Ñ 2014, 21:35 +01:00 Ğ¾Ñ‚ Paul Bolle <pebolle@tiscali.nl>:
> On Sun, 2014-02-16 at 23:21 +0400, Alexander Shiyan wrote:
> > Ğ’Ğ¾ÑĞºÑ€ĞµÑĞµĞ½ÑŒĞµ, 16 Ñ„ĞµĞ²Ñ€Ğ°Ğ»Ñ 2014, 20:12 +01:00 Ğ¾Ñ‚ Paul Bolle
> <pebolle@tiscali.nl>:
> > > On Sun, 2014-02-16 at 23:06 +0400, Alexander Shiyan wrote:
> > > > Kconfig selects MACH_MXLADS, this enables machine_arch_type
> > > > from include/generated/mach-types.h which used for machine_is_xx()
> macro,
> > > > so if multiple boards is defined in the kernel, this cause to incorrect
> > > matching.
> > > 
> > > But, as I stated in the commit explanation, there are no users of
> > > machine_is_mxlads().
> > 
> > If you have MXLADS and FOO boards support in the kernel (for example)
> > and you want to start MXLADS version, your machine_is_FOO() will be
> positive,
> > since machine_arch_type will be constant value FOO in this case.
> 
> I think it might be helpful - for people trying to understand this
> thread - to add a quote from https://lkml.org/lkml/2013/3/8/473 :
> So, the result is that:
> - de-selected platforms have their if (machine_is_xxx()) { } optimised
> out of the kernel.
> - for a kernel built targetting one platform, all the
> if (machine_is_xxx()) tests are optimised away, leaving only the
> relevant code behind.
> - otherwise, we get the _appropriate_ conditional code for the
> configuration generated.
> 
> Back to the issue at hand: without my patch ARCH_MX1ADS selects
> MACH_MXLADS. So it seems in this case people will have to select
> ARCH_MX1ADS besides selecting FOO. Wouldn't that solve this problem?
> Note that the MACH_MXLADS is now basically meant to be selected by
> ARCH_MX1ADS and not set directly anyway.

It seems that even in the current state, Kconfig for i.MX contains an error.
As a start, we should rename ARCH_MX1ADS to MACH_MX1ADS first.

---
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
