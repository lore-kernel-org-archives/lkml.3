Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758652Ab3IYBm6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:42:58 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:36925 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757730Ab3IYBmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 21:42:55 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 03/10] rcu: Flag lockless access to ->gp_flags with ACCESS_ONCE()
Date: Tue, 24 Sep 2013 18:42:32 -0700
Message-Id: <1380073359-31959-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1380073359-31959-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130925014210.GA31690@linux.vnet.ibm.com>
 <1380073359-31959-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092501-0928-0000-0000-000001DB9FF1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit applies ACCESS_ONCE() to an outside-of-lock access to
->gp_flags.  Although it is hard to imagine any sane compiler messing
this particular case up, the documentation benefits are substantial.
Plus the definition of "sane compiler" grows ever looser.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 62b67b7..6d028fd 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1481,7 +1481,7 @@ static int __noreturn rcu_gp_kthread(void *arg)
 		/* Handle grace-period start. */
 		for (;;) {
 			wait_event_interruptible(rsp->gp_wq,
-						 rsp->gp_flags &
+						 ACCESS_ONCE(rsp->gp_flags) &
 						 RCU_GP_FLAG_INIT);
 			if (rcu_gp_init(rsp))
 				break;
-- 
1.8.1.5

