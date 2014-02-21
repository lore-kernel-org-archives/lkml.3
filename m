Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356AbaBUVd6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 16:33:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59384 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756324AbaBUVdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 16:33:55 -0500
Date: Fri, 21 Feb 2014 13:33:20 -0800
From: tip-bot for Dongsheng Yang <tipbot@zytor.com>
Message-ID: <tip-eb2ae7dad9dad350b4444962465d7e09bcfc128a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, yangds.fnst@cn.fujitsu.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, yangds.fnst@cn.fujitsu.com
In-Reply-To: <72dc351df816a975e30b6320754fb52823d2aa3f.1392103744.git.yangds.fnst@cn.fujitsu.com>
References: <72dc351df816a975e30b6320754fb52823d2aa3f.1392103744.git.yangds.fnst@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: prio:
  Use NICE_WIDTH macro to avoid using of hard coding of 40 and 20 in prio.h.
Git-Commit-ID: eb2ae7dad9dad350b4444962465d7e09bcfc128a
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

Commit-ID:  eb2ae7dad9dad350b4444962465d7e09bcfc128a
Gitweb:     http://git.kernel.org/tip/eb2ae7dad9dad350b4444962465d7e09bcfc128a
Author:     Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
AuthorDate: Tue, 11 Feb 2014 15:34:47 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 21 Feb 2014 21:43:20 +0100

sched: prio: Use NICE_WIDTH macro to avoid using of hard coding of 40 and 20 in prio.h.

cc: Ingo Molnar <mingo@kernel.org>
cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/72dc351df816a975e30b6320754fb52823d2aa3f.1392103744.git.yangds.fnst@cn.fujitsu.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/sched/prio.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched/prio.h b/include/linux/sched/prio.h
index c6974c4..ac32258 100644
--- a/include/linux/sched/prio.h
+++ b/include/linux/sched/prio.h
@@ -21,8 +21,8 @@
 #define MAX_USER_RT_PRIO	100
 #define MAX_RT_PRIO		MAX_USER_RT_PRIO
 
-#define MAX_PRIO		(MAX_RT_PRIO + 40)
-#define DEFAULT_PRIO		(MAX_RT_PRIO + 20)
+#define MAX_PRIO		(MAX_RT_PRIO + NICE_WIDTH)
+#define DEFAULT_PRIO		(MAX_RT_PRIO + NICE_WIDTH / 2)
 
 /*
  * Convert user-nice values [ -20 ... 0 ... 19 ]
