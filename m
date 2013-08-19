Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751192Ab3HSTWM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 15:22:12 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:34870 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090Ab3HSTWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 15:22:10 -0400
From: Thiagarajan Thangavel <write2thiagu@gmail.com>
To: grant.likely@linaro.org
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH] Drivers:Block:swim3.c Fixed the coding style errors Fixed the coding style errors reported by checkpatch script
Date: Tue, 20 Aug 2013 00:51:48 +0530
Message-Id: <1376940108-4404-1-git-send-email-write2thiagu@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thiagarajan Thangavel <write2thiagu@gmail.com>
---
 drivers/block/swim3.c |   53 ++++++++++++++++++++++++-------------------------
 1 file changed, 26 insertions(+), 27 deletions(-)

diff --git a/drivers/block/swim3.c b/drivers/block/swim3.c
index 20e061c..99b1032 100644
--- a/drivers/block/swim3.c
+++ b/drivers/block/swim3.c
@@ -214,11 +214,11 @@ struct floppy_state {
 #ifdef DEBUG
 #define swim3_dbg(fmt, arg...)	dev_dbg(&fs->mdev->ofdev.dev, "[fd%d] " fmt, fs->index, arg)
 #else
-#define swim3_dbg(fmt, arg...)	do { } while(0)
+#define swim3_dbg(fmt, arg...)	do { } while (0)
 #endif
 
 static struct floppy_state floppy_states[MAX_FLOPPIES];
-static int floppy_count = 0;
+static int floppy_count;
 static DEFINE_SPINLOCK(swim3_lock);
 
 static unsigned short write_preamble[] = {
@@ -385,7 +385,7 @@ static void start_request(struct floppy_state *fs)
 	}
 }
 
-static void do_fd_request(struct request_queue * q)
+static void do_fd_request(struct request_queue *q)
 {
 	start_request(q->queuedata);
 }
@@ -426,7 +426,7 @@ static inline void seek_track(struct floppy_state *fs, int n)
 		swim3_action(fs, SEEK_NEGATIVE);
 		sw->nseek = -n;
 	}
-	fs->expect_cyl = (fs->cur_cyl >= 0)? fs->cur_cyl + n: -1;
+	fs->expect_cyl = (fs->cur_cyl >= 0) ? fs->cur_cyl + n : -1;
 	swim3_select(fs, STEP);
 	in_8(&sw->error);
 	/* enable intr when seek finished */
@@ -469,7 +469,7 @@ static inline void setup_transfer(struct floppy_state *fs)
 		  fs->req_sector, fs->secpertrack, fs->head, n);
 
 	fs->scount = n;
-	swim3_select(fs, fs->head? READ_DATA_1: READ_DATA_0);
+	swim3_select(fs, fs->head ? READ_DATA_1 : READ_DATA_0);
 	out_8(&sw->sector, fs->req_sector);
 	out_8(&sw->nsect, n);
 	out_8(&sw->gap3, 0);
@@ -662,8 +662,8 @@ static void xfer_timeout(unsigned long data)
 	out_8(&sw->intr_enable, 0);
 	out_8(&sw->control_bic, WRITE_SECTORS | DO_ACTION);
 	out_8(&sw->select, RELAX);
-	swim3_err("Timeout %sing sector %ld\n",
-	       (rq_data_dir(fs->cur_req)==WRITE? "writ": "read"),
+	swim3_err("Timeout %s block sector %ld\n",
+	       (rq_data_dir(fs->cur_req) == WRITE ? "writing" : "reading"),
 	       (long)blk_rq_pos(fs->cur_req));
 	swim3_end_request(fs, -EIO, 0);
 	fs->state = idle;
@@ -686,7 +686,7 @@ static irqreturn_t swim3_interrupt(int irq, void *dev_id)
 
 	spin_lock_irqsave(&swim3_lock, flags);
 	intr = in_8(&sw->intr);
-	err = (intr & ERROR_INTR)? in_8(&sw->error): 0;
+	err = (intr & ERROR_INTR) ? in_8(&sw->error) : 0;
 	if ((intr & ERROR_INTR) && fs->state != do_transfer)
 		swim3_err("Non-transfer error interrupt: state=%d, dir=%x, intr=%x, err=%x\n",
 			  fs->state, rq_data_dir(req), intr, err);
@@ -782,9 +782,9 @@ static irqreturn_t swim3_interrupt(int irq, void *dev_id)
 				++fs->retries;
 				act(fs);
 			} else {
-				swim3_err("Error %sing block %ld (err=%x)\n",
-				       rq_data_dir(req) == WRITE? "writ": "read",
-				       (long)blk_rq_pos(req), err);
+				swim3_err("Error %s block %ld (err=%x)\n",
+					rq_data_dir(req) == WRITE ? "writing" : "reading",
+					(long)blk_rq_pos(req), err);
 				swim3_end_request(fs, -EIO, 0);
 				fs->state = idle;
 			}
@@ -894,15 +894,16 @@ static int fd_eject(struct floppy_state *fs)
 	return err;
 }
 
-static struct floppy_struct floppy_type =
-	{ 2880,18,2,80,0,0x1B,0x00,0xCF,0x6C,NULL };	/*  7 1.44MB 3.5"   */
+static struct floppy_struct floppy_type = {	/*  7 1.44MB 3.5"   */
+	 2880, 18, 2, 80, 0x00, 0x1B, 0x00, 0xCF, 0x6C, NULL
+};
 
 static int floppy_locked_ioctl(struct block_device *bdev, fmode_t mode,
 			unsigned int cmd, unsigned long param)
 {
 	struct floppy_state *fs = bdev->bd_disk->private_data;
 	int err;
-		
+
 	if ((cmd & 0x80) && !capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
@@ -917,7 +918,7 @@ static int floppy_locked_ioctl(struct block_device *bdev, fmode_t mode,
 		err = fd_eject(fs);
 		return err;
 	case FDGETPRM:
-	        if (copy_to_user((void __user *) param, &floppy_type,
+		if (copy_to_user((void __user *) param, &floppy_type,
 				 sizeof(struct floppy_struct)))
 			return -EFAULT;
 		return 0;
@@ -1079,14 +1080,14 @@ static int floppy_revalidate(struct gendisk *disk)
 }
 
 static const struct block_device_operations floppy_fops = {
-	.open		= floppy_unlocked_open,
-	.release	= floppy_release,
-	.ioctl		= floppy_ioctl,
-	.check_events	= floppy_check_events,
-	.revalidate_disk= floppy_revalidate,
+	.open		 = floppy_unlocked_open,
+	.release	 = floppy_release,
+	.ioctl		 = floppy_ioctl,
+	.check_events	 = floppy_check_events,
+	.revalidate_disk = floppy_revalidate,
 };
 
-static void swim3_mb_event(struct macio_dev* mdev, int mb_state)
+static void swim3_mb_event(struct macio_dev *mdev, int mb_state)
 {
 	struct floppy_state *fs = macio_get_drvdata(mdev);
 	struct swim3 __iomem *sw;
@@ -1138,7 +1139,7 @@ static int swim3_add_device(struct macio_dev *mdev, int index)
 
 	if (mdev->media_bay == NULL)
 		pmac_call_feature(PMAC_FTR_SWIM3_ENABLE, swim, 0, 1);
-	
+
 	fs->state = idle;
 	fs->swim3 = (struct swim3 __iomem *)
 		ioremap(macio_resource_start(mdev, 0), 0x200);
@@ -1241,8 +1242,7 @@ static int swim3_attach(struct macio_dev *mdev,
 	return 0;
 }
 
-static struct of_device_id swim3_match[] =
-{
+static struct of_device_id swim3_match[] = {
 	{
 	.name		= "swim3",
 	},
@@ -1255,10 +1255,9 @@ static struct of_device_id swim3_match[] =
 	{ /* end of list */ }
 };
 
-static struct macio_driver swim3_driver =
-{
+static struct macio_driver swim3_driver = {
 	.driver = {
-		.name 		= "swim3",
+		.name		= "swim3",
 		.of_match_table	= swim3_match,
 	},
 	.probe		= swim3_attach,
-- 
1.7.9.5

