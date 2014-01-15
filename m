Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021AbaAOAdY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 19:33:24 -0500
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:1497 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbaAOAdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 19:33:19 -0500
From: Jason Low <jason.low2@hp.com>
To: mingo@redhat.com, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        Waiman.Long@hp.com, torvalds@linux-foundation.org, tglx@linutronix.de,
        jason.low2@hp.com
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, akpm@linux-foundation.org,
        davidlohr@hp.com, hpa@zytor.com, aswin@hp.com, scott.norton@hp.com
Subject: [RFC 1/3] mutex: In mutex_can_spin_on_owner(), return false if task need_resched()
Date: Tue, 14 Jan 2014 16:33:08 -0800
Message-Id: <1389745990-7069-2-git-send-email-jason.low2@hp.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389745990-7069-1-git-send-email-jason.low2@hp.com>
References: <1389745990-7069-1-git-send-email-jason.low2@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mutex_can_spin_on_owner() function should also return false if the
task needs to be rescheduled.

Signed-off-by: Jason Low <jason.low2@hp.com>
---
 kernel/locking/mutex.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index 4dd6e4c..85c6be1 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -212,6 +212,9 @@ static inline int mutex_can_spin_on_owner(struct mutex *lock)
 	struct task_struct *owner;
 	int retval = 1;
 
+	if (need_resched())
+		return 0;
+
 	rcu_read_lock();
 	owner = ACCESS_ONCE(lock->owner);
 	if (owner)
-- 
1.7.1

