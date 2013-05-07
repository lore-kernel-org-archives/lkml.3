Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932986Ab3EGOHo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 10:07:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42317 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932979Ab3EGNlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:41:22 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 054/118] net: sctp: sctp_auth_key_put: use kzfree instead of kfree
Date: Tue,  7 May 2013 14:38:20 +0100
Message-Id: <1367933964-1564-55-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <dborkman@redhat.com>

commit 586c31f3bf04c290dc0a0de7fc91d20aa9a5ee53 upstream.

For sensitive data like keying material, it is common practice to zero
out keys before returning the memory back to the allocator. Thus, use
kzfree instead of kfree.

Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Acked-by: Vlad Yasevich <vyasevich@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/sctp/auth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/auth.c b/net/sctp/auth.c
index bf81204..333926d 100644
--- a/net/sctp/auth.c
+++ b/net/sctp/auth.c
@@ -71,7 +71,7 @@ void sctp_auth_key_put(struct sctp_auth_bytes *key)
 		return;
 
 	if (atomic_dec_and_test(&key->refcnt)) {
-		kfree(key);
+		kzfree(key);
 		SCTP_DBG_OBJCNT_DEC(keys);
 	}
 }
-- 
1.8.1.2

