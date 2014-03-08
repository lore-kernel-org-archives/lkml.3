Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056AbaCHUr3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 15:47:29 -0500
Received: from mail-ig0-f171.google.com ([209.85.213.171]:34158 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbaCHUr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 15:47:28 -0500
Date: Sat, 8 Mar 2014 15:47:24 -0500
From: Conrad Meyer <cemeyer@uw.edu>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Updated: [PATCH] Staging: comedi: Fix 80-char line limit style
 issue in addi_apci_1500.c
Message-ID: <20140308154724.57a1d53d@m>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename some very long functions in addi-data/hwdrv_apci1500.c.

Signed-off-by: Conrad Meyer <cse.cem@gmail.com>
---
 .../staging/comedi/drivers/addi-data/hwdrv_apci1500.c  | 18 ++++++++----------
 drivers/staging/comedi/drivers/addi_apci_1500.c        |  4 ++--
 2 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
index 0549105..2628ac4 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
@@ -1035,70 +1035,69 @@ static int i_APCI1500_Initialisation(struct comedi_device *dev,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* Deletes all interrupts */
 	outb(0, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	return insn->n;
 }
 
 static int apci1500_di_insn_bits(struct comedi_device *dev,
 				 struct comedi_subdevice *s,
 				 struct comedi_insn *insn,
 				 unsigned int *data)
 {
 	struct addi_private *devpriv = dev->private;
 
 	data[1] = inw(devpriv->i_IobaseAddon + APCI1500_DIGITAL_IP);
 
 	return insn->n;
 }
 
 /*
 +----------------------------------------------------------------------------+
-| Function   Name   : int i_APCI1500_ConfigDigitalOutputErrorInterrupt
+| Function   Name   : int i_apci1500_config_output
 |                      (struct comedi_device *dev,struct comedi_subdevice *s struct comedi_insn
 |                      *insn,unsigned int *data)                                  |
 |				                                                     |
 +----------------------------------------------------------------------------+
 | Task              : Configures the digital output memory and the digital
 |                      output error interrupt                                 |
 +----------------------------------------------------------------------------+
 | Input Parameters  : struct comedi_device *dev : Driver handle                     |
 |                     unsigned int *data         : Data Pointer contains         |
 |                                          configuration parameters as below |
 |                      struct comedi_subdevice *s,   :pointer to subdevice structure
 |                       struct comedi_insn *insn      :pointer to insn structure                                                                                                                |
 |					  data[0]  :1:Memory on                          |
 |					            0:Memory off                         |
 |                              data[1]  :1 Enable the voltage error interrupt
 |							   :0 Disable the voltage error interrupt 		                                                                                                    |
 |																	 |
 +----------------------------------------------------------------------------+
 | Output Parameters :	--													 |
 +----------------------------------------------------------------------------+
 | Return Value      : TRUE  : No error occur                                 |
 |		            : FALSE : Error occur. Return the error          |
 |			                                                         |
 +----------------------------------------------------------------------------+
 */
-static int i_APCI1500_ConfigDigitalOutputErrorInterrupt(struct comedi_device *dev,
-							struct comedi_subdevice *s,
-							struct comedi_insn *insn,
-							unsigned int *data)
+static int i_acpi1500_config_output(struct comedi_device *dev,
+	struct comedi_subdevice *s, struct comedi_insn *insn,
+	unsigned int *data)
 {
 	struct addi_private *devpriv = dev->private;
 
 	devpriv->b_OutputMemoryStatus = data[0];
 	return insn->n;
 }
 
 /*
 +----------------------------------------------------------------------------+
 | Function   Name   : int i_APCI1500_WriteDigitalOutput                      |
 |			  (struct comedi_device *dev,struct comedi_subdevice *s,               |
 |                      struct comedi_insn *insn,unsigned int *data)                     |
 +----------------------------------------------------------------------------+
 | Task              : Writes port value  To the selected port                |
 +----------------------------------------------------------------------------+
 | Input Parameters  : struct comedi_device *dev      : Driver handle                |
 |                     unsigned int ui_NoOfChannels    : No Of Channels To Write      |
 |                     unsigned int *data              : Data Pointer to read status  |
 +----------------------------------------------------------------------------+
 | Output Parameters :	--													 |
@@ -1862,70 +1861,69 @@ static int i_APCI1500_ConfigCounterTimerWatchdog(struct comedi_device *dev,
 				return -EINVAL;
 			}	/* elseif(data[7]== APCI1500_ENABLE ||data[7]== APCI1500_DISABLE) */
 		}		/*  if ((data[3]>= 0) && (data[3] <= 65535)) */
 		else {
 			printk("\nError in selection of reload value\n");
 			return -EINVAL;
 		}		/* else if ((data[3]>= 0) && (data[3] <= 65535)) */
 		i_TimerCounterWatchdogInterrupt = data[7];
 		i_WatchdogCounter3Init = 1;
 		break;
 
 	default:
 		printk("\nThe specified counter\timer option does not exist\n");
 	}			/* switch(data[1]) */
 	i_CounterLogic = data[2];
 	return insn->n;
 }
 
 /*
 +----------------------------------------------------------------------------+
-| Function   Name   : int i_APCI1500_StartStopTriggerTimerCounterWatchdog      |
+| Function   Name   : int i_apci1500_timer_watchdog
 |				(struct comedi_device *dev,struct comedi_subdevice *s,
 |                         struct comedi_insn *insn,unsigned int *data);                  |
 +----------------------------------------------------------------------------+
 | Task              : Start / Stop or trigger the timer counter or Watchdog  |
 +----------------------------------------------------------------------------+
 | Input Parameters  : struct comedi_device *dev     : Driver handle                 |
 |                     struct comedi_subdevice *s,   :pointer to subdevice structure
 |                      struct comedi_insn *insn      :pointer to insn structure      |
 |                     unsigned int *data         : Data Pointer to read status   |
 |                      data[0]                : 0     Counter1/Timer1
 |                                               1     Counter2/Timer2
 |                                               2     Counter3/Watchdog
 |                      data[1]                : 0     start
 |                                               1     stop
 |                                               2     Trigger
 |                      data[2]                : 0     Counter
 |                                               1     Timer/Watchdog
 +----------------------------------------------------------------------------+
 | Output Parameters :	--													 |
 +----------------------------------------------------------------------------+
 | Return Value      : TRUE  : No error occur                                 |
 |		            : FALSE : Error occur. Return the error          |
 |			                                                         |
 +----------------------------------------------------------------------------+
 */
-static int i_APCI1500_StartStopTriggerTimerCounterWatchdog(struct comedi_device *dev,
-							   struct comedi_subdevice *s,
-							   struct comedi_insn *insn,
-							   unsigned int *data)
+static int i_apci1500_timer_watchdog(struct comedi_device *dev,
+	struct comedi_subdevice *s, struct comedi_insn *insn,
+	unsigned int *data)
 {
 	struct addi_private *devpriv = dev->private;
 	int i_CommandAndStatusValue;
 
 	switch (data[0]) {
 	case COUNTER1:
 		switch (data[1]) {
 		case START:
 			if (i_TimerCounter1Init == 1) {
 				if (i_TimerCounterWatchdogInterrupt == 1) {
 					i_CommandAndStatusValue = 0xC4;	/* Enable the interrupt */
 				}	/*  if(i_TimerCounterWatchdogInterrupt==1) */
 				else {
 					i_CommandAndStatusValue = 0xE4;	/* disable the interrupt */
 				}	/* elseif(i_TimerCounterWatchdogInterrupt==1) */
 					      /**************************/
 				/* Starts timer/counter 1 */
 					      /**************************/
 				i_TimerCounter1Enabled = 1;
 						/********************************************/
diff --git a/drivers/staging/comedi/drivers/addi_apci_1500.c b/drivers/staging/comedi/drivers/addi_apci_1500.c
index 74f7ace..afa7d6e 100644
--- a/drivers/staging/comedi/drivers/addi_apci_1500.c
+++ b/drivers/staging/comedi/drivers/addi_apci_1500.c
@@ -9,45 +9,45 @@
 
 #include "addi-data/addi_eeprom.c"
 #include "addi-data/hwdrv_apci1500.c"
 #include "addi-data/addi_common.c"
 
 static const struct addi_board apci1500_boardtypes[] = {
 	{
 		.pc_DriverName		= "apci1500",
 		.i_IorangeBase1		= APCI1500_ADDRESS_RANGE,
 		.i_PCIEeprom		= ADDIDATA_NO_EEPROM,
 		.i_NbrDiChannel		= 16,
 		.i_NbrDoChannel		= 16,
 		.i_DoMaxdata		= 0xffff,
 		.i_Timer		= 1,
 		.interrupt		= v_APCI1500_Interrupt,
 		.reset			= i_APCI1500_Reset,
 		.di_config		= i_APCI1500_ConfigDigitalInputEvent,
 		.di_read		= i_APCI1500_Initialisation,
 		.di_write		= i_APCI1500_StartStopInputEvent,
 		.di_bits		= apci1500_di_insn_bits,
-		.do_config		= i_APCI1500_ConfigDigitalOutputErrorInterrupt,
+		.do_config		= i_acpi1500_config_output,
 		.do_write		= i_APCI1500_WriteDigitalOutput,
 		.do_bits		= i_APCI1500_ConfigureInterrupt,
 		.timer_config		= i_APCI1500_ConfigCounterTimerWatchdog,
-		.timer_write		= i_APCI1500_StartStopTriggerTimerCounterWatchdog,
+		.timer_write		= i_apci1500_timer_watchdog,
 		.timer_read		= i_APCI1500_ReadInterruptMask,
 		.timer_bits		= i_APCI1500_ReadCounterTimerWatchdog,
 	},
 };
 
 static int apci1500_auto_attach(struct comedi_device *dev,
 				unsigned long context)
 {
 	dev->board_ptr = &apci1500_boardtypes[0];
 
 	return addi_auto_attach(dev, context);
 }
 
 static struct comedi_driver apci1500_driver = {
 	.driver_name	= "addi_apci_1500",
 	.module		= THIS_MODULE,
 	.auto_attach	= apci1500_auto_attach,
 	.detach		= i_ADDI_Detach,
 };
 
-- 
1.8.5.3
