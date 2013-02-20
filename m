Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935055Ab3BTMsY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 07:48:24 -0500
Received: from fallback3.mail.ru ([94.100.176.58]:45573 "EHLO
	fallback3.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934016Ab3BTMsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 07:48:23 -0500
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?RG9uZyBBaXNoZW5n?= <dong.aisheng@linaro.org>
Cc: =?UTF-8?B?QXJuZCBCZXJnbWFubg==?= <arnd@arndb.de>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?B?U2FtdWVsIE9ydGl6?= <sameo@linux.intel.com>,
        =?UTF-8?B?TWFyayBCcm93bg==?= <broonie@opensource.wolfsonmicro.com>
Subject: =?UTF-8?B?UmVbMTBdOiBbUEFUQ0ggdjNdIG1mZDogc3lzY29uOiBBZGQgbm9uLURUIHN1?=
 =?UTF-8?B?cHBvcnQ=?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [188.134.40.128]
Date: Wed, 20 Feb 2013 16:47:52 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1361364471.967042408@f233.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Spam: Not detected
X-Mras: Ok
References: <1361198522-23789-1-git-send-email-shc_work@mail.ru> <201302201114.49304.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r1KCmevM003610

> On 20 February 2013 19:14, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Wednesday 20 February 2013, Dong Aisheng wrote:
> >> On 20 February 2013 18:06, Arnd Bergmann <arnd@arndb.de> wrote:
> >> > I would first like to get an answer to the question I asked in my first mail,
> >> > which is what the use case of non-DT support in this driver is. If this
> >> > is used only by a new platform that has to use DT anyway, or by an existing
> >> > platform that is easy enough to convert, we probably shouldn't do all this
> >> > at all.
> >> >
> >>
> >> If the platform can convert to dt, then we do not have such issue.
> >> The question is do we allow the existing non-dt platforms to use it
> >> before converting?
> >
> > I think the answer to that is "it depends". It's basically a question of
> > how much work it would be to convert the platforms that need it over to
> > DT, and how much of the interface it actually needs. E.g. if there is
> > only one in-tree platform that needs to use syscon but can't easily be
> > moved over to DT, but that platform can only have a single syscon device,
> > then we don't need any of the matching support but could simply return
> > the first regmap area we have in the list.
> >
> > Of course, if the platform in question is out of tree, I would argue
> > that the whatever patches are needed by that platform should also
> > remain out of tree.
> >
> 
> Basically i agree with your point.
> Alexander seems to be the first non-dt user of syscon driver.
> He may answer whether they could choose to convert to dt first.
> But one question i wonder is that it may be hard to know how many poteintial
> non-dt platforms may use syscon.

OK. I can convert platform to DT, no so easy, but possible.
But I will use syscon as way to using DT (and MULTIPLATFORM in the future),
this mean that I should completely drop ATAG support from this platform
(since I cannot use syscon device without DT support, but several platform devices
need to use system-wide registers).
Arnd, if its OK for you, I will use this way. (I talking about CLPS711X, you know it :) ).

---
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
