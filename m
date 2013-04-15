Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564Ab3DOOQ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 10:16:57 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:50640 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365Ab3DOOQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 10:16:56 -0400
From: Jonghwan Choi <jhbird.choi@gmail.com>
To: libin <huawei.libin@huawei.com>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        <jiang.liu@huawei.com>, <guohanjun@huawei.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: [PATCH 3.8-stable] sched/debug: Fix sd->*_idx limit range avoiding overflow
Date: Mon, 15 Apr 2013 23:15:28 +0900
Message-Id: <1366035328-4780-1-git-send-email-jhbird.choi@samsung.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: libin <huawei.libin@huawei.com>

This patch looks like it should be in the 3.8-stable tree, should we apply
it?

------------------

From: "libin <huawei.libin@huawei.com>"

commit fd9b86d37a600488dbd80fe60cca46b822bff1cd upstream

Commit 201c373e8e ("sched/debug: Limit sd->*_idx range on
sysctl") was an incomplete bug fix.

This patch fixes sd->*_idx limit range to [0 ~ CPU_LOAD_IDX_MAX-1]
avoiding array overflow caused by setting sd->*_idx to CPU_LOAD_IDX_MAX
on sysctl.

Signed-off-by: Libin <huawei.libin@huawei.com>
Cc: <jiang.liu@huawei.com>
Cc: <guohanjun@huawei.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/51626610.2040607@huawei.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 kernel/sched/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 26058d0..112a32a 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4948,7 +4948,7 @@ static void sd_free_ctl_entry(struct ctl_table **tablep)
 }
 
 static int min_load_idx = 0;
-static int max_load_idx = CPU_LOAD_IDX_MAX;
+static int max_load_idx = CPU_LOAD_IDX_MAX-1;
 
 static void
 set_table_entry(struct ctl_table *entry,
-- 
1.7.10.4

