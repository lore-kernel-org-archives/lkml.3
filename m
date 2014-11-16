Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531AbaKPMdx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 07:33:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35556 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755510AbaKPMdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 07:33:50 -0500
Date: Sun, 16 Nov 2014 04:33:19 -0800
From: "tip-bot for pang.xunlei" <tipbot@zytor.com>
Message-ID: <tip-c1a2b5f6293caa14804adca1840eeea1e8f6b322@git.kernel.org>
Cc: mingo@kernel.org, peterz@infradead.org, juri.lelli@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de, hpa@zytor.com,
        torvalds@linux-foundation.org, pang.xunlei@linaro.org,
        linux-kernel@vger.kernel.org
Reply-To: mingo@kernel.org, peterz@infradead.org, juri.lelli@gmail.com,
        hpa@zytor.com, torvalds@linux-foundation.org, tglx@linutronix.de,
        rostedt@goodmis.org, linux-kernel@vger.kernel.org,
        pang.xunlei@linaro.org
In-Reply-To: <1415260327-30465-4-git-send-email-pang.xunlei@linaro.org>
References: <1415260327-30465-4-git-send-email-pang.xunlei@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/deadline:
  Remove unnecessary definitions in cpudeadline.h
Git-Commit-ID: c1a2b5f6293caa14804adca1840eeea1e8f6b322
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

Commit-ID:  c1a2b5f6293caa14804adca1840eeea1e8f6b322
Gitweb:     http://git.kernel.org/tip/c1a2b5f6293caa14804adca1840eeea1e8f6b322
Author:     pang.xunlei <pang.xunlei@linaro.org>
AuthorDate: Thu, 6 Nov 2014 15:52:04 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 16 Nov 2014 10:59:00 +0100

sched/deadline: Remove unnecessary definitions in cpudeadline.h

Actually, cpudl_set() and cpudl_init() can never be used without
CONFIG_SMP.

Signed-off-by: pang.xunlei <pang.xunlei@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Juri Lelli <juri.lelli@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1415260327-30465-4-git-send-email-pang.xunlei@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/cpudeadline.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/kernel/sched/cpudeadline.h b/kernel/sched/cpudeadline.h
index 538c979..020039b 100644
--- a/kernel/sched/cpudeadline.h
+++ b/kernel/sched/cpudeadline.h
@@ -25,9 +25,6 @@ int cpudl_find(struct cpudl *cp, struct task_struct *p,
 void cpudl_set(struct cpudl *cp, int cpu, u64 dl, int is_valid);
 int cpudl_init(struct cpudl *cp);
 void cpudl_cleanup(struct cpudl *cp);
-#else
-#define cpudl_set(cp, cpu, dl) do { } while (0)
-#define cpudl_init() do { } while (0)
 #endif /* CONFIG_SMP */
 
 #endif /* _LINUX_CPUDL_H */
