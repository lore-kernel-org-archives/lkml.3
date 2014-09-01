Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499AbaIALEf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 07:04:35 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:38999 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753461AbaIALEb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 07:04:31 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 23/28] staging: comedi: amplc_pci230: reduce indentation in pci230_ao_inttrig_scan_begin()
Date: Mon,  1 Sep 2014 12:03:55 +0100
Message-Id: <1409569440-10979-24-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1409569440-10979-1-git-send-email-abbotti@mev.co.uk>
References: <1409569440-10979-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pci230.c | 35 ++++++++++++---------------
 1 file changed, 16 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index 727de3d..a44b056 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -1226,28 +1226,25 @@ static int pci230_ao_inttrig_scan_begin(struct comedi_device *dev,
 		return -EINVAL;
 
 	spin_lock_irqsave(&devpriv->ao_stop_spinlock, irqflags);
-	if (devpriv->ao_cmd_started) {
-		/* Perform scan. */
-		if (devpriv->hwver < 2) {
-			/* Not using DAC FIFO. */
-			spin_unlock_irqrestore(&devpriv->ao_stop_spinlock,
-					       irqflags);
-			pci230_handle_ao_nofifo(dev, s);
-			comedi_event(dev, s);
-		} else {
-			/* Using DAC FIFO. */
-			/* Read DACSWTRIG register to trigger conversion. */
-			inw(devpriv->daqio + PCI230P2_DACSWTRIG);
-			spin_unlock_irqrestore(&devpriv->ao_stop_spinlock,
-					       irqflags);
-		}
-		/* Delay.  Should driver be responsible for this? */
-		/* XXX TODO: See if DAC busy bit can be used. */
-		udelay(8);
+	if (!devpriv->ao_cmd_started) {
+		spin_unlock_irqrestore(&devpriv->ao_stop_spinlock, irqflags);
+		return 1;
+	}
+	/* Perform scan. */
+	if (devpriv->hwver < 2) {
+		/* Not using DAC FIFO. */
+		spin_unlock_irqrestore(&devpriv->ao_stop_spinlock, irqflags);
+		pci230_handle_ao_nofifo(dev, s);
+		comedi_event(dev, s);
 	} else {
+		/* Using DAC FIFO. */
+		/* Read DACSWTRIG register to trigger conversion. */
+		inw(devpriv->daqio + PCI230P2_DACSWTRIG);
 		spin_unlock_irqrestore(&devpriv->ao_stop_spinlock, irqflags);
 	}
-
+	/* Delay.  Should driver be responsible for this? */
+	/* XXX TODO: See if DAC busy bit can be used. */
+	udelay(8);
 	return 1;
 }
 
-- 
2.0.4

