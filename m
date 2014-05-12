Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112AbaELJ1j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 05:27:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14850 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506AbaELJ1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 05:27:34 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Dongsheng <yangds.fnst@cn.fujitsu.com>,
        Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 1/6] perf tools: Add missing event for perf sched record.
Date: Mon, 12 May 2014 11:27:08 +0200
Message-Id: <1399886833-15472-2-git-send-email-jolsa@kernel.org>
In-Reply-To: <1399886833-15472-1-git-send-email-jolsa@kernel.org>
References: <1399886833-15472-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dongsheng <yangds.fnst@cn.fujitsu.com>

We should record and process sched:sched_wakeup_new event in
perf sched tool, but currently, there is the process function
for it, without recording it in record subcommand.

This patch add -e sched:sched_wakeup_new to perf sched record.

Signed-off-by: Dongsheng <yangds.fnst@cn.fujitsu.com>
Link: http://lkml.kernel.org/r/710c6edd2162b2cea1711443f54de47c0210d9fd.1399273302.git.yangds.fnst@cn.fujitsu.com
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
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
1.8.3.1

