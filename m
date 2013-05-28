Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933567Ab3E1D44 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 23:56:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52594 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758864Ab3E1DyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 23:54:12 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Ingo Molnar" <mingo@kernel.org>,
        "libin" <huawei.libin@huawei.com>,
        "Peter Zijlstra" <peterz@infradead.org>, "" <guohanjun@huawei.com>,
        "" <jiang.liu@huawei.com>
Date: Tue, 28 May 2013 04:49:53 +0100
Message-ID: <lsq.1369712993.315847334@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [72/94] sched/debug: Fix sd->*_idx limit range avoiding overflow
In-Reply-To: <lsq.1369712992.755341692@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.46-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6673,7 +6673,7 @@ static void sd_free_ctl_entry(struct ctl
 }
 
 static int min_load_idx = 0;
-static int max_load_idx = CPU_LOAD_IDX_MAX;
+static int max_load_idx = CPU_LOAD_IDX_MAX-1;
 
 static void
 set_table_entry(struct ctl_table *entry,

