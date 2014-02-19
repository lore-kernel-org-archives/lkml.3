Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541AbaBSHhs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 02:37:48 -0500
Received: from nm13-vm10.bullet.mail.gq1.yahoo.com ([98.136.218.155]:41504
	"EHLO nm13-vm10.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751749AbaBSHhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 02:37:46 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=gcom1024; d=yahoo.com;
	b=j3XB7SZs/xSJht1z+WB3YPkcF2Zb1u8adBzMZS/yObSsuP/6QJ0KDkBGmp4M0RBhaneFpUKqOz0CxvB45N0OpVbLjKu0uK0wSqkjTw1THkndY8UmIy4juaPMYgvG66OfhA20v98lrwpzHfuIOVcp6ziJUxOWLJsPLDi+1pfKMOE=;
X-Yahoo-Newman-Id: 843135.8194.bm@smtp232.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: JjSZZ2UVM1nm1tKcJOsWD6Eq5uqKVkiZxDNE31Um1mhB210
 vpqP.wYHV2Y_7x9_aGKv7w4A2vdmdN.NA8l9aNr4FjSSmlClAVU.4CYb6N7m
 sNjqtXrSNwxtiBXXxLNx4NcU7.EwGqMCFKVap0K9_htAEIfcKjb_8uaOQuo4
 b.UxtAfXk8l2DY3KuiqicLFao73t8VG5sB1PztiVIX_re3img6mazJpw40qC
 CXtBmp8byok1sLaUAllUqqjWXIKuBRMjWeFW5Y2kRGqtrFcC2XDD2tq8S5D_
 7PpLzyMtjiGf_1fm0yc3rvOFb4tfT4QmGAUY2KzihwbKBkix4nkyypENZ3Fu
 ox9QVhn4P0AyevUAJuvwEbTBYnNxVYHDFzFYQQGENfCGqFLPpJAjuurlMoTl
 iB8_6sTdVKSZJd590RSxSU7fHARELr7Q9BMNko35uWaKhnbuOhqGKZH3su7y
 4I0HLfyVo7iLA3taEjj.YoZwDmCjAeWQDuoYgIT7Owv4p4xeBQ_mXQ2s6c1Q
 TSGafFA0.DnVzgRcoTyQQnI.56jLusqE-
X-Yahoo-SMTP: Ua.BYCGswBCLcNpMqiQEtkMTjL08M6XQy5ZdmA--
X-Rocket-Received: from localhost.localdomain (chase.southwood@50.129.102.163 with plain [98.138.105.21])
        by smtp232.mail.gq1.yahoo.com with SMTP; 19 Feb 2014 07:37:45 +0000 UTC
From: Chase Southwood <chase.southwood@yahoo.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@yahoo.com>
Subject: [PATCH 2/4] Staging: comedi: addi-data: cleanup brace usage in hwdrv_apci1564.c
Date: Wed, 19 Feb 2014 01:37:42 -0600
Message-Id: <1392795462-8668-1-git-send-email-chase.southwood@yahoo.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1392795406-8623-1-git-send-email-chase.southwood@yahoo.com>
References: <1392795406-8623-1-git-send-email-chase.southwood@yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hwdrv_apci1564.c had many single statments wrapped in braces, so we can
delete these.  Also, some else statements were improperly placed, fix
these too.

Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
---
 .../comedi/drivers/addi-data/hwdrv_apci1564.c      | 58 ++++++++--------------
 1 file changed, 22 insertions(+), 36 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
index ff556cc..66e6e68 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
@@ -153,14 +153,12 @@ static int i_APCI1564_ConfigDigitalInput(struct comedi_device *dev,
 			outl(0x4,
 				devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP +
 				APCI1564_DIGITAL_IP_IRQ);
-		}
-		else {
+		} else {
 			outl(0x6,
 				devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP +
 				APCI1564_DIGITAL_IP_IRQ);
 		}
-	}
-	else {
+	} else {
 		outl(0x0,
 			devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP +
 			APCI1564_DIGITAL_IP_INTERRUPT_MODE1);
@@ -225,24 +223,22 @@ static int i_APCI1564_ConfigDigitalOutput(struct comedi_device *dev,
 			"Not a valid Data !!! ,Data should be 1 or 0\n");
 		return -EINVAL;
 	}
-	if (data[0]) {
+
+	if (data[0])
 		devpriv->b_OutputMemoryStatus = ADDIDATA_ENABLE;
-	}
-	else {
+	else
 		devpriv->b_OutputMemoryStatus = ADDIDATA_DISABLE;
-	}
-	if (data[1] == ADDIDATA_ENABLE) {
+
+	if (data[1] == ADDIDATA_ENABLE)
 		ul_Command = ul_Command | 0x1;
-	}
-	else {
+	else
 		ul_Command = ul_Command & 0xFFFFFFFE;
-	}
-	if (data[2] == ADDIDATA_ENABLE) {
+
+	if (data[2] == ADDIDATA_ENABLE)
 		ul_Command = ul_Command | 0x2;
-	}
-	else {
+	else
 		ul_Command = ul_Command & 0xFFFFFFFD;
-	}
+
 	outl(ul_Command,
 		devpriv->i_IobaseAmcc + APCI1564_DIGITAL_OP +
 		APCI1564_DIGITAL_OP_INTERRUPT);
@@ -322,8 +318,7 @@ static int i_APCI1564_ConfigTimerCounterWatchdog(struct comedi_device *dev,
 		outl(data[3],
 			devpriv->i_IobaseAmcc + APCI1564_DIGITAL_OP_WATCHDOG +
 			APCI1564_TCW_RELOAD_VALUE);
-	}
-	else if (data[0] == ADDIDATA_TIMER) {
+	} else if (data[0] == ADDIDATA_TIMER) {
 		/* First Stop The Timer */
 		ul_Command1 =
 			inl(devpriv->i_IobaseAmcc + APCI1564_TIMER +
@@ -356,8 +351,7 @@ static int i_APCI1564_ConfigTimerCounterWatchdog(struct comedi_device *dev,
 			outl(0x0,
 				devpriv->iobase + APCI1564_COUNTER4 +
 				APCI1564_TCW_IRQ);
-		}
-		else {
+		} else {
 			outl(0x0, devpriv->i_IobaseAmcc + APCI1564_TIMER + APCI1564_TCW_PROG);	/* disable Timer interrupt */
 		}
 
@@ -377,8 +371,7 @@ static int i_APCI1564_ConfigTimerCounterWatchdog(struct comedi_device *dev,
 		ul_Command1 =
 			(ul_Command1 & 0xFFF719E2UL) | 2UL << 13UL | 0x10UL;
 		outl(ul_Command1, devpriv->i_IobaseAmcc + APCI1564_TIMER + APCI1564_TCW_PROG);	/* mode 2 */
-	}
-	else if (data[0] == ADDIDATA_COUNTER) {
+	} else if (data[0] == ADDIDATA_COUNTER) {
 		devpriv->b_TimerSelectMode = ADDIDATA_COUNTER;
 		devpriv->b_ModeSelectRegister = data[5];
 
@@ -420,8 +413,7 @@ static int i_APCI1564_ConfigTimerCounterWatchdog(struct comedi_device *dev,
 		outl(ul_Command1,
 			devpriv->iobase + ((data[5] - 1) * 0x20) +
 			APCI1564_TCW_PROG);
-	}
-	else {
+	} else {
 		printk(" Invalid subdevice.");
 	}
 
@@ -495,8 +487,7 @@ static int i_APCI1564_StartStopWriteTimerCounterWatchdog(struct comedi_device *d
 			outl(ul_Command1,
 				devpriv->i_IobaseAmcc + APCI1564_TIMER +
 				APCI1564_TCW_PROG);
-		}
-		else if (data[1] == 0) {
+		} else if (data[1] == 0) {
 			/* Stop The Timer */
 
 			ul_Command1 =
@@ -515,13 +506,11 @@ static int i_APCI1564_StartStopWriteTimerCounterWatchdog(struct comedi_device *d
 		if (data[1] == 1) {
 			/* Start the Counter subdevice */
 			ul_Command1 = (ul_Command1 & 0xFFFFF9FFUL) | 0x1UL;
-		}
-		else if (data[1] == 0) {
+		} else if (data[1] == 0) {
 			/*  Stops the Counter subdevice */
 			ul_Command1 = 0;
 
-		}
-		else if (data[1] == 2) {
+		} else if (data[1] == 2) {
 			/*  Clears the Counter subdevice */
 			ul_Command1 = (ul_Command1 & 0xFFFFF9FFUL) | 0x400;
 		}
@@ -570,8 +559,7 @@ static int i_APCI1564_ReadTimerCounterWatchdog(struct comedi_device *dev,
 		data[1] =
 			inl(devpriv->i_IobaseAmcc +
 			APCI1564_DIGITAL_OP_WATCHDOG);
-	}
-	else if (devpriv->b_TimerSelectMode == ADDIDATA_TIMER) {
+	} else if (devpriv->b_TimerSelectMode == ADDIDATA_TIMER) {
 		/*  Stores the status of the Timer */
 		data[0] =
 			inl(devpriv->i_IobaseAmcc + APCI1564_TIMER +
@@ -579,8 +567,7 @@ static int i_APCI1564_ReadTimerCounterWatchdog(struct comedi_device *dev,
 
 		/*  Stores the Actual value of the Timer */
 		data[1] = inl(devpriv->i_IobaseAmcc + APCI1564_TIMER);
-	}
-	else if (devpriv->b_TimerSelectMode == ADDIDATA_COUNTER) {
+	} else if (devpriv->b_TimerSelectMode == ADDIDATA_COUNTER) {
 		/*  Read the Counter Actual Value. */
 		data[0] =
 			inl(devpriv->iobase + ((devpriv->b_ModeSelectRegister -
@@ -601,8 +588,7 @@ static int i_APCI1564_ReadTimerCounterWatchdog(struct comedi_device *dev,
 
 		/* Get the overflow status */
 		data[4] = (unsigned char) ((ul_Command1 >> 0) & 1);
-	}
-	else if ((devpriv->b_TimerSelectMode != ADDIDATA_TIMER)
+	} else if ((devpriv->b_TimerSelectMode != ADDIDATA_TIMER)
 		&& (devpriv->b_TimerSelectMode != ADDIDATA_WATCHDOG)
 		&& (devpriv->b_TimerSelectMode != ADDIDATA_COUNTER)) {
 		printk("\n Invalid Subdevice !!!\n");
-- 
1.8.5.3

