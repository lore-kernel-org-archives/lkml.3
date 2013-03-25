Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755812Ab3CYKAK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 06:00:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41590 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765Ab3CYKAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 06:00:03 -0400
Date: Mon, 25 Mar 2013 02:58:51 -0700
From: tip-bot for Rado Vrbovsky <tipbot@zytor.com>
Message-ID: <tip-cfea7d7e452f57682a0bb55a55e9f79c569558c2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rvrbovsk@redhat.com, tglx@linutronix.de, dzickus@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rvrbovsk@redhat.com, tglx@linutronix.de, dzickus@redhat.com
In-Reply-To: <2037057938.893524.1360345050772.JavaMail.root@redhat.com>
References: <2037057938.893524.1360345050772.JavaMail.root@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] tick: Change log level of NOHZ:
  local_softirq_pending message
Git-Commit-ID: cfea7d7e452f57682a0bb55a55e9f79c569558c2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 25 Mar 2013 02:58:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cfea7d7e452f57682a0bb55a55e9f79c569558c2
Gitweb:     http://git.kernel.org/tip/cfea7d7e452f57682a0bb55a55e9f79c569558c2
Author:     Rado Vrbovsky <rvrbovsk@redhat.com>
AuthorDate: Fri, 8 Feb 2013 12:37:30 -0500
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 25 Mar 2013 10:46:59 +0100

tick: Change log level of NOHZ: local_softirq_pending message

The "NOHZ: local_softirq_pending" message is a largely informational
message.  This makes extra work for customers that have a policy of
investigating all kernel log messages logged at <= KERN_ERR log level.
This patch sets the message to a different log level.

[ tglx: Use pr_warn() ]

Signed-off-by: Rado Vrbovsky <rvrbovsk@redhat.com>
Cc: Don Zickus <dzickus@redhat.com>
Link: http://lkml.kernel.org/r/2037057938.893524.1360345050772.JavaMail.root@redhat.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 kernel/time/tick-sched.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index a19a399..225f8bf 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -482,8 +482,8 @@ static bool can_stop_idle_tick(int cpu, struct tick_sched *ts)
 
 		if (ratelimit < 10 &&
 		    (local_softirq_pending() & SOFTIRQ_STOP_IDLE_MASK)) {
-			printk(KERN_ERR "NOHZ: local_softirq_pending %02x\n",
-			       (unsigned int) local_softirq_pending());
+			pr_warn("NOHZ: local_softirq_pending %02x\n",
+				(unsigned int) local_softirq_pending());
 			ratelimit++;
 		}
 		return false;
