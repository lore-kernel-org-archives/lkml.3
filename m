Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016AbaHLCD6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 22:03:58 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:45758 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754939AbaHLCD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 22:03:56 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>,
        H Hartley Sweeten <hsweeten@visionengraver.com>
Subject: [PATCH 3/3] staging: comedi: addi_apci_1564: tidy register map defines
Date: Mon, 11 Aug 2014 21:03:48 -0500
Message-Id: <e56ba372462c6c4c86787752d85936f610ff2a31.1407804777.git.chase.southwood@gmail.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cover.1407804777.git.chase.southwood@gmail.com>
References: <cover.1407804777.git.chase.southwood@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit performs a final tidying of the register map defines, bringing
them to a state that is ready for merging into addi_apci_1564.c when the
time comes.  Actions performed include:

*Removes the APCI1564_ADDRESS_RANGE macro, which is no longer needed/used.
*Renames the APCI1564_DIGITAL_OP_{VCC,CC}_INTERRUPT_{ENABLE,DISABLE}
macros to shorter names which are more consistent with the digital input
interrupt macros.
*Fixes a typo in a comment (dev>iobase changed to dev->iobase).
*Renames the APCI1564_TCW_* macros to APCI1564_COUNTER_* names to more
accurately reflect that they are only offsets to counter registers (since
only the counters are offset from dev->iobase).

Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hsweeten@visionengraver.com>
---
 .../comedi/drivers/addi-data/hwdrv_apci1564.c      | 70 ++++++++++++----------
 drivers/staging/comedi/drivers/addi_apci_1564.c    | 19 +++---
 2 files changed, 48 insertions(+), 41 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
index f8d8cc9..198c627 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
@@ -21,8 +21,6 @@
  *
  */
 
-#define APCI1564_ADDRESS_RANGE				128
-
 /* Digital Input IRQ Function Selection */
 #define APCI1564_DI_INT_OR				(0 << 1)
 #define APCI1564_DI_INT_AND				(1 << 1)
@@ -32,10 +30,10 @@
 #define APCI1564_DI_INT_DISABLE				0xfffffffb
 
 /* Digital Output Interrupt Enable Disable. */
-#define APCI1564_DIGITAL_OP_VCC_INTERRUPT_ENABLE	0x1
-#define APCI1564_DIGITAL_OP_VCC_INTERRUPT_DISABLE	0xfffffffe
-#define APCI1564_DIGITAL_OP_CC_INTERRUPT_ENABLE		0x2
-#define APCI1564_DIGITAL_OP_CC_INTERRUPT_DISABLE	0xfffffffd
+#define APCI1564_DO_VCC_INT_ENABLE			0x1
+#define APCI1564_DO_VCC_INT_DISABLE			0xfffffffe
+#define APCI1564_DO_CC_INT_ENABLE			0x2
+#define APCI1564_DO_CC_IN_DISABLE			0xfffffffd
 
 /* TIMER COUNTER WATCHDOG DEFINES */
 #define ADDIDATA_TIMER					0
@@ -76,16 +74,16 @@
 #define APCI1564_TIMER_WARN_TIMEBASE_REG		0x64
 
 /*
- * dev>iobase Register Map
+ * dev->iobase Register Map
  */
-#define APCI1564_TCW_REG(x)				(0x00 + ((x) * 0x20))
-#define APCI1564_TCW_RELOAD_REG(x)			(0x04 + ((x) * 0x20))
-#define APCI1564_TCW_TIMEBASE_REG(x)			(0x08 + ((x) * 0x20))
-#define APCI1564_TCW_CTRL_REG(x)			(0x0c + ((x) * 0x20))
-#define APCI1564_TCW_STATUS_REG(x)			(0x10 + ((x) * 0x20))
-#define APCI1564_TCW_IRQ_REG(x)				(0x14 + ((x) * 0x20))
-#define APCI1564_TCW_WARN_TIMEVAL_REG(x)		(0x18 + ((x) * 0x20))
-#define APCI1564_TCW_WARN_TIMEBASE_REG(x)		(0x1c + ((x) * 0x20))
+#define APCI1564_COUNTER_REG(x)				(0x00 + ((x) * 0x20))
+#define APCI1564_COUNTER_RELOAD_REG(x)			(0x04 + ((x) * 0x20))
+#define APCI1564_COUNTER_TIMEBASE_REG(x)		(0x08 + ((x) * 0x20))
+#define APCI1564_COUNTER_CTRL_REG(x)			(0x0c + ((x) * 0x20))
+#define APCI1564_COUNTER_STATUS_REG(x)			(0x10 + ((x) * 0x20))
+#define APCI1564_COUNTER_IRQ_REG(x)			(0x14 + ((x) * 0x20))
+#define APCI1564_COUNTER_WARN_TIMEVAL_REG(x)		(0x18 + ((x) * 0x20))
+#define APCI1564_COUNTER_WARN_TIMEBASE_REG(x)		(0x1c + ((x) * 0x20))
 
 /*
  * Configures The Timer or Counter
@@ -121,14 +119,14 @@ static int apci1564_timer_config(struct comedi_device *dev,
 			outl(0x0, devpriv->amcc_iobase + APCI1564_DI_IRQ_REG);
 			outl(0x0, devpriv->amcc_iobase + APCI1564_DO_IRQ_REG);
 			outl(0x0, devpriv->amcc_iobase + APCI1564_WDOG_IRQ_REG);
-			outl(0x0,
-			     dev->iobase + APCI1564_TCW_IRQ_REG(APCI1564_COUNTER1));
-			outl(0x0,
-			     dev->iobase + APCI1564_TCW_IRQ_REG(APCI1564_COUNTER2));
-			outl(0x0,
-			     dev->iobase + APCI1564_TCW_IRQ_REG(APCI1564_COUNTER3));
-			outl(0x0,
-			     dev->iobase + APCI1564_TCW_IRQ_REG(APCI1564_COUNTER4));
+			outl(0x0, dev->iobase +
+			    APCI1564_COUNTER_IRQ_REG(APCI1564_COUNTER1));
+			outl(0x0, dev->iobase +
+			    APCI1564_COUNTER_IRQ_REG(APCI1564_COUNTER2));
+			outl(0x0, dev->iobase +
+			    APCI1564_COUNTER_IRQ_REG(APCI1564_COUNTER3));
+			outl(0x0, dev->iobase +
+			    APCI1564_COUNTER_IRQ_REG(APCI1564_COUNTER4));
 		} else {
 			/* disable Timer interrupt */
 			outl(0x0, devpriv->amcc_iobase + APCI1564_TIMER_CTRL_REG);
@@ -149,13 +147,16 @@ static int apci1564_timer_config(struct comedi_device *dev,
 		devpriv->mode_select_register = data[5];
 
 		/* First Stop The Counter */
-		ul_Command1 = inl(dev->iobase + APCI1564_TCW_CTRL_REG(data[5] - 1));
+		ul_Command1 = inl(dev->iobase +
+				 APCI1564_COUNTER_CTRL_REG(data[5] - 1));
 		ul_Command1 = ul_Command1 & 0xFFFFF9FEUL;
 		/* Stop The Timer */
-		outl(ul_Command1, dev->iobase + APCI1564_TCW_CTRL_REG(data[5] - 1));
+		outl(ul_Command1, dev->iobase +
+					APCI1564_COUNTER_CTRL_REG(data[5] - 1));
 
 		/* Set the reload value */
-		outl(data[3], dev->iobase + APCI1564_TCW_RELOAD_REG(data[5] - 1));
+		outl(data[3], dev->iobase +
+					APCI1564_COUNTER_RELOAD_REG(data[5] - 1));
 
 		/* Set the mode :             */
 		/* - Disable the hardware     */
@@ -168,15 +169,18 @@ static int apci1564_timer_config(struct comedi_device *dev,
 		ul_Command1 =
 			(ul_Command1 & 0xFFFC19E2UL) | 0x80000UL |
 			(unsigned int) ((unsigned int) data[4] << 16UL);
-		outl(ul_Command1, dev->iobase + APCI1564_TCW_CTRL_REG(data[5] - 1));
+		outl(ul_Command1, dev->iobase +
+					APCI1564_COUNTER_CTRL_REG(data[5] - 1));
 
 		/*  Enable or Disable Interrupt */
 		ul_Command1 = (ul_Command1 & 0xFFFFF9FD) | (data[1] << 1);
-		outl(ul_Command1, dev->iobase + APCI1564_TCW_CTRL_REG(data[5] - 1));
+		outl(ul_Command1, dev->iobase +
+					APCI1564_COUNTER_CTRL_REG(data[5] - 1));
 
 		/* Set the Up/Down selection */
 		ul_Command1 = (ul_Command1 & 0xFFFBF9FFUL) | (data[6] << 18);
-		outl(ul_Command1, dev->iobase + APCI1564_TCW_CTRL_REG(data[5] - 1));
+		outl(ul_Command1, dev->iobase +
+					APCI1564_COUNTER_CTRL_REG(data[5] - 1));
 	} else {
 		dev_err(dev->class_dev, "Invalid subdevice.\n");
 	}
@@ -214,7 +218,7 @@ static int apci1564_timer_write(struct comedi_device *dev,
 	} else if (devpriv->timer_select_mode == ADDIDATA_COUNTER) {
 		ul_Command1 =
 			inl(dev->iobase +
-			    APCI1564_TCW_CTRL_REG(devpriv->mode_select_register - 1));
+			   APCI1564_COUNTER_CTRL_REG(devpriv->mode_select_register - 1));
 		if (data[1] == 1) {
 			/* Start the Counter subdevice */
 			ul_Command1 = (ul_Command1 & 0xFFFFF9FFUL) | 0x1UL;
@@ -227,7 +231,7 @@ static int apci1564_timer_write(struct comedi_device *dev,
 			ul_Command1 = (ul_Command1 & 0xFFFFF9FFUL) | 0x400;
 		}
 		outl(ul_Command1, dev->iobase +
-		     APCI1564_TCW_CTRL_REG(devpriv->mode_select_register - 1));
+		     APCI1564_COUNTER_CTRL_REG(devpriv->mode_select_register - 1));
 	} else {
 		dev_err(dev->class_dev, "Invalid subdevice.\n");
 	}
@@ -255,10 +259,10 @@ static int apci1564_timer_read(struct comedi_device *dev,
 		/*  Read the Counter Actual Value. */
 		data[0] =
 			inl(dev->iobase +
-			    APCI1564_TCW_REG(devpriv->mode_select_register - 1));
+			    APCI1564_COUNTER_REG(devpriv->mode_select_register - 1));
 		ul_Command1 =
 			inl(dev->iobase +
-			    APCI1564_TCW_STATUS_REG(devpriv->mode_select_register - 1));
+			    APCI1564_COUNTER_STATUS_REG(devpriv->mode_select_register - 1));
 
 		/* Get the software trigger status */
 		data[1] = (unsigned char) ((ul_Command1 >> 1) & 1);
diff --git a/drivers/staging/comedi/drivers/addi_apci_1564.c b/drivers/staging/comedi/drivers/addi_apci_1564.c
index 555e0a9..16c02c8 100644
--- a/drivers/staging/comedi/drivers/addi_apci_1564.c
+++ b/drivers/staging/comedi/drivers/addi_apci_1564.c
@@ -42,10 +42,10 @@ static int apci1564_reset(struct comedi_device *dev)
 	outl(0x0, devpriv->amcc_iobase + APCI1564_TIMER_RELOAD_REG);
 
 	/* Reset the counter registers */
-	outl(0x0, dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER1));
-	outl(0x0, dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER2));
-	outl(0x0, dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER3));
-	outl(0x0, dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER4));
+	outl(0x0, dev->iobase + APCI1564_COUNTER_CTRL_REG(APCI1564_COUNTER1));
+	outl(0x0, dev->iobase + APCI1564_COUNTER_CTRL_REG(APCI1564_COUNTER2));
+	outl(0x0, dev->iobase + APCI1564_COUNTER_CTRL_REG(APCI1564_COUNTER3));
+	outl(0x0, dev->iobase + APCI1564_COUNTER_CTRL_REG(APCI1564_COUNTER4));
 
 	return 0;
 }
@@ -94,17 +94,20 @@ static irqreturn_t apci1564_interrupt(int irq, void *d)
 	}
 
 	for (chan = 0; chan < 4; chan++) {
-		status = inl(dev->iobase + APCI1564_TCW_IRQ_REG(chan));
+		status = inl(dev->iobase + APCI1564_COUNTER_IRQ_REG(chan));
 		if (status & 0x01) {
 			/*  Disable Counter Interrupt */
-			ctrl = inl(dev->iobase + APCI1564_TCW_CTRL_REG(chan));
-			outl(0x0, dev->iobase + APCI1564_TCW_CTRL_REG(chan));
+			ctrl = inl(dev->iobase +
+				  APCI1564_COUNTER_CTRL_REG(chan));
+			outl(0x0, dev->iobase +
+			    APCI1564_COUNTER_CTRL_REG(chan));
 
 			/* Send a signal to from kernel to user space */
 			send_sig(SIGIO, devpriv->tsk_current, 0);
 
 			/*  Enable Counter Interrupt */
-			outl(ctrl, dev->iobase + APCI1564_TCW_CTRL_REG(chan));
+			outl(ctrl, dev->iobase +
+			    APCI1564_COUNTER_CTRL_REG(chan));
 		}
 	}
 
-- 
2.0.4

