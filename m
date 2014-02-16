Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854AbaBPIl1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 03:41:27 -0500
Received: from nm37-vm1.bullet.mail.gq1.yahoo.com ([98.136.216.236]:29601 "EHLO
	nm37-vm1.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751742AbaBPIl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 03:41:26 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=gcom1024; d=yahoo.com;
	b=JPjm09s2b5xLdfzgF7jH2h+fE2CDg+Ic+n2Nc1nS8KjT+eaKOx7EMlrbkH9sULE+weHEhDAg4abzdsKHXeF9EybKjeVaRY6P+NZrjFDcke9RVMqyoIu9ld6DZ8qmXtCedQYpWLc/P7cxtU+Wv1SxRsn/UJxzJgctQuZ6yf7ZTuY=;
X-Yahoo-Newman-Id: 324868.19361.bm@smtp204.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: yVJZGbwVM1mWtA9XpfQKgmV8lvbEWOSvoZRfJ2kHosMY8g1
 352wN3fX8FanaVcHHPVZfTdFr6ysurOA7OTbfioAeH2sCH5GvhYuQebAqXSS
 DQxL3i6a1UjTgVXpp5FzPHGGM_u0b5oZKiuZ3.bhkchEsqjsBKpklXzmMFSb
 Oc6Tlkv.5EUpg_cD1u_KE1_DumY1B5BM7tp8_QEnipLvQ_7qeRKCq4xbP5e0
 bY5H_SvcDeeSpsp4XTjlsuUZ8v4eYsqVG9heDpA0bL1zngHENLS5akIXqsIQ
 GLbI8ipVz3dQdXcSLhMe73oFcVqVcrA7VxTffsEviIOlOIoiozncu_I0YcHs
 WFrMk1R4pSxtaBHMmYohb5zhVth3q_e1mnyIels7xYXZ5TwvtrP4sBIueUj_
 yHSOeR4SyaQ3hWQXT7oneowDaLrK3.qJPP1qILmbKuOBj8dheuOqmxroaUgj
 HDOuCayzo85CiIsRJR1w0HK4NJGgGFLY7d2Luhy1JyrLXPHlHdTXXzLT6irx
 xCXpzRFQqObMVseUfZGmYkDFVZlnMcqa8Lx3V
X-Yahoo-SMTP: Ua.BYCGswBCLcNpMqiQEtkMTjL08M6XQy5ZdmA--
X-Rocket-Received: from localhost.localdomain (chase.southwood@50.129.102.163 with plain [98.138.105.21])
        by smtp204.mail.gq1.yahoo.com with SMTP; 16 Feb 2014 00:41:26 -0800 PST
From: Chase Southwood <chase.southwood@yahoo.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@yahoo.com>
Subject: [PATCH 3/4] Staging: comedi: addi-data: convert printk() to dev_err()
Date: Sun, 16 Feb 2014 02:41:22 -0600
Message-Id: <1392540082-26064-1-git-send-email-chase.southwood@yahoo.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1392540006-25972-1-git-send-email-chase.southwood@yahoo.com>
References: <1392540006-25972-1-git-send-email-chase.southwood@yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch for hwdrv_apci035.c changes a printk() call to a dev_err call
since this is generally preferred.

Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
---
 drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
index 90d5801..f02b714 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
@@ -227,7 +227,7 @@ static int i_APCI035_ConfigTimerWatchdog(struct comedi_device *dev,
 			ui_Command = ui_Command & 0xFFF819E2UL;
 
 		} else {
-			printk("\n The parameter for Timer/watchdog selection is in error\n");
+			dev_err(dev->class_dev, "\n The parameter for Timer/watchdog selection is in error\n");
 			return -EINVAL;
 		}
 	}
-- 
1.8.5.3

