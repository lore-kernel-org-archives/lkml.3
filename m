Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782AbaCKRdj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 13:33:39 -0400
Received: from [172.245.23.124] ([172.245.23.124]:49480 "EHLO
	w1-ca.frizzlehost.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753628AbaCKRdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 13:33:37 -0400
From: Fred Akers <knivey@botops.net>
To: gregkh@linuxfoundation.org, abbotti@mev.co.uk,
        hsweeten@visionengravers.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Fred Akers <knivey@botops.net>
Subject: [PATCH v2] Staging: comedi: addi-data: Fix long CamelCase function names
Date: Tue, 11 Mar 2014 13:32:57 -0400
Message-Id: <1394559177-14616-1-git-send-email-knivey@botops.net>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1394350009-23464-1-git-send-email-knivey@botops.net>
References: <1394350009-23464-1-git-send-email-knivey@botops.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a few function names that are very long and are
not in the correct naming style

Signed-off-by: Fred Akers <knivey@botops.net>
---
This is v2 of "[PATCH] Staging: comedi: apci_1564: Fix long CamelCase function names"
Changed subject because it no longer applies to only that file exclusively.
---
 .../comedi/drivers/addi-data/hwdrv_apci035.c       |  53 +++++------
 .../comedi/drivers/addi-data/hwdrv_apci1500.c      |  96 +++++++++-----------
 .../comedi/drivers/addi-data/hwdrv_apci1564.c      |  62 ++++++-------
 .../comedi/drivers/addi-data/hwdrv_apci3120.c      | 100 ++++++++++-----------
 .../comedi/drivers/addi-data/hwdrv_apci3200.c      |  68 +++++++-------
 .../comedi/drivers/addi-data/hwdrv_apci3501.c      |  24 ++---
 drivers/staging/comedi/drivers/addi_apci_035.c     |  14 +--
 drivers/staging/comedi/drivers/addi_apci_1500.c    |  24 ++---
 drivers/staging/comedi/drivers/addi_apci_1564.c    |  16 ++--
 drivers/staging/comedi/drivers/addi_apci_3120.c    |  26 +++---
 drivers/staging/comedi/drivers/addi_apci_3200.c    |  36 ++++----
 drivers/staging/comedi/drivers/addi_apci_3501.c    |   6 +-
 12 files changed, 248 insertions(+), 277 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
index 80cca95..b22a8ea 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
@@ -111,7 +111,7 @@ static int i_Temp;
 static int i_Flag = 1;
 /*
 +----------------------------------------------------------------------------+
-| Function   Name   : int i_APCI035_ConfigTimerWatchdog                      |
+| Function   Name   : int apci035_timer_config                      |
 |			  (struct comedi_device *dev,struct comedi_subdevice *s,               |
 |                      struct comedi_insn *insn,unsigned int *data)                     |
 +----------------------------------------------------------------------------+
@@ -163,10 +163,9 @@ static int i_Flag = 1;
 |			                                                         |
 +----------------------------------------------------------------------------+
 */
-static int i_APCI035_ConfigTimerWatchdog(struct comedi_device *dev,
-					 struct comedi_subdevice *s,
-					 struct comedi_insn *insn,
-					 unsigned int *data)
+static int apci035_timer_config(struct comedi_device *dev,
+				struct comedi_subdevice *s,
+				struct comedi_insn *insn, unsigned int *data)
 {
 	struct addi_private *devpriv = dev->private;
 	unsigned int ui_Status;
@@ -287,7 +286,7 @@ static int i_APCI035_ConfigTimerWatchdog(struct comedi_device *dev,
 
 /*
 +----------------------------------------------------------------------------+
-| Function   Name   : int i_APCI035_StartStopWriteTimerWatchdog              |
+| Function   Name   : int apci035_timer_write              |
 |			  (struct comedi_device *dev,struct comedi_subdevice *s,               |
 |                      struct comedi_insn *insn,unsigned int *data)                     |
 +----------------------------------------------------------------------------+
@@ -312,10 +311,9 @@ static int i_APCI035_ConfigTimerWatchdog(struct comedi_device *dev,
 |					                                                 |
 +----------------------------------------------------------------------------+
 */
-static int i_APCI035_StartStopWriteTimerWatchdog(struct comedi_device *dev,
-						 struct comedi_subdevice *s,
-						 struct comedi_insn *insn,
-						 unsigned int *data)
+static int apci035_timer_write(struct comedi_device *dev,
+			       struct comedi_subdevice *s,
+			       struct comedi_insn *insn, unsigned int *data)
 {
 	struct addi_private *devpriv = dev->private;
 	unsigned int ui_Command;
@@ -402,7 +400,7 @@ static int i_APCI035_StartStopWriteTimerWatchdog(struct comedi_device *dev,
 
 /*
 +----------------------------------------------------------------------------+
-| Function   Name   : int i_APCI035_ReadTimerWatchdog                        |
+| Function   Name   : int apci035_timer_read                        |
 |			  (struct comedi_device *dev,struct comedi_subdevice *s,               |
 |                      struct comedi_insn *insn,unsigned int *data)                     |
 +----------------------------------------------------------------------------+
@@ -427,10 +425,9 @@ static int i_APCI035_StartStopWriteTimerWatchdog(struct comedi_device *dev,
 |			                                                         |
 +----------------------------------------------------------------------------+
 */
-static int i_APCI035_ReadTimerWatchdog(struct comedi_device *dev,
-				       struct comedi_subdevice *s,
-				       struct comedi_insn *insn,
-				       unsigned int *data)
+static int apci035_timer_read(struct comedi_device *dev,
+			      struct comedi_subdevice *s,
+			      struct comedi_insn *insn, unsigned int *data)
 {
 	struct addi_private *devpriv = dev->private;
 	unsigned int ui_Status;	/*  Status register */
@@ -459,7 +456,7 @@ static int i_APCI035_ReadTimerWatchdog(struct comedi_device *dev,
 
 /*
 +----------------------------------------------------------------------------+
-| Function   Name   : int i_APCI035_ConfigAnalogInput                        |
+| Function   Name   : int apci035_ai_config                        |
 |			  (struct comedi_device *dev,struct comedi_subdevice *s,               |
 |                      struct comedi_insn *insn,unsigned int *data)                     |
 +----------------------------------------------------------------------------+
@@ -480,10 +477,9 @@ static int i_APCI035_ReadTimerWatchdog(struct comedi_device *dev,
 |			                                                         |
 +----------------------------------------------------------------------------+
 */
-static int i_APCI035_ConfigAnalogInput(struct comedi_device *dev,
-				       struct comedi_subdevice *s,
-				       struct comedi_insn *insn,
-				       unsigned int *data)
+static int apci035_ai_config(struct comedi_device *dev,
+			     struct comedi_subdevice *s,
+			     struct comedi_insn *insn, unsigned int *data)
 {
 	struct addi_private *devpriv = dev->private;
 
@@ -501,7 +497,7 @@ static int i_APCI035_ConfigAnalogInput(struct comedi_device *dev,
 
 /*
 +----------------------------------------------------------------------------+
-| Function   Name   : int i_APCI035_ReadAnalogInput                          |
+| Function   Name   : int apci035_ai_read                          |
 |			          (struct comedi_device *dev,struct comedi_subdevice *s,       |
 |                     struct comedi_insn *insn,unsigned int *data)                      |
 +----------------------------------------------------------------------------+
@@ -520,10 +516,9 @@ static int i_APCI035_ConfigAnalogInput(struct comedi_device *dev,
 |			                                                         |
 +----------------------------------------------------------------------------+
 */
-static int i_APCI035_ReadAnalogInput(struct comedi_device *dev,
-				     struct comedi_subdevice *s,
-				     struct comedi_insn *insn,
-				     unsigned int *data)
+static int apci035_ai_read(struct comedi_device *dev,
+			   struct comedi_subdevice *s,
+			   struct comedi_insn *insn, unsigned int *data)
 {
 	struct addi_private *devpriv = dev->private;
 	unsigned int ui_CommandRegister;
@@ -541,7 +536,7 @@ static int i_APCI035_ReadAnalogInput(struct comedi_device *dev,
 
 /*
 +----------------------------------------------------------------------------+
-| Function   Name   :  int i_APCI035_Reset(struct comedi_device *dev)			     |
+| Function   Name   :  int apci035_reset(struct comedi_device *dev)
 |					                                                         |
 +----------------------------------------------------------------------------+
 | Task              :Resets the registers of the card                        |
@@ -554,7 +549,7 @@ static int i_APCI035_ReadAnalogInput(struct comedi_device *dev,
 |			                                                                 |
 +----------------------------------------------------------------------------+
 */
-static int i_APCI035_Reset(struct comedi_device *dev)
+static int apci035_reset(struct comedi_device *dev)
 {
 	struct addi_private *devpriv = dev->private;
 	int i_Count;
@@ -572,7 +567,7 @@ static int i_APCI035_Reset(struct comedi_device *dev)
 
 /*
 +----------------------------------------------------------------------------+
-| Function   Name   : static void v_APCI035_Interrupt					     |
+| Function   Name   : static void apci035_interrupt
 |					  (int irq , void *d)      |
 +----------------------------------------------------------------------------+
 | Task              : Interrupt processing Routine                           |
@@ -587,7 +582,7 @@ static int i_APCI035_Reset(struct comedi_device *dev)
 |			                                                         |
 +----------------------------------------------------------------------------+
 */
-static void v_APCI035_Interrupt(int irq, void *d)
+static void apci035_interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = d;
 	struct addi_private *devpriv = dev->private;
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
index 1f7adc5..c5d5495 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
@@ -154,7 +154,7 @@ static int i_TimerCounter1Enabled, i_TimerCounter2Enabled,
 
 /*
   +----------------------------------------------------------------------------+
-| Function   Name   : int i_APCI1500_ConfigDigitalInputEvent                 |
+  | Function   Name   : int apci1500_di_config                 |
 |			  (struct comedi_device *dev,struct comedi_subdevice *s,               |
 |                      struct comedi_insn *insn,unsigned int *data)                     |
 +----------------------------------------------------------------------------+
@@ -230,10 +230,9 @@ static int i_TimerCounter1Enabled, i_TimerCounter2Enabled,
 |			                                                         |
 +----------------------------------------------------------------------------+
 */
-static int i_APCI1500_ConfigDigitalInputEvent(struct comedi_device *dev,
-					      struct comedi_subdevice *s,
-					      struct comedi_insn *insn,
-					      unsigned int *data)
+static int apci1500_di_config(struct comedi_device *dev,
+			      struct comedi_subdevice *s,
+			      struct comedi_insn *insn, unsigned int *data)
 {
 	struct addi_private *devpriv = dev->private;
 	int i_PatternPolarity = 0, i_PatternTransition = 0, i_PatternMask = 0;
@@ -538,7 +537,7 @@ static int i_APCI1500_ConfigDigitalInputEvent(struct comedi_device *dev,
 
 /*
 +----------------------------------------------------------------------------+
-| Function   Name   : int i_APCI1500_StartStopInputEvent                     |
+| Function   Name   : int apci1500_di_write                     |
 |			  (struct comedi_device *dev,struct comedi_subdevice *s,               |
 |                      struct comedi_insn *insn,unsigned int *data)                     |
 +----------------------------------------------------------------------------+
@@ -558,10 +557,9 @@ static int i_APCI1500_ConfigDigitalInputEvent(struct comedi_device *dev,
 |			                                                         |
 +----------------------------------------------------------------------------+
 */
-static int i_APCI1500_StartStopInputEvent(struct comedi_device *dev,
-					  struct comedi_subdevice *s,
-					  struct comedi_insn *insn,
-					  unsigned int *data)
+static int apci1500_di_write(struct comedi_device *dev,
+			     struct comedi_subdevice *s,
+			     struct comedi_insn *insn, unsigned int *data)
 {
 	struct addi_private *devpriv = dev->private;
 	int i_Event1InterruptStatus = 0, i_Event2InterruptStatus =
@@ -749,7 +747,7 @@ static int i_APCI1500_StartStopInputEvent(struct comedi_device *dev,
 
 /*
 +----------------------------------------------------------------------------+
-| Function   Name   : int i_APCI1500_Initialisation                          |
+| Function   Name   : int apci1500_di_read                          |
 |			  (struct comedi_device *dev,struct comedi_subdevice *s,               |
 |                      struct comedi_insn *insn,unsigned int *data)                     |
 +----------------------------------------------------------------------------+
@@ -766,10 +764,9 @@ static int i_APCI1500_StartStopInputEvent(struct comedi_device *dev,
 |			                                                         |
 +----------------------------------------------------------------------------+
 */
-static int i_APCI1500_Initialisation(struct comedi_device *dev,
-				     struct comedi_subdevice *s,
-				     struct comedi_insn *insn,
-				     unsigned int *data)
+static int apci1500_di_read(struct comedi_device *dev,
+			    struct comedi_subdevice *s,
+			    struct comedi_insn *insn, unsigned int *data)
 {
 	struct addi_private *devpriv = dev->private;
 	int i_DummyRead = 0;
@@ -916,7 +913,7 @@ static int apci1500_di_insn_bits(struct comedi_device *dev,
 
 /*
 +----------------------------------------------------------------------------+
-| Function   Name   : int i_apci1500_config_output
+| Function   Name   : int apci1500_do_config
 |                      (struct comedi_device *dev,struct comedi_subdevice *s struct comedi_insn
 |                      *insn,unsigned int *data)                                  |
 |				                                                     |
@@ -942,9 +939,9 @@ static int apci1500_di_insn_bits(struct comedi_device *dev,
 |			                                                         |
 +----------------------------------------------------------------------------+
 */
-static int i_acpi1500_config_output(struct comedi_device *dev,
-	struct comedi_subdevice *s, struct comedi_insn *insn,
-	unsigned int *data)
+static int apci1500_do_config(struct comedi_device *dev,
+			      struct comedi_subdevice *s,
+			      struct comedi_insn *insn,	unsigned int *data)
 {
 	struct addi_private *devpriv = dev->private;
 
@@ -954,7 +951,7 @@ static int i_acpi1500_config_output(struct comedi_device *dev,
 
 /*
 +----------------------------------------------------------------------------+
-| Function   Name   : int i_APCI1500_WriteDigitalOutput                      |
+| Function   Name   : int apci1500_do_write                      |
 |			  (struct comedi_device *dev,struct comedi_subdevice *s,               |
 |                      struct comedi_insn *insn,unsigned int *data)                     |
 +----------------------------------------------------------------------------+
@@ -971,10 +968,9 @@ static int i_acpi1500_config_output(struct comedi_device *dev,
 |			                                                         |
 +----------------------------------------------------------------------------+
 */
-static int i_APCI1500_WriteDigitalOutput(struct comedi_device *dev,
-					 struct comedi_subdevice *s,
-					 struct comedi_insn *insn,
-					 unsigned int *data)
+static int apci1500_do_write(struct comedi_device *dev,
+			     struct comedi_subdevice *s,
+			     struct comedi_insn *insn, unsigned int *data)
 {
 	struct addi_private *devpriv = dev->private;
 	static unsigned int ui_Temp;
@@ -1125,7 +1121,7 @@ static int i_APCI1500_WriteDigitalOutput(struct comedi_device *dev,
 
 /*
 +----------------------------------------------------------------------------+
-| Function   Name   : int i_APCI1500_ConfigCounterTimerWatchdog(comedi_device
+| Function   Name   : int apci1500_timer_config(comedi_device
 |                   *dev,struct comedi_subdevice *s,struct comedi_insn *insn,unsigned int *data)|
 |				                                                     |
 +----------------------------------------------------------------------------+
@@ -1171,10 +1167,9 @@ static int i_APCI1500_WriteDigitalOutput(struct comedi_device *dev,
 |			                                                         |
 +----------------------------------------------------------------------------+
 */
-static int i_APCI1500_ConfigCounterTimerWatchdog(struct comedi_device *dev,
-						 struct comedi_subdevice *s,
-						 struct comedi_insn *insn,
-						 unsigned int *data)
+static int apci1500_timer_config(struct comedi_device *dev,
+				 struct comedi_subdevice *s,
+				 struct comedi_insn *insn, unsigned int *data)
 {
 	struct addi_private *devpriv = dev->private;
 	int i_TimerCounterMode, i_MasterConfiguration;
@@ -1663,7 +1658,7 @@ static int i_APCI1500_ConfigCounterTimerWatchdog(struct comedi_device *dev,
 
 /*
 +----------------------------------------------------------------------------+
-| Function   Name   : int i_apci1500_timer_watchdog
+| Function   Name   : int apci1500_timer_write
 |				(struct comedi_device *dev,struct comedi_subdevice *s,
 |                         struct comedi_insn *insn,unsigned int *data);                  |
 +----------------------------------------------------------------------------+
@@ -1689,9 +1684,9 @@ static int i_APCI1500_ConfigCounterTimerWatchdog(struct comedi_device *dev,
 |			                                                         |
 +----------------------------------------------------------------------------+
 */
-static int i_apci1500_timer_watchdog(struct comedi_device *dev,
-	struct comedi_subdevice *s, struct comedi_insn *insn,
-	unsigned int *data)
+static int apci1500_timer_write(struct comedi_device *dev,
+				struct comedi_subdevice *s,
+				struct comedi_insn *insn, unsigned int *data)
 {
 	struct addi_private *devpriv = dev->private;
 	int i_CommandAndStatusValue;
@@ -1958,7 +1953,7 @@ static int i_apci1500_timer_watchdog(struct comedi_device *dev,
 
 /*
 +----------------------------------------------------------------------------+
-| Function   Name   : int i_APCI1500_ReadCounterTimerWatchdog                |
+| Function   Name   : int apci1500_timer_bits                |
 |			(struct comedi_device *dev,struct comedi_subdevice *s,struct comedi_insn *insn,
 |                    unsigned int *data); 	                                     |
 +----------------------------------------------------------------------------+
@@ -1980,10 +1975,9 @@ static int i_apci1500_timer_watchdog(struct comedi_device *dev,
 |			                                                         |
 +----------------------------------------------------------------------------+
 */
-static int i_APCI1500_ReadCounterTimerWatchdog(struct comedi_device *dev,
-					       struct comedi_subdevice *s,
-					       struct comedi_insn *insn,
-					       unsigned int *data)
+static int apci1500_timer_bits(struct comedi_device *dev,
+			       struct comedi_subdevice *s,
+			       struct comedi_insn *insn, unsigned int *data)
 {
 	struct addi_private *devpriv = dev->private;
 	int i_CommandAndStatusValue;
@@ -2132,7 +2126,7 @@ static int i_APCI1500_ReadCounterTimerWatchdog(struct comedi_device *dev,
 
 /*
 +----------------------------------------------------------------------------+
-| Function   Name   : int  i_APCI1500_ReadInterruptMask                      |
+| Function   Name   : int  apci1500_timer_read                      |
 |			(struct comedi_device *dev,struct comedi_subdevice *s,struct comedi_insn *insn,
 |                    unsigned int *data); 	                                     |
 +----------------------------------------------------------------------------+
@@ -2152,10 +2146,9 @@ static int i_APCI1500_ReadCounterTimerWatchdog(struct comedi_device *dev,
 |			                                                         |
 +----------------------------------------------------------------------------+
 */
-static int i_APCI1500_ReadInterruptMask(struct comedi_device *dev,
-					struct comedi_subdevice *s,
-					struct comedi_insn *insn,
-					unsigned int *data)
+static int apci1500_timer_read(struct comedi_device *dev,
+			       struct comedi_subdevice *s,
+			       struct comedi_insn *insn, unsigned int *data)
 {
 	data[0] = i_InterruptMask;
 	data[1] = i_InputChannel;
@@ -2165,7 +2158,7 @@ static int i_APCI1500_ReadInterruptMask(struct comedi_device *dev,
 
 /*
 +----------------------------------------------------------------------------+
-| Function   Name   : int  i_APCI1500_ConfigureInterrupt                     |
+| Function   Name   : int  apci1500_do_bits                     |
 |			(struct comedi_device *dev,struct comedi_subdevice *s,struct comedi_insn *insn,
 |                    unsigned int *data); 	                                     |
 +----------------------------------------------------------------------------+
@@ -2185,10 +2178,9 @@ static int i_APCI1500_ReadInterruptMask(struct comedi_device *dev,
 |			                                                         |
 +----------------------------------------------------------------------------+
 */
-static int i_APCI1500_ConfigureInterrupt(struct comedi_device *dev,
-					 struct comedi_subdevice *s,
-					 struct comedi_insn *insn,
-					 unsigned int *data)
+static int apci1500_do_bits(struct comedi_device *dev,
+			    struct comedi_subdevice *s,
+			    struct comedi_insn *insn, unsigned int *data)
 {
 	struct addi_private *devpriv = dev->private;
 	unsigned int ui_Status;
@@ -2310,7 +2302,7 @@ static int i_APCI1500_ConfigureInterrupt(struct comedi_device *dev,
 
 /*
 +----------------------------------------------------------------------------+
-| Function   Name   : static void v_APCI1500_Interrupt					     |
+| Function   Name   : static void apci1500_interrupt
 |					  (int irq , void *d)      |
 +----------------------------------------------------------------------------+
 | Task              : Interrupt handler                                      |
@@ -2325,7 +2317,7 @@ static int i_APCI1500_ConfigureInterrupt(struct comedi_device *dev,
 |			                                                         |
 +----------------------------------------------------------------------------+
 */
-static void v_APCI1500_Interrupt(int irq, void *d)
+static void apci1500_interrupt(int irq, void *d)
 {
 
 	struct comedi_device *dev = d;
@@ -2505,7 +2497,7 @@ static void v_APCI1500_Interrupt(int irq, void *d)
 
 /*
 +----------------------------------------------------------------------------+
-| Function   Name   : int i_APCI1500_Reset(struct comedi_device *dev)               |                                                       |
+| Function   Name   : int apci1500_reset(struct comedi_device *dev)
 +----------------------------------------------------------------------------+
 | Task              :resets all the registers                                |
 +----------------------------------------------------------------------------+
@@ -2517,7 +2509,7 @@ static void v_APCI1500_Interrupt(int irq, void *d)
 |			                                                         |
 +----------------------------------------------------------------------------+
 */
-static int i_APCI1500_Reset(struct comedi_device *dev)
+static int apci1500_reset(struct comedi_device *dev)
 {
 	struct addi_private *devpriv = dev->private;
 	int i_DummyRead = 0;
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
index a31e115..fb25407 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
@@ -116,7 +116,7 @@ static unsigned int ui_InterruptData, ui_Type;
 
 /*
 +----------------------------------------------------------------------------+
-| Function   Name   : int i_APCI1564_ConfigDigitalInput                      |
+| Function   Name   : int apci1564_di_config                      |
 |			  (struct comedi_device *dev,struct comedi_subdevice *s,               |
 |                      struct comedi_insn *insn,unsigned int *data)                     |
 +----------------------------------------------------------------------------+
@@ -141,10 +141,9 @@ static unsigned int ui_InterruptData, ui_Type;
 |			                                                         |
 +----------------------------------------------------------------------------+
 */
-static int i_APCI1564_ConfigDigitalInput(struct comedi_device *dev,
-					 struct comedi_subdevice *s,
-					 struct comedi_insn *insn,
-					 unsigned int *data)
+static int apci1564_di_config(struct comedi_device *dev,
+			      struct comedi_subdevice *s,
+			      struct comedi_insn *insn, unsigned int *data)
 {
 	struct addi_private *devpriv = dev->private;
 
@@ -184,7 +183,7 @@ static int apci1564_di_insn_bits(struct comedi_device *dev,
 
 /*
 +----------------------------------------------------------------------------+
-| Function   Name   : int i_APCI1564_ConfigDigitalOutput                     |
+| Function   Name   : int apci1564_do_config                     |
 |			  (struct comedi_device *dev,struct comedi_subdevice *s,               |
 |                      struct comedi_insn *insn,unsigned int *data)                     |
 +----------------------------------------------------------------------------+
@@ -207,10 +206,9 @@ static int apci1564_di_insn_bits(struct comedi_device *dev,
 |			                                                         |
 +----------------------------------------------------------------------------+
 */
-static int i_APCI1564_ConfigDigitalOutput(struct comedi_device *dev,
-					  struct comedi_subdevice *s,
-					  struct comedi_insn *insn,
-					  unsigned int *data)
+static int apci1564_do_config(struct comedi_device *dev,
+			      struct comedi_subdevice *s,
+			      struct comedi_insn *insn, unsigned int *data)
 {
 	struct addi_private *devpriv = dev->private;
 	unsigned int ul_Command = 0;
@@ -261,7 +259,7 @@ static int apci1564_do_insn_bits(struct comedi_device *dev,
 
 /*
 +----------------------------------------------------------------------------+
-| Function   Name   : int i_APCI1564_ConfigTimerCounterWatchdog              |
+| Function   Name   : int apci1564_timer_config              |
 |			  (struct comedi_device *dev,struct comedi_subdevice *s,               |
 |                      struct comedi_insn *insn,unsigned int *data)                     |
 +----------------------------------------------------------------------------+
@@ -289,10 +287,9 @@ static int apci1564_do_insn_bits(struct comedi_device *dev,
 |			                                                         |
 +----------------------------------------------------------------------------+
 */
-static int i_APCI1564_ConfigTimerCounterWatchdog(struct comedi_device *dev,
-						 struct comedi_subdevice *s,
-						 struct comedi_insn *insn,
-						 unsigned int *data)
+static int apci1564_timer_config(struct comedi_device *dev,
+				 struct comedi_subdevice *s,
+				 struct comedi_insn *insn, unsigned int *data)
 {
 	struct addi_private *devpriv = dev->private;
 	unsigned int ul_Command1 = 0;
@@ -384,7 +381,7 @@ static int i_APCI1564_ConfigTimerCounterWatchdog(struct comedi_device *dev,
 
 /*
 +----------------------------------------------------------------------------+
-| Function   Name   : int i_APCI1564_StartStopWriteTimerCounterWatchdog      |
+| Function   Name   : int apci1564_timer_write      |
 |			  (struct comedi_device *dev,struct comedi_subdevice *s,               |
 |                      struct comedi_insn *insn,unsigned int *data)                     |
 +----------------------------------------------------------------------------+
@@ -408,10 +405,9 @@ static int i_APCI1564_ConfigTimerCounterWatchdog(struct comedi_device *dev,
 |			                                                         |
 +----------------------------------------------------------------------------+
 */
-static int i_APCI1564_StartStopWriteTimerCounterWatchdog(struct comedi_device *dev,
-							 struct comedi_subdevice *s,
-							 struct comedi_insn *insn,
-							 unsigned int *data)
+static int apci1564_timer_write(struct comedi_device *dev,
+				struct comedi_subdevice *s,
+				struct comedi_insn *insn, unsigned int *data)
 {
 	struct addi_private *devpriv = dev->private;
 	unsigned int ul_Command1 = 0;
@@ -472,7 +468,7 @@ static int i_APCI1564_StartStopWriteTimerCounterWatchdog(struct comedi_device *d
 
 /*
 +----------------------------------------------------------------------------+
-| Function   Name   : int i_APCI1564_ReadTimerCounterWatchdog                |
+| Function   Name   : int apci1564_timer_read                |
 |			  (struct comedi_device *dev,struct comedi_subdevice *s,               |
 |                      struct comedi_insn *insn,unsigned int *data)                     |
 +----------------------------------------------------------------------------+
@@ -491,10 +487,9 @@ static int i_APCI1564_StartStopWriteTimerCounterWatchdog(struct comedi_device *d
 |			                                                         |
 +----------------------------------------------------------------------------+
 */
-static int i_APCI1564_ReadTimerCounterWatchdog(struct comedi_device *dev,
-					       struct comedi_subdevice *s,
-					       struct comedi_insn *insn,
-					       unsigned int *data)
+static int apci1564_timer_read(struct comedi_device *dev,
+			       struct comedi_subdevice *s,
+			       struct comedi_insn *insn, unsigned int *data)
 {
 	struct addi_private *devpriv = dev->private;
 	unsigned int ul_Command1 = 0;
@@ -539,7 +534,7 @@ static int i_APCI1564_ReadTimerCounterWatchdog(struct comedi_device *dev,
 
 /*
 +----------------------------------------------------------------------------+
-| Function   Name   :  int i_APCI1564_ReadInterruptStatus                    |
+| Function   Name   :  int apci1564_do_read                    |
 |			  (struct comedi_device *dev,struct comedi_subdevice *s,               |
 |                      struct comedi_insn *insn,unsigned int *data)                     |
 +----------------------------------------------------------------------------+
@@ -554,10 +549,9 @@ static int i_APCI1564_ReadTimerCounterWatchdog(struct comedi_device *dev,
 +----------------------------------------------------------------------------+
 */
 
-static int i_APCI1564_ReadInterruptStatus(struct comedi_device *dev,
-					  struct comedi_subdevice *s,
-					  struct comedi_insn *insn,
-					  unsigned int *data)
+static int apci1564_do_read(struct comedi_device *dev,
+			    struct comedi_subdevice *s,
+			    struct comedi_insn *insn, unsigned int *data)
 {
 	*data = ui_Type;
 	return insn->n;
@@ -565,7 +559,7 @@ static int i_APCI1564_ReadInterruptStatus(struct comedi_device *dev,
 
 /*
 +----------------------------------------------------------------------------+
-| Function   Name   : static void v_APCI1564_Interrupt					     |
+| Function   Name   : static void apci1564_interrupt
 |					  (int irq , void *d)      |
 +----------------------------------------------------------------------------+
 | Task              : Interrupt handler for the interruptible digital inputs |
@@ -580,7 +574,7 @@ static int i_APCI1564_ReadInterruptStatus(struct comedi_device *dev,
 |			                                                         |
 +----------------------------------------------------------------------------+
 */
-static void v_APCI1564_Interrupt(int irq, void *d)
+static void apci1564_interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = d;
 	struct addi_private *devpriv = dev->private;
@@ -724,7 +718,7 @@ static void v_APCI1564_Interrupt(int irq, void *d)
 
 /*
 +----------------------------------------------------------------------------+
-| Function   Name   : int i_APCI1564_Reset(struct comedi_device *dev)               |                                                       |
+| Function   Name   : int apci1564_reset(struct comedi_device *dev)
 +----------------------------------------------------------------------------+
 | Task              :resets all the registers                                |
 +----------------------------------------------------------------------------+
@@ -737,7 +731,7 @@ static void v_APCI1564_Interrupt(int irq, void *d)
 +----------------------------------------------------------------------------+
 */
 
-static int i_APCI1564_Reset(struct comedi_device *dev)
+static int apci1564_reset(struct comedi_device *dev)
 {
 	struct addi_private *devpriv = dev->private;
 
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c
index bd05857..e9d52e28 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c
@@ -248,10 +248,9 @@ static const struct comedi_lrange range_apci3120_ao = {
 +----------------------------------------------------------------------------+
 */
 
-static int i_APCI3120_InsnConfigAnalogInput(struct comedi_device *dev,
-					    struct comedi_subdevice *s,
-					    struct comedi_insn *insn,
-					    unsigned int *data)
+static int apci3120_ai_insn_config(struct comedi_device *dev,
+				   struct comedi_subdevice *s,
+				   struct comedi_insn *insn, unsigned int *data)
 {
 	const struct addi_board *this_board = comedi_board(dev);
 	struct addi_private *devpriv = dev->private;
@@ -304,11 +303,10 @@ static int i_APCI3120_InsnConfigAnalogInput(struct comedi_device *dev,
  * If the last argument of function "check"is 1 then it only checks
  * the channel list is ok or not.
  */
-static int i_APCI3120_SetupChannelList(struct comedi_device *dev,
-				       struct comedi_subdevice *s,
-				       int n_chan,
-				       unsigned int *chanlist,
-				       char check)
+static int apci3120_setup_chan_list(struct comedi_device *dev,
+				    struct comedi_subdevice *s,
+				    int n_chan, unsigned int *chanlist,
+				    char check)
 {
 	struct addi_private *devpriv = dev->private;
 	unsigned int i;		/* , differencial=0, bipolar=0; */
@@ -358,10 +356,9 @@ static int i_APCI3120_SetupChannelList(struct comedi_device *dev,
  * as per configured if no conversion time is set uses default
  * conversion time 10 microsec.
  */
-static int i_APCI3120_InsnReadAnalogInput(struct comedi_device *dev,
-					  struct comedi_subdevice *s,
-					  struct comedi_insn *insn,
-					  unsigned int *data)
+static int apci3120_ai_insn_read(struct comedi_device *dev,
+				 struct comedi_subdevice *s,
+				 struct comedi_insn *insn, unsigned int *data)
 {
 	const struct addi_board *this_board = comedi_board(dev);
 	struct addi_private *devpriv = dev->private;
@@ -417,10 +414,7 @@ static int i_APCI3120_InsnReadAnalogInput(struct comedi_device *dev,
 			inw(devpriv->iobase + APCI3120_RESET_FIFO);
 
 			/*  Initialize the sequence array */
-
-			/* if (!i_APCI3120_SetupChannelList(dev,s,1,chanlist,0))  return -EINVAL; */
-
-			if (!i_APCI3120_SetupChannelList(dev, s, 1,
+			if (!apci3120_setup_chan_list(dev, s, 1,
 					&insn->chanspec, 0))
 				return -EINVAL;
 
@@ -512,7 +506,7 @@ static int i_APCI3120_InsnReadAnalogInput(struct comedi_device *dev,
 			outw(devpriv->us_OutputRegister,
 				devpriv->iobase + APCI3120_WR_ADDRESS);
 
-			if (!i_APCI3120_SetupChannelList(dev, s,
+			if (!apci3120_setup_chan_list(dev, s,
 					devpriv->ui_AiNbrofChannels,
 					devpriv->ui_AiChannelList, 0))
 				return -EINVAL;
@@ -606,7 +600,7 @@ static int i_APCI3120_InsnReadAnalogInput(struct comedi_device *dev,
 
 }
 
-static int i_APCI3120_Reset(struct comedi_device *dev)
+static int apci3120_reset(struct comedi_device *dev)
 {
 	struct addi_private *devpriv = dev->private;
 	unsigned int i;
@@ -663,7 +657,7 @@ static int i_APCI3120_Reset(struct comedi_device *dev)
 	return 0;
 }
 
-static int i_APCI3120_ExttrigEnable(struct comedi_device *dev)
+static int apci3120_exttrig_enable(struct comedi_device *dev)
 {
 	struct addi_private *devpriv = dev->private;
 
@@ -672,7 +666,7 @@ static int i_APCI3120_ExttrigEnable(struct comedi_device *dev)
 	return 0;
 }
 
-static int i_APCI3120_ExttrigDisable(struct comedi_device *dev)
+static int apci3120_exttrig_disable(struct comedi_device *dev)
 {
 	struct addi_private *devpriv = dev->private;
 
@@ -681,8 +675,8 @@ static int i_APCI3120_ExttrigDisable(struct comedi_device *dev)
 	return 0;
 }
 
-static int i_APCI3120_StopCyclicAcquisition(struct comedi_device *dev,
-					    struct comedi_subdevice *s)
+static int apci3120_cancel(struct comedi_device *dev,
+			   struct comedi_subdevice *s)
 {
 	struct addi_private *devpriv = dev->private;
 
@@ -705,7 +699,7 @@ static int i_APCI3120_StopCyclicAcquisition(struct comedi_device *dev,
 	 * devpriv->i_IobaseAmcc+AMCC_OP_REG_MCSR);  stop DMA */
 
 	/* Disable ext trigger */
-	i_APCI3120_ExttrigDisable(dev);
+	apci3120_exttrig_disable(dev);
 
 	devpriv->us_OutputRegister = 0;
 	/* stop  counters */
@@ -729,13 +723,13 @@ static int i_APCI3120_StopCyclicAcquisition(struct comedi_device *dev,
 	devpriv->b_AiCyclicAcquisition = APCI3120_DISABLE;
 	devpriv->b_InterruptMode = APCI3120_EOC_MODE;
 	devpriv->b_EocEosInterrupt = APCI3120_DISABLE;
-	i_APCI3120_Reset(dev);
+	apci3120_reset(dev);
 	return 0;
 }
 
-static int i_APCI3120_CommandTestAnalogInput(struct comedi_device *dev,
-					     struct comedi_subdevice *s,
-					     struct comedi_cmd *cmd)
+static int apci3120_ai_cmdtest(struct comedi_device *dev,
+			       struct comedi_subdevice *s,
+			       struct comedi_cmd *cmd)
 {
 	const struct addi_board *this_board = comedi_board(dev);
 	int err = 0;
@@ -818,9 +812,8 @@ static int i_APCI3120_CommandTestAnalogInput(struct comedi_device *dev,
  * If DMA is configured does DMA initialization otherwise does the
  * acquisition with EOS interrupt.
  */
-static int i_APCI3120_CyclicAnalogInput(int mode,
-					struct comedi_device *dev,
-					struct comedi_subdevice *s)
+static int i_apci3120_cyclic_ai(int mode, struct comedi_device *dev,
+				struct comedi_subdevice *s)
 {
 	const struct addi_board *this_board = comedi_board(dev);
 	struct addi_private *devpriv = dev->private;
@@ -904,7 +897,7 @@ static int i_APCI3120_CyclicAnalogInput(int mode,
    /**********************************/
 	/* Initializes the sequence array */
    /**********************************/
-	if (!i_APCI3120_SetupChannelList(dev, s, devpriv->ui_AiNbrofChannels,
+	if (!apci3120_setup_chan_list(dev, s, devpriv->ui_AiNbrofChannels,
 			devpriv->pui_AiChannelList, 0))
 		return -EINVAL;
 
@@ -957,7 +950,7 @@ static int i_APCI3120_CyclicAnalogInput(int mode,
 /*** EL241003 End ******************************************************************************/
 
 	if (devpriv->b_ExttrigEnable == APCI3120_ENABLE)
-		i_APCI3120_ExttrigEnable(dev);	/*  activate EXT trigger */
+		apci3120_exttrig_enable(dev);	/*  activate EXT trigger */
 	switch (mode) {
 	case 1:
 		/*  init timer0 in mode 2 */
@@ -1333,8 +1326,8 @@ static int i_APCI3120_CyclicAnalogInput(int mode,
  * Does asynchronous acquisition.
  * Determines the mode 1 or 2.
  */
-static int i_APCI3120_CommandAnalogInput(struct comedi_device *dev,
-					 struct comedi_subdevice *s)
+static int apci3120_ai_cmd(struct comedi_device *dev,
+			   struct comedi_subdevice *s)
 {
 	struct addi_private *devpriv = dev->private;
 	struct comedi_cmd *cmd = &s->async->cmd;
@@ -1371,7 +1364,7 @@ static int i_APCI3120_CommandAnalogInput(struct comedi_device *dev,
 
 			devpriv->ui_AiTimer0 = cmd->convert_arg;	/*  timer constant in nano seconds */
 			/* return this_board->ai_cmd(1,dev,s); */
-			return i_APCI3120_CyclicAnalogInput(1, dev, s);
+			return i_apci3120_cyclic_ai(1, dev, s);
 		}
 
 	}
@@ -1381,7 +1374,7 @@ static int i_APCI3120_CommandAnalogInput(struct comedi_device *dev,
 		devpriv->ui_AiTimer1 = cmd->scan_begin_arg;
 		devpriv->ui_AiTimer0 = cmd->convert_arg;	/*  variable changed timer2 to timer0 */
 		/* return this_board->ai_cmd(2,dev,s); */
-		return i_APCI3120_CyclicAnalogInput(2, dev, s);
+		return i_apci3120_cyclic_ai(2, dev, s);
 	}
 	return -1;
 }
@@ -1410,7 +1403,7 @@ static void v_APCI3120_InterruptDmaMoveBlock16bit(struct comedi_device *dev,
  * For continuous DMA it reinitializes the DMA operation.
  * For single mode DMA it stop the acquisition.
  */
-static void v_APCI3120_InterruptDma(int irq, void *d)
+static void apci3120_interrupt_dma(int irq, void *d)
 {
 	struct comedi_device *dev = d;
 	struct addi_private *devpriv = dev->private;
@@ -1429,7 +1422,7 @@ static void v_APCI3120_InterruptDma(int irq, void *d)
 	}
 	if (samplesinbuf & 1) {
 		comedi_error(dev, "Odd count of bytes in DMA ring!");
-		i_APCI3120_StopCyclicAcquisition(dev, s);
+		apci3120_cancel(dev, s);
 		devpriv->b_AiCyclicAcquisition = APCI3120_DISABLE;
 
 		return;
@@ -1500,7 +1493,7 @@ static void v_APCI3120_InterruptDma(int irq, void *d)
 	if (!devpriv->b_AiContinuous)
 		if (devpriv->ui_AiActualScan >= devpriv->ui_AiNbrofScans) {
 			/*  all data sampled */
-			i_APCI3120_StopCyclicAcquisition(dev, s);
+			apci3120_cancel(dev, s);
 			devpriv->b_AiCyclicAcquisition = APCI3120_DISABLE;
 			s->async->events |= COMEDI_CB_EOA;
 			comedi_event(dev, s);
@@ -1565,7 +1558,7 @@ static void v_APCI3120_InterruptDma(int irq, void *d)
  * This function handles EOS interrupt.
  * This function copies the acquired data(from FIFO) to Comedi buffer.
  */
-static int i_APCI3120_InterruptHandleEos(struct comedi_device *dev)
+static int apci3120_interrupt_handle_eos(struct comedi_device *dev)
 {
 	struct addi_private *devpriv = dev->private;
 	struct comedi_subdevice *s = dev->read_subdev;
@@ -1589,7 +1582,7 @@ static int i_APCI3120_InterruptHandleEos(struct comedi_device *dev)
 	return 0;
 }
 
-static void v_APCI3120_Interrupt(int irq, void *d)
+static void apci3120_interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = d;
 	struct addi_private *devpriv = dev->private;
@@ -1615,7 +1608,7 @@ static void v_APCI3120_Interrupt(int irq, void *d)
 
 	if (devpriv->b_ExttrigEnable == APCI3120_ENABLE) {
 		/* Disable ext trigger */
-		i_APCI3120_ExttrigDisable(dev);
+		apci3120_exttrig_disable(dev);
 		devpriv->b_ExttrigEnable = APCI3120_DISABLE;
 	}
 	/* clear the timer 2 interrupt */
@@ -1655,7 +1648,7 @@ static void v_APCI3120_Interrupt(int irq, void *d)
 
 			if (devpriv->b_AiCyclicAcquisition == APCI3120_ENABLE) {
 				ui_Check = 0;
-				i_APCI3120_InterruptHandleEos(dev);
+				apci3120_interrupt_handle_eos(dev);
 				devpriv->ui_AiActualScan++;
 				devpriv->b_ModeSelectRegister =
 					devpriv->
@@ -1711,7 +1704,7 @@ static void v_APCI3120_Interrupt(int irq, void *d)
 				dev->iobase + APCI3120_WR_ADDRESS);
 
 			/* stop timer 0 and timer 1 */
-			i_APCI3120_StopCyclicAcquisition(dev, s);
+			apci3120_cancel(dev, s);
 			devpriv->b_AiCyclicAcquisition = APCI3120_DISABLE;
 
 			/* UPDATE-0.7.57->0.7.68comedi_done(dev,s); */
@@ -1765,7 +1758,8 @@ static void v_APCI3120_Interrupt(int irq, void *d)
 			/* Clears the timer status register */
 			/************************************/
 			inw(dev->iobase + APCI3120_TIMER_STATUS_REGISTER);
-			v_APCI3120_InterruptDma(irq, d);	/*  do some data transfer */
+			/* do some data transfer */
+			apci3120_interrupt_dma(irq, d);
 		} else {
 			/* Stops the Timer */
 			outw(devpriv->
@@ -1787,7 +1781,7 @@ static void v_APCI3120_Interrupt(int irq, void *d)
  * data[1] = Timer constant
  * data[2] = Timer2 interrupt (1)enable or(0) disable
  */
-static int i_APCI3120_InsnConfigTimer(struct comedi_device *dev,
+static int apci3120_config_insn_timer(struct comedi_device *dev,
 				      struct comedi_subdevice *s,
 				      struct comedi_insn *insn,
 				      unsigned int *data)
@@ -1932,7 +1926,7 @@ static int i_APCI3120_InsnConfigTimer(struct comedi_device *dev,
  *			 = 1 Timer
  *			 = 2 Watch dog
  */
-static int i_APCI3120_InsnWriteTimer(struct comedi_device *dev,
+static int apci3120_write_insn_timer(struct comedi_device *dev,
 				     struct comedi_subdevice *s,
 				     struct comedi_insn *insn,
 				     unsigned int *data)
@@ -2104,7 +2098,7 @@ static int i_APCI3120_InsnWriteTimer(struct comedi_device *dev,
  * for watchdog: data[0] = 0 (still running)
  *			 = 1 (run down)
  */
-static int i_APCI3120_InsnReadTimer(struct comedi_device *dev,
+static int apci3120_read_insn_timer(struct comedi_device *dev,
 				    struct comedi_subdevice *s,
 				    struct comedi_insn *insn,
 				    unsigned int *data)
@@ -2189,10 +2183,10 @@ static int apci3120_do_insn_bits(struct comedi_device *dev,
 	return insn->n;
 }
 
-static int i_APCI3120_InsnWriteAnalogOutput(struct comedi_device *dev,
-					    struct comedi_subdevice *s,
-					    struct comedi_insn *insn,
-					    unsigned int *data)
+static int apci3120_ao_insn_write(struct comedi_device *dev,
+				  struct comedi_subdevice *s,
+				  struct comedi_insn *insn,
+				  unsigned int *data)
 {
 	struct addi_private *devpriv = dev->private;
 	unsigned int ui_Range, ui_Channel;
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.c
index 8c85a09..9063089 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.c
@@ -1268,7 +1268,7 @@ static int i_APCI3200_ReadCJCCalGain(struct comedi_device *dev,
 	return 0;
 }
 
-static int i_APCI3200_Reset(struct comedi_device *dev)
+static int apci3200_reset(struct comedi_device *dev)
 {
 	struct addi_private *devpriv = dev->private;
 	int i_Temp;
@@ -1322,10 +1322,9 @@ static int i_APCI3200_Reset(struct comedi_device *dev)
  * data[7] : Channel current source from eeprom
  * data[8] : Channle gain factor from eeprom
  */
-static int i_APCI3200_ReadAnalogInput(struct comedi_device *dev,
-				      struct comedi_subdevice *s,
-				      struct comedi_insn *insn,
-				      unsigned int *data)
+static int apci3200_ai_read(struct comedi_device *dev,
+			    struct comedi_subdevice *s,
+			    struct comedi_insn *insn, unsigned int *data)
 {
 	unsigned int ui_DummyValue = 0;
 	int i_ConvertCJCCalibration;
@@ -1336,7 +1335,7 @@ static int i_APCI3200_ReadAnalogInput(struct comedi_device *dev,
 	if (s_BoardInfos[dev->minor].i_Initialised == 0)
 		/* END JK 06.07.04: Management of sevrals boards */
 	{
-		i_APCI3200_Reset(dev);
+		apci3200_reset(dev);
 		return -EINVAL;
 	}			/* if(i_Initialised==0); */
 
@@ -1586,7 +1585,7 @@ static int i_APCI3200_ReadAnalogInput(struct comedi_device *dev,
 		break;
 	default:
 		printk("\nThe parameters passed are in error\n");
-		i_APCI3200_Reset(dev);
+		apci3200_reset(dev);
 		return -EINVAL;
 	}			/* switch(insn->unused[0]) */
 
@@ -1626,10 +1625,9 @@ static int i_APCI3200_ReadAnalogInput(struct comedi_device *dev,
  *	    = 2  RTD 3 wire connection
  *	    = 3  RTD 4 wire connection
  */
-static int i_APCI3200_ConfigAnalogInput(struct comedi_device *dev,
-					struct comedi_subdevice *s,
-					struct comedi_insn *insn,
-					unsigned int *data)
+static int apci3200_ai_config(struct comedi_device *dev,
+			      struct comedi_subdevice *s,
+			      struct comedi_insn *insn, unsigned int *data)
 {
 	struct addi_private *devpriv = dev->private;
 	unsigned int ul_Config = 0, ul_Temp = 0;
@@ -1970,7 +1968,7 @@ static int i_APCI3200_ConfigAnalogInput(struct comedi_device *dev,
 		}		/*  switch(data[11]) */
 	}			/*  elseif(data[12]==0 || data[12]==1) */
 	if (i_err) {
-		i_APCI3200_Reset(dev);
+		apci3200_reset(dev);
 		return -EINVAL;
 	}
 	/* if(i_ScanType!=1) */
@@ -2079,7 +2077,7 @@ static int i_APCI3200_ConfigAnalogInput(struct comedi_device *dev,
 		/* END JK 06.07.04: Management of sevrals boards */
 
 		insn->unused[0] = 0;
-		i_APCI3200_ReadAnalogInput(dev, s, insn, &ui_Dummy);
+		apci3200_ai_read(dev, s, insn, &ui_Dummy);
 	}
 
 	return insn->n;
@@ -2095,10 +2093,9 @@ static int i_APCI3200_ConfigAnalogInput(struct comedi_device *dev,
  * data[1] : calibration offset
  * data[2] : calibration gain
  */
-static int i_APCI3200_InsnBits_AnalogInput_Test(struct comedi_device *dev,
-						struct comedi_subdevice *s,
-						struct comedi_insn *insn,
-						unsigned int *data)
+static int apci3200_ai_bits_test(struct comedi_device *dev,
+				 struct comedi_subdevice *s,
+				 struct comedi_insn *insn, unsigned int *data)
 {
 	struct addi_private *devpriv = dev->private;
 	unsigned int ui_Configuration = 0;
@@ -2107,12 +2104,12 @@ static int i_APCI3200_InsnBits_AnalogInput_Test(struct comedi_device *dev,
 	/* if(i_Initialised==0) */
 
 	if (s_BoardInfos[dev->minor].i_Initialised == 0) {
-		i_APCI3200_Reset(dev);
+		apci3200_reset(dev);
 		return -EINVAL;
 	}			/* if(i_Initialised==0); */
 	if (data[0] != 0 && data[0] != 1) {
 		printk("\nError in selection of functionality\n");
-		i_APCI3200_Reset(dev);
+		apci3200_reset(dev);
 		return -EINVAL;
 	}			/* if(data[0]!=0 && data[0]!=1) */
 
@@ -2202,18 +2199,17 @@ static int i_APCI3200_InsnBits_AnalogInput_Test(struct comedi_device *dev,
 	return insn->n;
 }
 
-static int i_APCI3200_InsnWriteReleaseAnalogInput(struct comedi_device *dev,
-						  struct comedi_subdevice *s,
-						  struct comedi_insn *insn,
-						  unsigned int *data)
+static int apci3200_ai_write(struct comedi_device *dev,
+			     struct comedi_subdevice *s,
+			     struct comedi_insn *insn, unsigned int *data)
 {
-	i_APCI3200_Reset(dev);
+	apci3200_reset(dev);
 	return insn->n;
 }
 
-static int i_APCI3200_CommandTestAnalogInput(struct comedi_device *dev,
-					     struct comedi_subdevice *s,
-					     struct comedi_cmd *cmd)
+static int apci3200_ai_cmdtest(struct comedi_device *dev,
+			       struct comedi_subdevice *s,
+			       struct comedi_cmd *cmd)
 {
 
 	int err = 0;
@@ -2241,7 +2237,7 @@ static int i_APCI3200_CommandTestAnalogInput(struct comedi_device *dev,
 		err |= -EINVAL;
 
 	if (err) {
-		i_APCI3200_Reset(dev);
+		apci3200_reset(dev);
 		return 1;
 	}
 
@@ -2267,7 +2263,7 @@ static int i_APCI3200_CommandTestAnalogInput(struct comedi_device *dev,
 	}
 
 	if (err) {
-		i_APCI3200_Reset(dev);
+		apci3200_reset(dev);
 		return 2;
 	}
 	/* i_FirstChannel=cmd->chanlist[0]; */
@@ -2308,7 +2304,7 @@ static int i_APCI3200_CommandTestAnalogInput(struct comedi_device *dev,
 			printk("\nThe Delay time value is in error\n");
 		}
 		if (err) {
-			i_APCI3200_Reset(dev);
+			apci3200_reset(dev);
 			return 3;
 		}
 		fpu_begin();
@@ -2366,15 +2362,15 @@ static int i_APCI3200_CommandTestAnalogInput(struct comedi_device *dev,
 	}			/* else if(cmd->scan_begin_src==TRIG_FOLLOW) */
 
 	if (err) {
-		i_APCI3200_Reset(dev);
+		apci3200_reset(dev);
 		return 4;
 	}
 
 	return 0;
 }
 
-static int i_APCI3200_StopCyclicAcquisition(struct comedi_device *dev,
-					    struct comedi_subdevice *s)
+static int apci3200_cancel(struct comedi_device *dev,
+			   struct comedi_subdevice *s)
 {
 	struct addi_private *devpriv = dev->private;
 	unsigned int ui_Configuration = 0;
@@ -2410,8 +2406,8 @@ static int i_APCI3200_StopCyclicAcquisition(struct comedi_device *dev,
  * Does asynchronous acquisition
  * Determines the mode 1 or 2.
  */
-static int i_APCI3200_CommandAnalogInput(struct comedi_device *dev,
-					 struct comedi_subdevice *s)
+static int apci3200_ai_cmd(struct comedi_device *dev,
+			   struct comedi_subdevice *s)
 {
 	struct addi_private *devpriv = dev->private;
 	struct comedi_cmd *cmd = &s->async->cmd;
@@ -2730,7 +2726,7 @@ static int i_APCI3200_InterruptHandleEos(struct comedi_device *dev)
 	return 0;
 }
 
-static void v_APCI3200_Interrupt(int irq, void *d)
+static void apci3200_interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = d;
 	struct addi_private *devpriv = dev->private;
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c
index ebc1534..20e89b0 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c
@@ -16,10 +16,10 @@
  *	data[2] : Time Unit
  *	data[3] : Reload Value
  */
-static int i_APCI3501_ConfigTimerCounterWatchdog(struct comedi_device *dev,
-						 struct comedi_subdevice *s,
-						 struct comedi_insn *insn,
-						 unsigned int *data)
+static int apci3501_config_insn_timer(struct comedi_device *dev,
+				      struct comedi_subdevice *s,
+				      struct comedi_insn *insn,
+				      unsigned int *data)
 {
 	struct apci3501_private *devpriv = dev->private;
 	unsigned int ul_Command1 = 0;
@@ -86,10 +86,10 @@ static int i_APCI3501_ConfigTimerCounterWatchdog(struct comedi_device *dev,
  *		  0 Stop
  *		  2 Trigger
  */
-static int i_APCI3501_StartStopWriteTimerCounterWatchdog(struct comedi_device *dev,
-							 struct comedi_subdevice *s,
-							 struct comedi_insn *insn,
-							 unsigned int *data)
+static int apci3501_write_insn_timer(struct comedi_device *dev,
+				     struct comedi_subdevice *s,
+				     struct comedi_insn *insn,
+				     unsigned int *data)
 {
 	struct apci3501_private *devpriv = dev->private;
 	unsigned int ul_Command1 = 0;
@@ -153,10 +153,10 @@ static int i_APCI3501_StartStopWriteTimerCounterWatchdog(struct comedi_device *d
  *		  2 Watchdog
  *	data[1] : Timer Counter Watchdog Number
  */
-static int i_APCI3501_ReadTimerCounterWatchdog(struct comedi_device *dev,
-					       struct comedi_subdevice *s,
-					       struct comedi_insn *insn,
-					       unsigned int *data)
+static int apci3501_read_insn_timer(struct comedi_device *dev,
+				    struct comedi_subdevice *s,
+				    struct comedi_insn *insn,
+				    unsigned int *data)
 {
 	struct apci3501_private *devpriv = dev->private;
 
diff --git a/drivers/staging/comedi/drivers/addi_apci_035.c b/drivers/staging/comedi/drivers/addi_apci_035.c
index ccd4921..4da9db3 100644
--- a/drivers/staging/comedi/drivers/addi_apci_035.c
+++ b/drivers/staging/comedi/drivers/addi_apci_035.c
@@ -27,13 +27,13 @@ static const struct addi_board apci035_boardtypes[] = {
 		.i_Timer		= 1,
 		.ui_MinAcquisitiontimeNs = 10000,
 		.ui_MinDelaytimeNs	= 100000,
-		.interrupt		= v_APCI035_Interrupt,
-		.reset			= i_APCI035_Reset,
-		.ai_config		= i_APCI035_ConfigAnalogInput,
-		.ai_read		= i_APCI035_ReadAnalogInput,
-		.timer_config		= i_APCI035_ConfigTimerWatchdog,
-		.timer_write		= i_APCI035_StartStopWriteTimerWatchdog,
-		.timer_read		= i_APCI035_ReadTimerWatchdog,
+		.interrupt		= apci035_interrupt,
+		.reset			= apci035_reset,
+		.ai_config		= apci035_ai_config,
+		.ai_read		= apci035_ai_read,
+		.timer_config		= apci035_timer_config,
+		.timer_write		= apci035_timer_write,
+		.timer_read		= apci035_timer_read,
 	},
 };
 
diff --git a/drivers/staging/comedi/drivers/addi_apci_1500.c b/drivers/staging/comedi/drivers/addi_apci_1500.c
index afa7d6e..bd8e08c 100644
--- a/drivers/staging/comedi/drivers/addi_apci_1500.c
+++ b/drivers/staging/comedi/drivers/addi_apci_1500.c
@@ -20,19 +20,19 @@ static const struct addi_board apci1500_boardtypes[] = {
 		.i_NbrDoChannel		= 16,
 		.i_DoMaxdata		= 0xffff,
 		.i_Timer		= 1,
-		.interrupt		= v_APCI1500_Interrupt,
-		.reset			= i_APCI1500_Reset,
-		.di_config		= i_APCI1500_ConfigDigitalInputEvent,
-		.di_read		= i_APCI1500_Initialisation,
-		.di_write		= i_APCI1500_StartStopInputEvent,
+		.interrupt		= apci1500_interrupt,
+		.reset			= apci1500_reset,
+		.di_config		= apci1500_di_config,
+		.di_read		= apci1500_di_read,
+		.di_write		= apci1500_di_write,
 		.di_bits		= apci1500_di_insn_bits,
-		.do_config		= i_acpi1500_config_output,
-		.do_write		= i_APCI1500_WriteDigitalOutput,
-		.do_bits		= i_APCI1500_ConfigureInterrupt,
-		.timer_config		= i_APCI1500_ConfigCounterTimerWatchdog,
-		.timer_write		= i_apci1500_timer_watchdog,
-		.timer_read		= i_APCI1500_ReadInterruptMask,
-		.timer_bits		= i_APCI1500_ReadCounterTimerWatchdog,
+		.do_config		= apci1500_do_config,
+		.do_write		= apci1500_do_write,
+		.do_bits		= apci1500_do_bits,
+		.timer_config		= apci1500_timer_config,
+		.timer_write		= apci1500_timer_write,
+		.timer_read		= apci1500_timer_read,
+		.timer_bits		= apci1500_timer_bits,
 	},
 };
 
diff --git a/drivers/staging/comedi/drivers/addi_apci_1564.c b/drivers/staging/comedi/drivers/addi_apci_1564.c
index 6248284..27aa9ae 100644
--- a/drivers/staging/comedi/drivers/addi_apci_1564.c
+++ b/drivers/staging/comedi/drivers/addi_apci_1564.c
@@ -21,16 +21,16 @@ static const struct addi_board apci1564_boardtypes[] = {
 		.i_NbrDoChannel		= 32,
 		.i_DoMaxdata		= 0xffffffff,
 		.i_Timer		= 1,
-		.interrupt		= v_APCI1564_Interrupt,
-		.reset			= i_APCI1564_Reset,
-		.di_config		= i_APCI1564_ConfigDigitalInput,
+		.interrupt		= apci1564_interrupt,
+		.reset			= apci1564_reset,
+		.di_config		= apci1564_di_config,
 		.di_bits		= apci1564_di_insn_bits,
-		.do_config		= i_APCI1564_ConfigDigitalOutput,
+		.do_config		= apci1564_do_config,
 		.do_bits		= apci1564_do_insn_bits,
-		.do_read		= i_APCI1564_ReadInterruptStatus,
-		.timer_config		= i_APCI1564_ConfigTimerCounterWatchdog,
-		.timer_write		= i_APCI1564_StartStopWriteTimerCounterWatchdog,
-		.timer_read		= i_APCI1564_ReadTimerCounterWatchdog,
+		.do_read		= apci1564_do_read,
+		.timer_config		= apci1564_timer_config,
+		.timer_write		= apci1564_timer_write,
+		.timer_read		= apci1564_timer_read,
 	},
 };
 
diff --git a/drivers/staging/comedi/drivers/addi_apci_3120.c b/drivers/staging/comedi/drivers/addi_apci_3120.c
index 1e6fa56..57ee6e5 100644
--- a/drivers/staging/comedi/drivers/addi_apci_3120.c
+++ b/drivers/staging/comedi/drivers/addi_apci_3120.c
@@ -26,7 +26,7 @@ static const struct addi_board apci3120_boardtypes[] = {
 		.i_NbrDiChannel		= 4,
 		.i_NbrDoChannel		= 4,
 		.i_DoMaxdata		= 0x0f,
-		.interrupt		= v_APCI3120_Interrupt,
+		.interrupt		= apci3120_interrupt,
 	},
 	[BOARD_APCI3001] = {
 		.pc_DriverName		= "apci3001",
@@ -37,7 +37,7 @@ static const struct addi_board apci3120_boardtypes[] = {
 		.i_NbrDiChannel		= 4,
 		.i_NbrDoChannel		= 4,
 		.i_DoMaxdata		= 0x0f,
-		.interrupt		= v_APCI3120_Interrupt,
+		.interrupt		= apci3120_interrupt,
 	},
 };
 
@@ -136,11 +136,11 @@ static int apci3120_auto_attach(struct comedi_device *dev,
 	s->len_chanlist = this_board->i_AiChannelList;
 	s->range_table = &range_apci3120_ai;
 
-	s->insn_config = i_APCI3120_InsnConfigAnalogInput;
-	s->insn_read = i_APCI3120_InsnReadAnalogInput;
-	s->do_cmdtest = i_APCI3120_CommandTestAnalogInput;
-	s->do_cmd = i_APCI3120_CommandAnalogInput;
-	s->cancel = i_APCI3120_StopCyclicAcquisition;
+	s->insn_config = apci3120_ai_insn_config;
+	s->insn_read = apci3120_ai_insn_read;
+	s->do_cmdtest = apci3120_ai_cmdtest;
+	s->do_cmd = apci3120_ai_cmd;
+	s->cancel = apci3120_cancel;
 
 	/*  Allocate and Initialise AO Subdevice Structures */
 	s = &dev->subdevices[1];
@@ -151,7 +151,7 @@ static int apci3120_auto_attach(struct comedi_device *dev,
 		s->maxdata = this_board->i_AoMaxdata;
 		s->len_chanlist = this_board->i_NbrAoChannel;
 		s->range_table = &range_apci3120_ao;
-		s->insn_write = i_APCI3120_InsnWriteAnalogOutput;
+		s->insn_write = apci3120_ao_insn_write;
 	} else {
 		s->type = COMEDI_SUBD_UNUSED;
 	}
@@ -186,11 +186,11 @@ static int apci3120_auto_attach(struct comedi_device *dev,
 	s->len_chanlist = 1;
 	s->range_table = &range_digital;
 
-	s->insn_write = i_APCI3120_InsnWriteTimer;
-	s->insn_read = i_APCI3120_InsnReadTimer;
-	s->insn_config = i_APCI3120_InsnConfigTimer;
+	s->insn_write = apci3120_write_insn_timer;
+	s->insn_read = apci3120_read_insn_timer;
+	s->insn_config = apci3120_config_insn_timer;
 
-	i_APCI3120_Reset(dev);
+	apci3120_reset(dev);
 	return 0;
 }
 
@@ -200,7 +200,7 @@ static void apci3120_detach(struct comedi_device *dev)
 
 	if (devpriv) {
 		if (dev->iobase)
-			i_APCI3120_Reset(dev);
+			apci3120_reset(dev);
 		if (dev->irq)
 			free_irq(dev->irq, dev);
 		if (devpriv->ul_DmaBufferVirtual[0]) {
diff --git a/drivers/staging/comedi/drivers/addi_apci_3200.c b/drivers/staging/comedi/drivers/addi_apci_3200.c
index 9868a53..f0f891a 100644
--- a/drivers/staging/comedi/drivers/addi_apci_3200.c
+++ b/drivers/staging/comedi/drivers/addi_apci_3200.c
@@ -43,15 +43,15 @@ static const struct addi_board apci3200_boardtypes[] = {
 		.i_NbrDoChannel		= 4,
 		.ui_MinAcquisitiontimeNs = 10000,
 		.ui_MinDelaytimeNs	= 100000,
-		.interrupt		= v_APCI3200_Interrupt,
-		.reset			= i_APCI3200_Reset,
-		.ai_config		= i_APCI3200_ConfigAnalogInput,
-		.ai_read		= i_APCI3200_ReadAnalogInput,
-		.ai_write		= i_APCI3200_InsnWriteReleaseAnalogInput,
-		.ai_bits		= i_APCI3200_InsnBits_AnalogInput_Test,
-		.ai_cmdtest		= i_APCI3200_CommandTestAnalogInput,
-		.ai_cmd			= i_APCI3200_CommandAnalogInput,
-		.ai_cancel		= i_APCI3200_StopCyclicAcquisition,
+		.interrupt		= apci3200_interrupt,
+		.reset			= apci3200_reset,
+		.ai_config		= apci3200_ai_config,
+		.ai_read		= apci3200_ai_read,
+		.ai_write		= apci3200_ai_write,
+		.ai_bits		= apci3200_ai_bits_test,
+		.ai_cmdtest		= apci3200_ai_cmdtest,
+		.ai_cmd			= apci3200_ai_cmd,
+		.ai_cancel		= apci3200_cancel,
 		.di_bits		= apci3200_di_insn_bits,
 		.do_bits		= apci3200_do_insn_bits,
 	},
@@ -68,15 +68,15 @@ static const struct addi_board apci3200_boardtypes[] = {
 		.i_NbrDoChannel		= 4,
 		.ui_MinAcquisitiontimeNs = 10000,
 		.ui_MinDelaytimeNs	= 100000,
-		.interrupt		= v_APCI3200_Interrupt,
-		.reset			= i_APCI3200_Reset,
-		.ai_config		= i_APCI3200_ConfigAnalogInput,
-		.ai_read		= i_APCI3200_ReadAnalogInput,
-		.ai_write		= i_APCI3200_InsnWriteReleaseAnalogInput,
-		.ai_bits		= i_APCI3200_InsnBits_AnalogInput_Test,
-		.ai_cmdtest		= i_APCI3200_CommandTestAnalogInput,
-		.ai_cmd			= i_APCI3200_CommandAnalogInput,
-		.ai_cancel		= i_APCI3200_StopCyclicAcquisition,
+		.interrupt		= apci3200_interrupt,
+		.reset			= apci3200_reset,
+		.ai_config		= apci3200_ai_config,
+		.ai_read		= apci3200_ai_read,
+		.ai_write		= apci3200_ai_write,
+		.ai_bits		= apci3200_ai_bits_test,
+		.ai_cmdtest		= apci3200_ai_cmdtest,
+		.ai_cmd			= apci3200_ai_cmd,
+		.ai_cancel		= apci3200_cancel,
 		.di_bits		= apci3200_di_insn_bits,
 		.do_bits		= apci3200_do_insn_bits,
 	},
diff --git a/drivers/staging/comedi/drivers/addi_apci_3501.c b/drivers/staging/comedi/drivers/addi_apci_3501.c
index 4cb69ec..49bf1fb 100644
--- a/drivers/staging/comedi/drivers/addi_apci_3501.c
+++ b/drivers/staging/comedi/drivers/addi_apci_3501.c
@@ -390,9 +390,9 @@ static int apci3501_auto_attach(struct comedi_device *dev,
 	s->maxdata = 0;
 	s->len_chanlist = 1;
 	s->range_table = &range_digital;
-	s->insn_write = i_APCI3501_StartStopWriteTimerCounterWatchdog;
-	s->insn_read = i_APCI3501_ReadTimerCounterWatchdog;
-	s->insn_config = i_APCI3501_ConfigTimerCounterWatchdog;
+	s->insn_write = apci3501_write_insn_timer;
+	s->insn_read = apci3501_read_insn_timer;
+	s->insn_config = apci3501_config_insn_timer;
 
 	/* Initialize the eeprom subdevice */
 	s = &dev->subdevices[4];
-- 
1.8.5.3

