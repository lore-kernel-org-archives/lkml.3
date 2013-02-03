Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571Ab3BCTXA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 14:23:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50779 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450Ab3BCTW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 14:22:57 -0500
Date: Sun, 3 Feb 2013 11:22:41 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-5e67b51e3fb22ad43faf9589e9019ad9c6a00413@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rostedt@goodmis.org, namhyung.kim@lge.com, tglx@linutronix.de,
        namhyung@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, namhyung.kim@lge.com, tglx@linutronix.de,
        namhyung@kernel.org
In-Reply-To: <1356576585-28782-2-git-send-email-namhyung@kernel.org>
References: <1356576585-28782-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing:
  Use sched_clock_cpu for trace_clock_global
Git-Commit-ID: 5e67b51e3fb22ad43faf9589e9019ad9c6a00413
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sun, 03 Feb 2013 11:22:48 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5e67b51e3fb22ad43faf9589e9019ad9c6a00413
Gitweb:     http://git.kernel.org/tip/5e67b51e3fb22ad43faf9589e9019ad9c6a00413
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Thu, 27 Dec 2012 11:49:45 +0900
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 30 Jan 2013 11:02:05 -0500

tracing: Use sched_clock_cpu for trace_clock_global

For systems with an unstable sched_clock, all cpu_clock() does is enable/
disable local irq during the call to sched_clock_cpu().  And for stable
systems they are same.

trace_clock_global() already disables interrupts, so it can call
sched_clock_cpu() directly.

Link: http://lkml.kernel.org/r/1356576585-28782-2-git-send-email-namhyung@kernel.org

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_clock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace_clock.c b/kernel/trace/trace_clock.c
index 22b638b..24bf48e 100644
--- a/kernel/trace/trace_clock.c
+++ b/kernel/trace/trace_clock.c
@@ -84,7 +84,7 @@ u64 notrace trace_clock_global(void)
 	local_irq_save(flags);
 
 	this_cpu = raw_smp_processor_id();
-	now = cpu_clock(this_cpu);
+	now = sched_clock_cpu(this_cpu);
 	/*
 	 * If in an NMI context then dont risk lockups and return the
 	 * cpu_clock() time:
