Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522AbaJWMc7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 08:32:59 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:42915 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755323AbaJWMcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 08:32:55 -0400
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: remove unused label
Date: Thu, 23 Oct 2014 18:02:39 +0530
Message-Id: <1414067559-1828-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit "374f8fdea4aabec8e918cf9951e51bfa4f570ea8" has fixed a problem by
jumping to the correct label,but the previous incorrect label was not
removed and it was still there in the code unused.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 block/scsi_ioctl.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index cc7927a..1e053d9 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -517,7 +517,6 @@ int sg_scsi_ioctl(struct request_queue *q, struct gendisk *disk, fmode_t mode,
 
 	blk_execute_rq(q, disk, rq, 0);
 
-out:
 	err = rq->errors & 0xff;	/* only 8 bit SCSI status */
 	if (err) {
 		if (rq->sense_len && rq->sense) {
-- 
1.8.1.2

