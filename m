Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933126Ab3GQRa2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 13:30:28 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:46082 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756796Ab3GQR1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 13:27:16 -0400
From: Zubair Lutfullah <zubair.lutfullah@gmail.com>
To: jic23@cam.ac.uk
Cc: linux-iio@vger.kernel.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, koen@dominion.thruhere.net,
        zubair.lutfullah@gmail.com
Subject: [PATCH 12/21] IIO: ti_adc: Also clear threshold event when clearing overrun event
Date: Wed, 17 Jul 2013 18:26:41 +0100
Message-Id: <1374082010-28095-13-git-send-email-zubair.lutfullah@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374082010-28095-1-git-send-email-zubair.lutfullah@gmail.com>
References: <1374082010-28095-1-git-send-email-zubair.lutfullah@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When an overrun occurs, the FIFO is cleared. If a FIFO threshold event

was pending, the data is now gone. Clear the threshold event when

handling an overrun (or underflow).

Signed-off-by: Russ Dill <Russ.Dill@ti.com>
Signed-off-by: Zubair Lutfullah <zubair.lutfullah@gmail.com>
---
 drivers/iio/adc/ti_am335x_adc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
index fcd414d..1e48799 100644
--- a/drivers/iio/adc/ti_am335x_adc.c
+++ b/drivers/iio/adc/ti_am335x_adc.c
@@ -178,7 +178,8 @@ static irqreturn_t tiadc_irq(int irq, void *private)
 
                 tiadc_writel(adc_dev, REG_IRQSTATUS,
                                 IRQENB_FIFO1OVRRUN |
-                                IRQENB_FIFO1UNDRFLW);
+                                IRQENB_FIFO1UNDRFLW |
+                                IRQENB_FIFO1THRES);
  
                 tiadc_writel(adc_dev, REG_CTRL,
                        (config | CNTRLREG_TSCSSENB));
-- 
1.7.9.5

