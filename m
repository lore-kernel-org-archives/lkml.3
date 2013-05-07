Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758322Ab3EGEKA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:10:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21552 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932515Ab3EGD6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 23:58:48 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=Zcd60ZxF7AkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=cYXOv_9dK20A:10 a=t7CeM3EgAAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=z7_5JMWMQydspM-imDoA:9 a=2e6ZYRoF4I4A:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035843.257856022@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:57:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Shan Hai <shan.hai@windriver.com>, Jeff Garzik <jgarzik@redhat.com>
Subject: [014/126] libata: Set max sector to 65535 for Slimtype DVD A DS8A8SH drive
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0014-libata-Set-max-sector-to-65535-for-Slimtype-DVD-A-DS.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Shan Hai <shan.hai@windriver.com>

[ Upstream commit a32450e127fc6e5ca6d958ceb3cfea4d30a00846 ]

The Slimtype DVD A  DS8A8SH drive locks up when max sector is smaller than
65535, and the blow backtrace is observed on locking up:

INFO: task flush-8:32:1130 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
flush-8:32      D ffffffff8180cf60     0  1130      2 0x00000000
 ffff880273aef618 0000000000000046 0000000000000005 ffff880273aee000
 ffff880273aee000 ffff880273aeffd8 ffff880273aee010 ffff880273aee000
 ffff880273aeffd8 ffff880273aee000 ffff88026e842ea0 ffff880274a10000
Call Trace:
 [<ffffffff8168fc2d>] schedule+0x5d/0x70
 [<ffffffff8168fccc>] io_schedule+0x8c/0xd0
 [<ffffffff81324461>] get_request+0x731/0x7d0
 [<ffffffff8133dc60>] ? cfq_allow_merge+0x50/0x90
 [<ffffffff81083aa0>] ? wake_up_bit+0x40/0x40
 [<ffffffff81320443>] ? bio_attempt_back_merge+0x33/0x110
 [<ffffffff813248ea>] blk_queue_bio+0x23a/0x3f0
 [<ffffffff81322176>] generic_make_request+0xc6/0x120
 [<ffffffff81322308>] submit_bio+0x138/0x160
 [<ffffffff811d7596>] ? bio_alloc_bioset+0x96/0x120
 [<ffffffff811d1f61>] submit_bh+0x1f1/0x220
 [<ffffffff811d48b8>] __block_write_full_page+0x228/0x340
 [<ffffffff811d3650>] ? attach_nobh_buffers+0xc0/0xc0
 [<ffffffff811d8960>] ? I_BDEV+0x10/0x10
 [<ffffffff811d8960>] ? I_BDEV+0x10/0x10
 [<ffffffff811d4ab6>] block_write_full_page_endio+0xe6/0x100
 [<ffffffff811d4ae5>] block_write_full_page+0x15/0x20
 [<ffffffff811d9268>] blkdev_writepage+0x18/0x20
 [<ffffffff81142527>] __writepage+0x17/0x40
 [<ffffffff811438ba>] write_cache_pages+0x34a/0x4a0
 [<ffffffff81142510>] ? set_page_dirty+0x70/0x70
 [<ffffffff81143a61>] generic_writepages+0x51/0x80
 [<ffffffff81143ab0>] do_writepages+0x20/0x50
 [<ffffffff811c9ed6>] __writeback_single_inode+0xa6/0x2b0
 [<ffffffff811ca861>] writeback_sb_inodes+0x311/0x4d0
 [<ffffffff811caaa6>] __writeback_inodes_wb+0x86/0xd0
 [<ffffffff811cad43>] wb_writeback+0x1a3/0x330
 [<ffffffff816916cf>] ? _raw_spin_lock_irqsave+0x3f/0x50
 [<ffffffff811b8362>] ? get_nr_inodes+0x52/0x70
 [<ffffffff811cb0ac>] wb_do_writeback+0x1dc/0x260
 [<ffffffff8168dd34>] ? schedule_timeout+0x204/0x240
 [<ffffffff811cb232>] bdi_writeback_thread+0x102/0x2b0
 [<ffffffff811cb130>] ? wb_do_writeback+0x260/0x260
 [<ffffffff81083550>] kthread+0xc0/0xd0
 [<ffffffff81083490>] ? kthread_worker_fn+0x1b0/0x1b0
 [<ffffffff8169a3ec>] ret_from_fork+0x7c/0xb0
 [<ffffffff81083490>] ? kthread_worker_fn+0x1b0/0x1b0

 The above trace was triggered by
   "dd if=/dev/zero of=/dev/sr0 bs=2048 count=32768"

 It was previously working by accident, since another bug introduced
 by 4dce8ba94c7 (libata: Use 'bool' return value for ata_id_XXX) caused
 all drives to use maxsect=65535.

Cc: stable@vger.kernel.org
Signed-off-by: Shan Hai <shan.hai@windriver.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/ata/libata-core.c |    4 ++++
 include/linux/libata.h    |    1 +
 2 files changed, 5 insertions(+)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 8e1039c..3e351e7 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2413,6 +2413,9 @@ int ata_dev_configure(struct ata_device *dev)
 		dev->max_sectors = min_t(unsigned int, ATA_MAX_SECTORS_128,
 					 dev->max_sectors);
 
+	if (dev->horkage & ATA_HORKAGE_MAX_SEC_LBA48)
+		dev->max_sectors = ATA_MAX_SECTORS_LBA48;
+
 	if (ap->ops->dev_config)
 		ap->ops->dev_config(dev);
 
@@ -4069,6 +4072,7 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	/* Weird ATAPI devices */
 	{ "TORiSAN DVD-ROM DRD-N216", NULL,	ATA_HORKAGE_MAX_SEC_128 },
 	{ "QUANTUM DAT    DAT72-000", NULL,	ATA_HORKAGE_ATAPI_MOD16_DMA },
+	{ "Slimtype DVD A  DS8A8SH", NULL,	ATA_HORKAGE_MAX_SEC_LBA48 },
 
 	/* Devices we expect to fail diagnostics */
 
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 64f90e1..f216f6b 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -395,6 +395,7 @@ enum {
 	ATA_HORKAGE_NOSETXFER	= (1 << 14),	/* skip SETXFER, SATA only */
 	ATA_HORKAGE_BROKEN_FPDMA_AA	= (1 << 15),	/* skip AA */
 	ATA_HORKAGE_DUMP_ID	= (1 << 16),	/* dump IDENTIFY data */
+	ATA_HORKAGE_MAX_SEC_LBA48 = (1 << 17),	/* Set max sects to 65535 */
 
 	 /* DMA mask for user DMA control: User visible values; DO NOT
 	    renumber */
-- 
1.7.10.4


