Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597AbaFFWge (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 18:36:34 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:46683 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366AbaFFWgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 18:36:33 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: [PATCH] block: blk-exec.c:  Cleaning up local variable address returnd
Date: Sat,  7 Jun 2014 00:37:26 +0200
Message-Id: <1402094247-7998-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Address of local variable assigned to a function parameter

This was partly found using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 block/blk-exec.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/block/blk-exec.c b/block/blk-exec.c
index dbf4502..f4d27b1 100644
--- a/block/blk-exec.c
+++ b/block/blk-exec.c
@@ -132,6 +132,11 @@ int blk_execute_rq(struct request_queue *q, struct gendisk *bd_disk,
 	if (rq->errors)
 		err = -EIO;
 
+	if (rq->sense == sense)	{
+		rq->sense = NULL;
+		rq->sense_len = 0;
+	}
+
 	return err;
 }
 EXPORT_SYMBOL(blk_execute_rq);
-- 
1.7.10.4

