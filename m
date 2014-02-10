Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735AbaBJUnO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 15:43:14 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35701 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740AbaBJUl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 15:41:28 -0500
Message-Id: <20140210203659.465074341@infradead.org>
User-Agent: quilt/0.60-1
Date: Mon, 10 Feb 2014 20:58:22 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Jason Low <jason.low2@hp.com>, Waiman Long <waiman.long@hp.com>,
        Peter Zijlstra <peterz@infradead.org>, mingo@kernel.org,
        paulmck@linux.vnet.ibm.com, torvalds@linux-foundation.org,
        tglx@linutronix.de, riel@redhat.com, akpm@linux-foundation.org,
        davidlohr@hp.com, hpa@zytor.com, andi@firstfloor.org, aswin@hp.com,
        scott.norton@hp.com, chegu_vinod@hp.com
Subject: [PATCH 2/8] mutex: In mutex_can_spin_on_owner(), return false if task need_resched()
References: <20140210195820.834693028@infradead.org>
Content-Disposition: inline; filename=jason_low-mutex-in_mutex_can_spin_on_owner_return_false_if_task_need_resched.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mutex_can_spin_on_owner() function should also return false if the
task needs to be rescheduled to avoid entering the MCS queue when it
needs to reschedule.

Cc: chegu_vinod@hp.com
Cc: paulmck@linux.vnet.ibm.com
Cc: Waiman.Long@hp.com
Cc: torvalds@linux-foundation.org
Cc: tglx@linutronix.de
Cc: riel@redhat.com
Cc: akpm@linux-foundation.org
Cc: davidlohr@hp.com
Cc: hpa@zytor.com
Cc: andi@firstfloor.org
Cc: aswin@hp.com
Cc: mingo@kernel.org
Cc: scott.norton@hp.com
Signed-off-by: Jason Low <jason.low2@hp.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1390936396-3962-2-git-send-email-jason.low2@hp.com
---
 kernel/locking/mutex.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -166,6 +166,9 @@ static inline int mutex_can_spin_on_owne
 	struct task_struct *owner;
 	int retval = 1;
 
+	if (need_resched())
+		return 0;
+
 	rcu_read_lock();
 	owner = ACCESS_ONCE(lock->owner);
 	if (owner)


