Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758975Ab3KIHgc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 02:36:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:32911 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758033Ab3KIGu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:50:27 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Geyslan G. Bem" <geyslan@gmail.com>,
        Tyler Hicks <tyhicks@canonical.com>
Subject: [PATCH 3.10 25/74] ecryptfs: Fix memory leakage in keystore.c
Date: Fri,  8 Nov 2013 22:51:30 -0800
Message-Id: <20131109065115.303372781@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065113.502217951@linuxfoundation.org>
References: <20131109065113.502217951@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Geyslan G. Bem" <geyslan@gmail.com>

commit 3edc8376c06133e3386265a824869cad03a4efd4 upstream.

In 'decrypt_pki_encrypted_session_key' function:

Initializes 'payload' pointer and releases it on exit.

Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ecryptfs/keystore.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -1149,7 +1149,7 @@ decrypt_pki_encrypted_session_key(struct
 	struct ecryptfs_msg_ctx *msg_ctx;
 	struct ecryptfs_message *msg = NULL;
 	char *auth_tok_sig;
-	char *payload;
+	char *payload = NULL;
 	size_t payload_len = 0;
 	int rc;
 
@@ -1203,6 +1203,7 @@ decrypt_pki_encrypted_session_key(struct
 	}
 out:
 	kfree(msg);
+	kfree(payload);
 	return rc;
 }
 


