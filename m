Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318AbaIADg1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 23:36:27 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:53918 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238AbaIADgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 23:36:25 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH] staging: comedi: hwdrv_apci3501: change printk to dev_err
Date: Sun, 31 Aug 2014 22:36:11 -0500
Message-Id: <1409542571-27509-1-git-send-email-chase.southwood@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dev_err() is preferred to printk() in device drivers.

Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
---
 drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c
index e82c3fc..339519a 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c
@@ -168,7 +168,7 @@ static int apci3501_read_insn_timer(struct comedi_device *dev,
 
 	else if ((devpriv->b_TimerSelectMode != ADDIDATA_TIMER)
 		&& (devpriv->b_TimerSelectMode != ADDIDATA_WATCHDOG)) {
-		printk("\nIn ReadTimerCounterWatchdog :: Invalid Subdevice \n");
+		dev_err(dev->class_dev, "Invalid subdevice.\n");
 	}
 	return insn->n;
 }
-- 
2.1.0

