Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319Ab3JAMq0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 08:46:26 -0400
Received: from smtp2.stec-inc.com ([68.225.24.15]:48754 "EHLO
	smtp2.stec-inc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071Ab3JAMqL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 08:46:11 -0400
X-ASG-Debug-ID: 1380631504-486e66b10001-xx1T2L
X-Barracuda-Envelope-From: osengineering@stec-inc.com
From: OS Engineering <osengineering@stec-inc.com>
X-Barracuda-Apparent-Source-IP: fe80::30dd:fd5:3d97:5f13
To: "axboe@kernel.dk" <axboe@kernel.dk>
CC: Akhil Bhansali <Akhil.Bhansali@hgst.com>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Amit Phansalkar <Amit.Phansalkar@hgst.com>,
        Ramprasad Chinthekindi <Ramprasad.Chinthekindi@hgst.com>
Subject: [PATCH 1/2] skd: Replaced custom debug PRINTKs with pr_debug
Thread-Topic: [PATCH 1/2] skd: Replaced custom debug PRINTKs with pr_debug
X-ASG-Orig-Subj: [PATCH 1/2] skd: Replaced custom debug PRINTKs with pr_debug
Thread-Index: Ac6+oPuVd4lKh9QoQrOWMCHXDRyqEg==
Date: Tue, 1 Oct 2013 12:25:20 +0000
Message-ID: <26D762E250385C4D8E9D6EC3C8E47DC11E70587F@sambx4.stec-inc.ad>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [14.140.125.250]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Barracuda-Connect: sacas02.stec-inc.ad[172.17.3.1]
X-Barracuda-Start-Time: 1380631504
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://saspam1.stec-inc.com:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=BSF_SC0_MISMATCH_TO
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.141083
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.00 BSF_SC0_MISMATCH_TO    Envelope rcpt doesn't match header
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

I'm sending a patch to replace custom debug macros with pr_debug(). Kindly please review the patch.
Thanking you.

-Ramprasad
----------------------

>From 15ec62eb8f7ddb61ad8738898c6b67b2c1e23a78 Mon Sep 17 00:00:00 2001
From: rchinthekindi <rchinthekindi@stec-inc.com>
Date: Tue, 1 Oct 2013 17:23:17 +0530
Subject: [PATCH 1/2] skd: Replaced custom debug PRINTKs with pr_debug

Replaced DPRINTK() and VPRINTK() with pr_debug().

Signed-off-by: Ramprasad C <ramprasad.chinthekindi@hgst.com>
---
 drivers/block/skd_main.c |  690 +++++++++++++++++++++++++++-------------------
 1 files changed, 406 insertions(+), 284 deletions(-)

diff --git a/drivers/block/skd_main.c b/drivers/block/skd_main.c
index 3110f68..9646dcf 100644
--- a/drivers/block/skd_main.c
+++ b/drivers/block/skd_main.c
@@ -68,14 +68,6 @@ enum {
 	SKD_FLUSH_DATA_SECOND,
 };
 
-#define DPRINTK(skdev, fmt, args ...) \
-	do { \
-		if (unlikely((skdev)->dbg_level > 0)) {	\
-			pr_err("%s:%s:%d " fmt, (skdev)->name,	\
-			       __func__, __LINE__, ## args); \
-		} \
-	} while (0)
-
 #define SKD_ASSERT(expr) \
 	do { \
 		if (unlikely(!(expr))) { \
@@ -84,15 +76,6 @@ enum {
 		} \
 	} while (0)
 
-#define VPRINTK(skdev, fmt, args ...) \
-	do { \
-		if (unlikely((skdev)->dbg_level > 1)) {	\
-			pr_err("%s:%s:%d " fmt, (skdev)->name,	\
-			       __func__, __LINE__, ## args); \
-		} \
-	} while (0)
-
-
 #define DRV_NAME "skd"
 #define DRV_VERSION "2.2.1"
 #define DRV_BUILD_ID "0260"
@@ -408,7 +391,8 @@ static inline u32 skd_reg_read32(struct skd_device *skdev, u32 offset)
 		barrier();
 		val = readl(skdev->mem_map[1] + offset);
 		barrier();
-		VPRINTK(skdev, "offset %x = %x\n", offset, val);
+		pr_debug("%s:%s:%d offset %x = %x\n",
+			 skdev->name, __func__, __LINE__, offset, val);
 		return val;
 	}
 
@@ -428,7 +412,8 @@ static inline void skd_reg_write32(struct skd_device *skdev, u32 val,
 		barrier();
 		readl(skdev->mem_map[1] + offset);
 		barrier();
-		VPRINTK(skdev, "offset %x = %x\n", offset, val);
+		pr_debug("%s:%s:%d offset %x = %x\n",
+			 skdev->name, __func__, __LINE__, offset, val);
 	}
 }
 
@@ -446,7 +431,8 @@ static inline void skd_reg_write64(struct skd_device *skdev, u64 val,
 		barrier();
 		readq(skdev->mem_map[1] + offset);
 		barrier();
-		VPRINTK(skdev, "offset %x = %016llx\n", offset, val);
+		pr_debug("%s:%s:%d offset %x = %016llx\n",
+			 skdev->name, __func__, __LINE__, offset, val);
 	}
 }
 
@@ -772,15 +758,18 @@ static void skd_request_fn(struct request_queue *q)
 			if (io_flags & REQ_FUA)
 				fua++;
 
-			VPRINTK(skdev,
-				"new req=%p lba=%u(0x%x) count=%u(0x%x) dir=%d\n",
-				req, lba, lba, count, count, data_dir);
+			pr_debug("%s:%s:%d new req=%p lba=%u(0x%x) "
+				 "count=%u(0x%x) dir=%d\n",
+				 skdev->name, __func__, __LINE__,
+				 req, lba, lba, count, count, data_dir);
 		} else {
 			if (!list_empty(&skdev->flush_list)) {
 				/* Process data part of FLUSH request. */
 				bio = (struct bio *)skd_flush_cmd_dequeue(skdev);
 				flush++;
-				VPRINTK(skdev, "processing FLUSH request with data.\n");
+				pr_debug("%s:%s:%d processing FLUSH request"
+					 " with data.\n",
+					 skdev->name, __func__, __LINE__);
 			} else {
 				/* peek at our bio queue */
 				bio = bio_list_peek(&skdev->bio_queue);
@@ -795,9 +784,10 @@ static void skd_request_fn(struct request_queue *q)
 			data_dir = bio_data_dir(bio);
 			io_flags = bio->bi_rw;
 
-			VPRINTK(skdev,
-				"new bio=%p lba=%u(0x%x) count=%u(0x%x) dir=%d\n",
-				bio, lba, lba, count, count, data_dir);
+			pr_debug("%s:%s:%d new bio=%p lba=%u(0x%x) "
+				 "count=%u(0x%x) dir=%d\n",
+				 skdev->name, __func__, __LINE__,
+				 bio, lba, lba, count, count, data_dir);
 
 			if (io_flags & REQ_FLUSH)
 				flush++;
@@ -813,15 +803,17 @@ static void skd_request_fn(struct request_queue *q)
 
 		/* Are too many requets already in progress? */
 		if (skdev->in_flight >= skdev->cur_max_queue_depth) {
-			VPRINTK(skdev, "qdepth %d, limit %d\n",
-				skdev->in_flight, skdev->cur_max_queue_depth);
+			pr_debug("%s:%s:%d qdepth %d, limit %d\n",
+				 skdev->name, __func__, __LINE__,
+				 skdev->in_flight, skdev->cur_max_queue_depth);
 			break;
 		}
 
 		/* Is a skd_request_context available? */
 		skreq = skdev->skreq_free_list;
 		if (skreq == NULL) {
-			VPRINTK(skdev, "Out of req=%p\n", q);
+			pr_debug("%s:%s:%d Out of req=%p\n",
+				 skdev->name, __func__, __LINE__, q);
 			break;
 		}
 		SKD_ASSERT(skreq->state == SKD_REQ_STATE_IDLE);
@@ -830,7 +822,8 @@ static void skd_request_fn(struct request_queue *q)
 		/* Now we check to see if we can get a fit msg */
 		if (skmsg == NULL) {
 			if (skdev->skmsg_free_list == NULL) {
-				VPRINTK(skdev, "Out of msg\n");
+				pr_debug("%s:%s:%d Out of msg\n",
+					 skdev->name, __func__, __LINE__);
 				break;
 			}
 		}
@@ -870,7 +863,8 @@ static void skd_request_fn(struct request_queue *q)
 			/* Are there any FIT msg buffers available? */
 			skmsg = skdev->skmsg_free_list;
 			if (skmsg == NULL) {
-				VPRINTK(skdev, "Out of msg skdev=%p\n", skdev);
+				pr_debug("%s:%s:%d Out of msg skdev=%p\n",
+					 skdev->name, __func__, __LINE__, skdev);
 				break;
 			}
 			SKD_ASSERT(skmsg->state == SKD_MSG_STATE_IDLE);
@@ -953,7 +947,8 @@ static void skd_request_fn(struct request_queue *q)
 			 * only resource that has been allocated but might
 			 * not be used is that the FIT msg could be empty.
 			 */
-			DPRINTK(skdev, "error Out\n");
+			pr_debug("%s:%s:%d error Out\n",
+				 skdev->name, __func__, __LINE__);
 			skd_end_request(skdev, skreq, error);
 			continue;
 		}
@@ -978,8 +973,9 @@ skip_sg:
 		timo_slot = skreq->timeout_stamp & SKD_TIMEOUT_SLOT_MASK;
 		skdev->timeout_slot[timo_slot]++;
 		skdev->in_flight++;
-		VPRINTK(skdev, "req=0x%x busy=%d\n",
-			skreq->id, skdev->in_flight);
+		pr_debug("%s:%s:%d req=0x%x busy=%d\n",
+			 skdev->name, __func__, __LINE__,
+			 skreq->id, skdev->in_flight);
 
 		/*
 		 * If the FIT msg buffer is full send it.
@@ -1001,8 +997,9 @@ skip_sg:
 	if (skmsg != NULL) {
 		/* Bigger than just a FIT msg header? */
 		if (skmsg->length > sizeof(struct fit_msg_hdr)) {
-			VPRINTK(skdev, "sending msg=%p, len %d\n",
-				skmsg, skmsg->length);
+			pr_debug("%s:%s:%d sending msg=%p, len %d\n",
+				 skdev->name, __func__, __LINE__,
+				 skmsg, skmsg->length);
 			skd_send_fitmsg(skdev, skmsg);
 		} else {
 			/*
@@ -1035,7 +1032,8 @@ static void skd_end_request_blk(struct skd_device *skdev,
 
 	if ((io_flags & REQ_DISCARD) &&
 		(skreq->discard_page == 1)) {
-		VPRINTK(skdev, "skd_end_request_blk, free the page!");
+		pr_debug("%s:%s:%d skd_end_request_blk, free the page!",
+			 skdev->name, __func__, __LINE__);
 		free_page((unsigned long)req->buffer);
 		req->buffer = NULL;
 	}
@@ -1049,7 +1047,8 @@ static void skd_end_request_blk(struct skd_device *skdev,
 		pr_err("(%s): Error cmd=%s sect=%u count=%u id=0x%x\n",
 		       skd_name(skdev), cmd, lba, count, skreq->id);
 	} else
-		VPRINTK(skdev, "id=0x%x error=%d\n", skreq->id, error);
+		pr_debug("%s:%s:%d id=0x%x error=%d\n",
+			 skdev->name, __func__, __LINE__, skreq->id, error);
 
 	__blk_end_request_all(skreq->req, error);
 }
@@ -1101,14 +1100,16 @@ static int skd_preop_sg_list_blk(struct skd_device *skdev,
 	skreq->sksg_list[n_sg - 1].control = FIT_SGD_CONTROL_LAST;
 
 	if (unlikely(skdev->dbg_level > 1)) {
-		VPRINTK(skdev, "skreq=%x sksg_list=%p sksg_dma=%llx\n",
-			skreq->id, skreq->sksg_list, skreq->sksg_dma_address);
+		pr_debug("%s:%s:%d skreq=%x sksg_list=%p sksg_dma=%llx\n",
+			 skdev->name, __func__, __LINE__,
+			 skreq->id, skreq->sksg_list, skreq->sksg_dma_address);
 		for (i = 0; i < n_sg; i++) {
 			struct fit_sg_descriptor *sgd = &skreq->sksg_list[i];
-			VPRINTK(skdev, "  sg[%d] count=%u ctrl=0x%x "
-				"addr=0x%llx next=0x%llx\n",
-				i, sgd->byte_count, sgd->control,
-				sgd->host_side_addr, sgd->next_desc_ptr);
+			pr_debug("%s:%s:%d   sg[%d] count=%u ctrl=0x%x "
+				 "addr=0x%llx next=0x%llx\n",
+				 skdev->name, __func__, __LINE__,
+				 i, sgd->byte_count, sgd->control,
+				 sgd->host_side_addr, sgd->next_desc_ptr);
 		}
 	}
 
@@ -1140,7 +1141,9 @@ static void skd_end_request_bio(struct skd_device *skdev,
 
 	if ((io_flags & REQ_DISCARD) &&
 		(skreq->discard_page == 1)) {
-		VPRINTK(skdev, "biomode: skd_end_request: freeing DISCARD page.\n");
+		pr_debug("%s:%s:%d biomode: skd_end_request: "
+			 "freeing DISCARD page.\n",
+			 skdev->name, __func__, __LINE__);
 		free_page((unsigned long)page_address(bio->bi_io_vec->bv_page));
 	}
 
@@ -1165,7 +1168,8 @@ static void skd_end_request_bio(struct skd_device *skdev,
 		part_stat_unlock();
 	}
 
-	VPRINTK(skdev, "id=0x%x error=%d\n", skreq->id, error);
+	pr_debug("%s:%s:%d id=0x%x error=%d\n",
+		 skdev->name, __func__, __LINE__, skreq->id, error);
 
 	bio_endio(skreq->bio, error);
 }
@@ -1237,14 +1241,16 @@ static int skd_preop_sg_list_bio(struct skd_device *skdev,
 	}
 
 	if (unlikely(skdev->dbg_level > 1)) {
-		VPRINTK(skdev, "skreq=%x sksg_list=%p sksg_dma=%llx\n",
-			skreq->id, skreq->sksg_list, skreq->sksg_dma_address);
+		pr_debug("%s:%s:%d skreq=%x sksg_list=%p sksg_dma=%llx\n",
+			 skdev->name, __func__, __LINE__,
+			 skreq->id, skreq->sksg_list, skreq->sksg_dma_address);
 		for (i = 0; i < n_sg; i++) {
 			struct fit_sg_descriptor *sgd = &skreq->sksg_list[i];
-			VPRINTK(skdev, "  sg[%d] count=%u ctrl=0x%x "
-				"addr=0x%llx next=0x%llx\n",
-				i, sgd->byte_count, sgd->control,
-				sgd->host_side_addr, sgd->next_desc_ptr);
+			pr_debug("%s:%s:%d   sg[%d] count=%u ctrl=0x%x "
+				 "addr=0x%llx next=0x%llx\n",
+				 skdev->name, __func__, __LINE__,
+				 i, sgd->byte_count, sgd->control,
+				 sgd->host_side_addr, sgd->next_desc_ptr);
 		}
 	}
 
@@ -1399,8 +1405,9 @@ static void skd_timer_tick(ulong arg)
 	/* Something is overdue */
 	overdue_timestamp = skdev->timeout_stamp - SKD_N_TIMEOUT_SLOT;
 
-	DPRINTK(skdev, "found %d timeouts, draining busy=%d\n",
-		skdev->timeout_slot[timo_slot], skdev->in_flight);
+	pr_debug("%s:%s:%d found %d timeouts, draining busy=%d\n",
+		 skdev->name, __func__, __LINE__,
+		 skdev->timeout_slot[timo_slot], skdev->in_flight);
 	pr_err("(%s): Overdue IOs (%d), busy %d\n",
 	       skd_name(skdev), skdev->timeout_slot[timo_slot],
 	       skdev->in_flight);
@@ -1423,8 +1430,9 @@ static void skd_timer_tick_not_online(struct skd_device *skdev)
 	case SKD_DRVR_STATE_LOAD:
 		break;
 	case SKD_DRVR_STATE_BUSY_SANITIZE:
-		VPRINTK(skdev, "drive busy sanitize[%x], driver[%x]\n",
-			skdev->drive_state, skdev->state);
+		pr_debug("%s:%s:%d drive busy sanitize[%x], driver[%x]\n",
+			 skdev->name, __func__, __LINE__,
+			 skdev->drive_state, skdev->state);
 		/* If we've been in sanitize for 3 seconds, we figure we're not
 		 * going to get anymore completions, so recover requests now
 		 */
@@ -1438,14 +1446,16 @@ static void skd_timer_tick_not_online(struct skd_device *skdev)
 	case SKD_DRVR_STATE_BUSY:
 	case SKD_DRVR_STATE_BUSY_IMMINENT:
 	case SKD_DRVR_STATE_BUSY_ERASE:
-		VPRINTK(skdev, "busy[%x], countdown=%d\n",
-			skdev->state, skdev->timer_countdown);
+		pr_debug("%s:%s:%d busy[%x], countdown=%d\n",
+			 skdev->name, __func__, __LINE__,
+			 skdev->state, skdev->timer_countdown);
 		if (skdev->timer_countdown > 0) {
 			skdev->timer_countdown--;
 			return;
 		}
-		DPRINTK(skdev, "busy[%x], timedout=%d, restarting device.",
-			skdev->state, skdev->timer_countdown);
+		pr_debug("%s:%s:%d busy[%x], timedout=%d, restarting device.",
+			 skdev->name, __func__, __LINE__,
+			 skdev->state, skdev->timer_countdown);
 		skd_restart_device(skdev);
 		break;
 
@@ -1478,15 +1488,17 @@ static void skd_timer_tick_not_online(struct skd_device *skdev)
 		break;
 
 	case SKD_DRVR_STATE_DRAINING_TIMEOUT:
-		DPRINTK(skdev,
-			"draining busy [%d] tick[%d] qdb[%d] tmls[%d]\n",
-			skdev->timo_slot,
-			skdev->timer_countdown,
-			skdev->in_flight,
-			skdev->timeout_slot[skdev->timo_slot]);
+		pr_debug("%s:%s:%d "
+			 "draining busy [%d] tick[%d] qdb[%d] tmls[%d]\n",
+			 skdev->name, __func__, __LINE__,
+			 skdev->timo_slot,
+			 skdev->timer_countdown,
+			 skdev->in_flight,
+			 skdev->timeout_slot[skdev->timo_slot]);
 		/* if the slot has cleared we can let the I/O continue */
 		if (skdev->timeout_slot[skdev->timo_slot] == 0) {
-			DPRINTK(skdev, "Slot drained, starting queue.\n");
+			pr_debug("%s:%s:%d Slot drained, starting queue.\n",
+				 skdev->name, __func__, __LINE__);
 			skdev->state = SKD_DRVR_STATE_ONLINE;
 			skd_start_queue(skdev);
 			return;
@@ -1609,8 +1621,9 @@ static int skd_bdev_ioctl(struct block_device *bdev, fmode_t mode,
 	struct skd_device *skdev = disk->private_data;
 	void __user *p = (void *)arg;
 
-	DPRINTK(skdev, "%s: CMD[%s] ioctl  mode 0x%x, cmd 0x%x arg %0lx\n",
-		disk->disk_name, current->comm, mode, cmd_in, arg);
+	pr_debug("%s:%s:%d %s: CMD[%s] ioctl  mode 0x%x, cmd 0x%x arg %0lx\n",
+		 skdev->name, __func__, __LINE__,
+		 disk->disk_name, current->comm, mode, cmd_in, arg);
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -1630,7 +1643,8 @@ static int skd_bdev_ioctl(struct block_device *bdev, fmode_t mode,
 		break;
 	}
 
-	DPRINTK(skdev, "%s:  completion rc %d\n", disk->disk_name, rc);
+	pr_debug("%s:%s:%d %s:  completion rc %d\n",
+		 skdev->name, __func__, __LINE__, disk->disk_name, rc);
 	return rc;
 }
 
@@ -1651,7 +1665,8 @@ static int skd_ioctl_sg_io(struct skd_device *skdev, fmode_t mode,
 		break;
 
 	default:
-		DPRINTK(skdev, "drive not online\n");
+		pr_debug("%s:%s:%d drive not online\n",
+			 skdev->name, __func__, __LINE__);
 		rc = -ENXIO;
 		goto out;
 	}
@@ -1687,33 +1702,38 @@ static int skd_sg_io_get_and_check_args(struct skd_device *skdev,
 	int i, acc;
 
 	if (!access_ok(VERIFY_WRITE, sksgio->argp, sizeof(sg_io_hdr_t))) {
-		DPRINTK(skdev, "access sg failed %p\n", sksgio->argp);
+		pr_debug("%s:%s:%d access sg failed %p\n",
+			 skdev->name, __func__, __LINE__, sksgio->argp);
 		return -EFAULT;
 	}
 
 	if (__copy_from_user(sgp, sksgio->argp, sizeof(sg_io_hdr_t))) {
-		DPRINTK(skdev, "copy_from_user sg failed %p\n", sksgio->argp);
+		pr_debug("%s:%s:%d copy_from_user sg failed %p\n",
+			 skdev->name, __func__, __LINE__, sksgio->argp);
 		return -EFAULT;
 	}
 
 	if (sgp->interface_id != SG_INTERFACE_ID_ORIG) {
-		DPRINTK(skdev, "interface_id invalid 0x%x\n",
-			sgp->interface_id);
+		pr_debug("%s:%s:%d interface_id invalid 0x%x\n",
+			 skdev->name, __func__, __LINE__, sgp->interface_id);
 		return -EINVAL;
 	}
 
 	if (sgp->cmd_len > sizeof(sksgio->cdb)) {
-		DPRINTK(skdev, "cmd_len invalid %d\n", sgp->cmd_len);
+		pr_debug("%s:%s:%d cmd_len invalid %d\n",
+			 skdev->name, __func__, __LINE__, sgp->cmd_len);
 		return -EINVAL;
 	}
 
 	if (sgp->iovec_count > 256) {
-		DPRINTK(skdev, "iovec_count invalid %d\n", sgp->iovec_count);
+		pr_debug("%s:%s:%d iovec_count invalid %d\n",
+			 skdev->name, __func__, __LINE__, sgp->iovec_count);
 		return -EINVAL;
 	}
 
 	if (sgp->dxfer_len > (PAGE_SIZE * SKD_N_SG_PER_SPECIAL)) {
-		DPRINTK(skdev, "dxfer_len invalid %d\n", sgp->dxfer_len);
+		pr_debug("%s:%s:%d dxfer_len invalid %d\n",
+			 skdev->name, __func__, __LINE__, sgp->dxfer_len);
 		return -EINVAL;
 	}
 
@@ -1732,18 +1752,21 @@ static int skd_sg_io_get_and_check_args(struct skd_device *skdev,
 		break;
 
 	default:
-		DPRINTK(skdev, "dxfer_dir invalid %d\n", sgp->dxfer_direction);
+		pr_debug("%s:%s:%d dxfer_dir invalid %d\n",
+			 skdev->name, __func__, __LINE__, sgp->dxfer_direction);
 		return -EINVAL;
 	}
 
 	if (copy_from_user(sksgio->cdb, sgp->cmdp, sgp->cmd_len)) {
-		DPRINTK(skdev, "copy_from_user cmdp failed %p\n", sgp->cmdp);
+		pr_debug("%s:%s:%d copy_from_user cmdp failed %p\n",
+			 skdev->name, __func__, __LINE__, sgp->cmdp);
 		return -EFAULT;
 	}
 
 	if (sgp->mx_sb_len != 0) {
 		if (!access_ok(VERIFY_WRITE, sgp->sbp, sgp->mx_sb_len)) {
-			DPRINTK(skdev, "access sbp failed %p\n", sgp->sbp);
+			pr_debug("%s:%s:%d access sbp failed %p\n",
+				 skdev->name, __func__, __LINE__, sgp->sbp);
 			return -EFAULT;
 		}
 	}
@@ -1760,16 +1783,17 @@ static int skd_sg_io_get_and_check_args(struct skd_device *skdev,
 
 		iov = kmalloc(nbytes, GFP_KERNEL);
 		if (iov == NULL) {
-			DPRINTK(skdev, "alloc iovec failed %d\n",
-				sgp->iovec_count);
+			pr_debug("%s:%s:%d alloc iovec failed %d\n",
+				 skdev->name, __func__, __LINE__,
+				 sgp->iovec_count);
 			return -ENOMEM;
 		}
 		sksgio->iov = iov;
 		sksgio->iovcnt = sgp->iovec_count;
 
 		if (copy_from_user(iov, sgp->dxferp, nbytes)) {
-			DPRINTK(skdev, "copy_from_user iovec failed %p\n",
-				sgp->dxferp);
+			pr_debug("%s:%s:%d copy_from_user iovec failed %p\n",
+				 skdev->name, __func__, __LINE__, sgp->dxferp);
 			return -EFAULT;
 		}
 
@@ -1797,8 +1821,9 @@ static int skd_sg_io_get_and_check_args(struct skd_device *skdev,
 		struct sg_iovec *iov = sksgio->iov;
 		for (i = 0; i < sksgio->iovcnt; i++, iov++) {
 			if (!access_ok(acc, iov->iov_base, iov->iov_len)) {
-				DPRINTK(skdev, "access data failed %p/%d\n",
-					iov->iov_base, (int)iov->iov_len);
+				pr_debug("%s:%s:%d access data failed %p/%d\n",
+					 skdev->name, __func__, __LINE__,
+					 iov->iov_base, (int)iov->iov_len);
 				return -EFAULT;
 			}
 		}
@@ -1833,14 +1858,15 @@ static int skd_sg_io_obtain_skspcl(struct skd_device *skdev,
 			break;
 		}
 
-		DPRINTK(skdev, "blocking\n");
+		pr_debug("%s:%s:%d blocking\n", skdev->name, __func__, __LINE__);
 
 		rc = wait_event_interruptible_timeout(
 				skdev->waitq,
 				(skdev->skspcl_free_list != NULL),
 				msecs_to_jiffies(sksgio->sg.timeout));
 
-		DPRINTK(skdev, "unblocking, rc=%d\n", rc);
+		pr_debug("%s:%s:%d unblocking, rc=%d\n",
+			 skdev->name, __func__, __LINE__, rc);
 
 		if (rc <= 0) {
 			if (rc == 0)
@@ -1917,15 +1943,17 @@ static int skd_skreq_prep_buffering(struct skd_device *skdev,
 	if (unlikely(skdev->dbg_level > 1)) {
 		u32 i;
 
-		VPRINTK(skdev, "skreq=%x sksg_list=%p sksg_dma=%llx\n",
-			skreq->id, skreq->sksg_list, skreq->sksg_dma_address);
+		pr_debug("%s:%s:%d skreq=%x sksg_list=%p sksg_dma=%llx\n",
+			 skdev->name, __func__, __LINE__,
+			 skreq->id, skreq->sksg_list, skreq->sksg_dma_address);
 		for (i = 0; i < skreq->n_sg; i++) {
 			struct fit_sg_descriptor *sgd = &skreq->sksg_list[i];
 
-			VPRINTK(skdev, "  sg[%d] count=%u ctrl=0x%x "
-				"addr=0x%llx next=0x%llx\n",
-				i, sgd->byte_count, sgd->control,
-				sgd->host_side_addr, sgd->next_desc_ptr);
+			pr_debug("%s:%s:%d   sg[%d] count=%u ctrl=0x%x "
+				 "addr=0x%llx next=0x%llx\n",
+				 skdev->name, __func__, __LINE__,
+				 i, sgd->byte_count, sgd->control,
+				 sgd->host_side_addr, sgd->next_desc_ptr);
 		}
 	}
 
@@ -2047,7 +2075,8 @@ static int skd_sg_io_await(struct skd_device *skdev, struct skd_sg_io *sksgio)
 	spin_lock_irqsave(&skdev->lock, flags);
 
 	if (sksgio->skspcl->req.state == SKD_REQ_STATE_ABORTED) {
-		DPRINTK(skdev, "skspcl %p aborted\n", sksgio->skspcl);
+		pr_debug("%s:%s:%d skspcl %p aborted\n",
+			 skdev->name, __func__, __LINE__, sksgio->skspcl);
 
 		/* Build check cond, sense and let command finish. */
 		/* For a timeout, we must fabricate completion and sense
@@ -2072,11 +2101,13 @@ static int skd_sg_io_await(struct skd_device *skdev, struct skd_sg_io *sksgio)
 		sksgio->skspcl->orphaned = 1;
 		sksgio->skspcl = NULL;
 		if (rc == 0) {
-			DPRINTK(skdev, "timed out %p (%u ms)\n", sksgio,
-				sksgio->sg.timeout);
+			pr_debug("%s:%s:%d timed out %p (%u ms)\n",
+				 skdev->name, __func__, __LINE__,
+				 sksgio, sksgio->sg.timeout);
 			rc = -ETIMEDOUT;
 		} else {
-			DPRINTK(skdev, "cntlc %p\n", sksgio);
+			pr_debug("%s:%s:%d cntlc %p\n",
+				 skdev->name, __func__, __LINE__, sksgio);
 			rc = -EINTR;
 		}
 	}
@@ -2106,8 +2137,9 @@ static int skd_sg_io_put_status(struct skd_device *skdev,
 	if (sgp->masked_status || sgp->host_status || sgp->driver_status)
 		sgp->info |= SG_INFO_CHECK;
 
-	DPRINTK(skdev, "status %x masked %x resid 0x%x\n", sgp->status,
-		sgp->masked_status, sgp->resid);
+	pr_debug("%s:%s:%d status %x masked %x resid 0x%x\n",
+		 skdev->name, __func__, __LINE__,
+		 sgp->status, sgp->masked_status, sgp->resid);
 
 	if (sgp->masked_status == SAM_STAT_CHECK_CONDITION) {
 		if (sgp->mx_sb_len > 0) {
@@ -2119,15 +2151,17 @@ static int skd_sg_io_put_status(struct skd_device *skdev,
 			sgp->sb_len_wr = nbytes;
 
 			if (__copy_to_user(sgp->sbp, ei, nbytes)) {
-				DPRINTK(skdev, "copy_to_user sense failed %p\n",
-					sgp->sbp);
+				pr_debug("%s:%s:%d copy_to_user sense failed %p\n",
+					 skdev->name, __func__, __LINE__,
+					 sgp->sbp);
 				return -EFAULT;
 			}
 		}
 	}
 
 	if (__copy_to_user(sksgio->argp, sgp, sizeof(sg_io_hdr_t))) {
-		DPRINTK(skdev, "copy_to_user sg failed %p\n", sksgio->argp);
+		pr_debug("%s:%s:%d copy_to_user sg failed %p\n",
+			 skdev->name, __func__, __LINE__, sksgio->argp);
 		return -EFAULT;
 	}
 
@@ -2315,7 +2349,8 @@ static void skd_complete_internal(struct skd_device *skdev,
 
 	SKD_ASSERT(skspcl == &skdev->internal_skspcl);
 
-	DPRINTK(skdev, "complete internal %x\n", scsi->cdb[0]);
+	pr_debug("%s:%s:%d complete internal %x\n",
+		 skdev->name, __func__, __LINE__, scsi->cdb[0]);
 
 	skspcl->req.completion = *skcomp;
 	skspcl->req.state = SKD_REQ_STATE_IDLE;
@@ -2335,11 +2370,13 @@ static void skd_complete_internal(struct skd_device *skdev,
 			skd_send_internal_skspcl(skdev, skspcl, WRITE_BUFFER);
 		else {
 			if (skdev->state == SKD_DRVR_STATE_STOPPING) {
-				VPRINTK(skdev, "TUR failed, don't send anymore"
-					"state 0x%x\n", skdev->state);
+				pr_debug("%s:%s:%d TUR failed, don't send anymore"
+					 "state 0x%x\n",
+					 skdev->name, __func__, __LINE__, skdev->state);
 				return;
 			}
-			DPRINTK(skdev, "**** TUR failed, retry skerr\n");
+			pr_debug("%s:%s:%d **** TUR failed, retry skerr\n",
+				 skdev->name, __func__, __LINE__);
 			skd_send_internal_skspcl(skdev, skspcl, 0x00);
 		}
 		break;
@@ -2349,12 +2386,14 @@ static void skd_complete_internal(struct skd_device *skdev,
 			skd_send_internal_skspcl(skdev, skspcl, READ_BUFFER);
 		else {
 			if (skdev->state == SKD_DRVR_STATE_STOPPING) {
-				VPRINTK(skdev, "write buffer failed, don't send"
-					" anymore state 0x%x\n", skdev->state);
+				pr_debug("%s:%s:%d write buffer failed, don't send"
+					 " anymore state 0x%x\n",
+					 skdev->name, __func__, __LINE__, skdev->state);
 				return;
 			}
-			DPRINTK(skdev,
-				"**** write buffer failed, retry skerr\n");
+			pr_debug("%s:%s:%d "
+				 "**** write buffer failed, retry skerr\n",
+				 skdev->name, __func__, __LINE__);
 			skd_send_internal_skspcl(skdev, skspcl, 0x00);
 		}
 		break;
@@ -2382,13 +2421,16 @@ static void skd_complete_internal(struct skd_device *skdev,
 
 		} else {
 			if (skdev->state == SKD_DRVR_STATE_STOPPING) {
-				VPRINTK(skdev,
-					"read buffer failed, don't send anymore"
-					"state 0x%x\n", skdev->state);
+				pr_debug("%s:%s:%d "
+					 "read buffer failed, don't send"
+					 " anymore state 0x%x\n",
+					 skdev->name, __func__, __LINE__,
+					 skdev->state);
 				return;
 			}
-			DPRINTK(skdev,
-				"**** read buffer failed, retry skerr\n");
+			pr_debug("%s:%s:%d "
+				 "**** read buffer failed, retry skerr\n",
+				 skdev->name, __func__, __LINE__);
 			skd_send_internal_skspcl(skdev, skspcl, 0x00);
 		}
 		break;
@@ -2403,9 +2445,10 @@ static void skd_complete_internal(struct skd_device *skdev,
 				(buf[4] << 24) | (buf[5] << 16) |
 				(buf[6] << 8) | buf[7];
 
-			DPRINTK(skdev, "last lba %d, bs %d\n",
-				skdev->read_cap_last_lba,
-				skdev->read_cap_blocksize);
+			pr_debug("%s:%s:%d last lba %d, bs %d\n",
+				 skdev->name, __func__, __LINE__,
+				 skdev->read_cap_last_lba,
+				 skdev->read_cap_blocksize);
 
 			set_capacity(skdev->disk, skdev->read_cap_last_lba + 1);
 
@@ -2416,11 +2459,13 @@ static void skd_complete_internal(struct skd_device *skdev,
 			   (skerr->key == MEDIUM_ERROR)) {
 			skdev->read_cap_last_lba = ~0;
 			set_capacity(skdev->disk, skdev->read_cap_last_lba + 1);
-			DPRINTK(skdev,
-				"**** MEDIUM ERROR caused READCAP to fail, ignore failure and continue to inquiry\n");
+			pr_debug("%s:%s:%d **** MEDIUM ERROR caused READCAP to "
+				 "fail, ignore failure and continue to inquiry\n",
+				 skdev->name, __func__, __LINE__);
 			skd_send_internal_skspcl(skdev, skspcl, INQUIRY);
 		} else {
-			DPRINTK(skdev, "**** READCAP failed, retry TUR\n");
+			pr_debug("%s:%s:%d **** READCAP failed, retry TUR\n",
+				 skdev->name, __func__, __LINE__);
 			skd_send_internal_skspcl(skdev, skspcl,
 						 TEST_UNIT_READY);
 		}
@@ -2437,7 +2482,8 @@ static void skd_complete_internal(struct skd_device *skdev,
 		}
 
 		if (skd_unquiesce_dev(skdev) < 0)
-			DPRINTK(skdev, "**** failed, to ONLINE device\n");
+			pr_debug("%s:%s:%d **** failed, to ONLINE device\n",
+				 skdev->name, __func__, __LINE__);
 		 /* connection is complete */
 		skdev->connect_retries = 0;
 		break;
@@ -2467,10 +2513,12 @@ static void skd_send_fitmsg(struct skd_device *skdev,
 	u64 qcmd;
 	struct fit_msg_hdr *fmh;
 
-	VPRINTK(skdev, "dma address 0x%llx, busy=%d\n",
-		skmsg->mb_dma_address, skdev->in_flight);
-	VPRINTK(skdev, "msg_buf 0x%p, offset %x\n",
-		skmsg->msg_buf, skmsg->offset);
+	pr_debug("%s:%s:%d dma address 0x%llx, busy=%d\n",
+		 skdev->name, __func__, __LINE__,
+		 skmsg->mb_dma_address, skdev->in_flight);
+	pr_debug("%s:%s:%d msg_buf 0x%p, offset %x\n",
+		 skdev->name, __func__, __LINE__,
+		 skmsg->msg_buf, skmsg->offset);
 
 	qcmd = skmsg->mb_dma_address;
 	qcmd |= FIT_QCMD_QID_NORMAL;
@@ -2482,11 +2530,12 @@ static void skd_send_fitmsg(struct skd_device *skdev,
 		u8 *bp = (u8 *)skmsg->msg_buf;
 		int i;
 		for (i = 0; i < skmsg->length; i += 8) {
-			VPRINTK(skdev, "  msg[%2d] %02x %02x %02x %02x "
-				"%02x %02x %02x %02x\n",
-				i, bp[i + 0], bp[i + 1], bp[i + 2],
-				bp[i + 3], bp[i + 4], bp[i + 5],
-				bp[i + 6], bp[i + 7]);
+			pr_debug("%s:%s:%d msg[%2d] %02x %02x %02x %02x "
+				 "%02x %02x %02x %02x\n",
+				 skdev->name, __func__, __LINE__,
+				 i, bp[i + 0], bp[i + 1], bp[i + 2],
+				 bp[i + 3], bp[i + 4], bp[i + 5],
+				 bp[i + 6], bp[i + 7]);
 			if (i == 0)
 				i = 64 - 8;
 		}
@@ -2520,26 +2569,28 @@ static void skd_send_special_fitmsg(struct skd_device *skdev,
 		int i;
 
 		for (i = 0; i < SKD_N_SPECIAL_FITMSG_BYTES; i += 8) {
-			VPRINTK(skdev,
-				"  spcl[%2d] %02x %02x %02x %02x  "
-				"%02x %02x %02x %02x\n", i,
-				bp[i + 0], bp[i + 1], bp[i + 2], bp[i + 3],
-				bp[i + 4], bp[i + 5], bp[i + 6], bp[i + 7]);
+			pr_debug("%s:%s:%d  spcl[%2d] %02x %02x %02x %02x  "
+				 "%02x %02x %02x %02x\n",
+				 skdev->name, __func__, __LINE__, i,
+				 bp[i + 0], bp[i + 1], bp[i + 2], bp[i + 3],
+				 bp[i + 4], bp[i + 5], bp[i + 6], bp[i + 7]);
 			if (i == 0)
 				i = 64 - 8;
 		}
 
-		VPRINTK(skdev, "skspcl=%p id=%04x sksg_list=%p sksg_dma=%llx\n",
-			skspcl, skspcl->req.id, skspcl->req.sksg_list,
-			skspcl->req.sksg_dma_address);
+		pr_debug("%s:%s:%d skspcl=%p id=%04x sksg_list=%p sksg_dma=%llx\n",
+			 skdev->name, __func__, __LINE__,
+			 skspcl, skspcl->req.id, skspcl->req.sksg_list,
+			 skspcl->req.sksg_dma_address);
 		for (i = 0; i < skspcl->req.n_sg; i++) {
 			struct fit_sg_descriptor *sgd =
 				&skspcl->req.sksg_list[i];
 
-			VPRINTK(skdev, "  sg[%d] count=%u ctrl=0x%x "
-				"addr=0x%llx next=0x%llx\n",
-				i, sgd->byte_count, sgd->control,
-				sgd->host_side_addr, sgd->next_desc_ptr);
+			pr_debug("%s:%s:%d   sg[%d] count=%u ctrl=0x%x "
+				 "addr=0x%llx next=0x%llx\n",
+				 skdev->name, __func__, __LINE__,
+				 i, sgd->byte_count, sgd->control,
+				 sgd->host_side_addr, sgd->next_desc_ptr);
 		}
 	}
 
@@ -2622,9 +2673,9 @@ static enum skd_check_status_action skd_check_status(struct skd_device *skdev,
 	       skd_name(skdev), skerr->key, skerr->code, skerr->qual,
 	       skerr->fruc);
 
-	VPRINTK(skdev, "stat: t=%02x stat=%02x k=%02x c=%02x q=%02x "
-		"fruc=%02x\n", skerr->type, cmp_status, skerr->key,
-		skerr->code, skerr->qual, skerr->fruc);
+	pr_debug("%s:%s:%d stat: t=%02x stat=%02x k=%02x c=%02x q=%02x fruc=%02x\n",
+		 skdev->name, __func__, __LINE__, skerr->type, cmp_status,
+		 skerr->key, skerr->code, skerr->qual, skerr->fruc);
 
 	/* Does the info match an entry in the good category? */
 	n = sizeof(skd_chkstat_table) / sizeof(skd_chkstat_table[0]);
@@ -2664,11 +2715,13 @@ static enum skd_check_status_action skd_check_status(struct skd_device *skdev,
 	 * zero status means good
 	 */
 	if (cmp_status) {
-		DPRINTK(skdev, "status check: error\n");
+		pr_debug("%s:%s:%d status check: error\n",
+			 skdev->name, __func__, __LINE__);
 		return SKD_CHECK_STATUS_REPORT_ERROR;
 	}
 
-	DPRINTK(skdev, "status check good default\n");
+	pr_debug("%s:%s:%d status check good default\n",
+		 skdev->name, __func__, __LINE__);
 	return SKD_CHECK_STATUS_REPORT_GOOD;
 }
 
@@ -2806,7 +2859,8 @@ static void skd_do_inq_page_00(struct skd_device *skdev,
 	/* Caller requested "supported pages".  The driver needs to insert
 	 * its page.
 	 */
-	VPRINTK(skdev, "skd_do_driver_inquiry: modify supported pages.\n");
+	pr_debug("%s:%s:%d skd_do_driver_inquiry: modify supported pages.\n",
+		 skdev->name, __func__, __LINE__);
 
 	/* If the device rejected the request because the CDB was
 	 * improperly formed, then just leave.
@@ -2903,7 +2957,8 @@ static void skd_do_inq_page_da(struct skd_device *skdev,
 	struct driver_inquiry_data inq;
 	u16 val;
 
-	VPRINTK(skdev, "skd_do_driver_inquiry: return driver page\n");
+	pr_debug("%s:%s:%d skd_do_driver_inquiry: return driver page\n",
+		 skdev->name, __func__, __LINE__);
 
 	memset(&inq, 0, sizeof(inq));
 
@@ -3035,14 +3090,16 @@ static int skd_isr_completion_posted(struct skd_device *skdev,
 
 		skerr = &skdev->skerr_table[skdev->skcomp_ix];
 
-		VPRINTK(skdev,
-			"cycle=%d ix=%d got cycle=%d cmdctxt=0x%x stat=%d "
-			"busy=%d rbytes=0x%x proto=%d\n", skdev->skcomp_cycle,
-			skdev->skcomp_ix, cmp_cycle, cmp_cntxt, cmp_status,
-			skdev->in_flight, cmp_bytes, skdev->proto_ver);
+		pr_debug("%s:%s:%d "
+			 "cycle=%d ix=%d got cycle=%d cmdctxt=0x%x stat=%d "
+			 "busy=%d rbytes=0x%x proto=%d\n",
+			 skdev->name, __func__, __LINE__, skdev->skcomp_cycle,
+			 skdev->skcomp_ix, cmp_cycle, cmp_cntxt, cmp_status,
+			 skdev->in_flight, cmp_bytes, skdev->proto_ver);
 
 		if (cmp_cycle != skdev->skcomp_cycle) {
-			VPRINTK(skdev, "end of completions\n");
+			pr_debug("%s:%s:%d end of completions\n",
+				 skdev->name, __func__, __LINE__);
 			break;
 		}
 		/*
@@ -3078,8 +3135,9 @@ static int skd_isr_completion_posted(struct skd_device *skdev,
 		 * Make sure the request ID for the slot matches.
 		 */
 		if (skreq->id != req_id) {
-			DPRINTK(skdev, "mismatch comp_id=0x%x req_id=0x%x\n",
-				req_id, skreq->id);
+			pr_debug("%s:%s:%d mismatch comp_id=0x%x req_id=0x%x\n",
+				 skdev->name, __func__, __LINE__,
+				 req_id, skreq->id);
 			{
 				u16 new_id = cmp_cntxt;
 				pr_err("(%s): Completion mismatch "
@@ -3094,8 +3152,9 @@ static int skd_isr_completion_posted(struct skd_device *skdev,
 		SKD_ASSERT(skreq->state == SKD_REQ_STATE_BUSY);
 
 		if (skreq->state == SKD_REQ_STATE_ABORTED) {
-			DPRINTK(skdev, "reclaim req %p id=%04x\n",
-				skreq, skreq->id);
+			pr_debug("%s:%s:%d reclaim req %p id=%04x\n",
+				 skdev->name, __func__, __LINE__,
+				 skreq, skreq->id);
 			/* a previously timed out command can
 			 * now be cleaned up */
 			skd_release_skreq(skdev, skreq);
@@ -3115,9 +3174,10 @@ static int skd_isr_completion_posted(struct skd_device *skdev,
 
 		if (((!skd_bio) && !skreq->req) ||
 		    ((skd_bio) && !skreq->bio)) {
-			DPRINTK(skdev, "NULL backptr skdreq %p, "
-				"req=0x%x req_id=0x%x\n",
-				skreq, skreq->id, req_id);
+			pr_debug("%s:%s:%d NULL backptr skdreq %p, "
+				 "req=0x%x req_id=0x%x\n",
+				 skdev->name, __func__, __LINE__,
+				 skreq, skreq->id, req_id);
 		} else {
 			/*
 			 * Capture the outcome and post it back to the
@@ -3186,8 +3246,9 @@ static void skd_complete_other(struct skd_device *skdev,
 	req_table = req_id & SKD_ID_TABLE_MASK;
 	req_slot = req_id & SKD_ID_SLOT_MASK;
 
-	DPRINTK(skdev, "table=0x%x id=0x%x slot=%d\n", req_table, req_id,
-		req_slot);
+	pr_debug("%s:%s:%d table=0x%x id=0x%x slot=%d\n",
+		 skdev->name, __func__, __LINE__,
+		 req_table, req_id, req_slot);
 
 	/*
 	 * Based on the request id, determine how to dispatch this completion.
@@ -3255,12 +3316,14 @@ static void skd_complete_special(struct skd_device *skdev,
 				 volatile struct fit_comp_error_info *skerr,
 				 struct skd_special_context *skspcl)
 {
-	DPRINTK(skdev, " completing special request %p\n", skspcl);
+	pr_debug("%s:%s:%d  completing special request %p\n",
+		 skdev->name, __func__, __LINE__, skspcl);
 	if (skspcl->orphaned) {
 		/* Discard orphaned request */
 		/* ?: Can this release directly or does it need
 		 * to use a worker? */
-		DPRINTK(skdev, "release orphaned %p\n", skspcl);
+		pr_debug("%s:%s:%d release orphaned %p\n",
+			 skdev->name, __func__, __LINE__, skspcl);
 		skd_release_special(skdev, skspcl);
 		return;
 	}
@@ -3298,7 +3361,8 @@ static void skd_release_special(struct skd_device *skdev,
 	skdev->skspcl_free_list = (struct skd_special_context *)skspcl;
 
 	if (was_depleted) {
-		DPRINTK(skdev, "skspcl was depleted\n");
+		pr_debug("%s:%s:%d skspcl was depleted\n",
+			 skdev->name, __func__, __LINE__);
 		/* Free list was depleted. Their might be waiters. */
 		wake_up_interruptible(&skdev->waitq);
 	}
@@ -3363,7 +3427,8 @@ static skd_isr(int irq, void *ptr)
 		ack = FIT_INT_DEF_MASK;
 		ack &= intstat;
 
-		VPRINTK(skdev, "intstat=0x%x ack=0x%x\n", intstat, ack);
+		pr_debug("%s:%s:%d intstat=0x%x ack=0x%x\n",
+			 skdev->name, __func__, __LINE__, intstat, ack);
 
 		/* As long as there is an int pending on device, keep
 		 * running loop.  When none, get out, but if we've never
@@ -3524,7 +3589,8 @@ static void skd_isr_fwstate(struct skd_device *skdev)
 		}
 		break;
 	case FIT_SR_DRIVE_FW_BOOTING:
-		VPRINTK(skdev, "ISR FIT_SR_DRIVE_FW_BOOTING %s\n", skdev->name);
+		pr_debug("%s:%s:%d ISR FIT_SR_DRIVE_FW_BOOTING %s\n",
+			 skdev->name, __func__, __LINE__, skdev->name);
 		skdev->state = SKD_DRVR_STATE_WAIT_BOOT;
 		skdev->timer_countdown = SKD_WAIT_BOOT_TIMO;
 		break;
@@ -3633,10 +3699,12 @@ static void skd_recover_requests(struct skd_device *skdev, int requeue)
 		 */
 		if (skspcl->req.state == SKD_REQ_STATE_BUSY) {
 			if (skspcl->orphaned) {
-				DPRINTK(skdev, "orphaned %p\n", skspcl);
+				pr_debug("%s:%s:%d orphaned %p\n",
+					 skdev->name, __func__, __LINE__, skspcl);
 				skd_release_special(skdev, skspcl);
 			} else {
-				DPRINTK(skdev, "not orphaned %p\n", skspcl);
+				pr_debug("%s:%s:%d not orphaned %p\n",
+					 skdev->name, __func__, __LINE__, skspcl);
 				skspcl->req.state = SKD_REQ_STATE_ABORTED;
 			}
 		}
@@ -3657,7 +3725,8 @@ static void skd_isr_msg_from_dev(struct skd_device *skdev)
 
 	mfd = SKD_READL(skdev, FIT_MSG_FROM_DEVICE);
 
-	DPRINTK(skdev, "mfd=0x%x last_mtd=0x%x\n", mfd, skdev->last_mtd);
+	pr_debug("%s:%s:%d mfd=0x%x last_mtd=0x%x\n",
+		 skdev->name, __func__, __LINE__, mfd, skdev->last_mtd);
 
 	/* ignore any mtd that is an ack for something we didn't send */
 	if (FIT_MXD_TYPE(mfd) != FIT_MXD_TYPE(skdev->last_mtd))
@@ -3752,7 +3821,8 @@ static void skd_disable_interrupts(struct skd_device *skdev)
 	sense = SKD_READL(skdev, FIT_CONTROL);
 	sense &= ~FIT_CR_ENABLE_INTERRUPTS;
 	SKD_WRITEL(skdev, sense, FIT_CONTROL);
-	DPRINTK(skdev, "sense 0x%x\n", sense);
+	pr_debug("%s:%s:%d sense 0x%x\n",
+		 skdev->name, __func__, __LINE__, sense);
 
 	/* Note that the 1s is written. A 1-bit means
 	 * disable, a 0 means enable.
@@ -3771,11 +3841,13 @@ static void skd_enable_interrupts(struct skd_device *skdev)
 	/* Note that the compliment of mask is written. A 1-bit means
 	 * disable, a 0 means enable. */
 	SKD_WRITEL(skdev, ~val, FIT_INT_MASK_HOST);
-	DPRINTK(skdev, "interrupt mask=0x%x\n", ~val);
+	pr_debug("%s:%s:%d interrupt mask=0x%x\n",
+		 skdev->name, __func__, __LINE__, ~val);
 
 	val = SKD_READL(skdev, FIT_CONTROL);
 	val |= FIT_CR_ENABLE_INTERRUPTS;
-	DPRINTK(skdev, "control=0x%x\n", val);
+	pr_debug("%s:%s:%d control=0x%x\n",
+		 skdev->name, __func__, __LINE__, val);
 	SKD_WRITEL(skdev, val, FIT_CONTROL);
 }
 
@@ -3791,7 +3863,8 @@ static void skd_soft_reset(struct skd_device *skdev)
 
 	val = SKD_READL(skdev, FIT_CONTROL);
 	val |= (FIT_CR_SOFT_RESET);
-	DPRINTK(skdev, "control=0x%x\n", val);
+	pr_debug("%s:%s:%d control=0x%x\n",
+		 skdev->name, __func__, __LINE__, val);
 	SKD_WRITEL(skdev, val, FIT_CONTROL);
 }
 
@@ -3808,7 +3881,8 @@ static void skd_start_device(struct skd_device *skdev)
 
 	sense = SKD_READL(skdev, FIT_STATUS);
 
-	DPRINTK(skdev, "initial status=0x%x\n", sense);
+	pr_debug("%s:%s:%d initial status=0x%x\n",
+		 skdev->name, __func__, __LINE__, sense);
 
 	state = sense & FIT_SR_DRIVE_STATE_MASK;
 	skdev->drive_state = state;
@@ -3825,7 +3899,8 @@ static void skd_start_device(struct skd_device *skdev)
 		break;
 
 	case FIT_SR_DRIVE_FW_BOOTING:
-		VPRINTK(skdev, "FIT_SR_DRIVE_FW_BOOTING %s\n", skdev->name);
+		pr_debug("%s:%s:%d FIT_SR_DRIVE_FW_BOOTING %s\n",
+			 skdev->name, __func__, __LINE__, skdev->name);
 		skdev->state = SKD_DRVR_STATE_WAIT_BOOT;
 		skdev->timer_countdown = SKD_WAIT_BOOT_TIMO;
 		break;
@@ -3866,7 +3941,8 @@ static void skd_start_device(struct skd_device *skdev)
 		 */
 		skd_drive_fault(skdev);
 		/*start the queue so we can respond with error to requests */
-		VPRINTK(skdev, "starting %s queue\n", skdev->name);
+		pr_debug("%s:%s:%d starting %s queue\n",
+			 skdev->name, __func__, __LINE__, skdev->name);
 		skd_start_queue(skdev);
 		skdev->gendisk_on = -1;
 		wake_up_interruptible(&skdev->waitq);
@@ -3877,8 +3953,8 @@ static void skd_start_device(struct skd_device *skdev)
 		 * to the BAR1 addresses. */
 		skd_drive_disappeared(skdev);
 		/*start the queue so we can respond with error to requests */
-		VPRINTK(skdev, "starting %s queue to error-out reqs\n",
-			skdev->name);
+		pr_debug("%s:%s:%d starting %s queue to error-out reqs\n",
+			 skdev->name, __func__, __LINE__, skdev->name);
 		skd_start_queue(skdev);
 		skdev->gendisk_on = -1;
 		wake_up_interruptible(&skdev->waitq);
@@ -3891,19 +3967,24 @@ static void skd_start_device(struct skd_device *skdev)
 	}
 
 	state = SKD_READL(skdev, FIT_CONTROL);
-	DPRINTK(skdev, "FIT Control Status=0x%x\n", state);
+	pr_debug("%s:%s:%d FIT Control Status=0x%x\n",
+		 skdev->name, __func__, __LINE__, state);
 
 	state = SKD_READL(skdev, FIT_INT_STATUS_HOST);
-	DPRINTK(skdev, "Intr Status=0x%x\n", state);
+	pr_debug("%s:%s:%d Intr Status=0x%x\n",
+		 skdev->name, __func__, __LINE__, state);
 
 	state = SKD_READL(skdev, FIT_INT_MASK_HOST);
-	DPRINTK(skdev, "Intr Mask=0x%x\n", state);
+	pr_debug("%s:%s:%d Intr Mask=0x%x\n",
+		 skdev->name, __func__, __LINE__, state);
 
 	state = SKD_READL(skdev, FIT_MSG_FROM_DEVICE);
-	DPRINTK(skdev, "Msg from Dev=0x%x\n", state);
+	pr_debug("%s:%s:%d Msg from Dev=0x%x\n",
+		 skdev->name, __func__, __LINE__, state);
 
 	state = SKD_READL(skdev, FIT_HW_VERSION);
-	DPRINTK(skdev, "HW version=0x%x\n", state);
+	pr_debug("%s:%s:%d HW version=0x%x\n",
+		 skdev->name, __func__, __LINE__, state);
 
 	spin_unlock_irqrestore(&skdev->lock, flags);
 }
@@ -3996,7 +4077,8 @@ static void skd_restart_device(struct skd_device *skdev)
 
 	state = SKD_READL(skdev, FIT_STATUS);
 
-	DPRINTK(skdev, "drive status=0x%x\n", state);
+	pr_debug("%s:%s:%d drive status=0x%x\n",
+		 skdev->name, __func__, __LINE__, state);
 
 	state &= FIT_SR_DRIVE_STATE_MASK;
 	skdev->drive_state = state;
@@ -4016,7 +4098,8 @@ static int skd_quiesce_dev(struct skd_device *skdev)
 	switch (skdev->state) {
 	case SKD_DRVR_STATE_BUSY:
 	case SKD_DRVR_STATE_BUSY_IMMINENT:
-		VPRINTK(skdev, "stopping %s queue\n", skdev->name);
+		pr_debug("%s:%s:%d stopping %s queue\n",
+			 skdev->name, __func__, __LINE__, skdev->name);
 		skd_stop_queue(skdev);
 		break;
 	case SKD_DRVR_STATE_ONLINE:
@@ -4029,7 +4112,8 @@ static int skd_quiesce_dev(struct skd_device *skdev)
 	case SKD_DRVR_STATE_RESUMING:
 	default:
 		rc = -EINVAL;
-		VPRINTK(skdev, "state [%d] not implemented\n", skdev->state);
+		pr_debug("%s:%s:%d state [%d] not implemented\n",
+			 skdev->name, __func__, __LINE__, skdev->state);
 	}
 	return rc;
 }
@@ -4041,7 +4125,8 @@ static int skd_unquiesce_dev(struct skd_device *skdev)
 
 	skd_log_skdev(skdev, "unquiesce");
 	if (skdev->state == SKD_DRVR_STATE_ONLINE) {
-		DPRINTK(skdev, "**** device already ONLINE\n");
+		pr_debug("%s:%s:%d **** device already ONLINE\n",
+			 skdev->name, __func__, __LINE__);
 		return 0;
 	}
 	if (skdev->drive_state != FIT_SR_DRIVE_ONLINE) {
@@ -4054,7 +4139,8 @@ static int skd_unquiesce_dev(struct skd_device *skdev)
 		 * to become available.
 		 */
 		skdev->state = SKD_DRVR_STATE_BUSY;
-		DPRINTK(skdev, "drive BUSY state\n");
+		pr_debug("%s:%s:%d drive BUSY state\n",
+			 skdev->name, __func__, __LINE__);
 		return 0;
 	}
 
@@ -4078,8 +4164,10 @@ static int skd_unquiesce_dev(struct skd_device *skdev)
 		       skd_skdev_state_to_str(prev_driver_state),
 		       prev_driver_state, skd_skdev_state_to_str(skdev->state),
 		       skdev->state);
-		DPRINTK(skdev, "**** device ONLINE...starting block queue\n");
-		VPRINTK(skdev, "starting %s queue\n", skdev->name);
+		pr_debug("%s:%s:%d **** device ONLINE...starting block queue\n",
+			 skdev->name, __func__, __LINE__);
+		pr_debug("%s:%s:%d starting %s queue\n",
+			 skdev->name, __func__, __LINE__, skdev->name);
 		pr_info("(%s): STEC s1120 ONLINE\n", skd_name(skdev));
 		skd_start_queue(skdev);
 		skdev->gendisk_on = 1;
@@ -4088,8 +4176,9 @@ static int skd_unquiesce_dev(struct skd_device *skdev)
 
 	case SKD_DRVR_STATE_DISAPPEARED:
 	default:
-		DPRINTK(skdev, "**** driver state %d, not implemented \n",
-			skdev->state);
+		pr_debug("%s:%s:%d **** driver state %d, not implemented \n",
+			 skdev->name, __func__, __LINE__,
+			 skdev->state);
 		return -EBUSY;
 	}
 	return 0;
@@ -4107,7 +4196,9 @@ static irqreturn_t skd_reserved_isr(int irq, void *skd_host_data)
 	unsigned long flags;
 
 	spin_lock_irqsave(&skdev->lock, flags);
-	VPRINTK(skdev, "MSIX = 0x%x\n", SKD_READL(skdev, FIT_INT_STATUS_HOST));
+	pr_debug("%s:%s:%d MSIX = 0x%x\n",
+		 skdev->name, __func__, __LINE__,
+		 SKD_READL(skdev, FIT_INT_STATUS_HOST));
 	pr_err("(%s): MSIX reserved irq %d = 0x%x\n", skd_name(skdev),
 	       irq, SKD_READL(skdev, FIT_INT_STATUS_HOST));
 	SKD_WRITEL(skdev, FIT_INT_RESERVED_MASK, FIT_INT_STATUS_HOST);
@@ -4121,7 +4212,9 @@ static irqreturn_t skd_statec_isr(int irq, void *skd_host_data)
 	unsigned long flags;
 
 	spin_lock_irqsave(&skdev->lock, flags);
-	VPRINTK(skdev, "MSIX = 0x%x\n", SKD_READL(skdev, FIT_INT_STATUS_HOST));
+	pr_debug("%s:%s:%d MSIX = 0x%x\n",
+		 skdev->name, __func__, __LINE__,
+		 SKD_READL(skdev, FIT_INT_STATUS_HOST));
 	SKD_WRITEL(skdev, FIT_ISH_FW_STATE_CHANGE, FIT_INT_STATUS_HOST);
 	skd_isr_fwstate(skdev);
 	spin_unlock_irqrestore(&skdev->lock, flags);
@@ -4136,7 +4229,9 @@ static irqreturn_t skd_comp_q(int irq, void *skd_host_data)
 	int deferred;
 
 	spin_lock_irqsave(&skdev->lock, flags);
-	VPRINTK(skdev, "MSIX = 0x%x\n", SKD_READL(skdev, FIT_INT_STATUS_HOST));
+	pr_debug("%s:%s:%d MSIX = 0x%x\n",
+		 skdev->name, __func__, __LINE__,
+		 SKD_READL(skdev, FIT_INT_STATUS_HOST));
 	SKD_WRITEL(skdev, FIT_ISH_COMPLETION_POSTED, FIT_INT_STATUS_HOST);
 	deferred = skd_isr_completion_posted(skdev, skd_isr_comp_limit,
 						&flush_enqueued);
@@ -4160,7 +4255,9 @@ static irqreturn_t skd_msg_isr(int irq, void *skd_host_data)
 	unsigned long flags;
 
 	spin_lock_irqsave(&skdev->lock, flags);
-	VPRINTK(skdev, "MSIX = 0x%x\n", SKD_READL(skdev, FIT_INT_STATUS_HOST));
+	pr_debug("%s:%s:%d MSIX = 0x%x\n",
+		 skdev->name, __func__, __LINE__,
+		 SKD_READL(skdev, FIT_INT_STATUS_HOST));
 	SKD_WRITEL(skdev, FIT_ISH_MSG_FROM_DEV, FIT_INT_STATUS_HOST);
 	skd_isr_msg_from_dev(skdev);
 	spin_unlock_irqrestore(&skdev->lock, flags);
@@ -4173,7 +4270,9 @@ static irqreturn_t skd_qfull_isr(int irq, void *skd_host_data)
 	unsigned long flags;
 
 	spin_lock_irqsave(&skdev->lock, flags);
-	VPRINTK(skdev, "MSIX = 0x%x\n", SKD_READL(skdev, FIT_INT_STATUS_HOST));
+	pr_debug("%s:%s:%d MSIX = 0x%x\n",
+		 skdev->name, __func__, __LINE__,
+		 SKD_READL(skdev, FIT_INT_STATUS_HOST));
 	SKD_WRITEL(skdev, FIT_INT_QUEUE_FULL, FIT_INT_STATUS_HOST);
 	spin_unlock_irqrestore(&skdev->lock, flags);
 	return IRQ_HANDLED;
@@ -4265,8 +4364,9 @@ static int skd_acquire_msix(struct skd_device *skdev)
 			       skd_name(skdev), rc);
 			goto msix_out;
 		}
-		DPRINTK(skdev, "%s: <%s> allocated %d MSI-X vectors\n",
-			pci_name(pdev), skdev->name, rc);
+		pr_debug("%s:%s:%d %s: <%s> allocated %d MSI-X vectors\n",
+			 skdev->name, __func__, __LINE__,
+			 pci_name(pdev), skdev->name, rc);
 
 		skdev->msix_count = rc;
 		rc = pci_enable_msix(pdev, entries, skdev->msix_count);
@@ -4293,9 +4393,10 @@ static int skd_acquire_msix(struct skd_device *skdev)
 		qentry->entry = entries[i].entry;
 		qentry->rsp = NULL;
 		qentry->have_irq = 0;
-		DPRINTK(skdev, "%s: <%s> msix (%d) vec %d, entry %x\n",
-			pci_name(pdev), skdev->name,
-			i, qentry->vector, qentry->entry);
+		pr_debug("%s:%s:%d %s: <%s> msix (%d) vec %d, entry %x\n",
+			 skdev->name, __func__, __LINE__,
+			 pci_name(pdev), skdev->name,
+			 i, qentry->vector, qentry->entry);
 		qentry++;
 	}
 
@@ -4318,8 +4419,9 @@ static int skd_acquire_msix(struct skd_device *skdev)
 			qentry->rsp = skdev;
 		}
 	}
-	DPRINTK(skdev, "%s: <%s> msix %d irq(s) enabled\n",
-		pci_name(pdev), skdev->name, skdev->msix_count);
+	pr_debug("%s:%s:%d %s: <%s> msix %d irq(s) enabled\n",
+		 skdev->name, __func__, __LINE__,
+		 pci_name(pdev), skdev->name, skdev->msix_count);
 	return 0;
 
 msix_out:
@@ -4479,43 +4581,41 @@ static struct skd_device *skd_construct(struct pci_dev *pdev)
 	INIT_WORK(&skdev->completion_worker, skd_completion_worker);
 	INIT_LIST_HEAD(&skdev->flush_list);
 
-	VPRINTK(skdev, "skcomp\n");
+	pr_debug("%s:%s:%d skcomp\n", skdev->name, __func__, __LINE__);
 	rc = skd_cons_skcomp(skdev);
 	if (rc < 0)
 		goto err_out;
 
-	VPRINTK(skdev, "skmsg\n");
+	pr_debug("%s:%s:%d skmsg\n", skdev->name, __func__, __LINE__);
 	rc = skd_cons_skmsg(skdev);
 	if (rc < 0)
 		goto err_out;
 
-	VPRINTK(skdev, "skreq\n");
+	pr_debug("%s:%s:%d skreq\n", skdev->name, __func__, __LINE__);
 	rc = skd_cons_skreq(skdev);
 	if (rc < 0)
 		goto err_out;
 
-	VPRINTK(skdev, "skspcl\n");
+	pr_debug("%s:%s:%d skspcl\n", skdev->name, __func__, __LINE__);
 	rc = skd_cons_skspcl(skdev);
 	if (rc < 0)
 		goto err_out;
 
-	VPRINTK(skdev, "sksb\n");
+	pr_debug("%s:%s:%d sksb\n", skdev->name, __func__, __LINE__);
 	rc = skd_cons_sksb(skdev);
 	if (rc < 0)
 		goto err_out;
 
-	VPRINTK(skdev, "disk\n");
+	pr_debug("%s:%s:%d disk\n", skdev->name, __func__, __LINE__);
 	rc = skd_cons_disk(skdev);
 	if (rc < 0)
 		goto err_out;
 
-
-
-	DPRINTK(skdev, "VICTORY\n");
+	pr_debug("%s:%s:%d VICTORY\n", skdev->name, __func__, __LINE__);
 	return skdev;
 
 err_out:
-	DPRINTK(skdev, "construct failed\n");
+	pr_debug("%s:%s:%d construct failed\n", skdev->name, __func__, __LINE__);
 	skd_destruct(skdev);
 	return NULL;
 }
@@ -4529,8 +4629,9 @@ static int skd_cons_skcomp(struct skd_device *skdev)
 	nbytes = sizeof(*skcomp) * SKD_N_COMPLETION_ENTRY;
 	nbytes += sizeof(struct fit_comp_error_info) * SKD_N_COMPLETION_ENTRY;
 
-	VPRINTK(skdev, "comp pci_alloc, total bytes %d entries %d\n", nbytes,
-		SKD_N_COMPLETION_ENTRY);
+	pr_debug("%s:%s:%d comp pci_alloc, total bytes %d entries %d\n",
+		 skdev->name, __func__, __LINE__,
+		 nbytes, SKD_N_COMPLETION_ENTRY);
 
 	skcomp = pci_alloc_consistent(skdev->pdev, nbytes,
 				      &skdev->cq_dma_address);
@@ -4556,10 +4657,11 @@ static int skd_cons_skmsg(struct skd_device *skdev)
 	int rc = 0;
 	u32 i;
 
-	VPRINTK(skdev, "skmsg_table kzalloc, struct %u, count %u total %lu\n",
-		sizeof(struct skd_fitmsg_context),
-		skdev->num_fitmsg_context,
-		(unsigned long) sizeof(struct skd_fitmsg_context) *
+	pr_debug("%s:%s:%d skmsg_table kzalloc, struct %u, count %u total %lu\n",
+		 skdev->name, __func__, __LINE__,
+		 sizeof(struct skd_fitmsg_context),
+		 skdev->num_fitmsg_context,
+		 (unsigned long) sizeof(struct skd_fitmsg_context) *
 					skdev->num_fitmsg_context);
 
 	skdev->skmsg_table = kzalloc(sizeof(struct skd_fitmsg_context)
@@ -4611,10 +4713,11 @@ static int skd_cons_skreq(struct skd_device *skdev)
 	int rc = 0;
 	u32 i;
 
-	VPRINTK(skdev, "skreq_table kzalloc, struct %u, count %u total %u\n",
-		sizeof(struct skd_request_context),
-		skdev->num_req_context,
-		sizeof(struct skd_request_context) * skdev->num_req_context);
+	pr_debug("%s:%s:%d skreq_table kzalloc, struct %u, count %u total %u\n",
+		 skdev->name, __func__, __LINE__,
+		 sizeof(struct skd_request_context),
+		 skdev->num_req_context,
+		 sizeof(struct skd_request_context) * skdev->num_req_context);
 
 	skdev->skreq_table = kzalloc(sizeof(struct skd_request_context)
 				     * skdev->num_req_context, GFP_KERNEL);
@@ -4623,9 +4726,10 @@ static int skd_cons_skreq(struct skd_device *skdev)
 		goto err_out;
 	}
 
-	VPRINTK(skdev, "alloc sg_table sg_per_req %u scatlist %u total %u\n",
-		skdev->sgs_per_request, sizeof(struct scatterlist),
-		skdev->sgs_per_request * sizeof(struct scatterlist));
+	pr_debug("%s:%s:%d alloc sg_table sg_per_req %u scatlist %u total %u\n",
+		 skdev->name, __func__, __LINE__,
+		 skdev->sgs_per_request, sizeof(struct scatterlist),
+		 skdev->sgs_per_request * sizeof(struct scatterlist));
 
 	for (i = 0; i < skdev->num_req_context; i++) {
 		struct skd_request_context *skreq;
@@ -4668,10 +4772,11 @@ static int skd_cons_skspcl(struct skd_device *skdev)
 	int rc = 0;
 	u32 i, nbytes;
 
-	VPRINTK(skdev, "skspcl_table kzalloc, struct %u, count %u total %u\n",
-		sizeof(struct skd_special_context),
-		skdev->n_special,
-		sizeof(struct skd_special_context) * skdev->n_special);
+	pr_debug("%s:%s:%d skspcl_table kzalloc, struct %u, count %u total %u\n",
+		 skdev->name, __func__, __LINE__,
+		 sizeof(struct skd_special_context),
+		 skdev->n_special,
+		 sizeof(struct skd_special_context) * skdev->n_special);
 
 	skdev->skspcl_table = kzalloc(sizeof(struct skd_special_context)
 				      * skdev->n_special, GFP_KERNEL);
@@ -4863,7 +4968,8 @@ static int skd_cons_disk(struct skd_device *skdev)
 	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, q);
 
 	spin_lock_irqsave(&skdev->lock, flags);
-	VPRINTK(skdev, "stopping %s queue\n", skdev->name);
+	pr_debug("%s:%s:%d stopping %s queue\n",
+		 skdev->name, __func__, __LINE__, skdev->name);
 	skd_stop_queue(skdev);
 	spin_unlock_irqrestore(&skdev->lock, flags);
 
@@ -4893,25 +4999,25 @@ static void skd_destruct(struct skd_device *skdev)
 		return;
 
 
-	VPRINTK(skdev, "disk\n");
+	pr_debug("%s:%s:%d disk\n", skdev->name, __func__, __LINE__);
 	skd_free_disk(skdev);
 
-	VPRINTK(skdev, "sksb\n");
+	pr_debug("%s:%s:%d sksb\n", skdev->name, __func__, __LINE__);
 	skd_free_sksb(skdev);
 
-	VPRINTK(skdev, "skspcl\n");
+	pr_debug("%s:%s:%d skspcl\n", skdev->name, __func__, __LINE__);
 	skd_free_skspcl(skdev);
 
-	VPRINTK(skdev, "skreq\n");
+	pr_debug("%s:%s:%d skreq\n", skdev->name, __func__, __LINE__);
 	skd_free_skreq(skdev);
 
-	VPRINTK(skdev, "skmsg\n");
+	pr_debug("%s:%s:%d skmsg\n", skdev->name, __func__, __LINE__);
 	skd_free_skmsg(skdev);
 
-	VPRINTK(skdev, "skcomp\n");
+	pr_debug("%s:%s:%d skcomp\n", skdev->name, __func__, __LINE__);
 	skd_free_skcomp(skdev);
 
-	VPRINTK(skdev, "skdev\n");
+	pr_debug("%s:%s:%d skdev\n", skdev->name, __func__, __LINE__);
 	kfree(skdev);
 }
 
@@ -5097,8 +5203,9 @@ static int skd_bdev_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 
 	skdev = bdev->bd_disk->private_data;
 
-	DPRINTK(skdev, "%s: CMD[%s] getgeo device\n",
-		bdev->bd_disk->disk_name, current->comm);
+	pr_debug("%s:%s:%d %s: CMD[%s] getgeo device\n",
+		 skdev->name, __func__, __LINE__,
+		 bdev->bd_disk->disk_name, current->comm);
 
 	if (skdev->read_cap_is_valid) {
 		capacity = get_capacity(skdev->disk);
@@ -5113,7 +5220,7 @@ static int skd_bdev_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 
 static int skd_bdev_attach(struct skd_device *skdev)
 {
-	DPRINTK(skdev, "add_disk\n");
+	pr_debug("%s:%s:%d add_disk\n", skdev->name, __func__, __LINE__);
 	add_disk(skdev->disk);
 	return 0;
 }
@@ -5236,9 +5343,10 @@ static int skd_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			rc = -ENODEV;
 			goto err_out_iounmap;
 		}
-		DPRINTK(skdev, "mem_map=%p, phyd=%016llx, size=%d\n",
-			skdev->mem_map[i],
-			(uint64_t)skdev->mem_phys[i], skdev->mem_size[i]);
+		pr_debug("%s:%s:%d mem_map=%p, phyd=%016llx, size=%d\n",
+			 skdev->name, __func__, __LINE__,
+			 skdev->mem_map[i],
+			 (uint64_t)skdev->mem_phys[i], skdev->mem_size[i]);
 	}
 
 	rc = skd_acquire_irq(skdev);
@@ -5432,9 +5540,10 @@ static int skd_pci_resume(struct pci_dev *pdev)
 			rc = -ENODEV;
 			goto err_out_iounmap;
 		}
-		DPRINTK(skdev, "mem_map=%p, phyd=%016llx, size=%d\n",
-			skdev->mem_map[i],
-			(uint64_t)skdev->mem_phys[i], skdev->mem_size[i]);
+		pr_debug("%s:%s:%d mem_map=%p, phyd=%016llx, size=%d\n",
+			 skdev->name, __func__, __LINE__,
+			 skdev->mem_map[i],
+			 (uint64_t)skdev->mem_phys[i], skdev->mem_size[i]);
 	}
 	rc = skd_acquire_irq(skdev);
 	if (rc) {
@@ -5634,35 +5743,44 @@ const char *skd_skreq_state_to_str(enum skd_req_state state)
 
 static void skd_log_skdev(struct skd_device *skdev, const char *event)
 {
-	DPRINTK(skdev, "(%s) skdev=%p event='%s'\n", skdev->name, skdev, event);
-	DPRINTK(skdev, "  drive_state=%s(%d) driver_state=%s(%d)\n",
-		skd_drive_state_to_str(skdev->drive_state), skdev->drive_state,
-		skd_skdev_state_to_str(skdev->state), skdev->state);
-	DPRINTK(skdev, "  busy=%d limit=%d dev=%d lowat=%d\n",
-		skdev->in_flight, skdev->cur_max_queue_depth,
-		skdev->dev_max_queue_depth, skdev->queue_low_water_mark);
-	DPRINTK(skdev, "  timestamp=0x%x cycle=%d cycle_ix=%d\n",
-		skdev->timeout_stamp, skdev->skcomp_cycle, skdev->skcomp_ix);
+	pr_debug("%s:%s:%d (%s) skdev=%p event='%s'\n",
+		 skdev->name, __func__, __LINE__, skdev->name, skdev, event);
+	pr_debug("%s:%s:%d   drive_state=%s(%d) driver_state=%s(%d)\n",
+		 skdev->name, __func__, __LINE__,
+		 skd_drive_state_to_str(skdev->drive_state), skdev->drive_state,
+		 skd_skdev_state_to_str(skdev->state), skdev->state);
+	pr_debug("%s:%s:%d   busy=%d limit=%d dev=%d lowat=%d\n",
+		 skdev->name, __func__, __LINE__,
+		 skdev->in_flight, skdev->cur_max_queue_depth,
+		 skdev->dev_max_queue_depth, skdev->queue_low_water_mark);
+	pr_debug("%s:%s:%d   timestamp=0x%x cycle=%d cycle_ix=%d\n",
+		 skdev->name, __func__, __LINE__,
+		 skdev->timeout_stamp, skdev->skcomp_cycle, skdev->skcomp_ix);
 }
 
 static void skd_log_skmsg(struct skd_device *skdev,
 			  struct skd_fitmsg_context *skmsg, const char *event)
 {
-	DPRINTK(skdev, "(%s) skmsg=%p event='%s'\n", skdev->name, skmsg, event);
-	DPRINTK(skdev, "  state=%s(%d) id=0x%04x length=%d\n",
-		skd_skmsg_state_to_str(skmsg->state), skmsg->state,
-		skmsg->id, skmsg->length);
+	pr_debug("%s:%s:%d (%s) skmsg=%p event='%s'\n",
+		 skdev->name, __func__, __LINE__, skdev->name, skmsg, event);
+	pr_debug("%s:%s:%d   state=%s(%d) id=0x%04x length=%d\n",
+		 skdev->name, __func__, __LINE__,
+		 skd_skmsg_state_to_str(skmsg->state), skmsg->state,
+		 skmsg->id, skmsg->length);
 }
 
 static void skd_log_skreq(struct skd_device *skdev,
 			  struct skd_request_context *skreq, const char *event)
 {
-	DPRINTK(skdev, "(%s) skreq=%p event='%s'\n", skdev->name, skreq, event);
-	DPRINTK(skdev, "  state=%s(%d) id=0x%04x fitmsg=0x%04x\n",
-		skd_skreq_state_to_str(skreq->state), skreq->state,
-		skreq->id, skreq->fitmsg_id);
-	DPRINTK(skdev, "  timo=0x%x sg_dir=%d n_sg=%d\n",
-		skreq->timeout_stamp, skreq->sg_data_dir, skreq->n_sg);
+	pr_debug("%s:%s:%d (%s) skreq=%p event='%s'\n",
+		 skdev->name, __func__, __LINE__, skdev->name, skreq, event);
+	pr_debug("%s:%s:%d   state=%s(%d) id=0x%04x fitmsg=0x%04x\n",
+		 skdev->name, __func__, __LINE__,
+		 skd_skreq_state_to_str(skreq->state), skreq->state,
+		 skreq->id, skreq->fitmsg_id);
+	pr_debug("%s:%s:%d   timo=0x%x sg_dir=%d n_sg=%d\n",
+		 skdev->name, __func__, __LINE__,
+		 skreq->timeout_stamp, skreq->sg_data_dir, skreq->n_sg);
 
 	if (!skd_bio) {
 		if (skreq->req != NULL) {
@@ -5670,24 +5788,28 @@ static void skd_log_skreq(struct skd_device *skdev,
 			u32 lba = (u32)blk_rq_pos(req);
 			u32 count = blk_rq_sectors(req);
 
-			DPRINTK(skdev,
-				"  req=%p lba=%u(0x%x) count=%u(0x%x) dir=%d\n",
-				req, lba, lba, count, count,
-				(int)rq_data_dir(req));
+			pr_debug("%s:%s:%d "
+				 "req=%p lba=%u(0x%x) count=%u(0x%x) dir=%d\n",
+				 skdev->name, __func__, __LINE__,
+				 req, lba, lba, count, count,
+				 (int)rq_data_dir(req));
 		} else
-			DPRINTK(skdev, "  req=NULL\n");
+			pr_debug("%s:%s:%d req=NULL\n",
+				 skdev->name, __func__, __LINE__);
 	} else {
 		if (skreq->bio != NULL) {
 			struct bio *bio = skreq->bio;
 			u32 lba = (u32)bio->bi_sector;
 			u32 count = bio_sectors(bio);
 
-			DPRINTK(skdev,
-				"  bio=%p lba=%u(0x%x) count=%u(0x%x) dir=%d\n",
-				bio, lba, lba, count, count,
-				(int)bio_data_dir(bio));
+			pr_debug("%s:%s:%d "
+				 "bio=%p lba=%u(0x%x) count=%u(0x%x) dir=%d\n",
+				 skdev->name, __func__, __LINE__,
+				 bio, lba, lba, count, count,
+				 (int)bio_data_dir(bio));
 		} else
-			DPRINTK(skdev, "  req=NULL\n");
+			pr_debug("%s:%s:%d req=NULL\n",
+				 skdev->name, __func__, __LINE__);
 	}
 }
 
-- 
1.7.5.4
