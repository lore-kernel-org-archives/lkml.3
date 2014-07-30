Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515AbaG3Lys (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 07:54:48 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:54842 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887AbaG3Lyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 07:54:47 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 13/19 v2] staging: comedi: amplc_pci230: remove unnecessary braces
Date: Wed, 30 Jul 2014 12:53:47 +0100
Message-Id: <1406721227-8144-1-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406635107-27950-14-git-send-email-abbotti@mev.co.uk>
References: <1406635107-27950-14-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
v2: Be less aggressive in brace removal.  Keep them for outer nested
'if's.  Keep them in outer control statements where the inner control
statement uses braces.
---
 drivers/staging/comedi/drivers/amplc_pci230.c | 120 ++++++++++----------------
 1 file changed, 46 insertions(+), 74 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index 4222e28..dfc8798 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -862,19 +862,18 @@ static int pci230_ai_rinsn(struct comedi_device *dev,
 	if (aref == AREF_DIFF) {
 		/* Differential. */
 		gainshift = chan * 2;
-		if (devpriv->hwver == 0) {
+		if (devpriv->hwver == 0)
 			/*
 			 * Original PCI230/260 expects both inputs of the
 			 * differential channel to be enabled.
 			 */
 			adcen = 3 << gainshift;
-		} else {
+		else
 			/*
 			 * PCI230+/260+ expects only one input of the
 			 * differential channel to be enabled.
 			 */
 			adcen = 1 << gainshift;
-		}
 		adccon |= PCI230_ADC_IM_DIF;
 	} else {
 		/* Single ended. */
@@ -889,7 +888,6 @@ static int pci230_ai_rinsn(struct comedi_device *dev,
 	else
 		adccon |= PCI230_ADC_IR_UNI;
 
-
 	/*
 	 * Enable only this channel in the scan list - otherwise by default
 	 * we'll get one sample from each channel.
@@ -953,10 +951,9 @@ static int pci230_ao_winsn(struct comedi_device *dev,
 	 * Writing a list of values to an AO channel is probably not
 	 * very useful, but that's how the interface is defined.
 	 */
-	for (i = 0; i < insn->n; i++) {
+	for (i = 0; i < insn->n; i++)
 		/* Write value to DAC and store it. */
 		pci230_ao_write_nofifo(dev, data[i], chan);
-	}
 
 	/* return the number of samples read/written */
 	return i;
@@ -1025,7 +1022,7 @@ static int pci230_ao_cmdtest(struct comedi_device *dev,
 	err |= cfc_check_trigger_src(&cmd->start_src, TRIG_INT);
 
 	tmp = TRIG_TIMER | TRIG_INT;
-	if ((thisboard->min_hwver > 0) && (devpriv->hwver >= 2)) {
+	if ((thisboard->min_hwver > 0) && (devpriv->hwver >= 2))
 		/*
 		 * For PCI230+ hardware version 2 onwards, allow external
 		 * trigger from EXTTRIG/EXTCONVCLK input (PCI230+ pin 25).
@@ -1041,7 +1038,6 @@ static int pci230_ao_cmdtest(struct comedi_device *dev,
 		 * guarantee!
 		 */
 		tmp |= TRIG_EXT;
-	}
 	err |= cfc_check_trigger_src(&cmd->scan_begin_src, tmp);
 
 	err |= cfc_check_trigger_src(&cmd->convert_src, TRIG_NOW);
@@ -1151,18 +1147,16 @@ static void pci230_ao_stop(struct comedi_device *dev,
 	if (!started)
 		return;
 	cmd = &s->async->cmd;
-	if (cmd->scan_begin_src == TRIG_TIMER) {
+	if (cmd->scan_begin_src == TRIG_TIMER)
 		/* Stop scan rate generator. */
 		pci230_cancel_ct(dev, 1);
-	}
 	/* Determine interrupt source. */
-	if (devpriv->hwver < 2) {
+	if (devpriv->hwver < 2)
 		/* Not using DAC FIFO.  Using CT1 interrupt. */
 		intsrc = PCI230_INT_ZCLK_CT1;
-	} else {
+	else
 		/* Using DAC FIFO interrupt. */
 		intsrc = PCI230P2_INT_DAC;
-	}
 	/*
 	 * Disable interrupt and wait for interrupt routine to finish running
 	 * unless we are called from the interrupt routine.
@@ -1249,10 +1243,9 @@ static int pci230_handle_ao_fifo(struct comedi_device *dev,
 		/* Fixed number of scans. */
 		if (num_scans > devpriv->ao_scan_count)
 			num_scans = devpriv->ao_scan_count;
-		if (devpriv->ao_scan_count == 0) {
+		if (devpriv->ao_scan_count == 0)
 			/* End of acquisition. */
 			events |= COMEDI_CB_EOA;
-		}
 	}
 	if (events == 0) {
 		/* Check for FIFO underrun. */
@@ -1390,10 +1383,9 @@ static void pci230_ao_start(struct comedi_device *dev,
 			/* Preload FIFO data. */
 			run = pci230_handle_ao_fifo(dev, s);
 			comedi_event(dev, s);
-			if (!run) {
+			if (!run)
 				/* Stopped. */
 				return;
-			}
 			/* Set scan trigger source. */
 			switch (cmd->scan_begin_src) {
 			case TRIG_TIMER:
@@ -1401,13 +1393,12 @@ static void pci230_ao_start(struct comedi_device *dev,
 				break;
 			case TRIG_EXT:
 				/* Trigger on EXTTRIG/EXTCONVCLK pin. */
-				if ((cmd->scan_begin_arg & CR_INVERT) == 0) {
+				if ((cmd->scan_begin_arg & CR_INVERT) == 0)
 					/* +ve edge */
 					scantrig = PCI230P2_DAC_TRIG_EXTP;
-				} else {
+				else
 					/* -ve edge */
 					scantrig = PCI230P2_DAC_TRIG_EXTN;
-				}
 				break;
 			case TRIG_INT:
 				scantrig = PCI230P2_DAC_TRIG_SW;
@@ -1695,7 +1686,7 @@ static int pci230_ai_cmdtest(struct comedi_device *dev,
 	err |= cfc_check_trigger_src(&cmd->start_src, TRIG_NOW | TRIG_INT);
 
 	tmp = TRIG_FOLLOW | TRIG_TIMER | TRIG_INT;
-	if ((thisboard->have_dio) || (thisboard->min_hwver > 0)) {
+	if ((thisboard->have_dio) || (thisboard->min_hwver > 0))
 		/*
 		 * Unfortunately, we cannot trigger a scan off an external
 		 * source on the PCI260 board, since it uses the PPIC0 (DIO)
@@ -1703,7 +1694,6 @@ static int pci230_ai_cmdtest(struct comedi_device *dev,
 		 * we can use the EXTTRIG/EXTCONVCLK input on pin 17 instead.
 		 */
 		tmp |= TRIG_EXT;
-	}
 	err |= cfc_check_trigger_src(&cmd->scan_begin_src, tmp);
 	err |= cfc_check_trigger_src(&cmd->convert_src,
 					TRIG_TIMER | TRIG_INT | TRIG_EXT);
@@ -1760,7 +1750,6 @@ static int pci230_ai_cmdtest(struct comedi_device *dev,
 					max_speed_ai = MAX_SPEED_AI_DIFF;
 				else
 					max_speed_ai = MAX_SPEED_AI_SE;
-
 			} else {
 				/* No channel list.  Assume single-ended. */
 				max_speed_ai = MAX_SPEED_AI_SE;
@@ -1895,32 +1884,27 @@ static void pci230_ai_update_fifo_trigger_level(struct comedi_device *dev,
 	unsigned short triglev;
 	unsigned short adccon;
 
-	if (cmd->flags & TRIG_WAKE_EOS) {
+	if (cmd->flags & TRIG_WAKE_EOS)
 		/* Wake at end of scan. */
 		wake = scanlen - devpriv->ai_scan_pos;
-	} else {
-		if (cmd->stop_src != TRIG_COUNT ||
-		    devpriv->ai_scan_count >= PCI230_ADC_FIFOLEVEL_HALFFULL ||
-		    scanlen >= PCI230_ADC_FIFOLEVEL_HALFFULL) {
-			wake = PCI230_ADC_FIFOLEVEL_HALFFULL;
-		} else {
-			wake = (devpriv->ai_scan_count * scanlen) -
-			       devpriv->ai_scan_pos;
-		}
-	}
+	else if (cmd->stop_src != TRIG_COUNT ||
+		 devpriv->ai_scan_count >= PCI230_ADC_FIFOLEVEL_HALFFULL ||
+		 scanlen >= PCI230_ADC_FIFOLEVEL_HALFFULL)
+		wake = PCI230_ADC_FIFOLEVEL_HALFFULL;
+	else
+		wake = (devpriv->ai_scan_count * scanlen) -
+		       devpriv->ai_scan_pos;
 	if (wake >= PCI230_ADC_FIFOLEVEL_HALFFULL) {
 		triglev = PCI230_ADC_INT_FIFO_HALF;
-	} else {
-		if ((wake > 1) && (devpriv->hwver > 0)) {
-			/* PCI230+/260+ programmable FIFO interrupt level. */
-			if (devpriv->adcfifothresh != wake) {
-				devpriv->adcfifothresh = wake;
-				outw(wake, dev->iobase + PCI230P_ADCFFTH);
-			}
-			triglev = PCI230P_ADC_INT_FIFO_THRESH;
-		} else {
-			triglev = PCI230_ADC_INT_FIFO_NEMPTY;
+	} else if ((wake > 1) && (devpriv->hwver > 0)) {
+		/* PCI230+/260+ programmable FIFO interrupt level. */
+		if (devpriv->adcfifothresh != wake) {
+			devpriv->adcfifothresh = wake;
+			outw(wake, dev->iobase + PCI230P_ADCFFTH);
 		}
+		triglev = PCI230P_ADC_INT_FIFO_THRESH;
+	} else {
+		triglev = PCI230_ADC_INT_FIFO_NEMPTY;
 	}
 	adccon = (devpriv->adccon & ~PCI230_ADC_INT_FIFO_MASK) | triglev;
 	if (adccon != devpriv->adccon) {
@@ -2013,14 +1997,12 @@ static void pci230_ai_stop(struct comedi_device *dev,
 	if (!started)
 		return;
 	cmd = &s->async->cmd;
-	if (cmd->convert_src == TRIG_TIMER) {
+	if (cmd->convert_src == TRIG_TIMER)
 		/* Stop conversion rate generator. */
 		pci230_cancel_ct(dev, 2);
-	}
-	if (cmd->scan_begin_src != TRIG_FOLLOW) {
+	if (cmd->scan_begin_src != TRIG_FOLLOW)
 		/* Stop scan period monostable. */
 		pci230_cancel_ct(dev, 0);
-	}
 	spin_lock_irqsave(&devpriv->isr_spinlock, irqflags);
 	/*
 	 * Disable ADC interrupt and wait for interrupt routine to finish
@@ -2086,22 +2068,20 @@ static void pci230_ai_start(struct comedi_device *dev,
 			break;
 		case TRIG_EXT:
 			if (cmd->convert_arg & CR_EDGE) {
-				if ((cmd->convert_arg & CR_INVERT) == 0) {
+				if ((cmd->convert_arg & CR_INVERT) == 0)
 					/* Trigger on +ve edge. */
 					conv = PCI230_ADC_TRIG_EXTP;
-				} else {
+				else
 					/* Trigger on -ve edge. */
 					conv = PCI230_ADC_TRIG_EXTN;
-				}
 			} else {
 				/* Backwards compatibility. */
-				if (cmd->convert_arg) {
+				if (cmd->convert_arg)
 					/* Trigger on +ve edge. */
 					conv = PCI230_ADC_TRIG_EXTP;
-				} else {
+				else
 					/* Trigger on -ve edge. */
 					conv = PCI230_ADC_TRIG_EXTN;
-				}
 			}
 			break;
 		case TRIG_INT:
@@ -2127,19 +2107,18 @@ static void pci230_ai_start(struct comedi_device *dev,
 			/* Update timer gates. */
 			unsigned char zgat;
 
-			if (cmd->scan_begin_src != TRIG_FOLLOW) {
+			if (cmd->scan_begin_src != TRIG_FOLLOW)
 				/*
 				 * Conversion timer CT2 needs to be gated by
 				 * inverted output of monostable CT2.
 				 */
 				zgat = GAT_CONFIG(2, GAT_NOUTNM2);
-			} else {
+			else
 				/*
 				 * Conversion timer CT2 needs to be gated on
 				 * continuously.
 				 */
 				zgat = GAT_CONFIG(2, GAT_VCC);
-			}
 			outb(zgat, devpriv->iobase1 + PCI230_ZGAT_SCE);
 			if (cmd->scan_begin_src != TRIG_FOLLOW) {
 				/* Set monostable CT0 trigger source. */
@@ -2269,10 +2248,9 @@ static void pci230_handle_ai(struct comedi_device *dev,
 					/* Read PCI230+/260+ ADC FIFO level. */
 					fifoamount =
 					    inw(dev->iobase + PCI230P_ADCFFLEV);
-					if (fifoamount == 0) {
+					if (fifoamount == 0)
 						/* Shouldn't happen. */
 						break;
-					}
 				} else {
 					fifoamount = 1;
 				}
@@ -2293,22 +2271,20 @@ static void pci230_handle_ai(struct comedi_device *dev,
 			async->events |= COMEDI_CB_EOS;
 		}
 	}
-	if (cmd->stop_src == TRIG_COUNT && devpriv->ai_scan_count == 0) {
+	if (cmd->stop_src == TRIG_COUNT && devpriv->ai_scan_count == 0)
 		/* End of acquisition. */
 		events |= COMEDI_CB_EOA;
-	} else {
+	else
 		/* More samples required, tell Comedi to block. */
 		events |= COMEDI_CB_BLOCK;
-	}
 	async->events |= events;
 	if (async->events & (COMEDI_CB_EOA | COMEDI_CB_ERROR |
-			     COMEDI_CB_OVERFLOW)) {
+			     COMEDI_CB_OVERFLOW))
 		/* disable hardware conversions */
 		pci230_ai_stop(dev, s);
-	} else {
+	else
 		/* update FIFO interrupt trigger level */
 		pci230_ai_update_fifo_trigger_level(dev, s);
-	}
 }
 
 static int pci230_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
@@ -2335,10 +2311,9 @@ static int pci230_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	if (cmd->scan_begin_src != TRIG_FOLLOW) {
 		/* Using Z2-CT0 monostable to gate Z2-CT2 conversion timer */
 		res_mask |= (1U << RES_Z2CT0);
-		if (cmd->scan_begin_src == TRIG_TIMER) {
+		if (cmd->scan_begin_src == TRIG_TIMER)
 			/* Using Z2-CT1 for scan frequency */
 			res_mask |= (1U << RES_Z2CT1);
-		}
 	}
 	/* Claim resources. */
 	if (!get_resources(dev, res_mask, OWNER_AICMD))
@@ -2397,19 +2372,18 @@ static int pci230_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		range = CR_RANGE(cmd->chanlist[i]);
 		if (diff) {
 			gainshift = 2 * chan;
-			if (devpriv->hwver == 0) {
+			if (devpriv->hwver == 0)
 				/*
 				 * Original PCI230/260 expects both inputs of
 				 * the differential channel to be enabled.
 				 */
 				adcen |= 3 << gainshift;
-			} else {
+			else
 				/*
 				 * PCI230+/260+ expects only one input of the
 				 * differential channel to be enabled.
 				 */
 				adcen |= 1 << gainshift;
-			}
 		} else {
 			gainshift = (chan & ~1);
 			adcen |= 1 << chan;
@@ -2721,7 +2695,7 @@ static int pci230_attach_common(struct comedi_device *dev,
 			return -EIO;
 		}
 		if (devpriv->hwver > 0) {
-			if (!thisboard->have_dio) {
+			if (!thisboard->have_dio)
 				/*
 				 * No DIO ports.  Route counters' external gates
 				 * to the EXTTRIG signal (PCI260+ pin 17).
@@ -2730,12 +2704,10 @@ static int pci230_attach_common(struct comedi_device *dev,
 				 * on PCI260[+].)
 				 */
 				extfunc |= PCI230P_EXTFUNC_GAT_EXTTRIG;
-			}
 			if ((thisboard->ao_chans > 0) &&
-			    (devpriv->hwver >= 2)) {
+			    (devpriv->hwver >= 2))
 				/* Enable DAC FIFO functionality. */
 				extfunc |= PCI230P2_EXTFUNC_DACFIFO;
-			}
 		}
 		outw(extfunc, dev->iobase + PCI230P_EXTFUNC);
 		if (extfunc & PCI230P2_EXTFUNC_DACFIFO) {
-- 
2.0.0

