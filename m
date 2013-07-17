Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932994Ab3GQR12 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 13:27:28 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:52238 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932779Ab3GQR1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 13:27:25 -0400
From: Zubair Lutfullah <zubair.lutfullah@gmail.com>
To: jic23@cam.ac.uk
Cc: linux-iio@vger.kernel.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, koen@dominion.thruhere.net,
        zubair.lutfullah@gmail.com
Subject: [PATCH 17/21] Revert "IIO: ti_adc: Correct wrong samples received on 1st read in continuous mode"
Date: Wed, 17 Jul 2013 18:26:46 +0100
Message-Id: <1374082010-28095-18-git-send-email-zubair.lutfullah@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374082010-28095-1-git-send-email-zubair.lutfullah@gmail.com>
References: <1374082010-28095-1-git-send-email-zubair.lutfullah@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With a proper fix to this code, this is no longer neccessary.

Signed-off-by: Russ Dill <Russ.Dill@ti.com>
Signed-off-by: Zubair Lutfullah <zubair.lutfullah@gmail.com>
---
 drivers/iio/adc/ti_am335x_adc.c |    8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
index 21294f2..1f42e0a 100644
--- a/drivers/iio/adc/ti_am335x_adc.c
+++ b/drivers/iio/adc/ti_am335x_adc.c
@@ -36,7 +36,6 @@
 #include <linux/iio/trigger_consumer.h>
 #include <linux/iio/kfifo_buf.h>
 #include <linux/iio/sysfs.h>
-#include <linux/delay.h>
 
 struct tiadc_device {
 	struct ti_tscadc_dev *mfd_tscadc;
@@ -222,13 +221,6 @@ static void tiadc_poll_handler(struct work_struct *work_s)
         iBuf = kmalloc((fifo1count) * sizeof(u32), GFP_KERNEL);
         if (iBuf == NULL)
                 goto out;
-        /*
-         * Wait for ADC sequencer to settle down.
-         * There could be a scenario where in we
-         * try to read data from ADC before
-         * it is available.
-         */
-        udelay(500);
 
         for (i = 0; i < fifo1count; i++) {
                 readx1 = tiadc_readl(adc_dev, REG_FIFO1);
-- 
1.7.9.5

