Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757902Ab3HPWsU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:48:20 -0400
Received: from mga03.intel.com ([143.182.124.21]:34598 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757852Ab3HPWsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:48:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,897,1367996400"; 
   d="scan'208";a="282994846"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, peterz@infradead.org, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 6/6] sched: Inline the need_resched test into the caller for _cond_resched
Date: Fri, 16 Aug 2013 14:17:24 -0700
Message-Id: <1376687844-19857-7-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1376687844-19857-1-git-send-email-andi@firstfloor.org>
References: <1376687844-19857-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

_cond_resched does at least two explicit calls just to decide to do
nothing: _cond_resched and should_resched(). Inline a need_resched()
into the caller to avoid these calls in the common case of no reschedule
being needed.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/sched.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 97f4b78..dd3fafc 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2435,7 +2435,7 @@ extern int __cond_resched_softirq(void);
 
 #ifdef CONFIG_PREEMPT_VOLUNTARY
 extern int _cond_resched(void);
-# define might_resched() _cond_resched()
+# define might_resched() (need_resched() ? _cond_resched() : 0)
 #else
 # define might_resched() do { } while (0)
 #endif
-- 
1.8.3.1

