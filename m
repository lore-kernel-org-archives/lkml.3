Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600AbaDONc4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 09:32:56 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:61961 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752149AbaDONcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 09:32:54 -0400
X-IronPort-AV: E=Sophos;i="4.97,863,1389715200"; 
   d="scan'208";a="29292489"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <rostedt@goodmis.org>, <fweisbec@gmail.com>, <mingo@redhat.com>,
        <peterz@infradead.org>, <acme@ghostprotocols.net>
CC: <linux-kernel@vger.kernel.org>, Dongsheng <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 6/8] perf tools: add missing event for perf sched record.
Date: Tue, 15 Apr 2014 21:32:55 +0900
Message-ID: <4111ab24ce8dfdf2700ca3eecba6378116762a16.1397562542.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1397562542.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1397562542.git.yangds.fnst@cn.fujitsu.com>
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
index a32af4e..72ec223 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1695,6 +1695,7 @@ static int __cmd_record(int argc, const char **argv)
 		"-e", "sched:sched_stat_runtime",
 		"-e", "sched:sched_process_fork",
 		"-e", "sched:sched_wakeup",
+		"-e", "sched:sched_wakeup_new",
 		"-e", "sched:sched_migrate_task",
 		"-e", "sched:sched_wait",
 	};
-- 
1.8.2.1

