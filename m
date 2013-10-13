Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab3JMFtp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 01:49:45 -0400
Received: from top.free-electrons.com ([176.31.233.9]:56174 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751283Ab3JMFto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 01:49:44 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] [media] misc drivers: remove deprecated IRQF_DISABLED
Date: Sun, 13 Oct 2013 07:49:29 +0200
Message-Id: <1381643369-8611-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the use of the IRQF_DISABLED flag

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/media/pci/bt8xx/bt878.c          | 3 +--
 drivers/media/pci/bt8xx/bttv-driver.c    | 2 +-
 drivers/media/pci/cx23885/cx23885-core.c | 2 +-
 drivers/media/pci/cx88/cx88-alsa.c       | 2 +-
 drivers/media/pci/cx88/cx88-mpeg.c       | 2 +-
 drivers/media/pci/cx88/cx88-video.c      | 2 +-
 drivers/media/pci/meye/meye.c            | 2 +-
 drivers/media/pci/saa7134/saa7134-alsa.c | 2 +-
 drivers/media/pci/saa7134/saa7134-core.c | 2 +-
 drivers/media/pci/saa7164/saa7164-core.c | 2 +-
 10 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/media/pci/bt8xx/bt878.c b/drivers/media/pci/bt8xx/bt878.c
index 66eb0ba..c2c8752 100644
--- a/drivers/media/pci/bt8xx/bt878.c
+++ b/drivers/media/pci/bt8xx/bt878.c
@@ -488,8 +488,7 @@ static int bt878_probe(struct pci_dev *dev, const struct pci_device_id *pci_id)
 	btwrite(0, BT848_INT_MASK);
 
 	result = request_irq(bt->irq, bt878_irq,
-			     IRQF_SHARED | IRQF_DISABLED, "bt878",
-			     (void *) bt);
+			     IRQF_SHARED, "bt878", (void *) bt);
 	if (result == -EINVAL) {
 		printk(KERN_ERR "bt878(%d): Bad irq number or handler\n",
 		       bt878_num);
diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index c6532de..a3b1ee9 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -4086,7 +4086,7 @@ static int bttv_probe(struct pci_dev *dev, const struct pci_device_id *pci_id)
 	/* disable irqs, register irq handler */
 	btwrite(0, BT848_INT_MASK);
 	result = request_irq(btv->c.pci->irq, bttv_irq,
-	    IRQF_SHARED | IRQF_DISABLED, btv->c.v4l2_dev.name, (void *)btv);
+	    IRQF_SHARED, btv->c.v4l2_dev.name, (void *)btv);
 	if (result < 0) {
 		pr_err("%d: can't get IRQ %d\n",
 		       bttv_num, btv->c.pci->irq);
diff --git a/drivers/media/pci/cx23885/cx23885-core.c b/drivers/media/pci/cx23885/cx23885-core.c
index 9f63d93..edcd79d 100644
--- a/drivers/media/pci/cx23885/cx23885-core.c
+++ b/drivers/media/pci/cx23885/cx23885-core.c
@@ -2129,7 +2129,7 @@ static int cx23885_initdev(struct pci_dev *pci_dev,
 	}
 
 	err = request_irq(pci_dev->irq, cx23885_irq,
-			  IRQF_SHARED | IRQF_DISABLED, dev->name, dev);
+			  IRQF_SHARED, dev->name, dev);
 	if (err < 0) {
 		printk(KERN_ERR "%s: can't get IRQ %d\n",
 		       dev->name, pci_dev->irq);
diff --git a/drivers/media/pci/cx88/cx88-alsa.c b/drivers/media/pci/cx88/cx88-alsa.c
index aba5b1c..b2e519a 100644
--- a/drivers/media/pci/cx88/cx88-alsa.c
+++ b/drivers/media/pci/cx88/cx88-alsa.c
@@ -834,7 +834,7 @@ static int snd_cx88_create(struct snd_card *card, struct pci_dev *pci,
 
 	/* get irq */
 	err = request_irq(chip->pci->irq, cx8801_irq,
-			  IRQF_SHARED | IRQF_DISABLED, chip->core->name, chip);
+			  IRQF_SHARED, chip->core->name, chip);
 	if (err < 0) {
 		dprintk(0, "%s: can't get IRQ %d\n",
 		       chip->core->name, chip->pci->irq);
diff --git a/drivers/media/pci/cx88/cx88-mpeg.c b/drivers/media/pci/cx88/cx88-mpeg.c
index 2d3507e..11da03e 100644
--- a/drivers/media/pci/cx88/cx88-mpeg.c
+++ b/drivers/media/pci/cx88/cx88-mpeg.c
@@ -499,7 +499,7 @@ static int cx8802_init_common(struct cx8802_dev *dev)
 
 	/* get irq */
 	err = request_irq(dev->pci->irq, cx8802_irq,
-			  IRQF_SHARED | IRQF_DISABLED, dev->core->name, dev);
+			  IRQF_SHARED, dev->core->name, dev);
 	if (err < 0) {
 		printk(KERN_ERR "%s: can't get IRQ %d\n",
 		       dev->core->name, dev->pci->irq);
diff --git a/drivers/media/pci/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
index ecf21d9..2769485 100644
--- a/drivers/media/pci/cx88/cx88-video.c
+++ b/drivers/media/pci/cx88/cx88-video.c
@@ -1738,7 +1738,7 @@ static int cx8800_initdev(struct pci_dev *pci_dev,
 
 	/* get irq */
 	err = request_irq(pci_dev->irq, cx8800_irq,
-			  IRQF_SHARED | IRQF_DISABLED, core->name, dev);
+			  IRQF_SHARED, core->name, dev);
 	if (err < 0) {
 		printk(KERN_ERR "%s/0: can't get IRQ %d\n",
 		       core->name,pci_dev->irq);
diff --git a/drivers/media/pci/meye/meye.c b/drivers/media/pci/meye/meye.c
index 2381b05..54d5c82 100644
--- a/drivers/media/pci/meye/meye.c
+++ b/drivers/media/pci/meye/meye.c
@@ -1698,7 +1698,7 @@ static int meye_probe(struct pci_dev *pcidev, const struct pci_device_id *ent)
 
 	meye.mchip_irq = pcidev->irq;
 	if (request_irq(meye.mchip_irq, meye_irq,
-			IRQF_DISABLED | IRQF_SHARED, "meye", meye_irq)) {
+			IRQF_SHARED, "meye", meye_irq)) {
 		v4l2_err(v4l2_dev, "request_irq failed\n");
 		goto outreqirq;
 	}
diff --git a/drivers/media/pci/saa7134/saa7134-alsa.c b/drivers/media/pci/saa7134/saa7134-alsa.c
index dbcdfbf..dd67c8a 100644
--- a/drivers/media/pci/saa7134/saa7134-alsa.c
+++ b/drivers/media/pci/saa7134/saa7134-alsa.c
@@ -1096,7 +1096,7 @@ static int alsa_card_saa7134_create(struct saa7134_dev *dev, int devnum)
 
 
 	err = request_irq(dev->pci->irq, saa7134_alsa_irq,
-				IRQF_SHARED | IRQF_DISABLED, dev->name,
+				IRQF_SHARED, dev->name,
 				(void*) &dev->dmasound);
 
 	if (err < 0) {
diff --git a/drivers/media/pci/saa7134/saa7134-core.c b/drivers/media/pci/saa7134/saa7134-core.c
index 45f0aca..27d7ee7 100644
--- a/drivers/media/pci/saa7134/saa7134-core.c
+++ b/drivers/media/pci/saa7134/saa7134-core.c
@@ -992,7 +992,7 @@ static int saa7134_initdev(struct pci_dev *pci_dev,
 
 	/* get irq */
 	err = request_irq(pci_dev->irq, saa7134_irq,
-			  IRQF_SHARED | IRQF_DISABLED, dev->name, dev);
+			  IRQF_SHARED, dev->name, dev);
 	if (err < 0) {
 		printk(KERN_ERR "%s: can't get IRQ %d\n",
 		       dev->name,pci_dev->irq);
diff --git a/drivers/media/pci/saa7164/saa7164-core.c b/drivers/media/pci/saa7164/saa7164-core.c
index d37ee37..6759c2b 100644
--- a/drivers/media/pci/saa7164/saa7164-core.c
+++ b/drivers/media/pci/saa7164/saa7164-core.c
@@ -1232,7 +1232,7 @@ static int saa7164_initdev(struct pci_dev *pci_dev,
 	}
 
 	err = request_irq(pci_dev->irq, saa7164_irq,
-		IRQF_SHARED | IRQF_DISABLED, dev->name, dev);
+		IRQF_SHARED, dev->name, dev);
 	if (err < 0) {
 		printk(KERN_ERR "%s: can't get IRQ %d\n", dev->name,
 			pci_dev->irq);
-- 
1.8.1.2

