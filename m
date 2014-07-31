Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611AbaGaNvs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 09:51:48 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:57867 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502AbaGaNsL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 09:48:11 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 10/18] staging: comedi: amplc_pci224: reduce leading whitespace in a few places
Date: Thu, 31 Jul 2014 14:47:47 +0100
Message-Id: <1406814475-5923-11-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406814475-5923-1-git-send-email-abbotti@mev.co.uk>
References: <1406814475-5923-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pci224.c | 53 +++++++++++++--------------
 1 file changed, 25 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci224.c b/drivers/staging/comedi/drivers/amplc_pci224.c
index a7f3454..68fc407 100644
--- a/drivers/staging/comedi/drivers/amplc_pci224.c
+++ b/drivers/staging/comedi/drivers/amplc_pci224.c
@@ -500,11 +500,10 @@ static void pci224_ao_stop(struct comedi_device *dev,
 	spin_unlock_irqrestore(&devpriv->ao_spinlock, flags);
 	/* Reconfigure DAC for insn_write usage. */
 	outw(0, dev->iobase + PCI224_DACCEN);	/* Disable channels. */
-	devpriv->daccon = COMBINE(devpriv->daccon,
-				  PCI224_DACCON_TRIG_SW |
-				  PCI224_DACCON_FIFOINTR_EMPTY,
-				  PCI224_DACCON_TRIG_MASK |
-				  PCI224_DACCON_FIFOINTR_MASK);
+	devpriv->daccon =
+	     COMBINE(devpriv->daccon,
+		     PCI224_DACCON_TRIG_SW | PCI224_DACCON_FIFOINTR_EMPTY,
+		     PCI224_DACCON_TRIG_MASK | PCI224_DACCON_FIFOINTR_MASK);
 	outw(devpriv->daccon | PCI224_DACCON_FIFORESET,
 	     dev->iobase + PCI224_DACCON);
 }
@@ -644,8 +643,8 @@ static void pci224_ao_handle_fifo(struct comedi_device *dev,
 			else
 				trig = PCI224_DACCON_TRIG_EXTP;
 		}
-		devpriv->daccon = COMBINE(devpriv->daccon, trig,
-					  PCI224_DACCON_TRIG_MASK);
+		devpriv->daccon =
+		    COMBINE(devpriv->daccon, trig, PCI224_DACCON_TRIG_MASK);
 		outw(devpriv->daccon, dev->iobase + PCI224_DACCON);
 	}
 
@@ -717,11 +716,11 @@ pci224_ao_cmdtest(struct comedi_device *dev, struct comedi_subdevice *s,
 
 	err |= cfc_check_trigger_src(&cmd->start_src, TRIG_INT | TRIG_EXT);
 	err |= cfc_check_trigger_src(&cmd->scan_begin_src,
-					TRIG_EXT | TRIG_TIMER);
+				     TRIG_EXT | TRIG_TIMER);
 	err |= cfc_check_trigger_src(&cmd->convert_src, TRIG_NOW);
 	err |= cfc_check_trigger_src(&cmd->scan_end_src, TRIG_COUNT);
 	err |= cfc_check_trigger_src(&cmd->stop_src,
-					TRIG_COUNT | TRIG_EXT | TRIG_NONE);
+				     TRIG_COUNT | TRIG_EXT | TRIG_NONE);
 
 	if (err)
 		return 1;
@@ -760,8 +759,8 @@ pci224_ao_cmdtest(struct comedi_device *dev, struct comedi_subdevice *s,
 	case TRIG_EXT:
 		/* Force to external trigger 0. */
 		if (cmd->start_arg & ~CR_FLAGS_MASK) {
-			cmd->start_arg = COMBINE(cmd->start_arg, 0,
-						 ~CR_FLAGS_MASK);
+			cmd->start_arg =
+			    COMBINE(cmd->start_arg, 0, ~CR_FLAGS_MASK);
 			err |= -EINVAL;
 		}
 		/* The only flag allowed is CR_EDGE, which is ignored. */
@@ -786,16 +785,16 @@ pci224_ao_cmdtest(struct comedi_device *dev, struct comedi_subdevice *s,
 	case TRIG_EXT:
 		/* Force to external trigger 0. */
 		if (cmd->scan_begin_arg & ~CR_FLAGS_MASK) {
-			cmd->scan_begin_arg = COMBINE(cmd->scan_begin_arg, 0,
-						      ~CR_FLAGS_MASK);
+			cmd->scan_begin_arg =
+			    COMBINE(cmd->scan_begin_arg, 0, ~CR_FLAGS_MASK);
 			err |= -EINVAL;
 		}
 		/* Only allow flags CR_EDGE and CR_INVERT.  Ignore CR_EDGE. */
 		if (cmd->scan_begin_arg & CR_FLAGS_MASK &
 		    ~(CR_EDGE | CR_INVERT)) {
-			cmd->scan_begin_arg = COMBINE(cmd->scan_begin_arg, 0,
-						      CR_FLAGS_MASK &
-						      ~(CR_EDGE | CR_INVERT));
+			cmd->scan_begin_arg =
+			    COMBINE(cmd->scan_begin_arg, 0,
+				    CR_FLAGS_MASK & ~(CR_EDGE | CR_INVERT));
 			err |= -EINVAL;
 		}
 		break;
@@ -811,14 +810,14 @@ pci224_ao_cmdtest(struct comedi_device *dev, struct comedi_subdevice *s,
 	case TRIG_EXT:
 		/* Force to external trigger 0. */
 		if (cmd->stop_arg & ~CR_FLAGS_MASK) {
-			cmd->stop_arg = COMBINE(cmd->stop_arg, 0,
-						~CR_FLAGS_MASK);
+			cmd->stop_arg =
+			    COMBINE(cmd->stop_arg, 0, ~CR_FLAGS_MASK);
 			err |= -EINVAL;
 		}
 		/* The only flag allowed is CR_EDGE, which is ignored. */
 		if (cmd->stop_arg & CR_FLAGS_MASK & ~CR_EDGE) {
-			cmd->stop_arg = COMBINE(cmd->stop_arg, 0,
-						CR_FLAGS_MASK & ~CR_EDGE);
+			cmd->stop_arg =
+			    COMBINE(cmd->stop_arg, 0, CR_FLAGS_MASK & ~CR_EDGE);
 		}
 		break;
 	case TRIG_NONE:
@@ -924,14 +923,12 @@ static int pci224_ao_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	 *
 	 * N.B. DAC FIFO interrupts are currently disabled.
 	 */
-	devpriv->daccon = COMBINE(devpriv->daccon,
-				  devpriv->hwrange[range] |
-				  PCI224_DACCON_TRIG_NONE |
-				  PCI224_DACCON_FIFOINTR_NHALF,
-				  PCI224_DACCON_POLAR_MASK |
-				  PCI224_DACCON_VREF_MASK |
-				  PCI224_DACCON_TRIG_MASK |
-				  PCI224_DACCON_FIFOINTR_MASK);
+	devpriv->daccon =
+	    COMBINE(devpriv->daccon,
+		    devpriv->hwrange[range] | PCI224_DACCON_TRIG_NONE |
+		    PCI224_DACCON_FIFOINTR_NHALF,
+		    PCI224_DACCON_POLAR_MASK | PCI224_DACCON_VREF_MASK |
+		    PCI224_DACCON_TRIG_MASK | PCI224_DACCON_FIFOINTR_MASK);
 	outw(devpriv->daccon | PCI224_DACCON_FIFORESET,
 	     dev->iobase + PCI224_DACCON);
 
-- 
2.0.0

