Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469AbaIADiJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 23:38:09 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:51216 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226AbaIADiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 23:38:07 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH 1/4] staging: comedi: hwdrv_apci1500: remove unneeded braces
Date: Sun, 31 Aug 2014 22:37:57 -0500
Message-Id: <04b1ecc0563cdf5b9d2c54cdbf632f60a1c757be.1409542016.git.chase.southwood@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1409542016.git.chase.southwood@gmail.com>
References: <cover.1409542016.git.chase.southwood@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need braces around single-statement blocks.

Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
---
 .../comedi/drivers/addi-data/hwdrv_apci1500.c      | 30 +++++++++-------------
 1 file changed, 12 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
index 1e2fe66..3cc827e 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
@@ -835,10 +835,9 @@ static int apci1500_do_write(struct comedi_device *dev,
 	unsigned int ui_Temp1;
 	unsigned int ui_NoOfChannel = CR_CHAN(insn->chanspec);	/*  get the channel */
 
-	if (!devpriv->b_OutputMemoryStatus) {
+	if (!devpriv->b_OutputMemoryStatus)
 		ui_Temp = 0;
 
-	}			/* if(!devpriv->b_OutputMemoryStatus ) */
 	if (data[3] == 0) {
 		if (data[1] == 0) {
 			data[0] = (data[0] << ui_NoOfChannel) | ui_Temp;
@@ -1502,12 +1501,11 @@ static int apci1500_timer_write(struct comedi_device *dev,
 		switch (data[1]) {
 		case START:
 			if (i_TimerCounter1Init == 1) {
-				if (i_TimerCounterWatchdogInterrupt == 1) {
+				if (i_TimerCounterWatchdogInterrupt == 1)
 					i_CommandAndStatusValue = 0xC4;	/* Enable the interrupt */
-				}	/*  if(i_TimerCounterWatchdogInterrupt==1) */
-				else {
+				else
 					i_CommandAndStatusValue = 0xE4;	/* disable the interrupt */
-				}	/* elseif(i_TimerCounterWatchdogInterrupt==1) */
+
 				/* Starts timer/counter 1 */
 				i_TimerCounter1Enabled = 1;
 				/* Selects the commands and status register */
@@ -1578,12 +1576,11 @@ static int apci1500_timer_write(struct comedi_device *dev,
 		switch (data[1]) {
 		case START:
 			if (i_TimerCounter2Init == 1) {
-				if (i_TimerCounterWatchdogInterrupt == 1) {
+				if (i_TimerCounterWatchdogInterrupt == 1)
 					i_CommandAndStatusValue = 0xC4;	/* Enable the interrupt */
-				}	/*  if(i_TimerCounterWatchdogInterrupt==1) */
-				else {
+				else
 					i_CommandAndStatusValue = 0xE4;	/* disable the interrupt */
-				}	/* elseif(i_TimerCounterWatchdogInterrupt==1) */
+
 				/* Starts timer/counter 2 */
 				i_TimerCounter2Enabled = 1;
 				/* Selects the commands and status register */
@@ -1652,12 +1649,11 @@ static int apci1500_timer_write(struct comedi_device *dev,
 		case START:
 			if (i_WatchdogCounter3Init == 1) {
 
-				if (i_TimerCounterWatchdogInterrupt == 1) {
+				if (i_TimerCounterWatchdogInterrupt == 1)
 					i_CommandAndStatusValue = 0xC4;	/* Enable the interrupt */
-				}	/*  if(i_TimerCounterWatchdogInterrupt==1) */
-				else {
+				else
 					i_CommandAndStatusValue = 0xE4;	/* disable the interrupt */
-				}	/* elseif(i_TimerCounterWatchdogInterrupt==1) */
+
 				/* Starts Watchdog/counter 3 */
 				i_WatchdogCounter3Enabled = 1;
 				/* Selects the commands and status register */
@@ -2208,12 +2204,10 @@ static void apci1500_interrupt(int irq, void *d)
 			outb(i_RegValue,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
-			if (i_CounterLogic == APCI1500_COUNTER) {
+			if (i_CounterLogic == APCI1500_COUNTER)
 				i_InterruptMask = i_InterruptMask | 0x10;
-			}	/* if(i_CounterLogic==APCI1500_COUNTER) */
-			else {
+			else
 				i_InterruptMask = i_InterruptMask | 0x20;
-			}
 		}		/*  if ((i_RegValue & 0x60) == 0x60) */
 
 		send_sig(SIGIO, devpriv->tsk_Current, 0);	/*  send signal to the sample */
-- 
2.1.0

