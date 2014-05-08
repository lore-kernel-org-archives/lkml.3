Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942AbaEHKfH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 06:35:07 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:29602 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752831AbaEHKfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 06:35:05 -0400
X-IronPort-AV: E=Sophos;i="4.97,1010,1389715200"; 
   d="scan'208";a="30251566"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <mingo@redhat.com>, <peterz@infradead.org>
CC: <linux-kernel@vger.kernel.org>,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH] sched: Use clamp() and clamp_val() to make it more readable.
Date: Thu, 8 May 2014 18:35:15 +0900
Message-ID: <1399541715-19568-1-git-send-email-yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.49]
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
index ff871f5..79f8638 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3039,17 +3039,10 @@ SYSCALL_DEFINE1(nice, int, increment)
 	 * We don't have to worry. Conceptually one call occurs first
 	 * and we have a single winner.
 	 */
-	if (increment < -40)
-		increment = -40;
-	if (increment > 40)
-		increment = 40;
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

