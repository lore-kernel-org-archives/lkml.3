Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487Ab3KHC0F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:26:05 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34914 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932704Ab3KHCWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:22:00 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Geyslan G. Bem" <geyslan@gmail.com>, Tyler Hicks <tyhicks@canonical.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 55/91] ecryptfs: Fix memory leakage in keystore.c
Date: Thu,  7 Nov 2013 18:15:10 -0800
Message-Id: <1383876946-2396-56-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383876946-2396-1-git-send-email-kamal@canonical.com>
References: <1383876946-2396-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Geyslan G. Bem" <geyslan@gmail.com>

commit 3edc8376c06133e3386265a824869cad03a4efd4 upstream.

In 'decrypt_pki_encrypted_session_key' function:

Initializes 'payload' pointer and releases it on exit.

Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/ecryptfs/keystore.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
index 2333203..a26bb46 100644
--- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -1149,8 +1149,8 @@ decrypt_pki_encrypted_session_key(struct ecryptfs_auth_tok *auth_tok,
 	struct ecryptfs_msg_ctx *msg_ctx;
 	struct ecryptfs_message *msg = NULL;
 	char *auth_tok_sig;
-	char *payload;
-	size_t payload_len;
+	char *payload = NULL;
+	size_t payload_len = 0;
 	int rc;
 
 	rc = ecryptfs_get_auth_tok_sig(&auth_tok_sig, auth_tok);
@@ -1202,8 +1202,8 @@ decrypt_pki_encrypted_session_key(struct ecryptfs_auth_tok *auth_tok,
 				  crypt_stat->key_size);
 	}
 out:
-	if (msg)
-		kfree(msg);
+	kfree(msg);
+	kfree(payload);
 	return rc;
 }
 
-- 
1.8.1.2

