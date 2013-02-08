Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946847Ab3BHRhc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 12:37:32 -0500
Received: from mx3-phx2.redhat.com ([209.132.183.24]:38251 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946723Ab3BHRhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 12:37:31 -0500
Date: Fri, 8 Feb 2013 12:37:30 -0500 (EST)
From: Rado Vrbovsky <rvrbovsk@redhat.com>
To: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@redhat.com>
Cc: Don Zickus <dzickus@redhat.com>
Message-ID: <2037057938.893524.1360345050772.JavaMail.root@redhat.com>
In-Reply-To: <350315726.726339.1360327201303.JavaMail.root@redhat.com>
Subject: [PATCH] time: Change log level of "NOHZ: local_softirq_pending"
 message
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.36.6.109]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - FF3.0 (Linux)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "NOHZ: local_softirq_pending" message is a largely informational message.
This makes extra work for customers that have a policy of investigating all
kernel log messages logged at <= KERN_ERR log level.
This patch sets the message to a different log level.

Signed-off-by: Rado Vrbovsky <rvrbovsk@redhat.com>

---
 kernel/time/tick-sched.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index d58e552..ece2beb 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -481,7 +481,7 @@ static bool can_stop_idle_tick(int cpu, struct tick_sched *ts)
 
                if (ratelimit < 10 &&
                    (local_softirq_pending() & SOFTIRQ_STOP_IDLE_MASK)) {
-                       printk(KERN_ERR "NOHZ: local_softirq_pending %02x\n",
+                       printk(KERN_WARNING "NOHZ: local_softirq_pending %02x\n",
                               (unsigned int) local_softirq_pending());
                        ratelimit++;
                }
-- 
1.7.11.7
