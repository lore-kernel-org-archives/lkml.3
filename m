Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757677AbaEPQGd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 12:06:33 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:62635 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757658AbaEPQGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 12:06:30 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ai0SAMI2dlNXQB71/2dsb2JhbABZgwaqaAUFBQGaGQICgRYXdIJTExwjGIECJBOIRQHSFoVViHqERwEDjy2KKgGTGYM5Ow
Date: Fri, 16 May 2014 18:06:27 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, akpm <akpm@linux-foundation.org>
Subject: [PATCH 3/3] kernel/hrtimer.c: fix array declarations
Message-Id: <20140516180627.1ffba237b9b3ea8c99110859@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

...and lines over 80 cols

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 kernel/hrtimer.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 1eccb98..d2daf63 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -64,12 +64,10 @@
  * to reach a base using a clockid, hrtimer_clockid_to_base()
  * is used to convert from clockid to the proper hrtimer_base_type.
  */
-DEFINE_PER_CPU(struct hrtimer_cpu_base, hrtimer_bases) =
-{
+DEFINE_PER_CPU(struct hrtimer_cpu_base, hrtimer_bases) = {
 
 	.lock = __RAW_SPIN_LOCK_UNLOCKED(hrtimer_bases.lock),
-	.clock_base =
-	{
+	.clock_base = {
 		{
 			.index = HRTIMER_BASE_MONOTONIC,
 			.clockid = CLOCK_MONOTONIC,
@@ -164,7 +162,8 @@ struct hrtimer_clock_base *lock_hrtimer_base(const struct hrtimer *timer,
 			if (likely(base == timer->base))
 				return base;
 			/* The timer has migrated to another CPU: */
-			raw_spin_unlock_irqrestore(&base->cpu_base->lock, *flags);
+			raw_spin_unlock_irqrestore(&base->cpu_base->lock,
+						   *flags);
 		}
 		cpu_relax();
 	}
@@ -1543,7 +1542,8 @@ void hrtimer_init_sleeper(struct hrtimer_sleeper *sl, struct task_struct *task)
 }
 EXPORT_SYMBOL_GPL(hrtimer_init_sleeper);
 
-static int __sched do_nanosleep(struct hrtimer_sleeper *t, enum hrtimer_mode mode)
+static int
+__sched do_nanosleep(struct hrtimer_sleeper *t, enum hrtimer_mode mode)
 {
 	hrtimer_init_sleeper(t, current);
 
-- 
1.8.4.5

