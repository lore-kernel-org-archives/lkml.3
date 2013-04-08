Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934979Ab3DHGkd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 02:40:33 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:53833 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934862Ab3DHGkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 02:40:31 -0400
Message-ID: <51626610.2040607@huawei.com>
Date: Mon, 8 Apr 2013 14:39:12 +0800
From: libin <huawei.libin@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
CC: <linux-kernel@vger.kernel.org>, <jiang.liu@huawei.com>,
        <guohanjun@huawei.com>
Subject: [PATCH resend] sched: Fix sd->*_idx limit range avoiding overflow
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
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
-- 1.6.0.2

