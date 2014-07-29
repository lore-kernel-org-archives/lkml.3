Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612AbaG2MBd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 08:01:33 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:51685 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960AbaG2L6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 07:58:48 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 11/19] staging: comedi: amplc_pci230: don't begin line with binary operator
Date: Tue, 29 Jul 2014 12:58:19 +0100
Message-Id: <1406635107-27950-12-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406635107-27950-1-git-send-email-abbotti@mev.co.uk>
References: <1406635107-27950-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If an expression involving a binary operator needs to be split across
two lines, put the split after the operator.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pci230.c | 86 +++++++++++++--------------
 1 file changed, 43 insertions(+), 43 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index 4d3d3cb..311c497 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -682,8 +682,8 @@ static int get_resources(struct comedi_device *dev, unsigned int res_mask,
 			} else if (devpriv->res_owner[i] != owner) {
 				for (b = 1, i = 0; claimed != 0; b <<= 1, i++) {
 					if ((claimed & b) != 0) {
-						devpriv->res_owner[i]
-						    = OWNER_NONE;
+						devpriv->res_owner[i] =
+						    OWNER_NONE;
 						claimed &= ~b;
 					}
 				}
@@ -884,8 +884,8 @@ static int pci230_ai_rinsn(struct comedi_device *dev,
 		gainshift = chan & ~1;
 		adccon |= PCI230_ADC_IM_SE;
 	}
-	devpriv->adcg = (devpriv->adcg & ~(3 << gainshift))
-	    | (pci230_ai_gain[range] << gainshift);
+	devpriv->adcg = (devpriv->adcg & ~(3 << gainshift)) |
+			(pci230_ai_gain[range] << gainshift);
 	if (devpriv->ai_bipolar)
 		adccon |= PCI230_ADC_IR_BIP;
 	else
@@ -1095,8 +1095,8 @@ static int pci230_ao_cmdtest(struct comedi_device *dev,
 		 * The only flags allowed are CR_EDGE and CR_INVERT.
 		 * The CR_EDGE flag is ignored.
 		 */
-		if ((cmd->scan_begin_arg
-		     & (CR_FLAGS_MASK & ~(CR_EDGE | CR_INVERT))) != 0) {
+		if ((cmd->scan_begin_arg &
+		     (CR_FLAGS_MASK & ~(CR_EDGE | CR_INVERT))) != 0) {
 			cmd->scan_begin_arg = COMBINE(cmd->scan_begin_arg, 0,
 						      CR_FLAGS_MASK &
 						      ~(CR_EDGE | CR_INVERT));
@@ -1186,8 +1186,8 @@ static void pci230_ao_stop(struct comedi_device *dev,
 		 * disable FIFO.
 		 */
 		devpriv->daccon &= PCI230_DAC_OR_MASK;
-		outw(devpriv->daccon | PCI230P2_DAC_FIFO_RESET
-		     | PCI230P2_DAC_FIFO_UNDERRUN_CLEAR,
+		outw(devpriv->daccon | PCI230P2_DAC_FIFO_RESET |
+		     PCI230P2_DAC_FIFO_UNDERRUN_CLEAR,
 		     dev->iobase + PCI230_DACCON);
 	}
 	/* Release resources. */
@@ -1307,10 +1307,10 @@ static int pci230_handle_ao_fifo(struct comedi_device *dev,
 				 * to FIFO.  Set FIFO interrupt trigger level
 				 * to 'empty'.
 				 */
-				devpriv->daccon = (devpriv->daccon
-						   &
-						   ~PCI230P2_DAC_INT_FIFO_MASK)
-				    | PCI230P2_DAC_INT_FIFO_EMPTY;
+				devpriv->daccon =
+				    (devpriv->daccon &
+				     ~PCI230P2_DAC_INT_FIFO_MASK) |
+				    PCI230P2_DAC_INT_FIFO_EMPTY;
 				outw(devpriv->daccon,
 				     dev->iobase + PCI230_DACCON);
 			}
@@ -1322,8 +1322,8 @@ static int pci230_handle_ao_fifo(struct comedi_device *dev,
 			events |= COMEDI_CB_OVERFLOW | COMEDI_CB_ERROR;
 		}
 	}
-	if ((events & (COMEDI_CB_EOA | COMEDI_CB_ERROR | COMEDI_CB_OVERFLOW))
-	    != 0) {
+	if ((events &
+	     (COMEDI_CB_EOA | COMEDI_CB_ERROR | COMEDI_CB_OVERFLOW)) != 0) {
 		/* Stopping AO due to completion or error. */
 		pci230_ao_stop(dev, s);
 		running = 0;
@@ -1420,8 +1420,8 @@ static void pci230_ao_start(struct comedi_device *dev,
 				scantrig = PCI230P2_DAC_TRIG_NONE;
 				break;
 			}
-			devpriv->daccon = (devpriv->daccon
-					   & ~PCI230P2_DAC_TRIG_MASK) |
+			devpriv->daccon =
+			    (devpriv->daccon & ~PCI230P2_DAC_TRIG_MASK) |
 			    scantrig;
 			outw(devpriv->daccon, dev->iobase + PCI230_DACCON);
 		}
@@ -1521,16 +1521,16 @@ static int pci230_ao_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		 *
 		 * N.B. DAC FIFO interrupts are currently disabled.
 		 */
-		daccon |= PCI230P2_DAC_FIFO_EN | PCI230P2_DAC_FIFO_RESET
-		    | PCI230P2_DAC_FIFO_UNDERRUN_CLEAR
-		    | PCI230P2_DAC_TRIG_NONE | PCI230P2_DAC_INT_FIFO_NHALF;
+		daccon |= PCI230P2_DAC_FIFO_EN | PCI230P2_DAC_FIFO_RESET |
+			  PCI230P2_DAC_FIFO_UNDERRUN_CLEAR |
+			  PCI230P2_DAC_TRIG_NONE | PCI230P2_DAC_INT_FIFO_NHALF;
 	}
 
 	/* Set DACCON. */
 	outw(daccon, dev->iobase + PCI230_DACCON);
 	/* Preserve most of DACCON apart from write-only, transient bits. */
-	devpriv->daccon = daccon
-	    & ~(PCI230P2_DAC_FIFO_RESET | PCI230P2_DAC_FIFO_UNDERRUN_CLEAR);
+	devpriv->daccon = daccon & ~(PCI230P2_DAC_FIFO_RESET |
+				     PCI230P2_DAC_FIFO_UNDERRUN_CLEAR);
 
 	if (cmd->scan_begin_src == TRIG_TIMER) {
 		/*
@@ -1797,8 +1797,8 @@ static int pci230_ai_cmdtest(struct comedi_device *dev,
 			 * The only flags allowed are CR_INVERT and CR_EDGE.
 			 * CR_EDGE is required.
 			 */
-			if ((cmd->convert_arg & (CR_FLAGS_MASK & ~CR_INVERT))
-			    != CR_EDGE) {
+			if ((cmd->convert_arg &
+			     (CR_FLAGS_MASK & ~CR_INVERT)) != CR_EDGE) {
 				/* Set CR_EDGE, preserve CR_INVERT. */
 				cmd->convert_arg = COMBINE(cmd->start_arg,
 							   (CR_EDGE | 0),
@@ -1907,8 +1907,8 @@ static void pci230_ai_update_fifo_trigger_level(struct comedi_device *dev,
 		    scanlen >= PCI230_ADC_FIFOLEVEL_HALFFULL) {
 			wake = PCI230_ADC_FIFOLEVEL_HALFFULL;
 		} else {
-			wake = (devpriv->ai_scan_count * scanlen)
-			    - devpriv->ai_scan_pos;
+			wake = (devpriv->ai_scan_count * scanlen) -
+			       devpriv->ai_scan_pos;
 		}
 	}
 	if (wake >= PCI230_ADC_FIFOLEVEL_HALFFULL) {
@@ -2043,8 +2043,8 @@ static void pci230_ai_stop(struct comedi_device *dev,
 	 * Reset FIFO, disable FIFO and set start conversion source to none.
 	 * Keep se/diff and bip/uni settings.
 	 */
-	devpriv->adccon = (devpriv->adccon & (PCI230_ADC_IR_MASK
-					      | PCI230_ADC_IM_MASK)) |
+	devpriv->adccon =
+	    (devpriv->adccon & (PCI230_ADC_IR_MASK | PCI230_ADC_IM_MASK)) |
 	    PCI230_ADC_TRIG_NONE;
 	outw(devpriv->adccon | PCI230_ADC_FIFO_RESET,
 	     dev->iobase + PCI230_ADCCON);
@@ -2115,8 +2115,8 @@ static void pci230_ai_start(struct comedi_device *dev,
 			conv = PCI230_ADC_TRIG_Z2CT2;
 			break;
 		}
-		devpriv->adccon = (devpriv->adccon & ~PCI230_ADC_TRIG_MASK)
-		    | conv;
+		devpriv->adccon =
+		    (devpriv->adccon & ~PCI230_ADC_TRIG_MASK) | conv;
 		outw(devpriv->adccon, dev->iobase + PCI230_ADCCON);
 		if (cmd->convert_src == TRIG_INT)
 			async->inttrig = pci230_ai_inttrig_convert;
@@ -2187,8 +2187,8 @@ static void pci230_ai_start(struct comedi_device *dev,
 					 * gated on to start counting.
 					 */
 					zgat = GAT_CONFIG(1, GAT_VCC);
-					outb(zgat, devpriv->iobase1
-					     + PCI230_ZGAT_SCE);
+					outb(zgat, devpriv->iobase1 +
+						   PCI230_ZGAT_SCE);
 					break;
 				case TRIG_INT:
 					async->inttrig =
@@ -2240,8 +2240,8 @@ static void pci230_handle_ai(struct comedi_device *dev,
 		   (scanlen > PCI230_ADC_FIFOLEVEL_HALFFULL)) {
 		todo = PCI230_ADC_FIFOLEVEL_HALFFULL;
 	} else {
-		todo = (devpriv->ai_scan_count * scanlen)
-		    - devpriv->ai_scan_pos;
+		todo = (devpriv->ai_scan_count * scanlen) -
+		       devpriv->ai_scan_pos;
 		if (todo > PCI230_ADC_FIFOLEVEL_HALFFULL)
 			todo = PCI230_ADC_FIFOLEVEL_HALFFULL;
 	}
@@ -2270,8 +2270,8 @@ static void pci230_handle_ai(struct comedi_device *dev,
 				/* FIFO not empty. */
 				if (devpriv->hwver > 0) {
 					/* Read PCI230+/260+ ADC FIFO level. */
-					fifoamount = inw(dev->iobase
-							 + PCI230P_ADCFFLEV);
+					fifoamount =
+					    inw(dev->iobase + PCI230P_ADCFFLEV);
 					if (fifoamount == 0) {
 						/* Shouldn't happen. */
 						break;
@@ -2417,8 +2417,8 @@ static int pci230_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 			gainshift = (chan & ~1);
 			adcen |= 1 << chan;
 		}
-		devpriv->adcg = (devpriv->adcg & ~(3 << gainshift))
-		    | (pci230_ai_gain[range] << gainshift);
+		devpriv->adcg = (devpriv->adcg & ~(3 << gainshift)) |
+				(pci230_ai_gain[range] << gainshift);
 	}
 
 	/* Set channel scan list. */
@@ -2490,8 +2490,8 @@ static int pci230_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 			zgat = GAT_CONFIG(0, GAT_VCC);
 			outb(zgat, devpriv->iobase1 + PCI230_ZGAT_SCE);
 			pci230_ct_setup_ns_mode(dev, 0, I8254_MODE1,
-						((uint64_t) cmd->convert_arg
-						 * cmd->scan_end_arg),
+						((uint64_t)cmd->convert_arg *
+						 cmd->scan_end_arg),
 						TRIG_ROUND_UP);
 			if (cmd->scan_begin_src == TRIG_TIMER) {
 				/*
@@ -2746,8 +2746,8 @@ static int pci230_attach_common(struct comedi_device *dev,
 			 * Temporarily enable DAC FIFO, reset it and disable
 			 * FIFO wraparound.
 			 */
-			outw(devpriv->daccon | PCI230P2_DAC_FIFO_EN
-			     | PCI230P2_DAC_FIFO_RESET,
+			outw(devpriv->daccon | PCI230P2_DAC_FIFO_EN |
+			     PCI230P2_DAC_FIFO_RESET,
 			     dev->iobase + PCI230_DACCON);
 			/* Clear DAC FIFO channel enable register. */
 			outw(0, dev->iobase + PCI230P2_DACEN);
@@ -2759,8 +2759,8 @@ static int pci230_attach_common(struct comedi_device *dev,
 	outb(0, devpriv->iobase1 + PCI230_INT_SCE);
 	/* Set ADC to a reasonable state. */
 	devpriv->adcg = 0;
-	devpriv->adccon = PCI230_ADC_TRIG_NONE | PCI230_ADC_IM_SE
-	    | PCI230_ADC_IR_BIP;
+	devpriv->adccon = PCI230_ADC_TRIG_NONE | PCI230_ADC_IM_SE |
+			  PCI230_ADC_IR_BIP;
 	outw(1 << 0, dev->iobase + PCI230_ADCEN);
 	outw(devpriv->adcg, dev->iobase + PCI230_ADCG);
 	outw(devpriv->adccon | PCI230_ADC_FIFO_RESET,
-- 
2.0.0

