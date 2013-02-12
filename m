Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933669Ab3BLSDy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 13:03:54 -0500
Received: from mail.tpi.com ([70.99.223.143]:3183 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932370Ab3BLSDw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 13:03:52 -0500
From: Tim Gardner <tim.gardner@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>,
        Tyler Hicks <tyhicks@canonical.com>,
        Dustin Kirkland <dustin.kirkland@gazzang.com>,
        ecryptfs@vger.kernel.org
Subject: [PATCH linux-next] ecryptfs: ecryptfs_msg_ctx_alloc_to_free(): remove kfree() redundant null check
Date: Tue, 12 Feb 2013 11:03:49 -0700
Message-Id: <1360692229-60655-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

smatch analysis:

fs/ecryptfs/messaging.c:101 ecryptfs_msg_ctx_alloc_to_free() info:
 redundant null check on msg_ctx->msg calling kfree()

Cc: Tyler Hicks <tyhicks@canonical.com>
Cc: Dustin Kirkland <dustin.kirkland@gazzang.com>
Cc: ecryptfs@vger.kernel.org
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 fs/ecryptfs/messaging.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ecryptfs/messaging.c b/fs/ecryptfs/messaging.c
index 8d7a577..308fdf2 100644
--- a/fs/ecryptfs/messaging.c
+++ b/fs/ecryptfs/messaging.c
@@ -97,8 +97,7 @@ static void ecryptfs_msg_ctx_free_to_alloc(struct ecryptfs_msg_ctx *msg_ctx)
 void ecryptfs_msg_ctx_alloc_to_free(struct ecryptfs_msg_ctx *msg_ctx)
 {
 	list_move(&(msg_ctx->node), &ecryptfs_msg_ctx_free_list);
-	if (msg_ctx->msg)
-		kfree(msg_ctx->msg);
+	kfree(msg_ctx->msg);
 	msg_ctx->msg = NULL;
 	msg_ctx->state = ECRYPTFS_MSG_CTX_STATE_FREE;
 }
-- 
1.7.9.5

