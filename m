Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936585Ab3DIPrp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 11:47:45 -0400
Received: from f12.mail.ru ([217.69.128.79]:44975 "EHLO f12.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936173Ab3DIPro (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 11:47:44 -0400
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?U2FtdWVsIE9ydGl6?= <sameo@linux.intel.com>
Cc: =?UTF-8?B?U3RlcGhlbiBSb3Rod2VsbA==?= <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: =?UTF-8?B?UmVbMl06IGxpbnV4LW5leHQ6IGJ1aWxkIGZhaWx1cmUgYWZ0ZXIgbWVyZ2Ug?=
 =?UTF-8?B?b2YgdGhlIG1mZCB0cmVl?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [188.134.40.128]
Date: Tue, 09 Apr 2013 19:47:40 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1365522460.690965802@f12.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Spam: Not detected
X-Mras: Ok
In-Reply-To: <20130409072059.GC23447@zurbaran>
References: <20130408142124.ac540429a889cdc9800e529a@canb.auug.org.au>
 <1365438469.322553103@f51.mail.ru>
 <20130409072059.GC23447@zurbaran>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r39Flje0005207

> On Mon, Apr 08, 2013 at 08:27:49PM +0400, Alexander Shiyan wrote:
> > > > > After merging the mfd tree, today's linux-next build (x86_64 allmodconfig)
> > > > > failed like this:
> > > > > 
> > > > > drivers/regulator/anatop-regulator.c: In function 'anatop_regulator_probe':
> > > > > drivers/regulator/anatop-regulator.c:134:2: error: implicit declaration of function 'of_get_parent' [-Werror=implicit-function-declaration]
> > > > > 
> > > > > Caused by commit 5ab3a89a741f ("mfd: syscon: Add non-DT support").
> > > > > 
> > > > > I have used the mfd tree from next-20130405 for today.
> > > > 
> > > > This means that we do not have empty declarations for the
> > > > of_xx functions in linux/of.h for !CONFIG_OF.
> > > > OK to declare these functions or any other opinions?
> > > Ok with me, but you'd need to get Grant and Rob's ACK.
...
> > Subject: [PATCH] regulator: anatop: Make select dependency from
> >  HAVE_IMX_ANATOP symbol
> > 
> > This patch make selection of anatop-regulator from HAVE_IMX_ANATOP
> > kernel symbol. This fixes build kernel with syscon driver but without
> > oftree support.
...
> This does look like a band-aid solution to me. Yes, it will fix the crash, but
> you're restricting this code to a much smaller architecture set. AFAIK
> linux-next is not tested on that arch, for example.

OK, the second solution:

>From 3296415f29818a430bad12c92dc65cd81e4d133f Mon Sep 17 00:00:00 2001
From: Alexander Shiyan <shc_work@mail.ru>
Date: Tue, 9 Apr 2013 19:41:27 +0400
Subject: [PATCH] of: add stub of_get_parent for non-OF builds

Fixes build error on x86_64 allmodconfig, introduced by commit
5ab3a89a741f ("mfd: syscon: Add non-DT support").

drivers/regulator/anatop-regulator.c: In function 'anatop_regulator_probe':
drivers/regulator/anatop-regulator.c:134:2: error: implicit declaration of function 'of_get_parent' [-Werror=implicit-function-declaration]

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 include/linux/of.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/of.h b/include/linux/of.h
index a0f1292..9f5923f 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -353,6 +353,11 @@ static inline struct device_node *of_find_node_by_name(struct device_node *from,
 	return NULL;
 }
 
+static inline struct device_node *of_get_parent(const struct device_node *node)
+{
+	return NULL;
+}
+
 static inline bool of_have_populated_dt(void)
 {
 	return false;
-- 
1.8.1.5

---
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
