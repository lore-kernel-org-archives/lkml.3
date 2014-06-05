Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483AbaFEE7k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:59:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43885 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553AbaFEEUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:20:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Geyslan G. Bem" <geyslan@gmail.com>,
        Tyler Hicks <tyhicks@canonical.com>,
        Ben Hutchings <ben@decadent.org.uk>, Rui Xiang <rui.xiang@huawei.com>
Subject: [PATCH 3.4 077/214] ecryptfs: Fix memory leakage in keystore.c
Date: Wed,  4 Jun 2014 21:17:20 -0700
Message-Id: <20140605041649.903356983@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Geyslan G. Bem" <geyslan@gmail.com>

commit 3edc8376c06133e3386265a824869cad03a4efd4 upstream.

In 'decrypt_pki_encrypted_session_key' function:

Initializes 'payload' pointer and releases it on exit.

Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Rui Xiang <rui.xiang@huawei.com>
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
 	size_t payload_len;
 	int rc;
 
@@ -1204,6 +1204,7 @@ decrypt_pki_encrypted_session_key(struct
 out:
 	if (msg)
 		kfree(msg);
+	kfree(payload);
 	return rc;
 }
 


