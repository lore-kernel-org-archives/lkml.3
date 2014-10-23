Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932562AbaJWSX2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 14:23:28 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:24706 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932423AbaJWSXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 14:23:25 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqASAGBGSVRbtA79/2dsb2JhbABcgw66QwUBdJo4BAKBExcBfYQwLyOBGjeIRQG6F453hiWKMx2ENQWdXYxoiUWBRwGCMjsvgksBAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/1 linux-next] scsi: remove unused label in sg_scsi_ioctl()
Date: Thu, 23 Oct 2014 20:23:21 +0200
Message-Id: <1414088601-24249-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

label 'out' is unused since commit 374f8fdea4aa
("scsi: Fix error handling in SCSI_IOCTL_SEND_COMMAND")

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 block/scsi_ioctl.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index cc7927a..d1ae462 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -516,8 +516,6 @@ int sg_scsi_ioctl(struct request_queue *q, struct gendisk *disk, fmode_t mode,
 	rq->sense_len = 0;
 
 	blk_execute_rq(q, disk, rq, 0);
-
-out:
 	err = rq->errors & 0xff;	/* only 8 bit SCSI status */
 	if (err) {
 		if (rq->sense_len && rq->sense) {
-- 
1.9.3

