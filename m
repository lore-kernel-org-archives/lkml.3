Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932151AbaGBPwo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 11:52:44 -0400
Received: from prod-mail-xrelay02.akamai.com ([72.246.2.14]:42434 "EHLO
	prod-mail-xrelay02.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754737AbaGBPwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 11:52:42 -0400
To: peterz@infradead.org, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, andi@firstfloor.org, rostedt@goodmis.org
Message-Id: <2ce52233ce200faad93b6029d90f1411cd926667.1404315388.git.jbaron@akamai.com>
In-Reply-To: <cover.1404315388.git.jbaron@akamai.com>
References: <cover.1404315388.git.jbaron@akamai.com>
From: Jason Baron <jbaron@akamai.com>
Subject: [PATCH 1/2] sched: remove extra static_key function indirection
Date: Wed,  2 Jul 2014 15:52:41 +0000 (GMT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think its a bit simpler without having to follow an extra layer of static
inline fuctions. No functional change just cosmetic.

Signed-off-by: Jason Baron <jbaron@akamai.com>
---
 kernel/sched/sched.h | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 31cc02e..10494c0 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -884,20 +884,10 @@ enum {
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
-- 
1.8.2.rc2

