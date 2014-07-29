Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444AbaG2L71 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 07:59:27 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:51661 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753249AbaG2L6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 07:58:51 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 19/19] staging: comedi: amplc_pci230: remove some unnecessary parentheses
Date: Tue, 29 Jul 2014 12:58:27 +0100
Message-Id: <1406635107-27950-20-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406635107-27950-1-git-send-email-abbotti@mev.co.uk>
References: <1406635107-27950-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove some pairs of parentheses that don't really improve readability.
Also, reduce the amount of leading whitespace in a few places.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pci230.c | 78 +++++++++++++--------------
 1 file changed, 37 insertions(+), 41 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index d3df96b..bb01351 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -628,7 +628,7 @@ static inline void pci230_ao_write_nofifo(struct comedi_device *dev,
 
 	/* Write mangled datum to appropriate DACOUT register. */
 	outw(pci230_ao_mangle_datum(dev, datum),
-	     dev->iobase + (((chan) == 0) ? PCI230_DACOUT1 : PCI230_DACOUT2));
+	     dev->iobase + (chan == 0 ? PCI230_DACOUT1 : PCI230_DACOUT2));
 }
 
 static inline void pci230_ao_write_fifo(struct comedi_device *dev,
@@ -657,7 +657,7 @@ static int get_resources(struct comedi_device *dev, unsigned int res_mask,
 	ok = 1;
 	claimed = 0;
 	spin_lock_irqsave(&devpriv->res_spinlock, irqflags);
-	for (b = 1, i = 0; (i < NUM_RESOURCES) && res_mask; b <<= 1, i++)
+	for (b = 1, i = 0; i < NUM_RESOURCES && res_mask; b <<= 1, i++)
 		if (res_mask & b) {
 			res_mask &= ~b;
 			if (devpriv->res_owner[i] == OWNER_NONE) {
@@ -682,7 +682,7 @@ static int get_resources(struct comedi_device *dev, unsigned int res_mask,
 static inline int get_one_resource(struct comedi_device *dev,
 				   unsigned int resource, unsigned char owner)
 {
-	return get_resources(dev, (1U << resource), owner);
+	return get_resources(dev, 1U << resource, owner);
 }
 
 static void put_resources(struct comedi_device *dev, unsigned int res_mask,
@@ -694,7 +694,7 @@ static void put_resources(struct comedi_device *dev, unsigned int res_mask,
 	unsigned long irqflags;
 
 	spin_lock_irqsave(&devpriv->res_spinlock, irqflags);
-	for (b = 1, i = 0; (i < NUM_RESOURCES) && res_mask; b <<= 1, i++)
+	for (b = 1, i = 0; i < NUM_RESOURCES && res_mask; b <<= 1, i++)
 		if (res_mask & b) {
 			res_mask &= ~b;
 			if (devpriv->res_owner[i] == owner)
@@ -706,7 +706,7 @@ static void put_resources(struct comedi_device *dev, unsigned int res_mask,
 static inline void put_one_resource(struct comedi_device *dev,
 				    unsigned int resource, unsigned char owner)
 {
-	put_resources(dev, (1U << resource), owner);
+	put_resources(dev, 1U << resource, owner);
 }
 
 static inline void put_all_resources(struct comedi_device *dev,
@@ -748,7 +748,7 @@ static unsigned int pci230_choose_clk_count(uint64_t ns, unsigned int *count,
 
 	for (clk_src = CLK_10MHZ;; clk_src++) {
 		cnt = divide_ns(ns, pci230_timebase[clk_src], flags);
-		if ((cnt <= 65536) || (clk_src == CLK_1KHZ))
+		if (cnt <= 65536 || clk_src == CLK_1KHZ)
 			break;
 	}
 	*count = cnt;
@@ -1005,7 +1005,7 @@ static int pci230_ao_cmdtest(struct comedi_device *dev,
 	err |= cfc_check_trigger_src(&cmd->start_src, TRIG_INT);
 
 	tmp = TRIG_TIMER | TRIG_INT;
-	if ((thisboard->min_hwver > 0) && (devpriv->hwver >= 2))
+	if (thisboard->min_hwver > 0 && devpriv->hwver >= 2)
 		/*
 		 * For PCI230+ hardware version 2 onwards, allow external
 		 * trigger from EXTTRIG/EXTCONVCLK input (PCI230+ pin 25).
@@ -1072,11 +1072,11 @@ static int pci230_ao_cmdtest(struct comedi_device *dev,
 		 * The only flags allowed are CR_EDGE and CR_INVERT.
 		 * The CR_EDGE flag is ignored.
 		 */
-		if (cmd->scan_begin_arg &
-		    (CR_FLAGS_MASK & ~(CR_EDGE | CR_INVERT))) {
-			cmd->scan_begin_arg = COMBINE(cmd->scan_begin_arg, 0,
-						      CR_FLAGS_MASK &
-						      ~(CR_EDGE | CR_INVERT));
+		if (cmd->scan_begin_arg & CR_FLAGS_MASK &
+		    ~(CR_EDGE | CR_INVERT)) {
+			cmd->scan_begin_arg =
+			    COMBINE(cmd->scan_begin_arg, 0,
+				    CR_FLAGS_MASK & ~(CR_EDGE | CR_INVERT));
 			err |= -EINVAL;
 		}
 		break;
@@ -1241,8 +1241,8 @@ static int pci230_handle_ao_fifo(struct comedi_device *dev,
 		 * (otherwise there will be loads of "DAC FIFO not half full"
 		 * interrupts).
 		 */
-		if ((num_scans == 0) &&
-		    ((dacstat & PCI230P2_DAC_FIFO_HALF) == 0)) {
+		if (num_scans == 0 &&
+		    (dacstat & PCI230P2_DAC_FIFO_HALF) == 0) {
 			dev_err(dev->class_dev, "AO buffer underrun\n");
 			events |= COMEDI_CB_OVERFLOW | COMEDI_CB_ERROR;
 		}
@@ -1537,8 +1537,8 @@ static int pci230_ai_check_scan_period(struct comedi_cmd *cmd)
 		chanlist_len = 1;
 
 	min_scan_period = chanlist_len * cmd->convert_arg;
-	if ((min_scan_period < chanlist_len) ||
-	    (min_scan_period < cmd->convert_arg)) {
+	if (min_scan_period < chanlist_len ||
+	    min_scan_period < cmd->convert_arg) {
 		/* Arithmetic overflow. */
 		min_scan_period = UINT_MAX;
 		err++;
@@ -1666,7 +1666,7 @@ static int pci230_ai_cmdtest(struct comedi_device *dev,
 	err |= cfc_check_trigger_src(&cmd->start_src, TRIG_NOW | TRIG_INT);
 
 	tmp = TRIG_FOLLOW | TRIG_TIMER | TRIG_INT;
-	if ((thisboard->have_dio) || (thisboard->min_hwver > 0))
+	if (thisboard->have_dio || thisboard->min_hwver > 0)
 		/*
 		 * Unfortunately, we cannot trigger a scan off an external
 		 * source on the PCI260 board, since it uses the PPIC0 (DIO)
@@ -1696,8 +1696,8 @@ static int pci230_ai_cmdtest(struct comedi_device *dev,
 	 * If scan_begin_src is not TRIG_FOLLOW, then a monostable will be
 	 * set up to generate a fixed number of timed conversion pulses.
 	 */
-	if ((cmd->scan_begin_src != TRIG_FOLLOW) &&
-	    (cmd->convert_src != TRIG_TIMER))
+	if (cmd->scan_begin_src != TRIG_FOLLOW &&
+	    cmd->convert_src != TRIG_TIMER)
 		err |= -EINVAL;
 
 	if (err)
@@ -1724,7 +1724,7 @@ static int pci230_ai_cmdtest(struct comedi_device *dev,
 			 * PCI230 or PCI260.  Max speed depends whether
 			 * single-ended or pseudo-differential.
 			 */
-			if (cmd->chanlist && (cmd->chanlist_len > 0))
+			if (cmd->chanlist && cmd->chanlist_len > 0)
 				/* Peek analogue reference of first channel. */
 				if (CR_AREF(cmd->chanlist[0]) == AREF_DIFF)
 					max_speed_ai = MAX_SPEED_AI_DIFF;
@@ -1762,13 +1762,12 @@ static int pci230_ai_cmdtest(struct comedi_device *dev,
 			 * The only flags allowed are CR_INVERT and CR_EDGE.
 			 * CR_EDGE is required.
 			 */
-			if ((cmd->convert_arg &
-			     (CR_FLAGS_MASK & ~CR_INVERT)) != CR_EDGE) {
+			if ((cmd->convert_arg & CR_FLAGS_MASK & ~CR_INVERT) !=
+			    CR_EDGE) {
 				/* Set CR_EDGE, preserve CR_INVERT. */
-				cmd->convert_arg = COMBINE(cmd->start_arg,
-							   (CR_EDGE | 0),
-							   CR_FLAGS_MASK &
-							   ~CR_INVERT);
+				cmd->convert_arg =
+				    COMBINE(cmd->start_arg, CR_EDGE | 0,
+					    CR_FLAGS_MASK & ~CR_INVERT);
 				err |= -EINVAL;
 			}
 		} else {
@@ -1871,11 +1870,10 @@ static void pci230_ai_update_fifo_trigger_level(struct comedi_device *dev,
 		 scanlen >= PCI230_ADC_FIFOLEVEL_HALFFULL)
 		wake = PCI230_ADC_FIFOLEVEL_HALFFULL;
 	else
-		wake = (devpriv->ai_scan_count * scanlen) -
-		       devpriv->ai_scan_pos;
+		wake = devpriv->ai_scan_count * scanlen - devpriv->ai_scan_pos;
 	if (wake >= PCI230_ADC_FIFOLEVEL_HALFFULL) {
 		triglev = PCI230_ADC_INT_FIFO_HALF;
-	} else if ((wake > 1) && (devpriv->hwver > 0)) {
+	} else if (wake > 1 && devpriv->hwver > 0) {
 		/* PCI230+/260+ programmable FIFO interrupt level. */
 		if (devpriv->adcfifothresh != wake) {
 			devpriv->adcfifothresh = wake;
@@ -1921,8 +1919,8 @@ static int pci230_ai_inttrig_convert(struct comedi_device *dev,
 		 * bit has a different meaning when FIFO enabled (and when
 		 * FIFO not enabled, it only works for software triggers).
 		 */
-		if (((devpriv->adccon & PCI230_ADC_IM_MASK) ==
-		     PCI230_ADC_IM_DIF) && (devpriv->hwver == 0)) {
+		if ((devpriv->adccon & PCI230_ADC_IM_MASK) ==
+		    PCI230_ADC_IM_DIF && devpriv->hwver == 0) {
 			/* PCI230/260 in differential mode */
 			delayus = 8;
 		} else {
@@ -2190,12 +2188,11 @@ static void pci230_handle_ai(struct comedi_device *dev,
 		todo = PCI230_ADC_FIFOLEVEL_HALFFULL;
 	} else if (devpriv->ai_scan_count == 0) {
 		todo = 0;
-	} else if ((devpriv->ai_scan_count > PCI230_ADC_FIFOLEVEL_HALFFULL) ||
-		   (scanlen > PCI230_ADC_FIFOLEVEL_HALFFULL)) {
+	} else if (devpriv->ai_scan_count > PCI230_ADC_FIFOLEVEL_HALFFULL ||
+		   scanlen > PCI230_ADC_FIFOLEVEL_HALFFULL) {
 		todo = PCI230_ADC_FIFOLEVEL_HALFFULL;
 	} else {
-		todo = (devpriv->ai_scan_count * scanlen) -
-		       devpriv->ai_scan_pos;
+		todo = devpriv->ai_scan_count * scanlen - devpriv->ai_scan_pos;
 		if (todo > PCI230_ADC_FIFOLEVEL_HALFFULL)
 			todo = PCI230_ADC_FIFOLEVEL_HALFFULL;
 	}
@@ -2285,13 +2282,13 @@ static int pci230_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	 * Need Z2-CT2 to supply a conversion trigger source at a high
 	 * logic level, even if not doing timed conversions.
 	 */
-	res_mask |= (1U << RES_Z2CT2);
+	res_mask |= 1U << RES_Z2CT2;
 	if (cmd->scan_begin_src != TRIG_FOLLOW) {
 		/* Using Z2-CT0 monostable to gate Z2-CT2 conversion timer */
-		res_mask |= (1U << RES_Z2CT0);
+		res_mask |= 1U << RES_Z2CT0;
 		if (cmd->scan_begin_src == TRIG_TIMER)
 			/* Using Z2-CT1 for scan frequency */
-			res_mask |= (1U << RES_Z2CT1);
+			res_mask |= 1U << RES_Z2CT1;
 	}
 	/* Claim resources. */
 	if (!get_resources(dev, res_mask, OWNER_AICMD))
@@ -2363,7 +2360,7 @@ static int pci230_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 				 */
 				adcen |= 1 << gainshift;
 		} else {
-			gainshift = (chan & ~1);
+			gainshift = chan & ~1;
 			adcen |= 1 << chan;
 		}
 		devpriv->adcg = (devpriv->adcg & ~(3 << gainshift)) |
@@ -2682,8 +2679,7 @@ static int pci230_attach_common(struct comedi_device *dev,
 				 * on PCI260[+].)
 				 */
 				extfunc |= PCI230P_EXTFUNC_GAT_EXTTRIG;
-			if ((thisboard->ao_chans > 0) &&
-			    (devpriv->hwver >= 2))
+			if (thisboard->ao_chans > 0 && devpriv->hwver >= 2)
 				/* Enable DAC FIFO functionality. */
 				extfunc |= PCI230P2_EXTFUNC_DACFIFO;
 		}
-- 
2.0.0

