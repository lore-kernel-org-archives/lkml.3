Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757904Ab3HMMP5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 08:15:57 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39381 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757843Ab3HMMP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 08:15:56 -0400
From: Michael Grzeschik <m.grzeschik@pengutronix.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH] mfd: mc13xxx: make it possible to use the codec without pdata
Date: Tue, 13 Aug 2013 14:15:48 +0200
Message-Id: <1376396148-29801-1-git-send-email-m.grzeschik@pengutronix.de>
X-Mailer: git-send-email 1.8.4.rc2
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case of devicetree, we currently don't have a way to append pdata for
the codec. This patch makes it possible to probe the codec without pdata
for that case.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
---
 drivers/mfd/mc13xxx-core.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/mc13xxx-core.c b/drivers/mfd/mc13xxx-core.c
index 278601f..e1b89e6 100644
--- a/drivers/mfd/mc13xxx-core.c
+++ b/drivers/mfd/mc13xxx-core.c
@@ -687,10 +687,6 @@ err_revision:
 	if (mc13xxx->flags & MC13XXX_USE_ADC)
 		mc13xxx_add_subdevice(mc13xxx, "%s-adc");
 
-	if (mc13xxx->flags & MC13XXX_USE_CODEC)
-		mc13xxx_add_subdevice_pdata(mc13xxx, "%s-codec",
-					pdata->codec, sizeof(*pdata->codec));
-
 	if (mc13xxx->flags & MC13XXX_USE_RTC)
 		mc13xxx_add_subdevice(mc13xxx, "%s-rtc");
 
@@ -705,6 +701,10 @@ err_revision:
 		if (mc13xxx->flags & MC13XXX_USE_TOUCHSCREEN)
 			mc13xxx_add_subdevice_pdata(mc13xxx, "%s-ts",
 					&pdata->touch, sizeof(pdata->touch));
+
+		if (mc13xxx->flags & MC13XXX_USE_CODEC)
+			mc13xxx_add_subdevice_pdata(mc13xxx, "%s-codec",
+					pdata->codec, sizeof(*pdata->codec));
 	} else {
 		mc13xxx_add_subdevice(mc13xxx, "%s-regulator");
 		mc13xxx_add_subdevice(mc13xxx, "%s-led");
@@ -712,6 +712,9 @@ err_revision:
 
 		if (mc13xxx->flags & MC13XXX_USE_TOUCHSCREEN)
 			mc13xxx_add_subdevice(mc13xxx, "%s-ts");
+
+		if (mc13xxx->flags & MC13XXX_USE_CODEC)
+			mc13xxx_add_subdevice(mc13xxx, "%s-codec");
 	}
 
 	return 0;
-- 
1.8.4.rc2

