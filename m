Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530AbaIALEi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 07:04:38 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:39050 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753418AbaIALEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 07:04:32 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 24/28] staging: comedi: amplc_pci230: reduce indentation in pci230_ao_start()
Date: Mon,  1 Sep 2014 12:03:56 +0100
Message-Id: <1409569440-10979-25-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1409569440-10979-1-git-send-email-abbotti@mev.co.uk>
References: <1409569440-10979-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pci230.c | 113 ++++++++++++--------------
 1 file changed, 54 insertions(+), 59 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index a44b056..e0b40b3 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -1262,78 +1262,73 @@ static void pci230_ao_start(struct comedi_device *dev,
 		async->events |= COMEDI_CB_EOA;
 		pci230_ao_stop(dev, s);
 		comedi_event(dev, s);
-	} else {
-		if (devpriv->hwver >= 2) {
-			/* Using DAC FIFO. */
-			unsigned short scantrig;
-			int run;
-
-			/* Preload FIFO data. */
-			run = pci230_handle_ao_fifo(dev, s);
-			comedi_event(dev, s);
-			if (!run) {
-				/* Stopped. */
-				return;
-			}
-			/* Set scan trigger source. */
-			switch (cmd->scan_begin_src) {
-			case TRIG_TIMER:
-				scantrig = PCI230P2_DAC_TRIG_Z2CT1;
-				break;
-			case TRIG_EXT:
-				/* Trigger on EXTTRIG/EXTCONVCLK pin. */
-				if ((cmd->scan_begin_arg & CR_INVERT) == 0) {
-					/* +ve edge */
-					scantrig = PCI230P2_DAC_TRIG_EXTP;
-				} else {
-					/* -ve edge */
-					scantrig = PCI230P2_DAC_TRIG_EXTN;
-				}
-				break;
-			case TRIG_INT:
-				scantrig = PCI230P2_DAC_TRIG_SW;
-				break;
-			default:
-				/* Shouldn't get here. */
-				scantrig = PCI230P2_DAC_TRIG_NONE;
-				break;
-			}
-			devpriv->daccon =
-			    (devpriv->daccon & ~PCI230P2_DAC_TRIG_MASK) |
-			    scantrig;
-			outw(devpriv->daccon, devpriv->daqio + PCI230_DACCON);
+		return;
+	}
+	if (devpriv->hwver >= 2) {
+		/* Using DAC FIFO. */
+		unsigned short scantrig;
+		int run;
+
+		/* Preload FIFO data. */
+		run = pci230_handle_ao_fifo(dev, s);
+		comedi_event(dev, s);
+		if (!run) {
+			/* Stopped. */
+			return;
 		}
+		/* Set scan trigger source. */
 		switch (cmd->scan_begin_src) {
 		case TRIG_TIMER:
-			if (devpriv->hwver < 2) {
-				/* Not using DAC FIFO. */
-				/* Enable CT1 timer interrupt. */
-				spin_lock_irqsave(&devpriv->isr_spinlock,
-						  irqflags);
-				devpriv->int_en |= PCI230_INT_ZCLK_CT1;
-				devpriv->ier |= PCI230_INT_ZCLK_CT1;
-				outb(devpriv->ier,
-				     dev->iobase + PCI230_INT_SCE);
-				spin_unlock_irqrestore(&devpriv->isr_spinlock,
-						       irqflags);
+			scantrig = PCI230P2_DAC_TRIG_Z2CT1;
+			break;
+		case TRIG_EXT:
+			/* Trigger on EXTTRIG/EXTCONVCLK pin. */
+			if ((cmd->scan_begin_arg & CR_INVERT) == 0) {
+				/* +ve edge */
+				scantrig = PCI230P2_DAC_TRIG_EXTP;
+			} else {
+				/* -ve edge */
+				scantrig = PCI230P2_DAC_TRIG_EXTN;
 			}
-			/* Set CT1 gate high to start counting. */
-			outb(GAT_CONFIG(1, GAT_VCC),
-			     dev->iobase + PCI230_ZGAT_SCE);
 			break;
 		case TRIG_INT:
-			async->inttrig = pci230_ao_inttrig_scan_begin;
+			scantrig = PCI230P2_DAC_TRIG_SW;
+			break;
+		default:
+			/* Shouldn't get here. */
+			scantrig = PCI230P2_DAC_TRIG_NONE;
 			break;
 		}
-		if (devpriv->hwver >= 2) {
-			/* Using DAC FIFO.  Enable DAC FIFO interrupt. */
+		devpriv->daccon =
+		    (devpriv->daccon & ~PCI230P2_DAC_TRIG_MASK) | scantrig;
+		outw(devpriv->daccon, devpriv->daqio + PCI230_DACCON);
+	}
+	switch (cmd->scan_begin_src) {
+	case TRIG_TIMER:
+		if (devpriv->hwver < 2) {
+			/* Not using DAC FIFO. */
+			/* Enable CT1 timer interrupt. */
 			spin_lock_irqsave(&devpriv->isr_spinlock, irqflags);
-			devpriv->int_en |= PCI230P2_INT_DAC;
-			devpriv->ier |= PCI230P2_INT_DAC;
+			devpriv->int_en |= PCI230_INT_ZCLK_CT1;
+			devpriv->ier |= PCI230_INT_ZCLK_CT1;
 			outb(devpriv->ier, dev->iobase + PCI230_INT_SCE);
 			spin_unlock_irqrestore(&devpriv->isr_spinlock,
 					       irqflags);
 		}
+		/* Set CT1 gate high to start counting. */
+		outb(GAT_CONFIG(1, GAT_VCC), dev->iobase + PCI230_ZGAT_SCE);
+		break;
+	case TRIG_INT:
+		async->inttrig = pci230_ao_inttrig_scan_begin;
+		break;
+	}
+	if (devpriv->hwver >= 2) {
+		/* Using DAC FIFO.  Enable DAC FIFO interrupt. */
+		spin_lock_irqsave(&devpriv->isr_spinlock, irqflags);
+		devpriv->int_en |= PCI230P2_INT_DAC;
+		devpriv->ier |= PCI230P2_INT_DAC;
+		outb(devpriv->ier, dev->iobase + PCI230_INT_SCE);
+		spin_unlock_irqrestore(&devpriv->isr_spinlock, irqflags);
 	}
 }
 
-- 
2.0.4

