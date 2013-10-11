Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933019Ab3JKT7w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 15:59:52 -0400
Received: from mail-ye0-f180.google.com ([209.85.213.180]:41287 "EHLO
	mail-ye0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932627Ab3JKT7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:59:49 -0400
From: "Geyslan G. Bem" <geyslan@gmail.com>
To: tyhicks@canonical.com
Cc: ecryptfs@vger.kernel.org, linux-kernel@vger.kernel.org, joe@perches.com,
        kernel-br@googlegroups.com, "Geyslan G. Bem" <geyslan@gmail.com>
Subject: [PATCH] ecryptfs: Fix memory leakage in keystore.c
Date: Fri, 11 Oct 2013 16:49:16 -0300
Message-Id: <1381520956-20282-1-git-send-email-geyslan@gmail.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In 'decrypt_pki_encrypted_session_key' function:

Initializes 'payload' pointer and releases it on exit.

Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
---
 fs/ecryptfs/keystore.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
index 7d52806..4725a07 100644
--- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -1149,7 +1149,7 @@ decrypt_pki_encrypted_session_key(struct ecryptfs_auth_tok *auth_tok,
 	struct ecryptfs_msg_ctx *msg_ctx;
 	struct ecryptfs_message *msg = NULL;
 	char *auth_tok_sig;
-	char *payload;
+	char *payload = NULL;
 	size_t payload_len = 0;
 	int rc;
 
@@ -1203,6 +1203,7 @@ decrypt_pki_encrypted_session_key(struct ecryptfs_auth_tok *auth_tok,
 	}
 out:
 	kfree(msg);
+	kfree(payload);
 	return rc;
 }
 
-- 
1.8.4

