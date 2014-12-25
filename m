Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283AbaLYLdv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 06:33:51 -0500
Received: from www.osadl.org ([62.245.132.105]:46425 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751968AbaLYLdu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 06:33:50 -0500
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Rik van Riel <riel@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, Nicholas Mc Guire <der.herr@hofr.at>
Subject: [PATCH] doc fix - brlock was removed in the 3.13 kernel series
Date: Thu, 25 Dec 2014 06:29:41 -0500
Message-Id: <1419506981-23952-1-git-send-email-der.herr@hofr.at>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The brlock was completely removed in the 3.13 kernel series.
see commit 0f6ed63b1707 ("no need to keep brlock macros anymore...")

It seems that documentation in seqlock.h was not updated to reflect
this. This patch drops the (hopefully last) false brlock reference.
All remaining references to brlock refer to byte-range locks (notably
in cifs) and not to "Big Reader Lock" and should be correct.

patch is against 3.19.0-rc1 linux-next

Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---
 include/linux/seqlock.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
index f5df8f6..af7f5e9 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -13,9 +13,8 @@
  *    from going forward. Unlike the regular rwlock, the read lock here is
  *    exclusive so that only one locking reader can get it.
  *
- * This is not as cache friendly as brlock. Also, this may not work well
- * for data that contains pointers, because any writer could
- * invalidate a pointer that a reader was following.
+ * This may not work well for data that contains pointers, because any
+ * writer could invalidate a pointer that a reader was following.
  *
  * Expected non-blocking reader usage:
  * 	do {
--
1.7.10.4

