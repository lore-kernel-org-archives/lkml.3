Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546AbaALSpa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 13:45:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46414 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbaALSpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 13:45:22 -0500
Date: Sun, 12 Jan 2014 10:44:48 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-zcfvacdlvlr63qmnn5i58vuj@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, arjan@linux.intel.com,
        peterz@infradead.org, bitbucket@online.de,
        eliezer.tamir@linux.intel.com, akpm@linux-foundation.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        arjan@linux.intel.com, torvalds@linux-foundation.org,
        peterz@infradead.org, bitbucket@online.de,
        eliezer.tamir@linux.intel.com, akpm@linux-foundation.org,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/idle] sched, thermal:
  Clean up preempt_enable_no_resched() abuse
Git-Commit-ID: 71434bc7ac606506d04e5f319fada44567072494
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 12 Jan 2014 10:44:55 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  71434bc7ac606506d04e5f319fada44567072494
Gitweb:     http://git.kernel.org/tip/71434bc7ac606506d04e5f319fada44567072494
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 11 Dec 2013 12:21:17 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 12 Jan 2014 14:50:39 +0100

sched, thermal: Clean up preempt_enable_no_resched() abuse

The only valid use of preempt_enable_no_resched() is if the very next
line is schedule() or if we know preemption cannot actually be enabled
by that statement due to known more preempt_count 'refs'.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: rjw@rjwysocki.net
Cc: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Cc: rui.zhang@intel.com
Cc: jacob.jun.pan@linux.intel.com
Cc: Mike Galbraith <bitbucket@online.de>
Cc: hpa@zytor.com
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: lenb@kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-zcfvacdlvlr63qmnn5i58vuj@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 drivers/thermal/intel_powerclamp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/intel_powerclamp.c b/drivers/thermal/intel_powerclamp.c
index e8275f2..d833c8f 100644
--- a/drivers/thermal/intel_powerclamp.c
+++ b/drivers/thermal/intel_powerclamp.c
@@ -443,7 +443,7 @@ static int clamp_thread(void *arg)
 			atomic_inc(&idle_wakeup_counter);
 		}
 		tick_nohz_idle_exit();
-		preempt_enable_no_resched();
+		preempt_enable();
 	}
 	del_timer_sync(&wakeup_timer);
 	clear_bit(cpunr, cpu_clamping_mask);
