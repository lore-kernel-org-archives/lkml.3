Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454AbaCEMie (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 07:38:34 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:23445 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753899AbaCEMic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 07:38:32 -0500
X-IronPort-AV: E=Sophos;i="4.97,592,1389715200"; 
   d="scan'208";a="9649259"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: fweisbec@gmail.com, rostedt@goodmis.org, peterz@infradead.org,
        mingo@redhat.com, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 2/3] sched: Use clamp() and clamp_val() to make it more readable.
Date: Wed, 5 Mar 2014 20:36:41 +0800
Message-Id: <0b02fa0f05c9cebca19cadce92cb8c85ee130ce0.1394022835.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <8ae8a3aefb157e9e7d1b62a4c136289e74783eaf.1394022835.git.yangds.fnst@cn.fujitsu.com>
References: <8ae8a3aefb157e9e7d1b62a4c136289e74783eaf.1394022835.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/05 20:35:54,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/05 20:35:54,
	Serialize complete at 2014/03/05 20:35:54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Kees suggested, I use clamp() function to replace the if and
else branch, making it more readable and modular.

Suggested-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 kernel/sched/core.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index ee8004c..5273037 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3070,17 +3070,10 @@ SYSCALL_DEFINE1(nice, int, increment)
 	 * We don't have to worry. Conceptually one call occurs first
 	 * and we have a single winner.
 	 */
-	if (increment < -40)
-		increment = -40;
-	if (increment > 40)
-		increment = 40;
-
+	increment = clamp(increment, -40, 40);
 	nice = task_nice(current) + increment;
-	if (nice < MIN_NICE)
-		nice = MIN_NICE;
-	if (nice > MAX_NICE)
-		nice = MAX_NICE;
 
+	nice = clamp_val(nice, MIN_NICE, MAX_NICE);
 	if (increment < 0 && !can_nice(current, nice))
 		return -EPERM;
 
-- 
1.8.2.1

