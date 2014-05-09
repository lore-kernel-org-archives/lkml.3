Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326AbaEIS35 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 14:29:57 -0400
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:25630 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757195AbaEIS34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 14:29:56 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap4XAMMdbVNXQw5R/2dsb2JhbABZgwasSwQBAQEBAQEFAZoUAgKBGRd0glMTHCMYahgkE4gtAxUByngNhjaFVoZlgheERwEDjySIMYFxAYsDghuFZIM4Ow
Date: Fri, 9 May 2014 20:29:51 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] kernel/watchdog.c: convert printk/pr_warning to
 pr_foo()
Message-Id: <20140509202951.67d91f4ff1ee6948c30c7834@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace some obsolete functions.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 kernel/watchdog.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 516203e..19c953e 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -244,9 +244,11 @@ static void watchdog_overflow_callback(struct perf_event *event,
 			return;
 
 		if (hardlockup_panic)
-			panic("Watchdog detected hard LOCKUP on cpu %d", this_cpu);
+			panic("Watchdog detected hard LOCKUP on cpu %d",
+			      this_cpu);
 		else
-			WARN(1, "Watchdog detected hard LOCKUP on cpu %d", this_cpu);
+			WARN(1, "Watchdog detected hard LOCKUP on cpu %d",
+			     this_cpu);
 
 		__this_cpu_write(hard_watchdog_warn, true);
 		return;
@@ -317,7 +319,7 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
 		if (__this_cpu_read(soft_watchdog_warn) == true)
 			return HRTIMER_RESTART;
 
-		printk(KERN_EMERG "BUG: soft lockup - CPU#%d stuck for %us! [%s:%d]\n",
+		pr_emerg("BUG: soft lockup - CPU#%d stuck for %us! [%s:%d]\n",
 			smp_processor_id(), duration,
 			current->comm, task_pid_nr(current));
 		print_modules();
@@ -445,7 +447,7 @@ static int watchdog_nmi_enable(unsigned int cpu)
 	if (PTR_ERR(event) == -EOPNOTSUPP)
 		pr_info("disabled (cpu%i): not supported (no LAPIC?)\n", cpu);
 	else if (PTR_ERR(event) == -ENOENT)
-		pr_warning("disabled (cpu%i): hardware events not enabled\n",
+		pr_warn("disabled (cpu%i): hardware events not enabled\n",
 			 cpu);
 	else
 		pr_err("disabled (cpu%i): unable to create perf event: %ld\n",
-- 
1.8.4.5
