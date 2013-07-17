Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933227Ab3GQR2A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 13:28:00 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:47429 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932779Ab3GQR1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 13:27:30 -0400
From: Zubair Lutfullah <zubair.lutfullah@gmail.com>
To: jic23@cam.ac.uk
Cc: linux-iio@vger.kernel.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, koen@dominion.thruhere.net,
        zubair.lutfullah@gmail.com
Subject: [PATCH 20/21] input: ti_am335x_tsc.c fix checkpatch.pl issues
Date: Wed, 17 Jul 2013 18:26:49 +0100
Message-Id: <1374082010-28095-21-git-send-email-zubair.lutfullah@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374082010-28095-1-git-send-email-zubair.lutfullah@gmail.com>
References: <1374082010-28095-1-git-send-email-zubair.lutfullah@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

code formatting fixes
Signed-off-by: Zubair Lutfullah <zubair.lutfullah@gmail.com>
---
 drivers/input/touchscreen/ti_am335x_tsc.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/input/touchscreen/ti_am335x_tsc.c b/drivers/input/touchscreen/ti_am335x_tsc.c
index 4bf2ee6..ba7abfe 100644
--- a/drivers/input/touchscreen/ti_am335x_tsc.c
+++ b/drivers/input/touchscreen/ti_am335x_tsc.c
@@ -260,19 +260,19 @@ static irqreturn_t titsc_irq(int irq, void *dev)
 	unsigned int fsm;
 
 	status = titsc_readl(ts_dev, REG_IRQSTATUS);
- 
-        /*
-         * ADC and touchscreen share the IRQ line.
-         * FIFO1 threshold, FIFO1 Overrun and FIFO1 underflow
-         * interrupts are used by ADC,
-         * hence return from touchscreen IRQ handler if FIFO1
-         * related interrupts occurred.
-         */
-       if ((status & IRQENB_FIFO1THRES) ||
-                       (status & IRQENB_FIFO1OVRRUN) ||
-                       (status & IRQENB_FIFO1UNDRFLW))
-                return IRQ_NONE;
-        else if (status & IRQENB_FIFO0THRES) {
+
+	/*
+	* ADC and touchscreen share the IRQ line.
+	* FIFO1 threshold, FIFO1 Overrun and FIFO1 underflow
+	* interrupts are used by ADC,
+	* hence return from touchscreen IRQ handler if FIFO1
+	* related interrupts occurred.
+	*/
+	if ((status & IRQENB_FIFO1THRES) ||
+			(status & IRQENB_FIFO1OVRRUN) ||
+			(status & IRQENB_FIFO1UNDRFLW))
+		return IRQ_NONE;
+	else if (status & IRQENB_FIFO0THRES) {
 		titsc_read_coordinates(ts_dev, &x, &y, &z1, &z2);
 
 		if (ts_dev->pen_down && z1 != 0 && z2 != 0) {
@@ -326,7 +326,7 @@ static irqreturn_t titsc_irq(int irq, void *dev)
 	}
 
 	if (irqclr) {
-		titsc_writel(ts_dev, REG_IRQSTATUS, (status | irqclr) );
+		titsc_writel(ts_dev, REG_IRQSTATUS, (status | irqclr));
 		am335x_tsc_se_update(ts_dev->mfd_tscadc);
 		return IRQ_HANDLED;
 	}
-- 
1.7.9.5

