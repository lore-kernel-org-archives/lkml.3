Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbbAHKEl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 05:04:41 -0500
Received: from cpanel09.rubas.ch ([195.182.222.79]:57916 "EHLO
	cpanel09.tophost.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbbAHKEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 05:04:39 -0500
From: =?UTF-8?q?J=C3=BCrg=20Billeter?= <j@bitron.ch>
To: Jens Axboe <axboe@fb.com>
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?J=C3=BCrg=20Billeter?= <j@bitron.ch>
Subject: [PATCH] null_blk: fix blk_mq_init_queue() error handling
Date: Thu,  8 Jan 2015 11:04:16 +0100
Message-Id: <1420711456-17257-1-git-send-email-j@bitron.ch>
X-Mailer: git-send-email 2.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cpanel09.tophost.ch
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - bitron.ch
X-Get-Message-Sender-Via: cpanel09.tophost.ch: authenticated_id: juerg@bitron.ch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blk_mq_init_queue() returns ERR_PTR() on failure, not NULL.

Signed-off-by: Jürg Billeter <j@bitron.ch>
---
 drivers/block/null_blk.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/null_blk.c b/drivers/block/null_blk.c
index ae9f615..727309c 100644
--- a/drivers/block/null_blk.c
+++ b/drivers/block/null_blk.c
@@ -530,8 +530,8 @@ static int null_add_dev(void)
 			goto out_cleanup_queues;
 
 		nullb->q = blk_mq_init_queue(&nullb->tag_set);
-		if (!nullb->q) {
-			rv = -ENOMEM;
+		if (IS_ERR(nullb->q)) {
+			rv = PTR_ERR(nullb->q);
 			goto out_cleanup_tags;
 		}
 	} else if (queue_mode == NULL_Q_BIO) {
-- 
2.2.1

