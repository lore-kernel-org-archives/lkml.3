Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998AbaG2L6q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 07:58:46 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:51639 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960AbaG2L6m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 07:58:42 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 03/19] staging: comedi: amplc_pci230: logical continuations should be on the previous line
Date: Tue, 29 Jul 2014 12:58:11 +0100
Message-Id: <1406635107-27950-4-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406635107-27950-1-git-send-email-abbotti@mev.co.uk>
References: <1406635107-27950-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch issues "CHECK: Logical continuations should be on the
previous line".

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pci230.c | 33 +++++++++++++--------------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index c6c3c4a..0609e51 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -694,8 +694,8 @@ static int get_resources(struct comedi_device *dev, unsigned int res_mask,
 	ok = 1;
 	claimed = 0;
 	spin_lock_irqsave(&devpriv->res_spinlock, irqflags);
-	for (b = 1, i = 0; (i < NUM_RESOURCES)
-	     && (res_mask != 0); b <<= 1, i++) {
+	for (b = 1, i = 0; (i < NUM_RESOURCES) && (res_mask != 0);
+	     b <<= 1, i++) {
 		if ((res_mask & b) != 0) {
 			res_mask &= ~b;
 			if (devpriv->res_owner[i] == OWNER_NONE) {
@@ -733,8 +733,8 @@ static void put_resources(struct comedi_device *dev, unsigned int res_mask,
 	unsigned long irqflags;
 
 	spin_lock_irqsave(&devpriv->res_spinlock, irqflags);
-	for (b = 1, i = 0; (i < NUM_RESOURCES)
-	     && (res_mask != 0); b <<= 1, i++) {
+	for (b = 1, i = 0; (i < NUM_RESOURCES) && (res_mask != 0);
+	     b <<= 1, i++) {
 		if ((res_mask & b) != 0) {
 			res_mask &= ~b;
 			if (devpriv->res_owner[i] == owner)
@@ -1291,8 +1291,8 @@ static int pci230_handle_ao_fifo(struct comedi_device *dev,
 		 * (otherwise there will be loads of "DAC FIFO not half full"
 		 * interrupts).
 		 */
-		if ((num_scans == 0)
-		    && ((dacstat & PCI230P2_DAC_FIFO_HALF) == 0)) {
+		if ((num_scans == 0) &&
+		    ((dacstat & PCI230P2_DAC_FIFO_HALF) == 0)) {
 			dev_err(dev->class_dev, "AO buffer underrun\n");
 			events |= COMEDI_CB_OVERFLOW | COMEDI_CB_ERROR;
 		}
@@ -1594,8 +1594,8 @@ static int pci230_ai_check_scan_period(struct comedi_cmd *cmd)
 		chanlist_len = 1;
 
 	min_scan_period = chanlist_len * cmd->convert_arg;
-	if ((min_scan_period < chanlist_len)
-	    || (min_scan_period < cmd->convert_arg)) {
+	if ((min_scan_period < chanlist_len) ||
+	    (min_scan_period < cmd->convert_arg)) {
 		/* Arithmetic overflow. */
 		min_scan_period = UINT_MAX;
 		err++;
@@ -1755,8 +1755,8 @@ static int pci230_ai_cmdtest(struct comedi_device *dev,
 	 * If scan_begin_src is not TRIG_FOLLOW, then a monostable will be
 	 * set up to generate a fixed number of timed conversion pulses.
 	 */
-	if ((cmd->scan_begin_src != TRIG_FOLLOW)
-	    && (cmd->convert_src != TRIG_TIMER))
+	if ((cmd->scan_begin_src != TRIG_FOLLOW) &&
+	    (cmd->convert_src != TRIG_TIMER))
 		err |= -EINVAL;
 
 	if (err)
@@ -1987,9 +1987,8 @@ static int pci230_ai_inttrig_convert(struct comedi_device *dev,
 		 * bit has a different meaning when FIFO enabled (and when
 		 * FIFO not enabled, it only works for software triggers).
 		 */
-		if (((devpriv->adccon & PCI230_ADC_IM_MASK)
-		     == PCI230_ADC_IM_DIF)
-		    && (devpriv->hwver == 0)) {
+		if (((devpriv->adccon & PCI230_ADC_IM_MASK) ==
+		     PCI230_ADC_IM_DIF) && (devpriv->hwver == 0)) {
 			/* PCI230/260 in differential mode */
 			delayus = 8;
 		} else {
@@ -2263,8 +2262,8 @@ static void pci230_handle_ai(struct comedi_device *dev,
 		todo = PCI230_ADC_FIFOLEVEL_HALFFULL;
 	} else if (devpriv->ai_scan_count == 0) {
 		todo = 0;
-	} else if ((devpriv->ai_scan_count > PCI230_ADC_FIFOLEVEL_HALFFULL)
-		   || (scanlen > PCI230_ADC_FIFOLEVEL_HALFFULL)) {
+	} else if ((devpriv->ai_scan_count > PCI230_ADC_FIFOLEVEL_HALFFULL) ||
+		   (scanlen > PCI230_ADC_FIFOLEVEL_HALFFULL)) {
 		todo = PCI230_ADC_FIFOLEVEL_HALFFULL;
 	} else {
 		todo = (devpriv->ai_scan_count * scanlen)
@@ -2761,8 +2760,8 @@ static int pci230_attach_common(struct comedi_device *dev,
 				 */
 				extfunc |= PCI230P_EXTFUNC_GAT_EXTTRIG;
 			}
-			if ((thisboard->ao_chans > 0)
-			    && (devpriv->hwver >= 2)) {
+			if ((thisboard->ao_chans > 0) &&
+			    (devpriv->hwver >= 2)) {
 				/* Enable DAC FIFO functionality. */
 				extfunc |= PCI230P2_EXTFUNC_DACFIFO;
 			}
-- 
2.0.0

