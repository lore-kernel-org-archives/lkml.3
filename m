Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750808AbaABBzO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 20:55:14 -0500
Received: from nm20-vm8.bullet.mail.gq1.yahoo.com ([98.136.217.39]:26584 "HELO
	nm20-vm8.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750732AbaABBzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 20:55:12 -0500
X-Yahoo-Newman-Id: 55570.49980.bm@smtp204.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-5
X-YMail-OSG: I9le6ukVM1kc5ud4M1K6OXikihgtkK61_qMvUsDf0ABIB3y
 iYSx03xLlXQF8wNLR7nf3ABMykRx8SOqFzKyJbZUzpBe0Hqm6Rt3mgM2ZtrB
 BIFgSA4gMOe8hNxq_P.MyS2OKE9j5np0A8yGPqaEA5mX_fQ2NrtcDEMwS1CX
 sht8BN2RSUYoynT2VOle1xKF2B_OusP7l_ArAgiEo9QL1bO2zht.3rcp6sX0
 AyY0xPW_1lXjew8tvzGMP4GkFapGNBfhwfENOeLtCkUlIGGM8iw0CP..QXcX
 7StWT816ffqLRUr7_I7vT5CHC3mKfUATTgUDwSLI5KzskvasAqYrNIRc4sB7
 HboJ26MgHGRZwrS88XlnrjqEX2EmT8uz3kyBkrb9dv7eVhxKnFE81esQp7hF
 VTizKFlEHQbrZ6GjkGzg8Gi0uFxrBmyzgk.PP5xkvCLWrAmORmDOcjNyZ1sA
 0A1wtk_.XDPkCGYoCvGamWLbIs4vlTOBH.TaiWpMNrHlGTOIgQimygugsYZY
 hp53B0cJWFU.YiIqfqcsOvUM.RJYWBJ2y5F0BhTClQXUlVZDvDqcUVq5Q8e8
 X1l7XzgRjzw1oG4Oo10j9LsAI..XfuJQ03T.VH28Cxvb28uU3HdwGVnkRjWI
 HCdBo
X-Yahoo-SMTP: Ua.BYCGswBCLcNpMqiQEtkMTjL08M6XQy5ZdmA--
X-Rocket-Received: from localhost.localdomain (chase.southwood@50.103.236.80 with plain [98.139.211.125])
        by smtp204.mail.gq1.yahoo.com with SMTP; 01 Jan 2014 17:55:12 -0800 PST
From: Chase Southwood <chase.southwood@yahoo.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org,
        Chase Southwood <chase.southwood@yahoo.com>
Subject: [PATCH][Resend] Staging: comedi: replace printk() calls with dev_dbg() in pcmmio.c
Date: Wed,  1 Jan 2014 19:55:02 -0600
Message-Id: <1388627702-7471-1-git-send-email-chase.southwood@yahoo.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chase Southwood <chase.southwood@yahoo.com>

This is a patch for pcmmio.c that changes several printk() calls to dev_dbg() or dev_err() to fix checkpatch.pl warnings.  Patched from 3.13-rc6.

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

