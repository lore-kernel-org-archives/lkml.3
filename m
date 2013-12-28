Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233Ab3L1JVA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 04:21:00 -0500
Received: from nm26.bullet.mail.gq1.yahoo.com ([98.136.217.9]:45745 "HELO
	nm26.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752494Ab3L1JU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 04:20:58 -0500
X-Greylist: delayed 415 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Dec 2013 04:20:57 EST
X-Yahoo-Newman-Id: 548279.56808.bm@smtp220.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-5
X-YMail-OSG: yM6lgSsVM1nxqSgFy4saWJ.ECKsd9REO178b1ce1uzgtIB_
 jcyqWYVZbTjx8bQ8wHOL05ZGH8QwQiEiIG4S14Cr2t5AKfJsI.aFEnyp.8gE
 uBzS9V41kmNPBPRm.xb57usThYHYR5YQ7WDJJAdyHx7Y4m8rUlEMVrJS.2P.
 fDYgHdjkBh0xxEVDTpZd.3erdnURypLWn.qzsXYahq6BdO5BFgzdTaJGHoRO
 BFlZTE3ftdn4liJ2Uc2GRUg5IFzwPxhCobuP.ub6PTMrRy4Vu2aCZZ_9gnNf
 s2Haxer3NR9Fp34R7GvKusf60Csi_WV9ebqxkZuqLv9f.29jo5_cyLtoRT5f
 _7LmX8H6C98VJTR6fL3JecJv2AgiCm6ajzeJJyaKNRILZ4IaJI_HiGtivUdA
 PbGyBScIqd9oBGx4WNKjgZkfb1Zuh_I3DSW5._YPdsr.NdKwrZOAzretUyKH
 ToS.NbIUTuic5jlIKz3qgbAeHVfPyZi9oDs7CbPtBFBus7YWe10BXy8H_wFW
 d52hUyjqyubq_2Ss.ZfFnLZSd0Q.Jr9mq9ZmuSrNa1gmmd59md8K3sCkunEF
 C9WYEHYqyHXgfwrLk1R0zibuv9z.GS5LNxvTJcEsTa82244zGwSaZo7CzB.m
 N6c18Q1C322I-
X-Yahoo-SMTP: Ua.BYCGswBCLcNpMqiQEtkMTjL08M6XQy5ZdmA--
X-Rocket-Received: from localhost.localdomain (chase.southwood@50.103.236.80 with plain [63.250.193.228])
        by smtp220.mail.gq1.yahoo.com with SMTP; 28 Dec 2013 09:14:01 +0000 UTC
From: Chase Southwood <chase.southwood@yahoo.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org,
        Chase Southwood <chase.southwood@yahoo.com>
Subject: [PATCH] Staging: comedi: replace printk() calls with dev_dbg() in pcmmio.c
Date: Sat, 28 Dec 2013 03:13:52 -0600
Message-Id: <1388222032-3691-1-git-send-email-chase.southwood@yahoo.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chase Southwood <chase.southwood@yahoo.com>

This is a patch for pcmmio.c that changes several printk() calls to dev_dbg() or dev_err() to fix checkpatch.pl warnings.  Patched from 3.13-rc5.

Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
---
 drivers/staging/comedi/drivers/pcmmio.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcmmio.c b/drivers/staging/comedi/drivers/pcmmio.c
index 14cee3a..8a567c9 100644
--- a/drivers/staging/comedi/drivers/pcmmio.c
+++ b/drivers/staging/comedi/drivers/pcmmio.c
@@ -252,7 +252,8 @@ static int pcmmio_dio_insn_bits(struct comedi_device *dev,
 
 #ifdef DAMMIT_ITS_BROKEN
 	/* DEBUG */
-	printk(KERN_DEBUG "write mask: %08x  data: %08x\n", data[0], data[1]);
+	dev_dbg(dev->class_dev, "write mask: %08x  data: %08x\n",
+			data[0], data[1]);
 #endif
 
 	s->state = 0;
@@ -273,10 +274,11 @@ static int pcmmio_dio_insn_bits(struct comedi_device *dev,
 
 #ifdef DAMMIT_ITS_BROKEN
 		/* DEBUG */
-		printk
-		    (KERN_DEBUG "byte %d wmb %02x db %02x offset %02d io %04x,"
-		     " data_in %02x ", byte_no, (unsigned)write_mask_byte,
-		     (unsigned)data_byte, offset, ioaddr, (unsigned)byte);
+		dev_dbg(dev->class_dev,
+				"byte %d wmb %02x db %02x offset %02d io %04x data_in %02x ",
+				byte_no, (unsigned)write_mask_byte,
+				(unsigned)data_byte, offset, ioaddr,
+				(unsigned)byte);
 #endif
 
 		if (write_mask_byte) {
@@ -293,7 +295,7 @@ static int pcmmio_dio_insn_bits(struct comedi_device *dev,
 		}
 #ifdef DAMMIT_ITS_BROKEN
 		/* DEBUG */
-		printk(KERN_DEBUG "data_out_byte %02x\n", (unsigned)byte);
+		dev_dbg(dev->class_dev, "data_out_byte %02x\n", (unsigned)byte);
 #endif
 		/* save the digital input lines for this byte.. */
 		s->state |= ((unsigned int)byte) << offset;
@@ -304,7 +306,8 @@ static int pcmmio_dio_insn_bits(struct comedi_device *dev,
 
 #ifdef DAMMIT_ITS_BROKEN
 	/* DEBUG */
-	printk(KERN_DEBUG "s->state %08x data_out %08x\n", s->state, data[1]);
+	dev_dbg(dev->class_dev, "s->state %08x data_out %08x\n",
+			s->state, data[1]);
 #endif
 
 	return insn->n;
@@ -505,8 +508,8 @@ static irqreturn_t interrupt_pcmmio(int irq, void *d)
 				 * TODO here: dispatch io lines to subdevs
 				 * with commands..
 				 */
-				printk
-				    (KERN_DEBUG "got edge detect interrupt %d asic %d which_chans: %06x\n",
+				dev_dbg(dev->class_dev,
+					 "got edge detect interrupt %d asic %d which_chans: %06x\n",
 				     irq, asic, triggered);
 				for (i = 2; i < dev->n_subdevices; i++) {
 					s = &dev->subdevices[i];
@@ -1021,7 +1024,7 @@ static int pcmmio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	    kcalloc(n_subdevs, sizeof(struct pcmmio_subdev_private),
 		    GFP_KERNEL);
 	if (!devpriv->sprivs) {
-		printk(KERN_ERR "comedi%d: cannot allocate subdevice private data structures\n",
+		dev_err(dev->class_dev, "comedi%d: cannot allocate subdevice private data structures\n",
 				dev->minor);
 		return -ENOMEM;
 	}
-- 
1.8.4.2

