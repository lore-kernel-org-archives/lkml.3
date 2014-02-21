Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287AbaBUVdp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 16:33:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59372 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756256AbaBUVdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 16:33:42 -0500
Date: Fri, 21 Feb 2014 13:32:58 -0800
From: tip-bot for Dongsheng Yang <tipbot@zytor.com>
Message-ID: <tip-103fc73128e3c55773d7f60998f9296c256df3a5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, yangds.fnst@cn.fujitsu.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, yangds.fnst@cn.fujitsu.com
In-Reply-To: <4e28ec36fb49e8906027cbbdd900ab26a149905e.1392103744.git.yangds.fnst@cn.fujitsu.com>
References: <4e28ec36fb49e8906027cbbdd900ab26a149905e.1392103744.git.yangds.fnst@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Prio:
  Use DEFAULT_PRIO to define NICE_TO_PRIO and PRIO_TO_NICE.
Git-Commit-ID: 103fc73128e3c55773d7f60998f9296c256df3a5
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

Commit-ID:  103fc73128e3c55773d7f60998f9296c256df3a5
Gitweb:     http://git.kernel.org/tip/103fc73128e3c55773d7f60998f9296c256df3a5
Author:     Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
AuthorDate: Tue, 11 Feb 2014 15:34:45 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 21 Feb 2014 21:43:20 +0100

sched: Prio: Use DEFAULT_PRIO to define NICE_TO_PRIO and PRIO_TO_NICE.

There is already a macro named DEFAULT_PRIO in prio.h, we can use it
to define NICE_TO_PRIO and PRIO_TO_NICE rather than use hard coding
of (MAX_RT_PRIO + 20).

cc: Peter Zijlstra <peterz@infradead.org>
cc: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/4e28ec36fb49e8906027cbbdd900ab26a149905e.1392103744.git.yangds.fnst@cn.fujitsu.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
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
