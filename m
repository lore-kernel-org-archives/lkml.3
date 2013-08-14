Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758974Ab3HNAH1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 20:07:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:1248 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758246Ab3HNAHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 20:07:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,873,1367996400"; 
   d="scan'208";a="386655096"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, torvalds@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 5/8] sched: mark should_resched() __always_inline
Date: Tue, 13 Aug 2013 17:07:13 -0700
Message-Id: <1376438836-13339-6-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1376438836-13339-1-git-send-email-andi@firstfloor.org>
References: <1376438836-13339-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

At least gcc 4.6 and some earlier ones does not inline this function.
Since it's small and on relatively hot paths force inline it.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 kernel/sched/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 74d7c04..23df96a 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3767,7 +3767,7 @@ SYSCALL_DEFINE0(sched_yield)
 	return 0;
 }
 
-static inline int should_resched(void)
+static __always_inline int should_resched(void)
 {
 	return need_resched() && !(preempt_count() & PREEMPT_ACTIVE);
 }
-- 
1.8.3.1

