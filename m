Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135AbaBEUEL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:04:11 -0500
Received: from mail.windriver.com ([147.11.1.11]:54291 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594AbaBEUD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:03:59 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 034/213] net: sctp: sctp_auth_key_put: use kzfree instead of kfree
Date: Wed, 5 Feb 2014 14:59:49 -0500
Message-ID: <1391630568-49251-35-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Borkmann <dborkman@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 586c31f3bf04c290dc0a0de7fc91d20aa9a5ee53 upstream.

For sensitive data like keying material, it is common practice to zero
out keys before returning the memory back to the allocator. Thus, use
kzfree instead of kfree.

Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Acked-by: Vlad Yasevich <vyasevich@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/sctp/auth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/auth.c b/net/sctp/auth.c
index ddbbf7c81fa1..ce9ef56708ac 100644
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
1.8.5.2

