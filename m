Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444Ab3JJLZo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 07:25:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42053 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861Ab3JJLZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 07:25:43 -0400
Date: Thu, 10 Oct 2013 04:25:17 -0700
From: tip-bot for Dong Zhu <tipbot@zytor.com>
Message-ID: <tip-2cb763614c1c5baef58045af9304265075f22d0a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org,
        bluezhudong@gmail.com, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, bluezhudong@gmail.com,
        john.stultz@linaro.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de
In-Reply-To: <20131010075618.GH2139@zhudong.nay.redhat.com>
References: <20131010075618.GH2139@zhudong.nay.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] timer stats: Add a 'Collection: active/inactive
 ' line to timer usage statistics
Git-Commit-ID: 2cb763614c1c5baef58045af9304265075f22d0a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 10 Oct 2013 04:25:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2cb763614c1c5baef58045af9304265075f22d0a
Gitweb:     http://git.kernel.org/tip/2cb763614c1c5baef58045af9304265075f22d0a
Author:     Dong Zhu <bluezhudong@gmail.com>
AuthorDate: Thu, 10 Oct 2013 15:56:18 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 10 Oct 2013 09:59:25 +0200

timer stats: Add a 'Collection: active/inactive' line to timer usage statistics

We can enable/disable timer statistics collection via:

  echo [1|0] > /proc/timers_stats

and it would be nice if apps had the ability to check
what the current collection status is.

This patch adds a 'Collection: active/inactive' line to display the
current timer collection status.

Also bump up the timer stats version to v0.3.

Signed-off-by: Dong Zhu <bluezhudong@gmail.com>
Cc: John Stultz <john.stultz@linaro.org>
Link: http://lkml.kernel.org/r/20131010075618.GH2139@zhudong.nay.redhat.com
[ Improved the changelog and the code. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/time/timer_stats.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/time/timer_stats.c b/kernel/time/timer_stats.c
index 0b537f2..1fb08f2 100644
--- a/kernel/time/timer_stats.c
+++ b/kernel/time/timer_stats.c
@@ -298,15 +298,15 @@ static int tstats_show(struct seq_file *m, void *v)
 	period = ktime_to_timespec(time);
 	ms = period.tv_nsec / 1000000;
 
-	seq_puts(m, "Timer Stats Version: v0.2\n");
+	seq_puts(m, "Timer Stats Version: v0.3\n");
 	seq_printf(m, "Sample period: %ld.%03ld s\n", period.tv_sec, ms);
 	if (atomic_read(&overflow_count))
-		seq_printf(m, "Overflow: %d entries\n",
-			atomic_read(&overflow_count));
+		seq_printf(m, "Overflow: %d entries\n", atomic_read(&overflow_count));
+	seq_printf(m, "Collection: %s\n", timer_stats_active ? "active" : "inactive");
 
 	for (i = 0; i < nr_entries; i++) {
 		entry = entries + i;
- 		if (entry->timer_flag & TIMER_STATS_FLAG_DEFERRABLE) {
+		if (entry->timer_flag & TIMER_STATS_FLAG_DEFERRABLE) {
 			seq_printf(m, "%4luD, %5d %-16s ",
 				entry->count, entry->pid, entry->comm);
 		} else {
