Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934293Ab3BTHiW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 02:38:22 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:50411 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933891Ab3BTHiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 02:38:21 -0500
From: Sha Zhengju <handai.szj@gmail.com>
To: linux-kernel@vger.kernel.org, mingo@kernel.org
Cc: Sha Zhengju <handai.szj@taobao.com>
Subject: [PATCH] sched/core: remove obsolete nr_uninterruptible()
Date: Wed, 20 Feb 2013 15:37:53 +0800
Message-Id: <1361345873-6440-1-git-send-email-handai.szj@taobao.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sha Zhengju <handai.szj@taobao.com>

Signed-off-by: Sha Zhengju <handai.szj@taobao.com>
---
 kernel/sched/core.c |   17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c0b07c3..792f6fc 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1957,23 +1957,6 @@ unsigned long nr_running(void)
 	return sum;
 }
 
-unsigned long nr_uninterruptible(void)
-{
-	unsigned long i, sum = 0;
-
-	for_each_possible_cpu(i)
-		sum += cpu_rq(i)->nr_uninterruptible;
-
-	/*
-	 * Since we read the counters lockless, it might be slightly
-	 * inaccurate. Do not allow it to go below zero though:
-	 */
-	if (unlikely((long)sum < 0))
-		sum = 0;
-
-	return sum;
-}
-
 unsigned long long nr_context_switches(void)
 {
 	int i;
-- 
1.7.9.5

