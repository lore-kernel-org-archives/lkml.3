Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937AbaBXQeY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 11:34:24 -0500
Received: from nm7-vm2.bullet.mail.gq1.yahoo.com ([98.136.218.209]:25586 "EHLO
	nm7-vm2.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752555AbaBXQeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 11:34:23 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=gcom1024; d=yahoo.com;
	b=jPej5B/1v6IQLzMGrYIyUjKY6Ke/+CF8BqpWP7HoTQwiU0DXyUlA8xaUS+yZ2n0VTDcvYD4cMzRR/0lJYzYWqIgconuDHNPI8VDUB48+kiZYlyLhfUgIQLQMcCbuaKHrRcTHn7Fd606Weu+Oog7Ic7fHo3HGGJUV05wQZqW/eus=;
X-Yahoo-Newman-Id: 604011.59873.bm@smtp211.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: rmd09KYVM1mBM_hcVw6pHVimO9XlcheEralI4qofOcQTQP1
 FZeu2Rjy00kzD70qNYWW9NWEdaS1vrn8TX8Dqs0bxwhTJoN2lW6.HA8HbRxk
 T.F1br1SoECU4WUW236ayHzjOR1xhjrg1FlL6SkOtzPmqU7VQwWk8zRAt8JA
 wblmsi06h74L2yjfK9w5VX2icxOFnDQgxopdgx9EPFAc21.8GCTGRs0eYwP_
 BLdS9NQt6CIMaQ0vh.OxssLiExQroR.Cyjn1vUFcYt2vpUrDUtrOncnF3wh_
 aIFbeSlUAtcydRvkJ45uYE3wWFvc0VSlqzDslv0taZECtxUAzSjmL2bOqMv.
 48iBQZCNxLirGKN3TBTtd.B32nrhyH4oLiGOE82JGOPLzrof3zld4_F_ElPd
 x1bUL5Tjp.kZ0FdRXtMlEUKORAtKiRnVT4327GGNoj9MXMzaFfbhiqaMIqVi
 quPqtqHKIJqwWBuRQvdFICt_yXtz58KmY._.y4.EFI2u1qQYOnFAuiz7sQwA
 vKGLSrBL1YwEJKLLNB6UT_YkO7LVjsl8-
X-Yahoo-SMTP: Ua.BYCGswBCLcNpMqiQEtkMTjL08M6XQy5ZdmA--
X-Rocket-Received: from localhost.localdomain (chase.southwood@166.217.207.43 with plain [98.139.211.125])
        by smtp211.mail.gq1.yahoo.com with SMTP; 24 Feb 2014 08:34:22 -0800 PST
From: Chase Southwood <chase.southwood@yahoo.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@yahoo.com>
Subject: [PATCH 2/3 v2] Staging: comedi: addi-data: cleanup conditional blocks in hwdrv_apci035.c
Date: Mon, 24 Feb 2014 10:34:13 -0600
Message-Id: <1393259653-18467-1-git-send-email-chase.southwood@yahoo.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393039279-7229-1-git-send-email-chase.southwood@yahoo.com>
References: <1393039279-7229-1-git-send-email-chase.southwood@yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There were some conditional blocks that had an unnecessary level of
indentation in them.  We can remove this to improve code clarity.

Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
---
2: Moved "else if" up to the same line as closing brace of "if".  Left
braces on single line "else if" matched to an "if" requiring braces, per
CodingStyle.

 .../comedi/drivers/addi-data/hwdrv_apci035.c       | 31 ++++++++++------------
 1 file changed, 14 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
index 7c40535..ebc0587 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
@@ -207,23 +207,22 @@ static int i_APCI035_ConfigTimerWatchdog(struct comedi_device *dev,
 		ui_Command =
 			(ui_Command & 0xFFF719E2UL) | ui_Mode << 13UL | 0x10UL;
 
-	} else {
-		if (data[0] == ADDIDATA_WATCHDOG) {
+	} else if (data[0] == ADDIDATA_WATCHDOG) {
 
-			/* Set the mode :             */
-			/* - Disable the hardware     */
-			/* - Disable the counter mode */
-			/* - Disable the warning      */
-			/* - Disable the reset        */
-			/* - Disable the timer mode   */
+		/* Set the mode :             */
+		/* - Disable the hardware     */
+		/* - Disable the counter mode */
+		/* - Disable the warning      */
+		/* - Disable the reset        */
+		/* - Disable the timer mode   */
 
-			ui_Command = ui_Command & 0xFFF819E2UL;
+		ui_Command = ui_Command & 0xFFF819E2UL;
 
-		} else {
-			dev_err(dev->class_dev, "The parameter for Timer/watchdog selection is in error\n");
-			return -EINVAL;
-		}
+	} else {
+		dev_err(dev->class_dev, "The parameter for Timer/watchdog selection is in error\n");
+		return -EINVAL;
 	}
+
 	outl(ui_Command, devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 12);
 	ui_Command = 0;
 	ui_Command = inl(devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 12);
@@ -626,11 +625,9 @@ static void v_APCI035_Interrupt(int irq, void *d)
 		/* Read the digital temperature value */
 		ui_DigitalTemperature = inl(devpriv->iobase + 128 + 60);
 		send_sig(SIGIO, devpriv->tsk_Current, 0);	/*  send signal to the sample */
-	}
 
-	else {
-		if ((ui_StatusRegister2 & 0x1) == 0x1)
-			send_sig(SIGIO, devpriv->tsk_Current, 0);	/*  send signal to the sample */
+	} else if ((ui_StatusRegister2 & 0x1) == 0x1) {
+		send_sig(SIGIO, devpriv->tsk_Current, 0);	/*  send signal to the sample */
 	}
 
 	return;
-- 
1.8.5.3

