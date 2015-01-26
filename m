Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659AbbAZO3R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 09:29:17 -0500
Received: from smtp121.iad3a.emailsrvr.com ([173.203.187.121]:39000 "EHLO
	smtp121.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753164AbbAZO3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 09:29:14 -0500
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: addi_apci_1032: add comedi driver comment
Date: Mon, 26 Jan 2015 14:28:56 +0000
Message-Id: <1422282536-18606-1-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a comedi driver comment in a form suitable for importing into
Comedilib documentation.  The information about the change-of-state
subdevice has been pulled from other comments in the driver.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/addi_apci_1032.c | 78 +++++++++++++++----------
 1 file changed, 48 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi_apci_1032.c b/drivers/staging/comedi/drivers/addi_apci_1032.c
index bf14165..4911b62 100644
--- a/drivers/staging/comedi/drivers/addi_apci_1032.c
+++ b/drivers/staging/comedi/drivers/addi_apci_1032.c
@@ -22,6 +22,54 @@
  * more details.
  */
 
+/*
+ * Driver: addi_apci_1032
+ * Description: ADDI-DATA APCI-1032 Digital Input Board
+ * Author: ADDI-DATA GmbH <info@addi-data.com>,
+ *   H Hartley Sweeten <hsweeten@visionengravers.com>
+ * Status: untested
+ * Devices: [ADDI-DATA] APCI-1032 (addi_apci_1032)
+ *
+ * Configuration options:
+ *   None; devices are configured automatically.
+ *
+ * This driver models the APCI-1032 as a 32-channel, digital input subdevice
+ * plus an additional digital input subdevice to handle change-of-state (COS)
+ * interrupts (if an interrupt handler can be set up successfully).
+ *
+ * The COS subdevice supports comedi asynchronous read commands.
+ *
+ * Change-Of-State (COS) interrupt configuration:
+ *
+ * Channels 0 to 15 are interruptible. These channels can be configured
+ * to generate interrupts based on AND/OR logic for the desired channels.
+ *
+ *   OR logic:
+ *   - reacts to rising or falling edges
+ *   - interrupt is generated when any enabled channel meets the desired
+ *     interrupt condition
+ *
+ *   AND logic:
+ *   - reacts to changes in level of the selected inputs
+ *   - interrupt is generated when all enabled channels meet the desired
+ *     interrupt condition
+ *   - after an interrupt, a change in level must occur on the selected
+ *     inputs to release the IRQ logic
+ *
+ * The COS subdevice must be configured before setting up a comedi
+ * asynchronous command:
+ *
+ *   data[0] : INSN_CONFIG_DIGITAL_TRIG
+ *   data[1] : trigger number (= 0)
+ *   data[2] : configuration operation:
+ *             - COMEDI_DIGITAL_TRIG_DISABLE = no interrupts
+ *             - COMEDI_DIGITAL_TRIG_ENABLE_EDGES = OR (edge) interrupts
+ *             - COMEDI_DIGITAL_TRIG_ENABLE_LEVELS = AND (level) interrupts
+ *   data[3] : left-shift for data[4] and data[5]
+ *   data[4] : rising-edge/high level channels
+ *   data[5] : falling-edge/low level channels
+ */
+
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/interrupt.h>
@@ -62,36 +110,6 @@ static int apci1032_reset(struct comedi_device *dev)
 	return 0;
 }
 
-/*
- * Change-Of-State (COS) interrupt configuration
- *
- * Channels 0 to 15 are interruptible. These channels can be configured
- * to generate interrupts based on AND/OR logic for the desired channels.
- *
- *	OR logic
- *		- reacts to rising or falling edges
- *		- interrupt is generated when any enabled channel
- *		  meet the desired interrupt condition
- *
- *	AND logic
- *		- reacts to changes in level of the selected inputs
- *		- interrupt is generated when all enabled channels
- *		  meet the desired interrupt condition
- *		- after an interrupt, a change in level must occur on
- *		  the selected inputs to release the IRQ logic
- *
- * The COS interrupt must be configured before it can be enabled.
- *
- *	data[0] : INSN_CONFIG_DIGITAL_TRIG
- *	data[1] : trigger number (= 0)
- *	data[2] : configuration operation:
- *	          COMEDI_DIGITAL_TRIG_DISABLE = no interrupts
- *	          COMEDI_DIGITAL_TRIG_ENABLE_EDGES = OR (edge) interrupts
- *	          COMEDI_DIGITAL_TRIG_ENABLE_LEVELS = AND (level) interrupts
- *	data[3] : left-shift for data[4] and data[5]
- *	data[4] : rising-edge/high level channels
- *	data[5] : falling-edge/low level channels
- */
 static int apci1032_cos_insn_config(struct comedi_device *dev,
 				    struct comedi_subdevice *s,
 				    struct comedi_insn *insn,
-- 
2.1.4

