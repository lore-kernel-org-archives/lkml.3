Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759716Ab3BYL1r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 06:27:47 -0500
Received: from multi.imgtec.com ([194.200.65.239]:30075 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661Ab3BYL1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 06:27:46 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        David Howells <dhowells@redhat.com>
Subject: [PATCH 1/1] debug_locks.h: make warning more verbose
Date: Mon, 25 Feb 2013 11:27:17 +0000
Message-ID: <1361791637-21646-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_02_25_11_27_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The WARN_ON(1) in DEBUG_LOCKS_WARN_ON is surprisingly awkward to track
down when it's hit, as it's usually buried in macros, causing multiple
instances to land on the same line number.

This patch makes it more useful by switching to:

    WARN(1, "DEBUG_LOCKS_WARN_ON(%s)", #c);

so that the particular DEBUG_LOCKS_WARN_ON is more easily identified and
grep'd for. For example:

    WARNING: at kernel/mutex.c:198 _mutex_lock_nested+0x31c/0x380()
    DEBUG_LOCKS_WARN_ON(l->magic != l)

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: David Howells <dhowells@redhat.com>
---
 include/linux/debug_locks.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/debug_locks.h b/include/linux/debug_locks.h
index 3bd46f7..21ca773 100644
--- a/include/linux/debug_locks.h
+++ b/include/linux/debug_locks.h
@@ -27,7 +27,7 @@ extern int debug_locks_off(void);
 									\
 	if (!oops_in_progress && unlikely(c)) {				\
 		if (debug_locks_off() && !debug_locks_silent)		\
-			WARN_ON(1);					\
+			WARN(1, "DEBUG_LOCKS_WARN_ON(%s)", #c);		\
 		__ret = 1;						\
 	}								\
 	__ret;								\
-- 
1.8.1.2


