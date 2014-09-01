Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546AbaIALEj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 07:04:39 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:39018 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753478AbaIALEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 07:04:32 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 25/28] staging: comedi: amplc_pci230: reduce indentation in pci230_ai_inttrig_convert()
Date: Mon,  1 Sep 2014 12:03:57 +0100
Message-Id: <1409569440-10979-26-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1409569440-10979-1-git-send-email-abbotti@mev.co.uk>
References: <1409569440-10979-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pci230.c | 54 +++++++++++++--------------
 1 file changed, 25 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index e0b40b3..b0313c8 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -1802,43 +1802,39 @@ static int pci230_ai_inttrig_convert(struct comedi_device *dev,
 {
 	struct pci230_private *devpriv = dev->private;
 	unsigned long irqflags;
+	unsigned int delayus;
 
 	if (trig_num)
 		return -EINVAL;
 
 	spin_lock_irqsave(&devpriv->ai_stop_spinlock, irqflags);
-	if (devpriv->ai_cmd_started) {
-		unsigned int delayus;
-
-		/*
-		 * Trigger conversion by toggling Z2-CT2 output.
-		 * Finish with output high.
-		 */
-		i8254_set_mode(dev->iobase + PCI230_Z2_CT_BASE, 0,
-			       2, I8254_MODE0);
-		i8254_set_mode(dev->iobase + PCI230_Z2_CT_BASE, 0,
-			       2, I8254_MODE1);
-		/*
-		 * Delay.  Should driver be responsible for this?  An
-		 * alternative would be to wait until conversion is complete,
-		 * but we can't tell when it's complete because the ADC busy
-		 * bit has a different meaning when FIFO enabled (and when
-		 * FIFO not enabled, it only works for software triggers).
-		 */
-		if ((devpriv->adccon & PCI230_ADC_IM_MASK) ==
-		    PCI230_ADC_IM_DIF && devpriv->hwver == 0) {
-			/* PCI230/260 in differential mode */
-			delayus = 8;
-		} else {
-			/* single-ended or PCI230+/260+ */
-			delayus = 4;
-		}
+	if (!devpriv->ai_cmd_started) {
 		spin_unlock_irqrestore(&devpriv->ai_stop_spinlock, irqflags);
-		udelay(delayus);
+		return 1;
+	}
+	/*
+	 * Trigger conversion by toggling Z2-CT2 output.
+	 * Finish with output high.
+	 */
+	i8254_set_mode(dev->iobase + PCI230_Z2_CT_BASE, 0, 2, I8254_MODE0);
+	i8254_set_mode(dev->iobase + PCI230_Z2_CT_BASE, 0, 2, I8254_MODE1);
+	/*
+	 * Delay.  Should driver be responsible for this?  An
+	 * alternative would be to wait until conversion is complete,
+	 * but we can't tell when it's complete because the ADC busy
+	 * bit has a different meaning when FIFO enabled (and when
+	 * FIFO not enabled, it only works for software triggers).
+	 */
+	if ((devpriv->adccon & PCI230_ADC_IM_MASK) == PCI230_ADC_IM_DIF &&
+	    devpriv->hwver == 0) {
+		/* PCI230/260 in differential mode */
+		delayus = 8;
 	} else {
-		spin_unlock_irqrestore(&devpriv->ai_stop_spinlock, irqflags);
+		/* single-ended or PCI230+/260+ */
+		delayus = 4;
 	}
-
+	spin_unlock_irqrestore(&devpriv->ai_stop_spinlock, irqflags);
+	udelay(delayus);
 	return 1;
 }
 
-- 
2.0.4

