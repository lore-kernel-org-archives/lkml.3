Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758527Ab3FAJjo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 05:39:44 -0400
Received: from www17.your-server.de ([213.133.104.17]:58709 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758486Ab3FAJji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 05:39:38 -0400
Message-ID: <1370079576.29224.7.camel@localhost.localdomain>
Subject: [PATCH] eCryptfs: Cocci spatch "memdup.spatch"
From: Thomas Meyer <thomas@m3y3r.de>
To: ecryptfs@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 01 Jun 2013 11:39:36 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/fs/ecryptfs/messaging.c b/fs/ecryptfs/messaging.c
--- a/fs/ecryptfs/messaging.c
+++ b/fs/ecryptfs/messaging.c
@@ -247,14 +247,13 @@ int ecryptfs_process_response(struct ecr
 		goto unlock;
 	}
 	msg_size = (sizeof(*msg) + msg->data_len);
-	msg_ctx->msg = kmalloc(msg_size, GFP_KERNEL);
+	msg_ctx->msg = kmemdup(msg, msg_size, GFP_KERNEL);
 	if (!msg_ctx->msg) {
 		rc = -ENOMEM;
 		printk(KERN_ERR "%s: Failed to allocate [%zd] bytes of "
 		       "GFP_KERNEL memory\n", __func__, msg_size);
 		goto unlock;
 	}
-	memcpy(msg_ctx->msg, msg, msg_size);
 	msg_ctx->state = ECRYPTFS_MSG_CTX_STATE_DONE;
 	wake_up_process(msg_ctx->task);
 	rc = 0;


