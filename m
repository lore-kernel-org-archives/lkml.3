Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989AbaFUUiE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 16:38:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35085 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037AbaFUUiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 16:38:00 -0400
Date: Sat, 21 Jun 2014 13:37:12 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-a9821c741c960a77a7f08491883f9cc4bffd2279@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org, hpa@zytor.com,
        mingo@kernel.org, jason.wessel@windriver.com, peterz@infradead.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, john.stultz@linaro.org,
        linux-kernel@vger.kernel.org, jason.wessel@windriver.com,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <20140611234607.261629142@linutronix.de>
References: <20140611234607.261629142@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] kdb: Use ktime_get_ts()
Git-Commit-ID: a9821c741c960a77a7f08491883f9cc4bffd2279
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

Commit-ID:  a9821c741c960a77a7f08491883f9cc4bffd2279
Gitweb:     http://git.kernel.org/tip/a9821c741c960a77a7f08491883f9cc4bffd2279
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 11 Jun 2014 23:59:16 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 12 Jun 2014 16:18:45 +0200

kdb: Use ktime_get_ts()

do_posix_clock_monotonic_gettime() is a leftover from the initial
posix timer implementation which maps to ktime_get_ts().

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jason Wessel <jason.wessel@windriver.com>
Link: http://lkml.kernel.org/r/20140611234607.261629142@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/debug/kdb/kdb_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index 2f7c760..379650b 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -2472,7 +2472,7 @@ static void kdb_gmtime(struct timespec *tv, struct kdb_tm *tm)
 static void kdb_sysinfo(struct sysinfo *val)
 {
 	struct timespec uptime;
-	do_posix_clock_monotonic_gettime(&uptime);
+	ktime_get_ts(&uptime);
 	memset(val, 0, sizeof(*val));
 	val->uptime = uptime.tv_sec;
 	val->loads[0] = avenrun[0];
