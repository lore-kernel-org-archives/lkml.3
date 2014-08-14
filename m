Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157AbaHNVP5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 17:15:57 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:61927 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251AbaHNVPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 17:15:41 -0400
From: Cong Wang <xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Cong Wang <xiyou.wangcong@gmail.com>, David Rientjes <rientjes@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>
Subject: [Patch v3 2/2] freezer: remove obsolete comments in __thaw_task()
Date: Thu, 14 Aug 2014 14:15:26 -0700
Message-Id: <1408050926-9525-2-git-send-email-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1408050926-9525-1-git-send-email-xiyou.wangcong@gmail.com>
References: <1408050926-9525-1-git-send-email-xiyou.wangcong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__thaw_task() no longer clears frozen flag.

Cc: David Rientjes <rientjes@google.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 kernel/freezer.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/kernel/freezer.c b/kernel/freezer.c
index 5b25351..33cbcb0 100644
--- a/kernel/freezer.c
+++ b/kernel/freezer.c
@@ -156,12 +156,6 @@ void __thaw_task(struct task_struct *p)
 {
 	unsigned long flags;
 
-	/*
-	 * Clear freezing and kick @p if FROZEN.  Clearing is guaranteed to
-	 * be visible to @p as waking up implies wmb.  Waking up inside
-	 * freezer_lock also prevents wakeups from leaking outside
-	 * refrigerator.
-	 */
 	spin_lock_irqsave(&freezer_lock, flags);
 	if (frozen(p))
 		wake_up_process(p);
-- 
1.8.3.1

