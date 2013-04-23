Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827Ab3DWWNX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 18:13:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34129 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662Ab3DWVxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 17:53:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Libin <huawei.libin@huawei.com>, jiang.liu@huawei.com,
        guohanjun@huawei.com, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: [ 22/42] sched/debug: Fix sd->*_idx limit range avoiding overflow
Date: Tue, 23 Apr 2013 14:52:20 -0700
Message-Id: <20130423215207.778285571@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130423215205.523980967@linuxfoundation.org>
References: <20130423215205.523980967@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/sched/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4950,7 +4950,7 @@ static void sd_free_ctl_entry(struct ctl
 }
 
 static int min_load_idx = 0;
-static int max_load_idx = CPU_LOAD_IDX_MAX;
+static int max_load_idx = CPU_LOAD_IDX_MAX-1;
 
 static void
 set_table_entry(struct ctl_table *entry,


