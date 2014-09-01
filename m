Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774AbaIALH4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 07:07:56 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:38999 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753403AbaIALE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 07:04:26 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 18/28] staging: comedi: amplc_pci230: add `pci230_` prefix to functions
Date: Mon,  1 Sep 2014 12:03:50 +0100
Message-Id: <1409569440-10979-19-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1409569440-10979-1-git-send-email-abbotti@mev.co.uk>
References: <1409569440-10979-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most functions in "amplc_pci230" are named with the prefix `pci230_`,
apart from one or two that have the prefix `amplc_pci230_` and a few
odd-balls with no particular prefix.  Rename the ones without a prefix
for consistency.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pci230.c | 41 ++++++++++++++-------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index 72da4b6..6cd235d 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -613,8 +613,8 @@ static void pci230_ao_write_fifo(struct comedi_device *dev,
 	     devpriv->daqio + PCI230P2_DACDATA);
 }
 
-static int get_resources(struct comedi_device *dev, unsigned int res_mask,
-			 unsigned char owner)
+static int pci230_get_resources(struct comedi_device *dev,
+				unsigned int res_mask, unsigned char owner)
 {
 	struct pci230_private *devpriv = dev->private;
 	int ok;
@@ -649,14 +649,14 @@ static int get_resources(struct comedi_device *dev, unsigned int res_mask,
 	return ok;
 }
 
-static int get_one_resource(struct comedi_device *dev,
-			    unsigned int resource, unsigned char owner)
+static int pci230_get_one_resource(struct comedi_device *dev,
+				   unsigned int resource, unsigned char owner)
 {
-	return get_resources(dev, 1U << resource, owner);
+	return pci230_get_resources(dev, 1U << resource, owner);
 }
 
-static void put_resources(struct comedi_device *dev, unsigned int res_mask,
-			  unsigned char owner)
+static void pci230_put_resources(struct comedi_device *dev,
+				 unsigned int res_mask, unsigned char owner)
 {
 	struct pci230_private *devpriv = dev->private;
 	unsigned int i;
@@ -674,19 +674,20 @@ static void put_resources(struct comedi_device *dev, unsigned int res_mask,
 	spin_unlock_irqrestore(&devpriv->res_spinlock, irqflags);
 }
 
-static void put_one_resource(struct comedi_device *dev,
-			     unsigned int resource, unsigned char owner)
+static void pci230_put_one_resource(struct comedi_device *dev,
+				    unsigned int resource, unsigned char owner)
 {
-	put_resources(dev, 1U << resource, owner);
+	pci230_put_resources(dev, 1U << resource, owner);
 }
 
-static void put_all_resources(struct comedi_device *dev, unsigned char owner)
+static void pci230_put_all_resources(struct comedi_device *dev,
+				     unsigned char owner)
 {
-	put_resources(dev, (1U << NUM_RESOURCES) - 1, owner);
+	pci230_put_resources(dev, (1U << NUM_RESOURCES) - 1, owner);
 }
 
-static unsigned int divide_ns(uint64_t ns, unsigned int timebase,
-			      unsigned int flags)
+static unsigned int pci230_divide_ns(uint64_t ns, unsigned int timebase,
+				     unsigned int flags)
 {
 	uint64_t div;
 	unsigned int rem;
@@ -717,7 +718,7 @@ static unsigned int pci230_choose_clk_count(uint64_t ns, unsigned int *count,
 	unsigned int clk_src, cnt;
 
 	for (clk_src = CLK_10MHZ;; clk_src++) {
-		cnt = divide_ns(ns, pci230_timebase[clk_src], flags);
+		cnt = pci230_divide_ns(ns, pci230_timebase[clk_src], flags);
 		if (cnt <= 65536 || clk_src == CLK_1KHZ)
 			break;
 	}
@@ -1112,7 +1113,7 @@ static void pci230_ao_stop(struct comedi_device *dev,
 		     devpriv->daqio + PCI230_DACCON);
 	}
 	/* Release resources. */
-	put_all_resources(dev, OWNER_AOCMD);
+	pci230_put_all_resources(dev, OWNER_AOCMD);
 }
 
 static void pci230_handle_ao_nofifo(struct comedi_device *dev,
@@ -1408,7 +1409,7 @@ static int pci230_ao_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 
 	if (cmd->scan_begin_src == TRIG_TIMER) {
 		/* Claim Z2-CT1. */
-		if (!get_one_resource(dev, RES_Z2CT1, OWNER_AOCMD))
+		if (!pci230_get_one_resource(dev, RES_Z2CT1, OWNER_AOCMD))
 			return -EBUSY;
 	}
 
@@ -1963,7 +1964,7 @@ static void pci230_ai_stop(struct comedi_device *dev,
 	outw(devpriv->adccon | PCI230_ADC_FIFO_RESET,
 	     devpriv->daqio + PCI230_ADCCON);
 	/* Release resources. */
-	put_all_resources(dev, OWNER_AICMD);
+	pci230_put_all_resources(dev, OWNER_AICMD);
 }
 
 static void pci230_ai_start(struct comedi_device *dev,
@@ -2112,7 +2113,7 @@ static void pci230_ai_start(struct comedi_device *dev,
 			}
 		} else if (cmd->convert_src != TRIG_INT) {
 			/* No longer need Z2-CT2. */
-			put_one_resource(dev, RES_Z2CT2, OWNER_AICMD);
+			pci230_put_one_resource(dev, RES_Z2CT2, OWNER_AICMD);
 		}
 	}
 }
@@ -2253,7 +2254,7 @@ static int pci230_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		}
 	}
 	/* Claim resources. */
-	if (!get_resources(dev, res_mask, OWNER_AICMD))
+	if (!pci230_get_resources(dev, res_mask, OWNER_AICMD))
 		return -EBUSY;
 
 	/* Get number of scans required. */
-- 
2.0.4

