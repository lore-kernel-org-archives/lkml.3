Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761582Ab3DCCvr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 22:51:47 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:2262 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222Ab3DCCvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 22:51:46 -0400
From: Libin <huawei.libin@huawei.com>
To: <mingo@redhat.com>, <peterz@infradead.org>
CC: <linux-kernel@vger.kernel.org>, <jiang.liu@huawei.com>,
        <guohanjun@huawei.com>, <wangyijing@huawei.com>,
        Libin <huawei.libin@huawei.com>
Subject: [PATCH] sched: Fix sd->*_idx limit range avoiding overflow
Date: Wed, 3 Apr 2013 10:49:52 +0800
Message-ID: <1364957392-49920-1-git-send-email-huawei.libin@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.74.57]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 201c373e8e ("sched/debug: Limit sd->*_idx range on sysctl")
was an incomplete bug fix. This patch fixs sd->*_idx limit range to
[0 ~ CPU_LOAD_IDX_MAX - 1] avioding array overflow caused by setting
sd->*_idx to CPU_LOAD_IDX_MAX on sysctl.

Signed-off-by: Libin <huawei.libin@huawei.com>
---
 kernel/sched/core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 7f12624..ba89ada 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4999,7 +4999,7 @@ static void sd_free_ctl_entry(struct ctl_table **tablep)
 }
 
 static int min_load_idx = 0;
-static int max_load_idx = CPU_LOAD_IDX_MAX;
+static int max_load_idx = CPU_LOAD_IDX_MAX - 1;
 
 static void
 set_table_entry(struct ctl_table *entry,
-- 
1.6.0.2


