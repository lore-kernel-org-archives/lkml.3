Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865AbaBVSEP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 13:04:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41370 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424AbaBVSEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 13:04:12 -0500
Date: Sat, 22 Feb 2014 10:03:24 -0800
From: tip-bot for Dongsheng Yang <tipbot@zytor.com>
Message-ID: <tip-7e298d60f717257dc8365c975f45ff9c37165362@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, yangds.fnst@cn.fujitsu.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, yangds.fnst@cn.fujitsu.com
In-Reply-To: <4e28ec36fb49e8906027cbbdd900ab26a149905e.1392103744.git.yangds.fnst@cn.fujitsu.com>
References: <4e28ec36fb49e8906027cbbdd900ab26a149905e.1392103744.git.yangds.fnst@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/prio:
  Use DEFAULT_PRIO to define NICE_TO_PRIO() and PRIO_TO_NICE()
Git-Commit-ID: 7e298d60f717257dc8365c975f45ff9c37165362
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

Commit-ID:  7e298d60f717257dc8365c975f45ff9c37165362
Gitweb:     http://git.kernel.org/tip/7e298d60f717257dc8365c975f45ff9c37165362
Author:     Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
AuthorDate: Tue, 11 Feb 2014 15:34:45 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 22 Feb 2014 18:11:29 +0100

sched/prio: Use DEFAULT_PRIO to define NICE_TO_PRIO() and PRIO_TO_NICE()

There is already a macro named DEFAULT_PRIO in prio.h, we can use it
to define NICE_TO_PRIO and PRIO_TO_NICE rather than use hard coding
of (MAX_RT_PRIO + 20).

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/4e28ec36fb49e8906027cbbdd900ab26a149905e.1392103744.git.yangds.fnst@cn.fujitsu.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/sched/prio.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched/prio.h b/include/linux/sched/prio.h
index 410ccb7..1ceaaa1 100644
--- a/include/linux/sched/prio.h
+++ b/include/linux/sched/prio.h
@@ -25,8 +25,8 @@
  * to static priority [ MAX_RT_PRIO..MAX_PRIO-1 ],
  * and back.
  */
-#define NICE_TO_PRIO(nice)	(MAX_RT_PRIO + (nice) + 20)
-#define PRIO_TO_NICE(prio)	((prio) - MAX_RT_PRIO - 20)
+#define NICE_TO_PRIO(nice)	((nice) + DEFAULT_PRIO)
+#define PRIO_TO_NICE(prio)	((prio) - DEFAULT_PRIO)
 
 /*
  * 'User priority' is the nice value converted to something we
