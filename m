Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbaBRGeu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 01:34:50 -0500
Received: from nm4-vm6.bullet.mail.gq1.yahoo.com ([98.136.218.165]:29595 "EHLO
	nm4-vm6.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753702AbaBRGeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 01:34:44 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=gcom1024; d=yahoo.com;
	b=Nks4l1yjG06rTQZd7+sAoENcyu4PFy1nRXVbmHeeBcQtqu+BEhKKWNTGdVdE14HSEQs0z07ZQwqpkQgbPk3C4zEas5a8Q8NaBEIunXL7+zuHQM8pxTfR+4DiRs4NCjEsJDM+UCK3Lj8tPQPn8UVKiNKZj9l2R4695taBGyyi8fg=;
X-Yahoo-Newman-Id: 18359.43726.bm@smtp232.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: RI2brUYVM1l9mp.KFj5VQqQwqwYKQYpu0NISl_cxfVTU5bf
 LDd9jpXCt4FN7YARvr62ab55mK5vGt_I2hr9bOc4etTKdK.ZvOUX257ErPDg
 zqtYkImd0L7HUxr1P_nObUXndvUn4CwIwpDSTqtSc5AHT7iLLbUyTmZ_k6Z4
 f00uaj3ScdV8M8GcE7qSZHsPF2vDcswF1g5_biwNHbY9Ik9140tbhUC2LFKF
 .d5RxbbzwFQJoA_a4L10N9KpzLsUwzm1e6RCrD1UN3_UXjAzE6I9yPuO1KT1
 dvKOV3E92laVNui__Wg9sNJzd7bPsH46hZbOzCrQ4HZ8Q4b._pB4iRmJAsYf
 v2hsYA.Afx8Nm3mHh4tnCKwCjOPreH924u0_CMBfl5ad9jAtyeISPv0iY531
 1DYHQpaGZ02tv1DJI.VXw6uJbl_7wYki3zCjPGcdAxN6rQRgzKG1zj9Z1kWe
 Ln7CVWPwEVjbtrBJueCkEwsWIJRLUt5je19kCLpS4PMEbZj.kOefM8OiuRoS
 vmEqtstEPEE7uxDnXGhQkp92mAYvTrEQ96sO6
X-Yahoo-SMTP: Ua.BYCGswBCLcNpMqiQEtkMTjL08M6XQy5ZdmA--
X-Rocket-Received: from localhost.localdomain (chase.southwood@50.129.102.163 with plain [98.138.105.21])
        by smtp232.mail.gq1.yahoo.com with SMTP; 18 Feb 2014 06:34:43 +0000 UTC
From: Chase Southwood <chase.southwood@yahoo.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@yahoo.com>
Subject: [PATCH 3/4 v2] Staging: comedi: addi-data: convert printk() to dev_err()
Date: Tue, 18 Feb 2014 00:34:39 -0600
Message-Id: <1392705279-29692-1-git-send-email-chase.southwood@yahoo.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1392540082-26064-1-git-send-email-chase.southwood@yahoo.com>
References: <1392540082-26064-1-git-send-email-chase.southwood@yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch for hwdrv_apci035.c changes a printk() call to a dev_err() call
since this is generally preferred.  It also removes a newline from the start
of the error message.

Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
---
2: Removed leading newline, per Ian's request.

 drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
index 90d5801..ff64540 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
@@ -227,7 +227,7 @@ static int i_APCI035_ConfigTimerWatchdog(struct comedi_device *dev,
 			ui_Command = ui_Command & 0xFFF819E2UL;
 
 		} else {
-			printk("\n The parameter for Timer/watchdog selection is in error\n");
+			dev_err(dev->class_dev, "The parameter for Timer/watchdog selection is in error\n");
 			return -EINVAL;
 		}
 	}
-- 
1.8.5.3

