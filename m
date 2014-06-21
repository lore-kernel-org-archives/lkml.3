Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746AbaFUUhb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 16:37:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35021 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025AbaFUUh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 16:37:29 -0400
Date: Sat, 21 Jun 2014 13:36:34 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-22001821d9cb6ddb83ee4e1f81e6b905de623165@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, john.stultz@linaro.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <20140611234606.764810535@linutronix.de>
References: <20140611234606.764810535@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] acct: Use ktime_get_ts()
Git-Commit-ID: 22001821d9cb6ddb83ee4e1f81e6b905de623165
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  22001821d9cb6ddb83ee4e1f81e6b905de623165
Gitweb:     http://git.kernel.org/tip/22001821d9cb6ddb83ee4e1f81e6b905de623165
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 11 Jun 2014 23:59:12 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 12 Jun 2014 16:18:44 +0200

acct: Use ktime_get_ts()

do_posix_clock_monotonic_gettime() is a leftover from the initial
posix timer implementation which maps to ktime_get_ts()

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140611234606.764810535@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/acct.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/acct.c b/kernel/acct.c
index 808a86f..1be013c 100644
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -484,7 +484,7 @@ static void do_acct_process(struct bsd_acct_struct *acct,
 	strlcpy(ac.ac_comm, current->comm, sizeof(ac.ac_comm));
 
 	/* calculate run_time in nsec*/
-	do_posix_clock_monotonic_gettime(&uptime);
+	ktime_get_ts(&uptime);
 	run_time = (u64)uptime.tv_sec*NSEC_PER_SEC + uptime.tv_nsec;
 	run_time -= (u64)current->group_leader->start_time.tv_sec * NSEC_PER_SEC
 		       + current->group_leader->start_time.tv_nsec;
