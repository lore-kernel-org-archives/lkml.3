Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340AbaDOSqN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 14:46:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33454 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755328AbaDOSqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 14:46:09 -0400
Date: Tue, 15 Apr 2014 11:45:56 -0700
From: tip-bot for Viresh Kumar <tipbot@zytor.com>
Message-ID: <tip-27630532ef5ead28b98cfe28d8f95222ef91c2b7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        viresh.kumar@linaro.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        viresh.kumar@linaro.org, tglx@linutronix.de
In-Reply-To: <40939c05f2d65d781b92b20302b02243d0654224.1397537987.git.viresh.kumar@linaro.org>
References: <40939c05f2d65d781b92b20302b02243d0654224.1397537987.git.viresh.kumar@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] tick-sched:
  Check tick_nohz_enabled in tick_nohz_switch_to_nohz()
Git-Commit-ID: 27630532ef5ead28b98cfe28d8f95222ef91c2b7
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

Commit-ID:  27630532ef5ead28b98cfe28d8f95222ef91c2b7
Gitweb:     http://git.kernel.org/tip/27630532ef5ead28b98cfe28d8f95222ef91c2b7
Author:     Viresh Kumar <viresh.kumar@linaro.org>
AuthorDate: Tue, 15 Apr 2014 10:54:41 +0530
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 15 Apr 2014 20:26:58 +0200

tick-sched: Check tick_nohz_enabled in tick_nohz_switch_to_nohz()

Since commit d689fe222 (NOHZ: Check for nohz active instead of nohz
enabled) the tick_nohz_switch_to_nohz() function returns because it
checks for the tick_nohz_active flag. This can't be set, because the
function itself sets it.

Undo the change in tick_nohz_switch_to_nohz().

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org
Cc: fweisbec@gmail.com
Cc: Arvind.Chauhan@arm.com
Cc: linaro-networking@linaro.org
Cc: <stable@vger.kernel.org> # 3.13+
Link: http://lkml.kernel.org/r/40939c05f2d65d781b92b20302b02243d0654224.1397537987.git.viresh.kumar@linaro.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/tick-sched.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index e947d96..6558b7a 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -970,7 +970,7 @@ static void tick_nohz_switch_to_nohz(void)
 	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
 	ktime_t next;
 
-	if (!tick_nohz_active)
+	if (!tick_nohz_enabled)
 		return;
 
 	local_irq_disable();
