Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964846Ab3BTQGQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 11:06:16 -0500
Received: from f173.mail.ru ([94.100.178.91]:35094 "EHLO f173.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935444Ab3BTQGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 11:06:15 -0500
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?QXJuZCBCZXJnbWFubg==?= <arnd@arndb.de>
Cc: =?UTF-8?B?RG9uZyBBaXNoZW5n?= <dong.aisheng@linaro.org>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?B?U2FtdWVsIE9ydGl6?= <sameo@linux.intel.com>,
        =?UTF-8?B?TWFyayBCcm93bg==?= <broonie@opensource.wolfsonmicro.com>
Subject: =?UTF-8?B?UmVbMTJdOiBbUEFUQ0ggdjNdIG1mZDogc3lzY29uOiBBZGQgbm9uLURUIHN1?=
 =?UTF-8?B?cHBvcnQ=?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [188.134.40.128]
Date: Wed, 20 Feb 2013 20:06:11 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1361376371.184258129@f173.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Spam: Not detected
X-Mras: Ok
In-Reply-To: <201302201500.18803.arnd@arndb.de>
References: <1361198522-23789-1-git-send-email-shc_work@mail.ru> <1361364471.967042408@f233.mail.ru> <201302201500.18803.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r1KG6J2X004521

> > OK. I can convert platform to DT, no so easy, but possible.
> > But I will use syscon as way to using DT (and MULTIPLATFORM in the future),
> > this mean that I should completely drop ATAG support from this platform
> > (since I cannot use syscon device without DT support, but several platform devices
> > need to use system-wide registers).
> > Arnd, if its OK for you, I will use this way. (I talking about CLPS711X, you know it :) ).
> 
> Ah, I should have realized that this is about clps711x when the patch
> is coming from you ;-)
> 
> This is an existing platform, and I would not require you to move it to
> devicetree just for supporting syscon, although it may be a good idea
> to make that move in the long run.
> 
> For clps711x, we know that there is only one syscon register set, so you
> could do a very simple patch like below. Basically we don't need to

No. Target have a three SYSCON registers and two SYSFLG. All these registers
can be combined into three syscon devices.
Only these registers will be handled via syscon device, so it is not only one.
Or you mean about handle all register via syscon? It is not it.

> treat the absence of DT information as an error, and a call to
> syscon_regmap_lookup_by_compatible or syscon_regmap_lookup_by_phandle
> will always return the syscon device that was registered first, or
> -EPROBE_DEFER for any error.

The initial idea is search desired syscon device from drivers only by one function
(i.e. search syscon device by compatible string or by specific alias) and no depend
on DT or non-DT. I.e. define syscon device always at machine start (even if we run
machine from DTS), because device should be always present in system.

---
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
