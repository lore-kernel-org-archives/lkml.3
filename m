Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211AbaIJScF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 14:32:05 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:58680 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751100AbaIJScE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 14:32:04 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] locking: Add WARN_ON_ONCE lock assertion
Date: Wed, 10 Sep 2014 14:31:39 -0400
Message-Id: <1410373899-4113-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.0
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An interface may need to assert a lock invariant and not flood the
system logs; add a lockdep helper macro equivalent to
lockdep_assert_held() which only WARNs once.

cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 include/linux/lockdep.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 008388f9..64c7425 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -362,6 +362,10 @@ extern void lockdep_trace_alloc(gfp_t mask);
 		WARN_ON(debug_locks && !lockdep_is_held(l));	\
 	} while (0)
 
+#define lockdep_assert_held_once(l)	do {				\
+		WARN_ON_ONCE(debug_locks && !lockdep_is_held(l));	\
+	} while (0)
+
 #define lockdep_recursing(tsk)	((tsk)->lockdep_recursion)
 
 #else /* !CONFIG_LOCKDEP */
@@ -412,6 +416,7 @@ struct lock_class_key { };
 #define lockdep_depth(tsk)	(0)
 
 #define lockdep_assert_held(l)			do { (void)(l); } while (0)
+#define lockdep_assert_held_once(l)		do { (void)(l); } while (0)
 
 #define lockdep_recursing(tsk)			(0)
 
-- 
2.1.0

