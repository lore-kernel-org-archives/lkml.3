Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751831AbaGaNsS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 09:48:18 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:57868 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480AbaGaNsL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 09:48:11 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 09/18] staging: comedi: amplc_pci224: remove some unnecessary parentheses
Date: Thu, 31 Jul 2014 14:47:46 +0100
Message-Id: <1406814475-5923-10-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406814475-5923-1-git-send-email-abbotti@mev.co.uk>
References: <1406814475-5923-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove some pairs of parentheses that don't really improve readability.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pci224.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci224.c b/drivers/staging/comedi/drivers/amplc_pci224.c
index 0ac05fb..a7f3454 100644
--- a/drivers/staging/comedi/drivers/amplc_pci224.c
+++ b/drivers/staging/comedi/drivers/amplc_pci224.c
@@ -396,8 +396,8 @@ pci224_ao_set_data(struct comedi_device *dev, int chan, int range,
 	outw(1 << chan, dev->iobase + PCI224_DACCEN);
 	/* Set range and reset FIFO. */
 	devpriv->daccon = COMBINE(devpriv->daccon, devpriv->hwrange[range],
-				  (PCI224_DACCON_POLAR_MASK |
-				   PCI224_DACCON_VREF_MASK));
+				  PCI224_DACCON_POLAR_MASK |
+				  PCI224_DACCON_VREF_MASK);
 	outw(devpriv->daccon | PCI224_DACCON_FIFORESET,
 	     dev->iobase + PCI224_DACCON);
 	/*
@@ -685,7 +685,7 @@ static int pci224_ao_check_chanlist(struct comedi_device *dev,
 				__func__);
 			return -EINVAL;
 		}
-		chan_mask |= (1 << chan);
+		chan_mask |= 1 << chan;
 
 		if (range != range0) {
 			dev_dbg(dev->class_dev,
@@ -925,13 +925,13 @@ static int pci224_ao_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	 * N.B. DAC FIFO interrupts are currently disabled.
 	 */
 	devpriv->daccon = COMBINE(devpriv->daccon,
-				  (devpriv->
-				   hwrange[range] | PCI224_DACCON_TRIG_NONE |
-				   PCI224_DACCON_FIFOINTR_NHALF),
-				  (PCI224_DACCON_POLAR_MASK |
-				   PCI224_DACCON_VREF_MASK |
-				   PCI224_DACCON_TRIG_MASK |
-				   PCI224_DACCON_FIFOINTR_MASK));
+				  devpriv->hwrange[range] |
+				  PCI224_DACCON_TRIG_NONE |
+				  PCI224_DACCON_FIFOINTR_NHALF,
+				  PCI224_DACCON_POLAR_MASK |
+				  PCI224_DACCON_VREF_MASK |
+				  PCI224_DACCON_TRIG_MASK |
+				  PCI224_DACCON_FIFOINTR_MASK);
 	outw(devpriv->daccon | PCI224_DACCON_FIFORESET,
 	     dev->iobase + PCI224_DACCON);
 
@@ -1161,9 +1161,8 @@ static int pci224_attach_common(struct comedi_device *dev,
 	outw(PCI224_DACCON_GLOBALRESET, dev->iobase + PCI224_DACCON);
 	outw(0, dev->iobase + PCI224_DACCEN);
 	outw(0, dev->iobase + PCI224_FIFOSIZ);
-	devpriv->daccon = (PCI224_DACCON_TRIG_SW | PCI224_DACCON_POLAR_BI |
-			   PCI224_DACCON_FIFOENAB |
-			   PCI224_DACCON_FIFOINTR_EMPTY);
+	devpriv->daccon = PCI224_DACCON_TRIG_SW | PCI224_DACCON_POLAR_BI |
+			  PCI224_DACCON_FIFOENAB | PCI224_DACCON_FIFOINTR_EMPTY;
 	outw(devpriv->daccon | PCI224_DACCON_FIFORESET,
 	     dev->iobase + PCI224_DACCON);
 
-- 
2.0.0

