Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642AbaJUH3R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 03:29:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43421 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754473AbaJUH1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 03:27:35 -0400
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>,
        "\\\"Rafael J. Wysocki\\\"" <rjw@rjwysocki.net>
Cc: Cong Wang <xiyou.wangcong@gmail.com>, David Rientjes <rientjes@google.com>,
        Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 2/4] freezer: remove obsolete comments in __thaw_task()
Date: Tue, 21 Oct 2014 09:27:13 +0200
Message-Id: <1413876435-11720-3-git-send-email-mhocko@suse.cz>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413876435-11720-1-git-send-email-mhocko@suse.cz>
References: <1413876435-11720-1-git-send-email-mhocko@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

__thaw_task() no longer clears frozen flag since commit a3201227f803
(freezer: make freezing() test freeze conditions in effect instead of TIF_FREEZE).

Cc: David Rientjes <rientjes@google.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 kernel/freezer.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/kernel/freezer.c b/kernel/freezer.c
index 8f9279b9c6d7..a8900a3bc27a 100644
--- a/kernel/freezer.c
+++ b/kernel/freezer.c
@@ -150,12 +150,6 @@ void __thaw_task(struct task_struct *p)
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
2.1.1

