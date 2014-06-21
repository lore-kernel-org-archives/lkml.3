Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939AbaFUUhv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 16:37:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35055 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706AbaFUUht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 16:37:49 -0400
Date: Sat, 21 Jun 2014 13:37:01 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-4e8c5847d1c55efed896508fb769f78ab07b968a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, john.stultz@linaro.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <20140611234606.840900621@linutronix.de>
References: <20140611234606.840900621@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] tsacct: Use ktime_get_ts()
Git-Commit-ID: 4e8c5847d1c55efed896508fb769f78ab07b968a
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

Commit-ID:  4e8c5847d1c55efed896508fb769f78ab07b968a
Gitweb:     http://git.kernel.org/tip/4e8c5847d1c55efed896508fb769f78ab07b968a
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 11 Jun 2014 23:59:13 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 12 Jun 2014 16:18:45 +0200

tsacct: Use ktime_get_ts()

do_posix_clock_monotonic_gettime() is a leftover from the initial
posix timer implementation which maps to ktime_get_ts()

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140611234606.840900621@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/tsacct.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/tsacct.c b/kernel/tsacct.c
index a1dd9a1..ea6d170 100644
--- a/kernel/tsacct.c
+++ b/kernel/tsacct.c
@@ -38,7 +38,7 @@ void bacct_add_tsk(struct user_namespace *user_ns,
 	BUILD_BUG_ON(TS_COMM_LEN < TASK_COMM_LEN);
 
 	/* calculate task elapsed time in timespec */
-	do_posix_clock_monotonic_gettime(&uptime);
+	ktime_get_ts(&uptime);
 	ts = timespec_sub(uptime, tsk->start_time);
 	/* rebase elapsed time to usec (should never be negative) */
 	ac_etime = timespec_to_ns(&ts);
