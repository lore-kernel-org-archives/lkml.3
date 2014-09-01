Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514AbaIADiX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 23:38:23 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:47799 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbaIADiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 23:38:21 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH 2/4] staging: comedi: hwdrv_apci1500: remove commented out code
Date: Sun, 31 Aug 2014 22:38:12 -0500
Message-Id: <b6e9988066f5689a0f12a5f289fc0cdf02bd9a4e.1409542016.git.chase.southwood@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1409542016.git.chase.southwood@gmail.com>
References: <cover.1409542016.git.chase.southwood@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
---
 .../comedi/drivers/addi-data/hwdrv_apci1500.c      | 249 ++++++++++-----------
 1 file changed, 123 insertions(+), 126 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
index 3cc827e..031882e 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
@@ -172,17 +172,17 @@ static int apci1500_di_config(struct comedi_device *dev,
 
 	if (data[0] == 1) {
 		i_MaxChannel = 8;
-	}			/*  if (data[0] == 1) */
+	}
 	else {
 		if (data[0] == 2) {
 			i_MaxChannel = 6;
-		}		/*  if(data[0]==2) */
+		}
 		else {
 			dev_warn(dev->hw_dev,
 				"The specified port event does not exist\n");
 			return -EINVAL;
-		}		/* else if(data[0]==2) */
-	}			/* else  if (data[0] == 1) */
+		}
+	}
 	switch (data[1]) {
 	case 0:
 		data[1] = APCI1500_AND;
@@ -197,7 +197,7 @@ static int apci1500_di_config(struct comedi_device *dev,
 		dev_warn(dev->hw_dev,
 			"The specified interrupt logic does not exist\n");
 		return -EINVAL;
-	}			/* switch(data[1]); */
+	}
 
 	i_Logic = data[1];
 	for (i_Count = i_MaxChannel, i = 0; i_Count > 0; i_Count--, i++) {
@@ -242,8 +242,8 @@ static int apci1500_di_config(struct comedi_device *dev,
 			dev_warn(dev->hw_dev,
 				"The option indicated in the event mask does not exist\n");
 			return -EINVAL;
-		}		/*  switch(i_EventMask) */
-	}			/* for (i_Count = i_MaxChannel; i_Count >0;i_Count --) */
+		}
+	}
 
 	if (data[0] == 1) {
 		/* Test the interrupt logic */
@@ -259,7 +259,7 @@ static int apci1500_di_config(struct comedi_device *dev,
 				dev_warn(dev->hw_dev,
 					"Transition error on an OR PRIORITY logic\n");
 				return -EINVAL;
-			}	/*  if (data[1]== APCI1500_OR_PRIORITY && i_PatternTransition != 0) */
+			}
 
 			/* Tests if more than one transition */
 			/* was declared for an AND logic     */
@@ -271,14 +271,14 @@ static int apci1500_di_config(struct comedi_device *dev,
 						((i_PatternTransition >>
 							i_Count) & 0x1);
 
-				}	/* for (i_Count = 0; i_Count < 8; i_Count++) */
+				}
 
 				if (i_PatternTransitionCount > 1) {
 					dev_warn(dev->hw_dev,
 						"Transition error on an AND logic\n");
 					return -EINVAL;
-				}	/*  if (i_PatternTransitionCount > 1) */
-			}	/*  if (data[1]== APCI1500_AND) */
+				}
+			}
 
 			/* Selects the APCI1500_RW_MASTER_CONFIGURATION_CONTROL register */
 			outb(APCI1500_RW_MASTER_CONFIGURATION_CONTROL,
@@ -347,13 +347,13 @@ static int apci1500_di_config(struct comedi_device *dev,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 
-		}		/*  if(data[1]==APCI1500_AND||data[1]==APCI1500_OR||data[1]==APCI1500_OR_PRIORITY) */
+		}
 		else {
 			dev_warn(dev->hw_dev,
 				"The choice for interrupt logic does not exist\n");
 			return -EINVAL;
-		}		/*  else }// if(data[1]==APCI1500_AND||data[1]==APCI1500_OR||data[1]==APCI1500_OR_PRIORITY) */
-	}			/*    if (data[0]== 1) */
+		}
+	}
 
 	/* Test if event setting for port 2 */
 
@@ -448,13 +448,13 @@ static int apci1500_di_config(struct comedi_device *dev,
 			outb(0xF4,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
-		}		/*   if (data[1] == APCI1500_OR) */
+		}
 		else {
 			dev_warn(dev->hw_dev,
 				"The choice for interrupt logic does not exist\n");
 			return -EINVAL;
-		}		/* elseif (data[1] == APCI1500_OR) */
-	}			/* if(data[0]==2) */
+		}
+	}
 
 	return insn->n;
 }
@@ -518,13 +518,13 @@ static int apci1500_di_write(struct comedi_device *dev,
 						devpriv->iobase +
 						APCI1500_Z8536_CONTROL_REGISTER);
 
-				}	/*  if(i_Event1Status==1) */
+				}
 				else {
 					dev_warn(dev->hw_dev,
 						"Event 1 not initialised\n");
 					return -EINVAL;
-				}	/* else if(i_Event1Status==1) */
-			}	/* if (data[1]==1) */
+				}
+			}
 			if (data[1] == 2) {
 
 				if (i_Event2Status == 1) {
@@ -555,19 +555,19 @@ static int apci1500_di_write(struct comedi_device *dev,
 						devpriv->iobase +
 						APCI1500_Z8536_CONTROL_REGISTER);
 					i_Event2InterruptStatus = 1;
-				}	/*  if(i_Event2Status==1) */
+				}
 				else {
 					dev_warn(dev->hw_dev,
 						"Event 2 not initialised\n");
 					return -EINVAL;
-				}	/* else if(i_Event2Status==1) */
-			}	/*  if(data[1]==2) */
-		}		/*  if (data[1] == 1 || data[0] == 2) */
+				}
+			}
+		}
 		else {
 			dev_warn(dev->hw_dev,
 				"The port parameter is in error\n");
 			return -EINVAL;
-		}		/* else if (data[1] == 1 || data[0] == 2) */
+		}
 
 		break;
 
@@ -600,13 +600,13 @@ static int apci1500_di_write(struct comedi_device *dev,
 						devpriv->iobase +
 						APCI1500_Z8536_CONTROL_REGISTER);
 					i_Event1InterruptStatus = 0;
-				}	/*  if(i_Event1Status==1) */
+				}
 				else {
 					dev_warn(dev->hw_dev,
 						"Event 1 not initialised\n");
 					return -EINVAL;
-				}	/* else if(i_Event1Status==1) */
-			}	/* if (data[1]==1) */
+				}
+			}
 			if (data[1] == 2) {
 				/* Test if event initialised */
 				if (i_Event2Status == 1) {
@@ -630,26 +630,26 @@ static int apci1500_di_write(struct comedi_device *dev,
 						devpriv->iobase +
 						APCI1500_Z8536_CONTROL_REGISTER);
 					i_Event2InterruptStatus = 0;
-				}	/*  if(i_Event2Status==1) */
+				}
 				else {
 					dev_warn(dev->hw_dev,
 						"Event 2 not initialised\n");
 					return -EINVAL;
-				}	/* else if(i_Event2Status==1) */
-			}	/* if(data[1]==2) */
+				}
+			}
 
-		}		/*  if (data[1] == 1 || data[1] == 2) */
+		}
 		else {
 			dev_warn(dev->hw_dev,
 				"The port parameter is in error\n");
 			return -EINVAL;
-		}		/* else if (data[1] == 1 || data[1] == 2) */
+		}
 		break;
 	default:
 		dev_warn(dev->hw_dev,
 			"The option of START/STOP logic does not exist\n");
 		return -EINVAL;
-	}			/* switch(data[0]) */
+	}
 
 	return insn->n;
 }
@@ -843,7 +843,7 @@ static int apci1500_do_write(struct comedi_device *dev,
 			data[0] = (data[0] << ui_NoOfChannel) | ui_Temp;
 			outw(data[0],
 				devpriv->i_IobaseAddon + APCI1500_DIGITAL_OP);
-		}		/* if(data[1]==0) */
+		}
 		else {
 			if (data[1] == 1) {
 				switch (ui_NoOfChannel) {
@@ -875,19 +875,19 @@ static int apci1500_do_write(struct comedi_device *dev,
 						"chan spec wrong\n");
 					return -EINVAL;	/*  "sorry channel spec wrong " */
 
-				}	/* switch(ui_NoOfChannels) */
+				}
 
 				outw(data[0],
 					devpriv->i_IobaseAddon +
 					APCI1500_DIGITAL_OP);
-			}	/*  if(data[1]==1) */
+			}
 			else {
 				dev_warn(dev->hw_dev,
 					"Specified channel not supported\n");
 				return -EINVAL;
-			}	/* else if(data[1]==1) */
-		}		/* elseif(data[1]==0) */
-	}			/* if(data[3]==0) */
+			}
+		}
+	}
 	else {
 		if (data[3] == 1) {
 			if (data[1] == 0) {
@@ -902,7 +902,7 @@ static int apci1500_do_write(struct comedi_device *dev,
 				outw(data[0],
 					devpriv->i_IobaseAddon +
 					APCI1500_DIGITAL_OP);
-			}	/* if(data[1]==0) */
+			}
 			else {
 				if (data[1] == 1) {
 					switch (ui_NoOfChannel) {
@@ -954,25 +954,25 @@ static int apci1500_do_write(struct comedi_device *dev,
 							"chan spec wrong\n");
 						return -EINVAL;	/*  "sorry channel spec wrong " */
 
-					}	/* switch(ui_NoOfChannels) */
+					}
 
 					outw(data[0],
 						devpriv->i_IobaseAddon +
 						APCI1500_DIGITAL_OP);
-				}	/*  if(data[1]==1) */
+				}
 				else {
 					dev_warn(dev->hw_dev,
 						"Specified channel not supported\n");
 					return -EINVAL;
-				}	/* else if(data[1]==1) */
-			}	/* elseif(data[1]==0) */
-		}		/* if(data[3]==1); */
+				}
+			}
+		}
 		else {
 			dev_warn(dev->hw_dev,
 				"Specified functionality does not exist\n");
 			return -EINVAL;
-		}		/* if else data[3]==1) */
-	}			/* if else data[3]==0) */
+		}
+	}
 	ui_Temp = data[0];
 	return insn->n;
 }
@@ -1004,14 +1004,14 @@ static int apci1500_timer_config(struct comedi_device *dev,
 /* Selection of the input clock */
 	if (data[0] == 0 || data[0] == 1 || data[0] == 2) {
 		outw(data[0], devpriv->i_IobaseAddon + APCI1500_CLK_SELECT);
-	}			/*  if(data[0]==0||data[0]==1||data[0]==2) */
+	}
 	else {
 		if (data[0] != 3) {
 			dev_warn(dev->hw_dev,
 				"The option for input clock selection does not exist\n");
 			return -EINVAL;
-		}		/*  if(data[0]!=3) */
-	}			/* elseif(data[0]==0||data[0]==1||data[0]==2) */
+		}
+	}
 	/* Select the counter/timer */
 	switch (data[1]) {
 	case COUNTER1:
@@ -1027,7 +1027,7 @@ static int apci1500_timer_config(struct comedi_device *dev,
 			dev_warn(dev->hw_dev,
 				"This choice is not a timer nor a counter\n");
 			return -EINVAL;
-		}		/*  switch(data[2]) */
+		}
 
 		/* Selecting  single or continuous mode */
 		switch (data[4]) {
@@ -1041,7 +1041,7 @@ static int apci1500_timer_config(struct comedi_device *dev,
 			dev_warn(dev->hw_dev,
 				"This option for single/continuous mode does not exist\n");
 			return -EINVAL;
-		}		/*  switch(data[4]) */
+		}
 
 		i_TimerCounterMode = data[2] | data[4] | 7;
 		/* Test the reload value */
@@ -1132,18 +1132,18 @@ static int apci1500_timer_config(struct comedi_device *dev,
 				outb(0x2,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
-			}	/* if(data[7]== APCI1500_ENABLE ||data[7]== APCI1500_DISABLE) */
+			}
 			else {
 				dev_warn(dev->hw_dev,
 					"Error in selection of interrupt enable or disable\n");
 				return -EINVAL;
-			}	/* elseif(data[7]== APCI1500_ENABLE ||data[7]== APCI1500_DISABLE) */
-		}		/*  if ((data[3]>= 0) && (data[3] <= 65535)) */
+			}
+		}
 		else {
 			dev_warn(dev->hw_dev,
 				"Error in selection of reload value\n");
 			return -EINVAL;
-		}		/* else if ((data[3]>= 0) && (data[3] <= 65535)) */
+		}
 		i_TimerCounterWatchdogInterrupt = data[7];
 		i_TimerCounter1Init = 1;
 		break;
@@ -1160,7 +1160,7 @@ static int apci1500_timer_config(struct comedi_device *dev,
 			dev_warn(dev->hw_dev,
 				"This choice is not a timer nor a counter\n");
 			return -EINVAL;
-		}		/*  switch(data[2]) */
+		}
 
 		/* Selecting  single or continuous mode */
 		switch (data[4]) {
@@ -1174,7 +1174,7 @@ static int apci1500_timer_config(struct comedi_device *dev,
 			dev_warn(dev->hw_dev,
 				"This option for single/continuous mode does not exist\n");
 			return -EINVAL;
-		}		/*  switch(data[4]) */
+		}
 
 		/* Selecting  software or hardware trigger */
 		switch (data[5]) {
@@ -1188,7 +1188,7 @@ static int apci1500_timer_config(struct comedi_device *dev,
 			dev_warn(dev->hw_dev,
 				"This choice for software or hardware trigger does not exist\n");
 			return -EINVAL;
-		}		/*  switch(data[5]) */
+		}
 
 		/* Selecting  software or hardware gate */
 		switch (data[6]) {
@@ -1202,7 +1202,7 @@ static int apci1500_timer_config(struct comedi_device *dev,
 			dev_warn(dev->hw_dev,
 				"This choice for software or hardware gate does not exist\n");
 			return -EINVAL;
-		}		/*  switch(data[6]) */
+		}
 
 		i_TimerCounterMode = data[2] | data[4] | data[5] | data[6] | 7;
 
@@ -1294,18 +1294,18 @@ static int apci1500_timer_config(struct comedi_device *dev,
 				outb(0x2,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
-			}	/* if(data[7]== APCI1500_ENABLE ||data[7]== APCI1500_DISABLE) */
+			}
 			else {
 				dev_warn(dev->hw_dev,
 					"Error in selection of interrupt enable or disable\n");
 				return -EINVAL;
-			}	/* elseif(data[7]== APCI1500_ENABLE ||data[7]== APCI1500_DISABLE) */
-		}		/*  if ((data[3]>= 0) && (data[3] <= 65535)) */
+			}
+		}
 		else {
 			dev_warn(dev->hw_dev,
 				"Error in selection of reload value\n");
 			return -EINVAL;
-		}		/* else if ((data[3]>= 0) && (data[3] <= 65535)) */
+		}
 		i_TimerCounterWatchdogInterrupt = data[7];
 		i_TimerCounter2Init = 1;
 		break;
@@ -1322,7 +1322,7 @@ static int apci1500_timer_config(struct comedi_device *dev,
 			dev_warn(dev->hw_dev,
 				"This choice is not a watchdog nor a counter\n");
 			return -EINVAL;
-		}		/*  switch(data[2]) */
+		}
 
 		/* Selecting  single or continuous mode */
 		switch (data[4]) {
@@ -1336,7 +1336,7 @@ static int apci1500_timer_config(struct comedi_device *dev,
 			dev_warn(dev->hw_dev,
 				"This option for single/continuous mode does not exist\n");
 			return -EINVAL;
-		}		/*  switch(data[4]) */
+		}
 
 		/* Selecting  software or hardware gate */
 		switch (data[6]) {
@@ -1350,7 +1350,7 @@ static int apci1500_timer_config(struct comedi_device *dev,
 			dev_warn(dev->hw_dev,
 				"This choice for software or hardware gate does not exist\n");
 			return -EINVAL;
-		}		/*  switch(data[6]) */
+		}
 
 		/* Test if used for watchdog */
 
@@ -1359,10 +1359,10 @@ static int apci1500_timer_config(struct comedi_device *dev,
 			/* - Enables retrigger       */
 			/* - Pulses output           */
 			i_TimerCounterMode = data[2] | data[4] | 0x54;
-		}		/* if (data[2] == APCI1500_WATCHDOG) */
+		}
 		else {
 			i_TimerCounterMode = data[2] | data[4] | data[6] | 7;
-		}		/* elseif (data[2] == APCI1500_WATCHDOG) */
+		}
 		/* Test the reload value */
 
 		if ((data[3] >= 0) && (data[3] <= 65535)) {
@@ -1454,20 +1454,20 @@ static int apci1500_timer_config(struct comedi_device *dev,
 						devpriv->iobase +
 						APCI1500_Z8536_CONTROL_REGISTER);
 
-				}	/* elseif(data[2]==APCI1500_COUNTER) */
+				}
 
-			}	/* if(data[7]== APCI1500_ENABLE ||data[7]== APCI1500_DISABLE) */
+			}
 			else {
 				dev_warn(dev->hw_dev,
 					"Error in selection of interrupt enable or disable\n");
 				return -EINVAL;
-			}	/* elseif(data[7]== APCI1500_ENABLE ||data[7]== APCI1500_DISABLE) */
-		}		/*  if ((data[3]>= 0) && (data[3] <= 65535)) */
+			}
+		}
 		else {
 			dev_warn(dev->hw_dev,
 				"Error in selection of reload value\n");
 			return -EINVAL;
-		}		/* else if ((data[3]>= 0) && (data[3] <= 65535)) */
+		}
 		i_TimerCounterWatchdogInterrupt = data[7];
 		i_WatchdogCounter3Init = 1;
 		break;
@@ -1476,7 +1476,7 @@ static int apci1500_timer_config(struct comedi_device *dev,
 		dev_warn(dev->hw_dev,
 			"The specified counter/timer option does not exist\n");
 		return -EINVAL;
-	}			/* switch(data[1]) */
+	}
 	i_CounterLogic = data[2];
 	return insn->n;
 }
@@ -1515,7 +1515,7 @@ static int apci1500_timer_write(struct comedi_device *dev,
 				outb(i_CommandAndStatusValue,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
-			}	/* if( i_TimerCounter1Init==1) */
+			}
 			else {
 				dev_warn(dev->hw_dev,
 					"Counter/Timer1 not configured\n");
@@ -1543,12 +1543,12 @@ static int apci1500_timer_write(struct comedi_device *dev,
 					/* Set Trigger and gate */
 
 					i_CommandAndStatusValue = 0x6;
-				}	/* if( i_TimerCounter1Enabled==1) */
+				}
 				else {
 					/* Set Trigger */
 
 					i_CommandAndStatusValue = 0x2;
-				}	/* elseif(i_TimerCounter1Enabled==1) */
+				}
 
 				/* Selects the commands and status register */
 				outb(APCI1500_RW_CPT_TMR1_CMD_STATUS,
@@ -1557,7 +1557,7 @@ static int apci1500_timer_write(struct comedi_device *dev,
 				outb(i_CommandAndStatusValue,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
-			}	/* if( i_TimerCounter1Init==1) */
+			}
 			else {
 				dev_warn(dev->hw_dev,
 					"Counter/Timer1 not configured\n");
@@ -1569,7 +1569,7 @@ static int apci1500_timer_write(struct comedi_device *dev,
 			dev_warn(dev->hw_dev,
 				"The specified option for start/stop/trigger does not exist\n");
 			return -EINVAL;
-		}		/* switch(data[1]) */
+		}
 		break;
 
 	case COUNTER2:
@@ -1590,7 +1590,7 @@ static int apci1500_timer_write(struct comedi_device *dev,
 				outb(i_CommandAndStatusValue,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
-			}	/* if( i_TimerCounter2Init==1) */
+			}
 			else {
 				dev_warn(dev->hw_dev,
 					"Counter/Timer2 not configured\n");
@@ -1617,12 +1617,12 @@ static int apci1500_timer_write(struct comedi_device *dev,
 					/* Set Trigger and gate */
 
 					i_CommandAndStatusValue = 0x6;
-				}	/* if( i_TimerCounter2Enabled==1) */
+				}
 				else {
 					/* Set Trigger */
 
 					i_CommandAndStatusValue = 0x2;
-				}	/* elseif(i_TimerCounter2Enabled==1) */
+				}
 
 				/* Selects the commands and status register */
 				outb(APCI1500_RW_CPT_TMR2_CMD_STATUS,
@@ -1631,7 +1631,7 @@ static int apci1500_timer_write(struct comedi_device *dev,
 				outb(i_CommandAndStatusValue,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
-			}	/* if( i_TimerCounter2Init==1) */
+			}
 			else {
 				dev_warn(dev->hw_dev,
 					"Counter/Timer2 not configured\n");
@@ -1642,7 +1642,7 @@ static int apci1500_timer_write(struct comedi_device *dev,
 			dev_warn(dev->hw_dev,
 				"The specified option for start/stop/trigger does not exist\n");
 			return -EINVAL;
-		}		/* switch(data[1]) */
+		}
 		break;
 	case COUNTER3:
 		switch (data[1]) {
@@ -1664,7 +1664,7 @@ static int apci1500_timer_write(struct comedi_device *dev,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 
-			}	/*  if( i_WatchdogCounter3init==1) */
+			}
 			else {
 				dev_warn(dev->hw_dev,
 					"Watchdog/Counter3 not configured\n");
@@ -1694,12 +1694,12 @@ static int apci1500_timer_write(struct comedi_device *dev,
 						/* Set Trigger and gate */
 
 						i_CommandAndStatusValue = 0x6;
-					}	/* if( i_WatchdogCounter3Enabled==1) */
+					}
 					else {
 						/* Set Trigger */
 
 						i_CommandAndStatusValue = 0x2;
-					}	/* elseif(i_WatchdogCounter3Enabled==1) */
+					}
 
 					/* Selects the commands and status register */
 					outb(APCI1500_RW_CPT_TMR3_CMD_STATUS,
@@ -1708,7 +1708,7 @@ static int apci1500_timer_write(struct comedi_device *dev,
 					outb(i_CommandAndStatusValue,
 						devpriv->iobase +
 						APCI1500_Z8536_CONTROL_REGISTER);
-				}	/* if( i_WatchdogCounter3Init==1) */
+				}
 				else {
 					dev_warn(dev->hw_dev,
 						"Counter3 not configured\n");
@@ -1726,7 +1726,7 @@ static int apci1500_timer_write(struct comedi_device *dev,
 					outb(0x6,
 						devpriv->iobase +
 						APCI1500_Z8536_CONTROL_REGISTER);
-				}	/* if( i_WatchdogCounter3Init==1) */
+				}
 				else {
 					dev_warn(dev->hw_dev,
 						"Watchdog 3 not configured\n");
@@ -1737,19 +1737,19 @@ static int apci1500_timer_write(struct comedi_device *dev,
 				dev_warn(dev->hw_dev,
 					"Wrong choice of watchdog/counter3\n");
 				return -EINVAL;
-			}	/* switch(data[2]) */
+			}
 			break;
 		default:
 			dev_warn(dev->hw_dev,
 				"The specified option for start/stop/trigger does not exist\n");
 			return -EINVAL;
-		}		/* switch(data[1]) */
+		}
 		break;
 	default:
 		dev_warn(dev->hw_dev,
 			"The specified choice for counter/watchdog/timer does not exist\n");
 		return -EINVAL;
-	}			/* switch(data[0]) */
+	}
 	return insn->n;
 }
 
@@ -1774,12 +1774,12 @@ static int apci1500_timer_bits(struct comedi_device *dev,
 				/* Set RCC and gate */
 
 				i_CommandAndStatusValue = 0xC;
-			}	/* if( i_TimerCounter1Init==1) */
+			}
 			else {
 				/* Set RCC */
 
 				i_CommandAndStatusValue = 0x8;
-			}	/* elseif(i_TimerCounter1Init==1) */
+			}
 
 			/* Selects the commands and status register */
 			outb(APCI1500_RW_CPT_TMR1_CMD_STATUS,
@@ -1804,12 +1804,12 @@ static int apci1500_timer_bits(struct comedi_device *dev,
 			data[0] =
 				data[0] | inb(devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
-		}		/* if( i_TimerCounter1Init==1) */
+		}
 		else {
 			dev_warn(dev->hw_dev,
 				"Timer/Counter1 not configured\n");
 			return -EINVAL;
-		}		/* elseif( i_TimerCounter1Init==1) */
+		}
 		break;
 	case COUNTER2:
 		/* Read counter/timer2 */
@@ -1818,12 +1818,12 @@ static int apci1500_timer_bits(struct comedi_device *dev,
 				/* Set RCC and gate */
 
 				i_CommandAndStatusValue = 0xC;
-			}	/* if( i_TimerCounter2Init==1) */
+			}
 			else {
 				/* Set RCC */
 
 				i_CommandAndStatusValue = 0x8;
-			}	/* elseif(i_TimerCounter2Init==1) */
+			}
 
 			/* Selects the commands and status register */
 			outb(APCI1500_RW_CPT_TMR2_CMD_STATUS,
@@ -1853,7 +1853,7 @@ static int apci1500_timer_bits(struct comedi_device *dev,
 			dev_warn(dev->hw_dev,
 				"Timer/Counter2 not configured\n");
 			return -EINVAL;
-		}		/* elseif( i_TimerCounter2Init==1) */
+		}
 		break;
 	case COUNTER3:
 		/* Read counter/watchdog2 */
@@ -1862,12 +1862,12 @@ static int apci1500_timer_bits(struct comedi_device *dev,
 				/* Set RCC and gate */
 
 				i_CommandAndStatusValue = 0xC;
-			}	/* if( i_TimerCounter2Init==1) */
+			}
 			else {
 				/* Set RCC */
 
 				i_CommandAndStatusValue = 0x8;
-			}	/* elseif(i_WatchdogCounter3Init==1) */
+			}
 
 			/* Selects the commands and status register */
 			outb(APCI1500_RW_CPT_TMR3_CMD_STATUS,
@@ -1892,18 +1892,18 @@ static int apci1500_timer_bits(struct comedi_device *dev,
 			data[0] =
 				data[0] | inb(devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
-		}		/* if( i_WatchdogCounter3Init==1) */
+		}
 		else {
 			dev_warn(dev->hw_dev,
 				"WatchdogCounter3 not configured\n");
 			return -EINVAL;
-		}		/* elseif( i_WatchdogCounter3Init==1) */
+		}
 		break;
 	default:
 		dev_warn(dev->hw_dev,
 			"The choice of timer/counter/watchdog does not exist\n");
 		return -EINVAL;
-	}			/* switch(data[0]) */
+	}
 
 	return insn->n;
 }
@@ -1942,17 +1942,17 @@ static int apci1500_do_bits(struct comedi_device *dev,
 	outl(0x0, devpriv->i_IobaseAmcc + 0x38);
 	if (data[0] == 1) {
 		i_Constant = 0xC0;
-	}			/* if(data[0]==1) */
+	}
 	else {
 		if (data[0] == 0) {
 			i_Constant = 0x00;
-		}		/* if{data[0]==0) */
+		}
 		else {
 			dev_warn(dev->hw_dev,
 				"The parameter passed to driver is in error for enabling the voltage interrupt\n");
 			return -EINVAL;
-		}		/* else if(data[0]==0) */
-	}			/* elseif(data[0]==1) */
+		}
+	}
 
 	/* Selects the mode specification register of port B */
 	outb(APCI1500_RW_PORT_B_SPECIFICATION,
@@ -2067,10 +2067,7 @@ static void apci1500_interrupt(int irq, void *d)
 	if ((ui_InterruptStatus & 0x800000) == 0x800000) {
 		/* Disable all Interrupt */
 		/* Selects the master interrupt control register */
-		/* outb(APCI1500_RW_MASTER_INTERRUPT_CONTROL,devpriv->iobase+APCI1500_Z8536_CONTROL_REGISTER); */
 		/* Disables  the main interrupt on the board */
-		/* outb(0x00,devpriv->iobase+APCI1500_Z8536_CONTROL_REGISTER); */
-
 		/* Selects the command and status register of port A */
 		outb(APCI1500_RW_PORT_A_COMMAND_AND_STATUS,
 			devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
@@ -2105,11 +2102,11 @@ static void apci1500_interrupt(int irq, void *d)
 
 				i_InputChannel = 1 + (i_RegValue >> 1);
 
-			}	/*  if(i_Logic==APCI1500_OR_PRIORITY) */
+			}
 			else {
 				i_InputChannel = 0;
-			}	/* elseif(i_Logic==APCI1500_OR_PRIORITY) */
-		}		/*  if ((i_RegValue & 0x60) == 0x60) */
+			}
+		}
 
 		/* Selects the command and status register of port B */
 		outb(APCI1500_RW_PORT_B_COMMAND_AND_STATUS,
@@ -2142,17 +2139,17 @@ static void apci1500_interrupt(int irq, void *d)
 				if (i_RegValue & 0x80) {
 					i_InterruptMask =
 						i_InterruptMask | 0x40;
-				}	/* if (i_RegValue & 0x80) */
+				}
 
 				if (i_RegValue & 0x40) {
 					i_InterruptMask =
 						i_InterruptMask | 0x80;
-				}	/* if (i_RegValue & 0x40) */
-			}	/*  if (i_RegValue) */
+				}
+			}
 			else {
 				i_InterruptMask = i_InterruptMask | 2;
-			}	/*  if (i_RegValue) */
-		}		/* if ((i_RegValue & 0x60) == 0x60) */
+			}
+		}
 
 		/* Selects the command and status register of timer 1 */
 		outb(APCI1500_RW_CPT_TMR1_CMD_STATUS,
@@ -2170,7 +2167,7 @@ static void apci1500_interrupt(int irq, void *d)
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 			i_InterruptMask = i_InterruptMask | 4;
-		}		/*  if ((i_RegValue & 0x60) == 0x60) */
+		}
 		/* Selects the command and status register of timer 2 */
 		outb(APCI1500_RW_CPT_TMR2_CMD_STATUS,
 			devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
@@ -2187,7 +2184,7 @@ static void apci1500_interrupt(int irq, void *d)
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 			i_InterruptMask = i_InterruptMask | 8;
-		}		/*  if ((i_RegValue & 0x60) == 0x60) */
+		}
 
 		/* Selects the command and status register of timer 3 */
 		outb(APCI1500_RW_CPT_TMR3_CMD_STATUS,
@@ -2208,7 +2205,7 @@ static void apci1500_interrupt(int irq, void *d)
 				i_InterruptMask = i_InterruptMask | 0x10;
 			else
 				i_InterruptMask = i_InterruptMask | 0x20;
-		}		/*  if ((i_RegValue & 0x60) == 0x60) */
+		}
 
 		send_sig(SIGIO, devpriv->tsk_Current, 0);	/*  send signal to the sample */
 		/* Enable all Interrupts */
@@ -2218,12 +2215,12 @@ static void apci1500_interrupt(int irq, void *d)
 			devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 		/* Authorizes the main interrupt on the board */
 		outb(0xD0, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-	}			/*   if ((ui_InterruptStatus & 0x800000) == 0x800000) */
+	}
 	else {
 		dev_warn(dev->hw_dev,
 			"Interrupt from unknown source\n");
 
-	}			/* else if ((ui_InterruptStatus & 0x800000) == 0x800000) */
+	}
 	return;
 }
 
-- 
2.1.0

