Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645AbaCLKd2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 06:33:28 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:36921 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753715AbaCLKce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 06:32:34 -0400
X-IronPort-AV: E=Sophos;i="4.97,636,1389715200"; 
   d="scan'208";a="9683575"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 3/3] sched: Use clamp() and clamp_val() to make it more readable.
Date: Wed, 12 Mar 2014 18:26:44 +0800
Message-Id: <08e669fea4242209aa625237214410c6bbf67dba.1394619587.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1394619587.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1394619587.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/12 18:26:13,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/12 18:26:36,
	Serialize complete at 2014/03/12 18:26:36
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
index 259ab85..85f4231 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3068,17 +3068,10 @@ SYSCALL_DEFINE1(nice, int, increment)
 	 * We don't have to worry. Conceptually one call occurs first
 	 * and we have a single winner.
 	 */
-	if (increment < -NICE_WIDTH)
-		increment = -NICE_WIDTH;
-	if (increment > NICE_WIDTH)
-		increment = NICE_WIDTH;
-
+	increment = clamp(increment, -NICE_WIDTH, NICE_WIDTH);
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

