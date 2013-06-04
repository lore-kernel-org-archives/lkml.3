Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902Ab3FDOOf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 10:14:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46886 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756261Ab3FDOIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 10:08:30 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Libin <huawei.libin@huawei.com>, <jiang.liu@huawei.com>,
        <guohanjun@huawei.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 48/70] sched/debug: Fix sd->*_idx limit range avoiding overflow
Date: Tue,  4 Jun 2013 15:07:04 +0100
Message-Id: <1370354846-14213-49-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370354846-14213-1-git-send-email-luis.henriques@canonical.com>
References: <1370354846-14213-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: libin <huawei.libin@huawei.com>

commit fd9b86d37a600488dbd80fe60cca46b822bff1cd upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/sched/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index e22a1f0..89e8c2c 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5435,7 +5435,7 @@ static void sd_free_ctl_entry(struct ctl_table **tablep)
 }
 
 static int min_load_idx = 0;
-static int max_load_idx = CPU_LOAD_IDX_MAX;
+static int max_load_idx = CPU_LOAD_IDX_MAX-1;
 
 static void
 set_table_entry(struct ctl_table *entry,
-- 
1.8.1.2

