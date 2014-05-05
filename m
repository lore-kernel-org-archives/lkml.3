Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893AbaEEIFq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 04:05:46 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:27050 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754777AbaEEIFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 04:05:43 -0400
X-IronPort-AV: E=Sophos;i="4.97,985,1389715200"; 
   d="scan'208";a="30073728"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <jolsa@redhat.com>
CC: <a.p.zijlstra@chello.nl>, <paulus@samba.org>, <mingo@redhat.com>,
        <acme@kernel.org>, <linux-kernel@vger.kernel.org>,
        Dongsheng <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 1/3] perf tools: add missing event for perf sched record.
Date: Mon, 5 May 2014 16:05:53 +0900
Message-ID: <710c6edd2162b2cea1711443f54de47c0210d9fd.1399273302.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1399273302.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1399273302.git.yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.49]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dongsheng <yangds.fnst@cn.fujitsu.com>

We should record and process sched:sched_wakeup_new event in
perf sched tool, but currently, there is the process function
for it, without recording it in record subcommand.

This patch add -e sched:sched_wakeup_new to perf sched record.

Signed-off-by: Dongsheng <yangds.fnst@cn.fujitsu.com>
---
 tools/perf/builtin-sched.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index d3fb0ed..7eae501 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1635,6 +1635,7 @@ static int __cmd_record(int argc, const char **argv)
 		"-e", "sched:sched_stat_runtime",
 		"-e", "sched:sched_process_fork",
 		"-e", "sched:sched_wakeup",
+		"-e", "sched:sched_wakeup_new",
 		"-e", "sched:sched_migrate_task",
 	};
 
-- 
1.8.2.1

