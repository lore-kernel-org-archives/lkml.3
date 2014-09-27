Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222AbaI0Xug (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 19:50:36 -0400
Received: from nm14-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.164]:53736 "EHLO
	nm14-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750736AbaI0Xue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 19:50:34 -0400
X-Greylist: delayed 411 seconds by postgrey-1.27 at vger.kernel.org; Sat, 27 Sep 2014 19:50:34 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=s2048; d=yahoo.com;
	b=B5crp053L7hs6y8kElPX3QlhBcyjHO0VZqEyW6UGMEVou9X70E9MwEaAwTc3GtH1cG5J5SWVsWJ45eQJyjjiyg8ybEaiYsqUK29diq/fofw7Vim62Dnmqiq10Dy9RIOwB9M2PAwuRyxHra1LzyxhBzignhNN2SSydsfts3V527lMe+vq6/ju6pSWD/xn4w4v6inKvWvbt6g8+9a8heNm8p0B/RKB0sJ1LZPjEoGzcORdNYkcVGvXdb8eJ3CG1NV5Kahx6dARtPjuQXqS3A9XA+RccOcc2CnZYlSbumhu16QKOCe1ZahfAnLO6L1jim/bHsBKPq7xR0LpZct2if2VOA==;
X-Yahoo-Newman-Id: 902773.84630.bm@smtp211.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: g77RRh4VM1mdyo3IrYyA97uOT.FSXoY7s1sDPz_R2qF2JYV
 0gl3mh4Ux.qPriX.tnto8K.l7reFL4nWri5WfuFnvd9zMoZk0QdXPSi5rbA4
 Ia7rXNCY9HDOcgRU7EBVaDlbrGqr42sxgQAM42V.op9a7yx2zM8SS6eQf20d
 YGKs4k8i2xW7Ph4g38PM8mX5I7L4NXyDwHKa2B_GgmXp60MC.9xLAwLqQrA6
 ncdd1qDOmwS6CvWMuNSDUa8XNLsl3o8ddIqpt4xj0Kx8mtna64IVdLrsWd_D
 RrPoFNZeLFfYBqy3fdvqzTycGhAXs0MclBcIKSV.hgbxAv2.CdxGoP5Ks9e8
 R2HG3zC5K85jo4FJaav6h9sHYiS1VNnIXbTvOp62hsdabpHEOERby8ksUhrr
 4MSbPEoV4dGCKCUmeejFcNlDLqN8XYLM1aEDcb_GnlEdjlfBwYJCenaEkPr0
 Kltl7egmShVrYjrBoUJqrPK5HWNQSBx0iKSNtp8YSCt4HKPj35nvgUJTkbvB
 vhEc9TYrFe4Q2EFCkZpHE1JyGwc.yM8KX
X-Yahoo-SMTP: 1rv77aOswBAZXHe.sKY40dUsriU-
From: Kieran Kunhya <kieran@kunhya.com>
To: Kieran Kunhya <kieran@kunhya.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Antti Palosaari <crope@iki.fi>, Jingoo Han <jg1.han@samsung.com>,
        Jens Axboe <axboe@kernel.dk>,
        Ramprasad Chinthekindi <rchinthekindi@stec-inc.com>,
        Pekka Enberg <penberg@kernel.org>, Minchan Kim <minchan@kernel.org>,
        Fabian Frederick <fabf@skynet.be>,
        Akhil Bhansali <abhansali@stec-inc.com>, Jiri Kosina <jkosina@suse.cz>,
        Alan <gnomes@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCHv3] block: Add support for Sony SxS cards
Date: Sun, 28 Sep 2014 01:43:35 +0200
Message-Id: <1411861415-16210-1-git-send-email-kieran@kunhya.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1405814499-4163-1-git-send-email-kieran@kunhya.com>
References: <1405814499-4163-1-git-send-email-kieran@kunhya.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kieran Kunhya <kieran@kunhya.com>
---
 MAINTAINERS            |    5 +
 drivers/block/Kconfig  |    9 +
 drivers/block/Makefile |    1 +
 drivers/block/sxs.c    |  494 ++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 509 insertions(+)
 create mode 100644 drivers/block/sxs.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 3705430..f3a5231 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8539,6 +8539,11 @@ M:	Maxim Levitsky <maximlevitsky@gmail.com>
 S:	Maintained
 F:	drivers/memstick/core/ms_block.*
 
+SONY SXS CARD SUPPORT
+M:      Kieran Kunhya <kieran@kunhya.com>
+S:      Maintained
+F:      drivers/block/sxs.c
+
 SOUND
 M:	Jaroslav Kysela <perex@perex.cz>
 M:	Takashi Iwai <tiwai@suse.de>
diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index 014a1cf..0b41ee0 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -356,6 +356,15 @@ config BLK_DEV_SX8
 
 	  Use devices /dev/sx8/$N and /dev/sx8/$Np$M.
 
+config BLK_DEV_SXS
+       tristate "Sony SxS card support"
+       depends on PCI
+       ---help---
+         Saying Y or M here will enable support for reading
+         from Sony SxS cards.
+
+         It creates a device called /dev/sxs
+
 config BLK_DEV_RAM
 	tristate "RAM block device support"
 	---help---
diff --git a/drivers/block/Makefile b/drivers/block/Makefile
index 02b688d..59b9c79 100644
--- a/drivers/block/Makefile
+++ b/drivers/block/Makefile
@@ -33,6 +33,7 @@ obj-$(CONFIG_VIRTIO_BLK)	+= virtio_blk.o
 
 obj-$(CONFIG_BLK_DEV_SX8)	+= sx8.o
 obj-$(CONFIG_BLK_DEV_HD)	+= hd.o
+obj-$(CONFIG_BLK_DEV_SXS)	+= sxs.o
 
 obj-$(CONFIG_XEN_BLKDEV_FRONTEND)	+= xen-blkfront.o
 obj-$(CONFIG_XEN_BLKDEV_BACKEND)	+= xen-blkback/
diff --git a/drivers/block/sxs.c b/drivers/block/sxs.c
new file mode 100644
index 0000000..a2da71d
--- /dev/null
+++ b/drivers/block/sxs.c
@@ -0,0 +1,494 @@
+/*
+ *  sxs.c: Driver for Sony SxS cards
+ *
+ *  Copyright 2014 Kieran Kunhya
+ *
+ *  Author/maintainer:  Kieran Kunhya <kieran@kunhya.com>
+ *
+ *  This file is subject to the terms and conditions of the GNU General Public
+ *  License.  See the file "COPYING" in the main directory of this archive
+ *  for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/interrupt.h>
+#include <linux/pci.h>
+#include <linux/device.h>
+#include <linux/init.h>
+#include <linux/delay.h>
+#include <linux/blkdev.h>
+#include <linux/genhd.h>
+#include <linux/hdreg.h>
+#include <linux/bio.h>
+
+#include <linux/completion.h>
+#include <linux/dma-mapping.h>
+#include <linux/log2.h>
+
+#include <asm/byteorder.h>
+
+#define DRV_NAME "sxs"
+
+#define PCI_DEVICE_ID_SXS_81CE 0x81ce
+#define PCI_DEVICE_ID_SXS_905C 0x905c
+
+#define SXS_MASTER_LINK_REG_L 0x10
+#define SXS_MASTER_LINK_REG_H 0x14
+#define SXS_MASTER_ADDR_REG_L 0x18
+#define SXS_MASTER_ADDR_REG_H 0x1c
+#define SXS_MASTER_SIZE_REG   0x20
+#define SXS_ENABLE_REG  0x28
+#define SXS_CONTROL_REG 0x2c
+#define SXS_STATUS_REG  0x6c
+#define SXS_RESPONSE_BUF 0x40
+
+#define KERNEL_SECTOR_SIZE 512
+
+static struct pci_device_id ids[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_SONY, PCI_DEVICE_ID_SXS_81CE), },
+	{ PCI_DEVICE(PCI_VENDOR_ID_SONY, PCI_DEVICE_ID_SXS_905C), },
+	{ 0, }
+};
+MODULE_DEVICE_TABLE(pci, ids);
+
+struct sxs_device {
+	struct pci_dev *pci_dev;
+	spinlock_t lock;
+	void __iomem *mmio;
+
+	int    sxs_major;
+	struct gendisk *disk;
+	int    sector_size;
+	int    num_sectors;
+	int    sector_shift;
+	struct request_queue *queue;
+
+	struct completion irq_response;
+};
+
+static int sxs_getgeo(struct block_device *bdev, struct hd_geometry *geo)
+{
+	struct sxs_device *dev = bdev->bd_disk->private_data;
+	long size;
+
+	/* Make something up here */
+	size = dev->num_sectors*(dev->sector_size/KERNEL_SECTOR_SIZE);
+	geo->cylinders = (size & ~0x3f) >> 6;
+	geo->heads = 4;
+	geo->sectors = 16;
+
+	return 0;
+}
+
+static const struct block_device_operations sxs_opts = {
+	.owner          = THIS_MODULE,
+	.getgeo         = sxs_getgeo
+};
+
+static void sxs_memcpy_read(struct sxs_device *dev, unsigned long sector,
+			    unsigned long nsect, char *buffer)
+{
+	struct pci_dev *pdev = dev->pci_dev;
+	u32 status;
+	u32 data[4];
+	u16 *tmp;
+	u32 *tmp2;
+
+	void *dma2;
+	dma_addr_t dma2_handle;
+	void *dma3;
+	dma_addr_t dma3_handle;
+
+	sector >>= dev->sector_shift;
+	nsect >>= dev->sector_shift;
+
+	/* Read */
+	dma2 = pci_alloc_consistent(pdev, 8192, &dma2_handle);
+	dma3 = pci_alloc_consistent(pdev, 8192, &dma3_handle);
+
+	tmp = dma2;
+	tmp2 = dma3;
+	tmp2[0] = dma2_handle;
+	tmp2[2] = dma3_handle;
+
+	dev_dbg_ratelimited(&pdev->dev, "CALL %lu %lu\n",
+			    sector & 0xffffffff, nsect & 0xffffffff);
+
+	reinit_completion(&dev->irq_response);
+	status = readl(dev->mmio+SXS_STATUS_REG);
+	data[0] = cpu_to_le32(0x00010028);
+	data[1] = cpu_to_le32(sector & 0xffffffff);
+	data[2] = 0x0;
+	data[3] = cpu_to_le32(nsect & 0xffffffff);
+	memcpy_toio(dev->mmio, data, sizeof(data));
+	writel(0xa0, dev->mmio+SXS_ENABLE_REG);
+	writel(0x80, dev->mmio+SXS_CONTROL_REG);
+
+	if (!wait_for_completion_timeout(&dev->irq_response,
+					 msecs_to_jiffies(5000))) {
+		dev_dbg(&pdev->dev, "No IRQ\n");
+	}
+
+	reinit_completion(&dev->irq_response);
+	writel(dma3_handle, dev->mmio+SXS_MASTER_LINK_REG_L);
+	writel(0x0, dev->mmio+SXS_MASTER_LINK_REG_H);
+	writel(0x20, dev->mmio+SXS_CONTROL_REG);
+
+	if (!wait_for_completion_timeout(&dev->irq_response,
+					 msecs_to_jiffies(5000))) {
+		dev_dbg(&pdev->dev, "No IRQ\n");
+	}
+
+	/* FIXME: Use DMA properly */
+	memcpy(buffer, dma2, dev->sector_size * nsect);
+
+	dev_dbg_ratelimited(&pdev->dev, "boot-signature %x\n",
+			    tmp[255]);
+
+	writel(0, dev->mmio+SXS_ENABLE_REG);
+
+	pci_free_consistent(pdev, 8192, dma3, dma3_handle);
+	pci_free_consistent(pdev, 8192, dma2, dma2_handle);
+}
+
+static void sxs_request(struct request_queue *q, struct bio *bio)
+{
+	struct bvec_iter iter;
+	struct bio_vec bvec;
+	char *buffer;
+	unsigned long flags;
+	struct sxs_device *dev = q->queuedata;
+	struct pci_dev *pdev = dev->pci_dev;
+	sector_t sector = bio->bi_iter.bi_sector;
+
+	bio_for_each_segment(bvec, bio, iter) {
+		dev_dbg_ratelimited(&pdev->dev, "REQUEST %i %i %i\n",
+				    bio_cur_bytes(bio), bio->bi_vcnt,
+				    bvec.bv_len);
+		buffer = bvec_kmap_irq(&bvec, &flags);
+		sxs_memcpy_read(dev, sector, bio_cur_bytes(bio) >> 9,
+				buffer);
+		sector += bio_cur_bytes(bio) >> 9;
+		bvec_kunmap_irq(buffer, &flags);
+	}
+
+	bio_endio(bio, 0);
+}
+
+static int sxs_setup_disk(struct sxs_device *dev)
+{
+	struct pci_dev *pdev = dev->pci_dev;
+	int ret = 0;
+
+	dev->sxs_major = register_blkdev(0, "sxs");
+	if (!dev->sxs_major) {
+		ret = -EBUSY;
+		goto end;
+	}
+
+	dev->queue = blk_alloc_queue(GFP_KERNEL);
+	if (!dev->queue) {
+		ret = -ENOMEM;
+		goto end;
+	}
+
+	blk_queue_make_request(dev->queue, sxs_request);
+	blk_queue_logical_block_size(dev->queue, dev->sector_size);
+	dev->queue->queuedata = dev;
+
+	/* XXX: can SxS have more partitions? */
+	dev->disk = alloc_disk(4);
+	if (!dev->disk) {
+		dev_notice(&pdev->dev, "could not allocate disk\n");
+		goto end;
+	}
+	dev->disk->major = dev->sxs_major;
+	dev->disk->first_minor = 0;
+	dev->disk->fops = &sxs_opts;
+	dev->disk->queue = dev->queue;
+	dev->disk->private_data = dev;
+	snprintf(dev->disk->disk_name, 32, "sxs");
+	set_capacity(dev->disk, dev->num_sectors*
+				(dev->sector_size/KERNEL_SECTOR_SIZE));
+	add_disk(dev->disk);
+
+end:
+	return ret;
+}
+
+static void sxs_read_response_buf(void __iomem *mmio, u32 *output)
+{
+	memcpy_fromio(output, mmio+SXS_RESPONSE_BUF, 4*4);
+}
+
+static int sxs_is_write_protected(struct sxs_device *dev)
+{
+	u32 status;
+
+	status = readl(dev->mmio+SXS_STATUS_REG);
+
+	return (status >> 8) & 1;
+}
+
+/* Setup the card exactly as the Windows driver does,
+ * even the strange parts! */
+static int sxs_boot_check(struct sxs_device *dev)
+{
+	struct pci_dev *pdev = dev->pci_dev;
+	int i, ret = 0;
+	u32 status;
+	u32 output[4];
+
+	status = readl(dev->mmio+SXS_STATUS_REG);
+	dev_dbg(&pdev->dev, "STATUS: %x", status);
+
+	if ((status & 0xa0) != 0xa0) {
+		if ((status & 0xff) != 0x20)
+			writel(1, dev->mmio+SXS_CONTROL_REG);
+
+		for (i = 0; i < 40; i++) {
+			status = readl(dev->mmio+SXS_STATUS_REG);
+			if (status & 0x80)
+				break;
+			msleep(100);
+		}
+		if (i == 40)
+			ret = -EBUSY;
+		else {
+			sxs_read_response_buf(dev->mmio, output);
+			/* Not clear what these values mean */
+			pr_debug("Boot Response %x %x %x %x\n",
+				 output[0], output[1],
+				 output[2], output[3]);
+		}
+	}
+
+	return ret;
+}
+
+static irqreturn_t sxs_irq(int irq, void *data)
+{
+	u32 status;
+	irqreturn_t ret = IRQ_HANDLED;
+	struct sxs_device *dev = data;
+	struct pci_dev *pdev = dev->pci_dev;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->lock, flags);
+
+	status = readl(dev->mmio+SXS_STATUS_REG);
+
+	if (status != 0x80000000)
+		writel(0x80000000, dev->mmio+SXS_STATUS_REG);
+
+	dev_dbg_ratelimited(&pdev->dev, "IRQ\n");
+
+	spin_unlock_irqrestore(&dev->lock, flags);
+
+	complete(&dev->irq_response);
+
+	return ret;
+}
+
+static void sxs_setup_card(struct sxs_device *dev)
+{
+	struct pci_dev *pdev = dev->pci_dev;
+	u32 status;
+	u32 data[4];
+
+	status = readl(dev->mmio+SXS_STATUS_REG);
+	memset(data, 0, sizeof(data));
+
+	memcpy_toio(dev->mmio, data, sizeof(data));
+	writel(0xa0, dev->mmio+SXS_ENABLE_REG);
+	writel(0x80, dev->mmio+SXS_CONTROL_REG);
+
+	if (!wait_for_completion_timeout(&dev->irq_response,
+					 msecs_to_jiffies(1000))) {
+		dev_dbg(&pdev->dev, "No IRQ\n");
+	}
+
+	writel(0, dev->mmio+SXS_ENABLE_REG);
+}
+
+static int sxs_get_size(struct sxs_device *dev)
+{
+	struct pci_dev *pdev = dev->pci_dev;
+	u32 status;
+	u32 data[4];
+	int ret = 0;
+	u32 *tmp2;
+
+	void *dma;
+	dma_addr_t dma_handle;
+
+	dma = pci_alloc_consistent(pdev, 8192, &dma_handle);
+
+	reinit_completion(&dev->irq_response);
+	status = readl(dev->mmio+SXS_STATUS_REG);
+	data[0] = cpu_to_le32(0x8);
+	data[1] = 0x0;
+	data[2] = 0x0;
+	data[3] = cpu_to_le32(0x1);
+	memcpy_toio(dev->mmio, data, sizeof(data));
+	writel(0xa0, dev->mmio+SXS_ENABLE_REG);
+	writel(0x80, dev->mmio+SXS_CONTROL_REG);
+
+	if (!wait_for_completion_timeout(&dev->irq_response,
+					 msecs_to_jiffies(1000))) {
+		dev_dbg(&pdev->dev, "No IRQ\n");
+		return -EIO;
+	}
+
+	reinit_completion(&dev->irq_response);
+	writel(dma_handle, dev->mmio+SXS_MASTER_ADDR_REG_L);
+	writel(0x0, dev->mmio+SXS_MASTER_ADDR_REG_H);
+	writel(0x800, dev->mmio+SXS_MASTER_SIZE_REG);
+	writel(0x20, dev->mmio+SXS_CONTROL_REG);
+
+	if (!wait_for_completion_timeout(&dev->irq_response,
+					 msecs_to_jiffies(1000))) {
+		dev_dbg(&pdev->dev, "No IRQ\n");
+		ret = -EIO;
+		goto error1;
+	}
+
+	tmp2 = dma;
+
+	writel(0, dev->mmio+SXS_ENABLE_REG);
+
+	/* XXX: this might be different for larger disks */
+	dev->sector_size = le32_to_cpu(tmp2[8]) & 0xffff;
+	dev->num_sectors = le32_to_cpu(tmp2[9]) * le32_to_cpu(tmp2[10]);
+	dev->sector_shift = ilog2(dev->sector_size /
+				  KERNEL_SECTOR_SIZE);
+	pr_debug("Sector size: %x Num sectors: %x\n",
+		 dev->sector_size, dev->num_sectors);
+
+error1:
+	pci_free_consistent(pdev, 8192, dma, dma_handle);
+
+	return ret;
+}
+
+static int sxs_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	int error = 0;
+	struct sxs_device *dev;
+
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (!dev)
+		goto error1;
+	spin_lock_init(&dev->lock);
+	dev->pci_dev = pdev;
+
+	error = pci_enable_device(pdev);
+	if (error < 0)
+		goto error2;
+
+	pci_enable_msi(pdev);
+
+	error = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+	if (error)
+		goto error3;
+
+	error = pci_request_regions(pdev, DRV_NAME);
+	if (error)
+		goto error3;
+
+	dev->mmio = pci_ioremap_bar(pdev, 0);
+	if (!dev->mmio)
+		goto error4;
+
+	pci_set_master(pdev);
+
+	if (request_irq(pdev->irq, &sxs_irq, IRQF_SHARED, DRV_NAME, dev))
+		goto error5;
+
+	if (sxs_boot_check(dev) < 0)
+		goto error6;
+
+	init_completion(&dev->irq_response);
+
+	sxs_setup_card(dev);
+
+	if (sxs_get_size(dev) < 0)
+		goto error6;
+
+	if (sxs_setup_disk(dev) < 0)
+		goto error7;
+
+	pci_set_drvdata(pdev, dev);
+
+	dev_dbg(&pdev->dev, "sxs driver successfully loaded\n");
+	return 0;
+
+error7:
+	if (dev->sxs_major)
+		unregister_blkdev(dev->sxs_major, "sxs");
+
+	if (dev->disk) {
+		del_gendisk(dev->disk);
+		put_disk(dev->disk);
+	}
+
+	if (dev->queue)
+		blk_cleanup_queue(dev->queue);
+error6:
+	free_irq(pdev->irq, dev);
+error5:
+	iounmap(dev->mmio);
+error4:
+	pci_release_regions(pdev);
+error3:
+	pci_disable_device(pdev);
+error2:
+	kfree(dev);
+error1:
+	return error;
+}
+
+static void sxs_remove(struct pci_dev *pdev)
+{
+	struct sxs_device *dev = pci_get_drvdata(pdev);
+
+	if (dev->sxs_major)
+		unregister_blkdev(dev->sxs_major, "sxs");
+
+	if (dev->disk) {
+		del_gendisk(dev->disk);
+		put_disk(dev->disk);
+	}
+	if (dev->queue)
+		blk_cleanup_queue(dev->queue);
+	free_irq(pdev->irq, dev);
+	iounmap(dev->mmio);
+	pci_release_regions(pdev);
+	pci_disable_msi(pdev);
+	pci_disable_device(pdev);
+	kfree(dev);
+}
+
+static struct pci_driver sxs_driver = {
+	.name = DRV_NAME,
+	.id_table = ids,
+	.probe = sxs_probe,
+	.remove = sxs_remove,
+};
+
+static int __init sxs_init(void)
+{
+	return pci_register_driver(&sxs_driver);
+}
+
+static void __exit sxs_exit(void)
+{
+	pci_unregister_driver(&sxs_driver);
+}
+
+MODULE_AUTHOR("Kieran Kunhya");
+MODULE_LICENSE("GPL");
+
+module_init(sxs_init);
+module_exit(sxs_exit);
-- 
1.7.9.5

