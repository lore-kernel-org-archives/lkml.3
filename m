Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934761Ab3GRWXN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 18:23:13 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:56097 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934641Ab3GRWVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 18:21:49 -0400
From: Zubair Lutfullah <zubair.lutfullah@gmail.com>
To: jic23@cam.ac.uk
Cc: gregkh@linuxfoundation.org, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, koen@dominion.thruhere.net
Subject: [PATCH 10/15] iio: ti_am335x_adc: Also clear threshold event when clearing overrun event
Date: Thu, 18 Jul 2013 23:21:21 +0100
Message-Id: <1374186086-5015-11-git-send-email-zubair.lutfullah@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374186086-5015-1-git-send-email-zubair.lutfullah@gmail.com>
References: <1374186086-5015-1-git-send-email-zubair.lutfullah@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Russ Dill <Russ.Dill@ti.com>

When an overrun occurs, the FIFO is cleared. If a FIFO threshold event
was pending, the data is now gone. Clear the threshold event when
handling an overrun (or underflow).

Signed-off-by: Russ Dill <Russ.Dill@ti.com>
Signed-off-by: Zubair Lutfullah <zubair.lutfullah@gmail.com>
---
 drivers/iio/adc/ti_am335x_adc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
index 8dc070d..6957011 100644
--- a/drivers/iio/adc/ti_am335x_adc.c
+++ b/drivers/iio/adc/ti_am335x_adc.c
@@ -171,8 +171,8 @@ static irqreturn_t tiadc_irq(int irq, void *private)
 		config = tiadc_readl(adc_dev, REG_CTRL);
 		config &= ~(CNTRLREG_TSCSSENB);
 		tiadc_writel(adc_dev, REG_CTRL, config);
-		tiadc_writel(adc_dev, REG_IRQSTATUS,
-				IRQENB_FIFO1OVRRUN | IRQENB_FIFO1UNDRFLW);
+		tiadc_writel(adc_dev, REG_IRQSTATUS, IRQENB_FIFO1THRES
+				| IRQENB_FIFO1OVRRUN | IRQENB_FIFO1UNDRFLW);
 		tiadc_writel(adc_dev, REG_CTRL,
 				(config | CNTRLREG_TSCSSENB));
 		return IRQ_HANDLED;
-- 
1.7.9.5

