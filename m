Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332AbaCICn1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 21:43:27 -0500
Received: from mail-ig0-f177.google.com ([209.85.213.177]:56879 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbaCICnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 21:43:01 -0500
Date: Sat, 8 Mar 2014 21:42:58 -0500
From: Conrad Meyer <cemeyer@uw.edu>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] Staging: comedi: do not initialize statics to 0
 (apci1500)
Message-ID: <20140308214258.301ce2c5@m>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minor style cleanup per checkpatch.pl.

Signed-off-by: Conrad Meyer <cse.cem@gmail.com>
---
 .../comedi/drivers/addi-data/hwdrv_apci1500.c      | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
index 4f5ce6a..1f7adc5 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
@@ -124,50 +124,50 @@ enum {
 
 	APCI1500_RW_PORT_A_SPECIFICATION,
 	APCI1500_RW_PORT_A_HANDSHAKE_SPECIFICATION,
 	APCI1500_RW_PORT_A_DATA_PCITCH_POLARITY,
 	APCI1500_RW_PORT_A_DATA_DIRECTION,
 	APCI1500_RW_PORT_A_SPECIAL_IO_CONTROL,
 	APCI1500_RW_PORT_A_PATTERN_POLARITY,
 	APCI1500_RW_PORT_A_PATTERN_TRANSITION,
 	APCI1500_RW_PORT_A_PATTERN_MASK,
 
 	APCI1500_RW_PORT_B_SPECIFICATION,
 	APCI1500_RW_PORT_B_HANDSHAKE_SPECIFICATION,
 	APCI1500_RW_PORT_B_DATA_PCITCH_POLARITY,
 	APCI1500_RW_PORT_B_DATA_DIRECTION,
 	APCI1500_RW_PORT_B_SPECIAL_IO_CONTROL,
 	APCI1500_RW_PORT_B_PATTERN_POLARITY,
 	APCI1500_RW_PORT_B_PATTERN_TRANSITION,
 	APCI1500_RW_PORT_B_PATTERN_MASK
 };
 
-static int i_TimerCounter1Init = 0;
-static int i_TimerCounter2Init = 0;
-static int i_WatchdogCounter3Init = 0;
-static int i_Event1Status = 0, i_Event2Status = 0;
-static int i_TimerCounterWatchdogInterrupt = 0;
-static int i_Logic = 0, i_CounterLogic = 0;
-static int i_InterruptMask = 0;
-static int i_InputChannel = 0;
-static int i_TimerCounter1Enabled = 0, i_TimerCounter2Enabled = 0,
-	   i_WatchdogCounter3Enabled = 0;
+static int i_TimerCounter1Init;
+static int i_TimerCounter2Init;
+static int i_WatchdogCounter3Init;
+static int i_Event1Status, i_Event2Status;
+static int i_TimerCounterWatchdogInterrupt;
+static int i_Logic, i_CounterLogic;
+static int i_InterruptMask;
+static int i_InputChannel;
+static int i_TimerCounter1Enabled, i_TimerCounter2Enabled,
+	   i_WatchdogCounter3Enabled;
 
 /*
   +----------------------------------------------------------------------------+
 | Function   Name   : int i_APCI1500_ConfigDigitalInputEvent                 |
 |			  (struct comedi_device *dev,struct comedi_subdevice *s,               |
 |                      struct comedi_insn *insn,unsigned int *data)                     |
 +----------------------------------------------------------------------------+
 | Task              : An event can be generated for each port.               |
 |                     The first event is related to the first 8 channels     |
 |                     (port 1) and the second to the following 6 channels    |
 |                     (port 2). An interrupt is generated when one or both   |
 |                     events have occurred                                   |
 +----------------------------------------------------------------------------+
 | Input Parameters  : struct comedi_device *dev : Driver handle                     |
 |                     unsigned int *data     : Data Pointer contains             |
 |                                          configuration parameters as below |
 |                                                                            |
 |			  data[0]            :Number of the input port on        |
 |                                         which the event will take place    |
 |                                         (1 or 2)
@@ -960,41 +960,41 @@ static int i_acpi1500_config_output(struct comedi_device *dev,
 +----------------------------------------------------------------------------+
 | Task              : Writes port value  To the selected port                |
 +----------------------------------------------------------------------------+
 | Input Parameters  : struct comedi_device *dev      : Driver handle                |
 |                     unsigned int ui_NoOfChannels    : No Of Channels To Write      |
 |                     unsigned int *data              : Data Pointer to read status  |
 +----------------------------------------------------------------------------+
 | Output Parameters :	--													 |
 +----------------------------------------------------------------------------+
 | Return Value      : TRUE  : No error occur                                 |
 |		            : FALSE : Error occur. Return the error          |
 |			                                                         |
 +----------------------------------------------------------------------------+
 */
 static int i_APCI1500_WriteDigitalOutput(struct comedi_device *dev,
 					 struct comedi_subdevice *s,
 					 struct comedi_insn *insn,
 					 unsigned int *data)
 {
 	struct addi_private *devpriv = dev->private;
-	static unsigned int ui_Temp = 0;
+	static unsigned int ui_Temp;
 	unsigned int ui_Temp1;
 	unsigned int ui_NoOfChannel = CR_CHAN(insn->chanspec);	/*  get the channel */
 
 	if (!devpriv->b_OutputMemoryStatus) {
 		ui_Temp = 0;
 
 	}			/* if(!devpriv->b_OutputMemoryStatus ) */
 	if (data[3] == 0) {
 		if (data[1] == 0) {
 			data[0] = (data[0] << ui_NoOfChannel) | ui_Temp;
 			outw(data[0],
 				devpriv->i_IobaseAddon + APCI1500_DIGITAL_OP);
 		}		/* if(data[1]==0) */
 		else {
 			if (data[1] == 1) {
 				switch (ui_NoOfChannel) {
 
 				case 2:
 					data[0] =
 						(data[0] << (2 *
-- 
1.8.5.3
