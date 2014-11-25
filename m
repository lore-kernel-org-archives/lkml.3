Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954AbaKYLh4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:37:56 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40711 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754370AbaKYLhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 06:37:53 -0500
From: Juergen Borleis <jbe@pengutronix.de>
To: rtc-linux@googlegroups.com
Cc: Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH 1/2] RTC/i.MX/DryIce: trivial clean up code
Date: Tue, 25 Nov 2014 12:37:47 +0100
Message-Id: <1416915468-20552-1-git-send-email-jbe@pengutronix.de>
X-Mailer: git-send-email 2.1.3
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: jbe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Juergen Borleis <jbe@pengutronix.de>
---
 drivers/rtc/rtc-imxdi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-imxdi.c b/drivers/rtc/rtc-imxdi.c
index cd741c7..a2544f0 100644
--- a/drivers/rtc/rtc-imxdi.c
+++ b/drivers/rtc/rtc-imxdi.c
@@ -313,7 +313,7 @@ static irqreturn_t dryice_norm_irq(int irq, void *dev_id)
 	dier = __raw_readl(imxdi->ioaddr + DIER);
 
 	/* handle write complete and write error cases */
-	if ((dier & DIER_WCIE)) {
+	if (dier & DIER_WCIE) {
 		/*If the write wait queue is empty then there is no pending
 		  operations. It means the interrupt is for DryIce -Security.
 		  IRQ must be returned as none.*/
@@ -322,7 +322,7 @@ static irqreturn_t dryice_norm_irq(int irq, void *dev_id)
 
 		/* DSR_WCF clears itself on DSR read */
 		dsr = __raw_readl(imxdi->ioaddr + DSR);
-		if ((dsr & (DSR_WCF | DSR_WEF))) {
+		if (dsr & (DSR_WCF | DSR_WEF)) {
 			/* mask the interrupt */
 			di_int_disable(imxdi, DIER_WCIE);
 
@@ -335,7 +335,7 @@ static irqreturn_t dryice_norm_irq(int irq, void *dev_id)
 	}
 
 	/* handle the alarm case */
-	if ((dier & DIER_CAIE)) {
+	if (dier & DIER_CAIE) {
 		/* DSR_WCF clears itself on DSR read */
 		dsr = __raw_readl(imxdi->ioaddr + DSR);
 		if (dsr & DSR_CAF) {
-- 
2.1.3

