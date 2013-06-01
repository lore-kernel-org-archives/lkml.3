Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932287Ab3FAAec (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 20:34:32 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:37485 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932107Ab3FAAeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 20:34:21 -0400
Date: Fri, 31 May 2013 19:34:14 -0500
From: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 7/8] rsxx: Adding in debugfs entries.
Message-ID: <20130601003414.GH3051@oc6784271780.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060100-3620-0000-0000-000002D71C0E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>

Adding debugfs entries to help with debugging and testing and
testing code.

pci_regs:
	This entry will spit out all of the data stored on the BAR.

stats:
	This entry will display all of the driver stats for each
	DMA channel.

Signed-off-by: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
-------------------------------------------------------------------------------



diff -uprN -X linux-block/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/core.c linux-block/drivers/block/rsxx/core.c
--- linux-block-vanilla/drivers/block/rsxx/core.c	2013-05-31 16:33:27.666140484 -0500
+++ linux-block/drivers/block/rsxx/core.c	2013-05-31 17:48:10.519527250 -0500
@@ -31,6 +31,8 @@
 #include <linux/slab.h>
 #include <linux/bitops.h>
 #include <linux/delay.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
 
 #include <linux/genhd.h>
 #include <linux/idr.h>
@@ -52,6 +54,168 @@ MODULE_PARM_DESC(force_legacy, "Force th
 static DEFINE_IDA(rsxx_disk_ida);
 static DEFINE_SPINLOCK(rsxx_ida_lock);
 
+/* --------------------Debugfs Setup ------------------- */
+
+static int rsxx_attr_pci_regs_show(struct seq_file *m, void *p)
+{
+	struct rsxx_cardinfo *card = m->private;
+
+	seq_printf(m, "HWID		0x%08x\n",
+					ioread32(card->regmap + HWID));
+	seq_printf(m, "SCRATCH		0x%08x\n",
+					ioread32(card->regmap + SCRATCH));
+	seq_printf(m, "IER		0x%08x\n",
+					ioread32(card->regmap + IER));
+	seq_printf(m, "IPR		0x%08x\n",
+					ioread32(card->regmap + IPR));
+	seq_printf(m, "CREG_CMD		0x%08x\n",
+					ioread32(card->regmap + CREG_CMD));
+	seq_printf(m, "CREG_ADD		0x%08x\n",
+					ioread32(card->regmap + CREG_ADD));
+	seq_printf(m, "CREG_CNT		0x%08x\n",
+					ioread32(card->regmap + CREG_CNT));
+	seq_printf(m, "CREG_STAT	0x%08x\n",
+					ioread32(card->regmap + CREG_STAT));
+	seq_printf(m, "CREG_DATA0	0x%08x\n",
+					ioread32(card->regmap + CREG_DATA0));
+	seq_printf(m, "CREG_DATA1	0x%08x\n",
+					ioread32(card->regmap + CREG_DATA1));
+	seq_printf(m, "CREG_DATA2	0x%08x\n",
+					ioread32(card->regmap + CREG_DATA2));
+	seq_printf(m, "CREG_DATA3	0x%08x\n",
+					ioread32(card->regmap + CREG_DATA3));
+	seq_printf(m, "CREG_DATA4	0x%08x\n",
+					ioread32(card->regmap + CREG_DATA4));
+	seq_printf(m, "CREG_DATA5	0x%08x\n",
+					ioread32(card->regmap + CREG_DATA5));
+	seq_printf(m, "CREG_DATA6	0x%08x\n",
+					ioread32(card->regmap + CREG_DATA6));
+	seq_printf(m, "CREG_DATA7	0x%08x\n",
+					ioread32(card->regmap + CREG_DATA7));
+	seq_printf(m, "INTR_COAL	0x%08x\n",
+					ioread32(card->regmap + INTR_COAL));
+	seq_printf(m, "HW_ERROR		0x%08x\n",
+					ioread32(card->regmap + HW_ERROR));
+	seq_printf(m, "DEBUG0		0x%08x\n",
+					ioread32(card->regmap + PCI_DEBUG0));
+	seq_printf(m, "DEBUG1		0x%08x\n",
+					ioread32(card->regmap + PCI_DEBUG1));
+	seq_printf(m, "DEBUG2		0x%08x\n",
+					ioread32(card->regmap + PCI_DEBUG2));
+	seq_printf(m, "DEBUG3		0x%08x\n",
+					ioread32(card->regmap + PCI_DEBUG3));
+	seq_printf(m, "DEBUG4		0x%08x\n",
+					ioread32(card->regmap + PCI_DEBUG4));
+	seq_printf(m, "DEBUG5		0x%08x\n",
+					ioread32(card->regmap + PCI_DEBUG5));
+	seq_printf(m, "DEBUG6		0x%08x\n",
+					ioread32(card->regmap + PCI_DEBUG6));
+	seq_printf(m, "DEBUG7		0x%08x\n",
+					ioread32(card->regmap + PCI_DEBUG7));
+	seq_printf(m, "RECONFIG		0x%08x\n",
+					ioread32(card->regmap + PCI_RECONFIG));
+
+	return 0;
+}
+
+static int rsxx_attr_stats_show(struct seq_file *m, void *p)
+{
+	struct rsxx_cardinfo *card = m->private;
+	int i;
+
+	for (i = 0; i < card->n_targets; i++) {
+		seq_printf(m, "Ctrl %d CRC Errors	= %d\n",
+				i, card->ctrl[i].stats.crc_errors);
+		seq_printf(m, "Ctrl %d Hard Errors	= %d\n",
+				i, card->ctrl[i].stats.hard_errors);
+		seq_printf(m, "Ctrl %d Soft Errors	= %d\n",
+				i, card->ctrl[i].stats.soft_errors);
+		seq_printf(m, "Ctrl %d Writes Issued	= %d\n",
+				i, card->ctrl[i].stats.writes_issued);
+		seq_printf(m, "Ctrl %d Writes Failed	= %d\n",
+				i, card->ctrl[i].stats.writes_failed);
+		seq_printf(m, "Ctrl %d Reads Issued	= %d\n",
+				i, card->ctrl[i].stats.reads_issued);
+		seq_printf(m, "Ctrl %d Reads Failed	= %d\n",
+				i, card->ctrl[i].stats.reads_failed);
+		seq_printf(m, "Ctrl %d Reads Retried	= %d\n",
+				i, card->ctrl[i].stats.reads_retried);
+		seq_printf(m, "Ctrl %d Discards Issued	= %d\n",
+				i, card->ctrl[i].stats.discards_issued);
+		seq_printf(m, "Ctrl %d Discards Failed	= %d\n",
+				i, card->ctrl[i].stats.discards_failed);
+		seq_printf(m, "Ctrl %d DMA SW Errors	= %d\n",
+				i, card->ctrl[i].stats.dma_sw_err);
+		seq_printf(m, "Ctrl %d DMA HW Faults	= %d\n",
+				i, card->ctrl[i].stats.dma_hw_fault);
+		seq_printf(m, "Ctrl %d DMAs Cancelled	= %d\n",
+				i, card->ctrl[i].stats.dma_cancelled);
+		seq_printf(m, "Ctrl %d SW Queue Depth	= %d\n",
+				i, card->ctrl[i].stats.sw_q_depth);
+		seq_printf(m, "Ctrl %d HW Queue Depth	= %d\n",
+			i, atomic_read(&card->ctrl[i].stats.hw_q_depth));
+	}
+
+	return 0;
+}
+
+static int rsxx_attr_stats_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, rsxx_attr_stats_show, inode->i_private);
+}
+
+static int rsxx_attr_pci_regs_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, rsxx_attr_pci_regs_show, inode->i_private);
+}
+
+static const struct file_operations debugfs_stats_fops = {
+	.owner		= THIS_MODULE,
+	.open		= rsxx_attr_stats_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static const struct file_operations debugfs_pci_regs_fops = {
+	.owner		= THIS_MODULE,
+	.open		= rsxx_attr_pci_regs_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static void rsxx_debugfs_dev_new(struct rsxx_cardinfo *card)
+{
+	struct dentry *debugfs_stats;
+	struct dentry *debugfs_pci_regs;
+
+	card->debugfs_dir = debugfs_create_dir(card->gendisk->disk_name, NULL);
+	if (IS_ERR_OR_NULL(card->debugfs_dir))
+		goto failed_debugfs_dir;
+
+	debugfs_stats = debugfs_create_file("stats", S_IRUGO,
+					    card->debugfs_dir, card,
+					    &debugfs_stats_fops);
+	if (IS_ERR_OR_NULL(debugfs_stats))
+		goto failed_debugfs_stats;
+
+	debugfs_pci_regs = debugfs_create_file("pci_regs", S_IRUGO,
+					       card->debugfs_dir, card,
+					       &debugfs_pci_regs_fops);
+	if (IS_ERR_OR_NULL(debugfs_pci_regs))
+		goto failed_debugfs_pci_regs;
+
+	return;
+
+failed_debugfs_pci_regs:
+	debugfs_remove(debugfs_stats);
+failed_debugfs_stats:
+	debugfs_remove(card->debugfs_dir);
+failed_debugfs_dir:
+	card->debugfs_dir = NULL;
+}
+
 /*----------------- Interrupt Control & Handling -------------------*/
 
 static void rsxx_mask_interrupts(struct rsxx_cardinfo *card)
@@ -707,6 +871,9 @@ static int rsxx_pci_probe(struct pci_dev
 
 	rsxx_attach_dev(card);
 
+	/************* Setup Debugfs *************/
+	rsxx_debugfs_dev_new(card);
+
 	return 0;
 
 failed_create_dev:
@@ -784,6 +951,8 @@ static void rsxx_pci_remove(struct pci_d
 	/* Prevent work_structs from re-queuing themselves. */
 	card->halt = 1;
 
+	debugfs_remove_recursive(card->debugfs_dir);
+
 	free_irq(dev->irq, card);
 
 	if (!force_legacy)
diff -uprN -X linux-block/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/rsxx_priv.h linux-block/drivers/block/rsxx/rsxx_priv.h
--- linux-block-vanilla/drivers/block/rsxx/rsxx_priv.h	2013-05-31 17:02:35.371019402 -0500
+++ linux-block/drivers/block/rsxx/rsxx_priv.h	2013-05-31 17:49:36.910019132 -0500
@@ -185,6 +185,8 @@ struct rsxx_cardinfo {
 
 	int			n_targets;
 	struct rsxx_dma_ctrl	*ctrl;
+
+	struct dentry		*debugfs_dir;
 };
 
 enum rsxx_pci_regmap {

