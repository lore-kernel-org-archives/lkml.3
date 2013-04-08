Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934734Ab3DHQ1z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 12:27:55 -0400
Received: from f51.mail.ru ([217.69.128.71]:56845 "EHLO f51.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759492Ab3DHQ1y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 12:27:54 -0400
X-Greylist: delayed 42117 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Apr 2013 12:27:53 EDT
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?U2FtdWVsIE9ydGl6?= <sameo@linux.intel.com>
Cc: =?UTF-8?B?U3RlcGhlbiBSb3Rod2VsbA==?= <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: =?UTF-8?B?UmVbMl06IGxpbnV4LW5leHQ6IGJ1aWxkIGZhaWx1cmUgYWZ0ZXIgbWVyZ2Ug?=
 =?UTF-8?B?b2YgdGhlIG1mZCB0cmVl?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [188.134.40.128]
Date: Mon, 08 Apr 2013 20:27:49 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1365438469.322553103@f51.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Spam: Not detected
X-Mras: Ok
In-Reply-To: <20130408092243.GK24058@zurbaran>
References: <20130408142124.ac540429a889cdc9800e529a@canb.auug.org.au>
 <1365396351.542317232@f36.mail.ru>
 <20130408092243.GK24058@zurbaran>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r38GRtJS028616

> > > After merging the mfd tree, today's linux-next build (x86_64 allmodconfig)
> > > failed like this:
> > > 
> > > drivers/regulator/anatop-regulator.c: In function 'anatop_regulator_probe':
> > > drivers/regulator/anatop-regulator.c:134:2: error: implicit declaration of function 'of_get_parent' [-Werror=implicit-function-declaration]
> > > 
> > > Caused by commit 5ab3a89a741f ("mfd: syscon: Add non-DT support").
> > > 
> > > I have used the mfd tree from next-20130405 for today.
> > 
> > This means that we do not have empty declarations for the
> > of_xx functions in linux/of.h for !CONFIG_OF.
> > OK to declare these functions or any other opinions?
> Ok with me, but you'd need to get Grant and Rob's ACK.

I've revised my initial opinion and write â€‹â€‹a quick patch for fix this issue.

>From a884d309d2978cbc44c52b650d669e56fef664e2 Mon Sep 17 00:00:00 2001
From: Alexander Shiyan <shc_work@mail.ru>
Date: Mon, 8 Apr 2013 19:13:10 +0400
Subject: [PATCH] regulator: anatop: Make select dependency from
 HAVE_IMX_ANATOP symbol

This patch make selection of anatop-regulator from HAVE_IMX_ANATOP
kernel symbol. This fixes build kernel with syscon driver but without
oftree support.

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 drivers/regulator/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index a5d97ea..078932d 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -133,7 +133,7 @@ config REGULATOR_FAN53555
 
 config REGULATOR_ANATOP
 	tristate "Freescale i.MX on-chip ANATOP LDO regulators"
-	depends on MFD_SYSCON
+	depends on HAVE_IMX_ANATOP
 	help
 	  Say y here to support Freescale i.MX on-chip ANATOP LDOs
 	  regulators. It is recommended that this option be
-- 
1.8.1.5

---
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
