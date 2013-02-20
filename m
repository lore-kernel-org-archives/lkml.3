Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934044Ab3BTR1u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 12:27:50 -0500
Received: from f53.mail.ru ([94.100.178.229]:38346 "EHLO f53.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758932Ab3BTR1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 12:27:48 -0500
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?QXJuZCBCZXJnbWFubg==?= <arnd@arndb.de>
Cc: =?UTF-8?B?RG9uZyBBaXNoZW5n?= <dong.aisheng@linaro.org>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?B?U2FtdWVsIE9ydGl6?= <sameo@linux.intel.com>,
        =?UTF-8?B?TWFyayBCcm93bg==?= <broonie@opensource.wolfsonmicro.com>
Subject: =?UTF-8?B?UmVbMTRdOiBbUEFUQ0ggdjNdIG1mZDogc3lzY29uOiBBZGQgbm9uLURUIHN1?=
 =?UTF-8?B?cHBvcnQ=?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [188.134.40.128]
Date: Wed, 20 Feb 2013 21:27:45 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1361381265.182415798@f53.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Spam: Not detected
X-Mras: Ok
In-Reply-To: <201302201716.04650.arnd@arndb.de>
References: <1361198522-23789-1-git-send-email-shc_work@mail.ru> <1361376371.184258129@f173.mail.ru> <201302201716.04650.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r1KHRpKA004916

> On Wednesday 20 February 2013, Alexander Shiyan wrote:
> > No. Target have a three SYSCON registers and two SYSFLG. All these registers
> > can be combined into three syscon devices.
> > Only these registers will be handled via syscon device, so it is not only one.
> > Or you mean about handle all register via syscon? It is not it.
> 
> Yes, I was expecting that you would list all three pages in the resource
> for the syscon device, basically making all of the core clps711x
> registers available this way.

All other will be passed as resource to drivers, as for other drivers.
And this change replaces clps_read/write.

> > > treat the absence of DT information as an error, and a call to
> > > syscon_regmap_lookup_by_compatible or syscon_regmap_lookup_by_phandle
> > > will always return the syscon device that was registered first, or
> > > -EPROBE_DEFER for any error.
> > 
> > The initial idea is search desired syscon device from drivers only by one function
> > (i.e. search syscon device by compatible string or by specific alias) and no depend
> > on DT or non-DT. I.e. define syscon device always at machine start (even if we run
> > machine from DTS), because device should be always present in system.
> 
> I don't understand yet what the advantage for clps711x is over just a single
> register area that would get registered at boot time and replace all the
> clps_readl/clps_writel calls.

This cause a serious perfomance impact. Only SYSCON and SYSFLG is used
in several places and should be protected by spinlocks. Other registers
can be used without locks. And, as say before, clps_read/write will be replaced with
read/write when registers will passed as resource. First example of this change I
sent to you before (patchset for serial driver).

---
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
