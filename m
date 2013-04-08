Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965024Ab3DHPbE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 11:31:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37850 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964888Ab3DHPbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 11:31:00 -0400
Date: Mon, 8 Apr 2013 08:28:13 -0700
From: tip-bot for libin <tipbot@zytor.com>
Message-ID: <tip-fd9b86d37a600488dbd80fe60cca46b822bff1cd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        huawei.libin@huawei.com, peterz@infradead.org, tglx@linutronix.de,
        jiang.liu@huawei.com, guohanjun@huawei.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        huawei.libin@huawei.com, peterz@infradead.org, tglx@linutronix.de,
        jiang.liu@huawei.com, guohanjun@huawei.com
In-Reply-To: <51626610.2040607@huawei.com>
References: <51626610.2040607@huawei.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched/debug: Fix sd->
 *_idx limit range avoiding overflow
Git-Commit-ID: fd9b86d37a600488dbd80fe60cca46b822bff1cd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 08 Apr 2013 08:28:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fd9b86d37a600488dbd80fe60cca46b822bff1cd
Gitweb:     http://git.kernel.org/tip/fd9b86d37a600488dbd80fe60cca46b822bff1cd
Author:     libin <huawei.libin@huawei.com>
AuthorDate: Mon, 8 Apr 2013 14:39:12 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 8 Apr 2013 13:23:03 +0200

sched/debug: Fix sd->*_idx limit range avoiding overflow

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
---
 kernel/sched/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 306943f..fa07792 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4933,7 +4933,7 @@ static void sd_free_ctl_entry(struct ctl_table **tablep)
 }
 
 static int min_load_idx = 0;
-static int max_load_idx = CPU_LOAD_IDX_MAX;
+static int max_load_idx = CPU_LOAD_IDX_MAX-1;
 
 static void
 set_table_entry(struct ctl_table *entry,
