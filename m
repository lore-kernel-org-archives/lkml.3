Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab3BUP11 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 10:27:27 -0500
Received: from f272.mail.ru ([217.69.128.240]:60979 "EHLO f272.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753844Ab3BUP10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 10:27:26 -0500
X-Greylist: delayed 95971 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Feb 2013 10:27:26 EST
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?QXJuZCBCZXJnbWFubg==?= <arnd@arndb.de>
Cc: =?UTF-8?B?RG9uZyBBaXNoZW5n?= <dong.aisheng@linaro.org>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?B?U2FtdWVsIE9ydGl6?= <sameo@linux.intel.com>,
        =?UTF-8?B?TWFyayBCcm93bg==?= <broonie@opensource.wolfsonmicro.com>
Subject: =?UTF-8?B?UmVbMTZdOiBbUEFUQ0ggdjNdIG1mZDogc3lzY29uOiBBZGQgbm9uLURUIHN1?=
 =?UTF-8?B?cHBvcnQ=?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [188.134.40.128]
Date: Thu, 21 Feb 2013 19:27:23 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1361460443.648613272@f272.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Spam: Not detected
X-Mras: Ok
In-Reply-To: <201302202127.09979.arnd@arndb.de>
References: <1361198522-23789-1-git-send-email-shc_work@mail.ru> <1361381265.182415798@f53.mail.ru> <201302202127.09979.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r1LFRXuS010150

...
> > > > > treat the absence of DT information as an error, and a call to
> > > > > syscon_regmap_lookup_by_compatible or syscon_regmap_lookup_by_phandle
> > > > > will always return the syscon device that was registered first, or
> > > > > -EPROBE_DEFER for any error.
> > > > 
> > > > The initial idea is search desired syscon device from drivers only by one function
> > > > (i.e. search syscon device by compatible string or by specific alias) and no depend
> > > > on DT or non-DT. I.e. define syscon device always at machine start (even if we run
> > > > machine from DTS), because device should be always present in system.
> > > 
> > > I don't understand yet what the advantage for clps711x is over just a single
> > > register area that would get registered at boot time and replace all the
> > > clps_readl/clps_writel calls.
> > 
> > This cause a serious perfomance impact. Only SYSCON and SYSFLG is used
> > in several places and should be protected by spinlocks. Other registers
> > can be used without locks. And, as say before, clps_read/write will be replaced with
> > read/write when registers will passed as resource. First example of this change I
> > sent to you before (patchset for serial driver).
> 
> Yes, that makes sense. I have no fundamental objections then. I'll wait
> for the next version of your patch and then comment on any details I still
> find sticking out.

OK. Next version will be sent in few minutes.
I am leave search by id_entry and extend it with variant from first patch version.
This will allow to search syscon device with id_entry record in the driver, and
without last one by specifying generic name with id (for example "syscon.0").
Thanks.

---
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
