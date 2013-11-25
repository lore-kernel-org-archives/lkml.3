Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287Ab3KYN2a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:28:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:56990 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536Ab3KYNH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:07:27 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Geyslan G. Bem" <geyslan@gmail.com>, Tyler Hicks <tyhicks@canonical.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 12/78] ecryptfs: Fix memory leakage in keystore.c
Date: Mon, 25 Nov 2013 13:05:59 +0000
Message-Id: <1385384825-21681-13-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
References: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.26 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Geyslan G. Bem" <geyslan@gmail.com>

commit 3edc8376c06133e3386265a824869cad03a4efd4 upstream.

In 'decrypt_pki_encrypted_session_key' function:

Initializes 'payload' pointer and releases it on exit.

Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ecryptfs/keystore.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
index 2333203..d28fc34 100644
--- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -1149,7 +1149,7 @@ decrypt_pki_encrypted_session_key(struct ecryptfs_auth_tok *auth_tok,
 	struct ecryptfs_msg_ctx *msg_ctx;
 	struct ecryptfs_message *msg = NULL;
 	char *auth_tok_sig;
-	char *payload;
+	char *payload = NULL;
 	size_t payload_len;
 	int rc;
 
@@ -1204,6 +1204,7 @@ decrypt_pki_encrypted_session_key(struct ecryptfs_auth_tok *auth_tok,
 out:
 	if (msg)
 		kfree(msg);
+	kfree(payload);
 	return rc;
 }
 
-- 
1.8.3.2

