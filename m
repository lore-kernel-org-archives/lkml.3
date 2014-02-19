Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610AbaBSHiD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 02:38:03 -0500
Received: from nm12-vm2.bullet.mail.gq1.yahoo.com ([98.136.218.189]:39193 "EHLO
	nm12-vm2.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752559AbaBSHiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 02:38:01 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=gcom1024; d=yahoo.com;
	b=JyST9dlLYFXlDMV6sbwND1qz1rkIUnCaDA+ehK8+3zNX7dY5gikZszT40zQ4y70eNNx/Z6e2jijlza4/kCFBvtPXY48j9xYXF13ODP8/dVPZ4UnnpqqwQgLrI7ahAbkSvwXuzuWULVGIwxmdeDCd6WtTtM8YWGAEWtvQcNJZlok=;
X-Yahoo-Newman-Id: 351654.10857.bm@smtp216.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: xmlLK7oVM1kr7UtgQz5piVRClfEfv8pwIfLbgFpoK0sX4W7
 5WJze0hZtWiXtE4yZCJNaXp9iBRrsd5kjzqAH8aGO70b45ZNRc0QYFy1BwVF
 5swt4PExLO4Xx6QMn2Zy1THINc6UY3QPSp70yIcfW3DzHxZiMaVarsdZqLsu
 qCIlcXf1ugtVRZDWHewhAxJHyxfxGJhqD9SozInvQIpdrogQsR7FUYuwsExM
 aYpjPo4OCNls4Ak_tWEWRbxjMANZdDy5WUKyvAw_piUu7FO79qOP6dyR0aj.
 1b.8vx_Y6g3uY7hoiZA_fhvjvHxE3M3QzJ0wfC1XI75wfgnbQ.APJfquBUn6
 a4HaF.JV1lvV48N3PCvwYXlHjX7QD_PRkOldnSBZvyIoVY6.CSI_PTQCYAgv
 3ItWkEy9aJ8Ke4joFgpy87qEcFh7wmMVuQOlCpiK1ry5stWHqtleuDLaV84B
 R9jhFZ6L98gI1wxAyKsq31s7gLWJkRH5ofwpQp0KwUaoQE8hB7XeqKIn16y.
 yV8kRkN5WcKeH5kITD8czfrPJFvzdz0.PvXxE
X-Yahoo-SMTP: Ua.BYCGswBCLcNpMqiQEtkMTjL08M6XQy5ZdmA--
X-Rocket-Received: from localhost.localdomain (chase.southwood@50.129.102.163 with plain [63.250.193.228])
        by smtp216.mail.gq1.yahoo.com with SMTP; 19 Feb 2014 07:38:00 +0000 UTC
From: Chase Southwood <chase.southwood@yahoo.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@yahoo.com>
Subject: [PATCH 3/4] Staging: comedi: addi-data: replace printk() with dev_err() in hwdrv_apci1564.c
Date: Wed, 19 Feb 2014 01:37:54 -0600
Message-Id: <1392795474-8713-1-git-send-email-chase.southwood@yahoo.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1392795406-8623-1-git-send-email-chase.southwood@yahoo.com>
References: <1392795406-8623-1-git-send-email-chase.southwood@yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There were a small handful of printk() calls in hwdrv_apci1564.c.  It is
generally better to use dev_err() for error messages instead, so I
switched all the printk() calls out, as well as cleaned up the error
strings.

Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
---
 drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
index 66e6e68..21dd028 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
@@ -414,7 +414,7 @@ static int i_APCI1564_ConfigTimerCounterWatchdog(struct comedi_device *dev,
 			devpriv->iobase + ((data[5] - 1) * 0x20) +
 			APCI1564_TCW_PROG);
 	} else {
-		printk(" Invalid subdevice.");
+		dev_err(dev->class_dev, "Invalid subdevice.\n");
 	}
 
 	return insn->n;
@@ -472,7 +472,7 @@ static int i_APCI1564_StartStopWriteTimerCounterWatchdog(struct comedi_device *d
 				APCI1564_TCW_PROG);
 			break;
 		default:
-			printk("\nSpecified functionality does not exist\n");
+			dev_err(dev->class_dev, "Specified functionality does not exist.\n");
 			return -EINVAL;
 		}
 	}
@@ -591,7 +591,7 @@ static int i_APCI1564_ReadTimerCounterWatchdog(struct comedi_device *dev,
 	} else if ((devpriv->b_TimerSelectMode != ADDIDATA_TIMER)
 		&& (devpriv->b_TimerSelectMode != ADDIDATA_WATCHDOG)
 		&& (devpriv->b_TimerSelectMode != ADDIDATA_COUNTER)) {
-		printk("\n Invalid Subdevice !!!\n");
+		dev_err(dev->class_dev, "Invalid Subdevice!\n");
 	}
 	return insn->n;
 }
@@ -665,7 +665,7 @@ static void v_APCI1564_Interrupt(int irq, void *d)
 		APCI1564_TCW_IRQ) & 0x1;
 	if (ui_DI == 0 && ui_DO == 0 && ui_Timer == 0 && ui_C1 == 0
 		&& ui_C2 == 0 && ui_C3 == 0 && ui_C4 == 0) {
-		printk("\nInterrupt from unknown source\n");
+		dev_err(dev->class_dev, "Interrupt from unknown source.\n");
 	}
 
 	if (ui_DI == 1) {
-- 
1.8.5.3

