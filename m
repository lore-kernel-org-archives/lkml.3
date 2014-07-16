Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935214AbaGPTYI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 15:24:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44535 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934984AbaGPTYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 15:24:01 -0400
Date: Wed, 16 Jul 2014 12:23:06 -0700
From: tip-bot for Jason Baron <tipbot@zytor.com>
Message-ID: <tip-6e76ea8a8209386c3cc7ee5594e6ea5d25525cf2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de, jbaron@akamai.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de, jbaron@akamai.com
In-Reply-To: <2ce52233ce200faad93b6029d90f1411cd926667.1404315388.git.jbaron@akamai.com>
References: <2ce52233ce200faad93b6029d90f1411cd926667.1404315388.git.jbaron@akamai.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Remove extra static_key*()
  function indirection
Git-Commit-ID: 6e76ea8a8209386c3cc7ee5594e6ea5d25525cf2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6e76ea8a8209386c3cc7ee5594e6ea5d25525cf2
Gitweb:     http://git.kernel.org/tip/6e76ea8a8209386c3cc7ee5594e6ea5d25525cf2
Author:     Jason Baron <jbaron@akamai.com>
AuthorDate: Wed, 2 Jul 2014 15:52:41 +0000
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 16 Jul 2014 13:38:20 +0200

sched: Remove extra static_key*() function indirection

I think its a bit simpler without having to follow an extra layer of static
inline fuctions. No functional change just cosmetic.

Signed-off-by: Jason Baron <jbaron@akamai.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: rostedt@goodmis.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/2ce52233ce200faad93b6029d90f1411cd926667.1404315388.git.jbaron@akamai.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/sched.h | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 1283945..579712f 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -887,20 +887,10 @@ enum {
 #undef SCHED_FEAT
 
 #if defined(CONFIG_SCHED_DEBUG) && defined(HAVE_JUMP_LABEL)
-static __always_inline bool static_branch__true(struct static_key *key)
-{
-	return static_key_true(key); /* Not out of line branch. */
-}
-
-static __always_inline bool static_branch__false(struct static_key *key)
-{
-	return static_key_false(key); /* Out of line branch. */
-}
-
 #define SCHED_FEAT(name, enabled)					\
 static __always_inline bool static_branch_##name(struct static_key *key) \
 {									\
-	return static_branch__##enabled(key);				\
+	return static_key_##enabled(key);				\
 }
 
 #include "features.h"
