Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033Ab3GXTI3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 15:08:29 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:41511 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896Ab3GXTI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 15:08:26 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Mike Galbraith <efault@gmx.de>,
        Kevin Hilman <khilman@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/2] nohz: Do not warn about unstable tsc unless user uses nohz_full
Date: Wed, 24 Jul 2013 21:08:13 +0200
Message-Id: <1374692894-27202-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1374692894-27202-1-git-send-email-fweisbec@gmail.com>
References: <1374692894-27202-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

If the user enables CONFIG_NO_HZ_FULL and runs the kernel on a machine
with an unstable TSC, it will produce a WARN_ON dump as well as taint
the kernel. This is a bit extreme for a kernel that just enables a
feature but doesn't use it.

The warning should only happen if the user tries to use the feature by
either adding nohz_full to the kernel command line, or by enabling
CONFIG_NO_HZ_FULL_ALL that makes nohz used on all CPUs at boot up. Note,
this second feature should not (yet) be used by distros or anyone that
doesn't care if NO_HZ is used or not.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Kevin Hilman <khilman@linaro.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/time/tick-sched.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index e80183f..1102534 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -182,7 +182,8 @@ static bool can_stop_full_tick(void)
 		 * Don't allow the user to think they can get
 		 * full NO_HZ with this machine.
 		 */
-		WARN_ONCE(1, "NO_HZ FULL will not work with unstable sched clock");
+		WARN_ONCE(have_nohz_full_mask,
+			  "NO_HZ FULL will not work with unstable sched clock");
 		return false;
 	}
 #endif
-- 
1.7.5.4

