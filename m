Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849AbaELQBQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 12:01:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53573 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955AbaELQBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 12:01:15 -0400
Date: Mon, 12 May 2014 09:00:40 -0700
From: tip-bot for Dongsheng <tipbot@zytor.com>
Message-ID: <tip-7fff959783949b2f50454c49e325697073f48dc0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, yangds.fnst@cn.fujitsu.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, yangds.fnst@cn.fujitsu.com
In-Reply-To: <710c6edd2162b2cea1711443f54de47c0210d9fd.1399273302.git.yangds.fnst@cn.fujitsu.com>
References: <710c6edd2162b2cea1711443f54de47c0210d9fd.1399273302.git.yangds.fnst@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Add missing event for perf sched record.
Git-Commit-ID: 7fff959783949b2f50454c49e325697073f48dc0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7fff959783949b2f50454c49e325697073f48dc0
Gitweb:     http://git.kernel.org/tip/7fff959783949b2f50454c49e325697073f48dc0
Author:     Dongsheng <yangds.fnst@cn.fujitsu.com>
AuthorDate: Mon, 5 May 2014 16:05:53 +0900
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Mon, 12 May 2014 10:01:41 +0200

perf tools: Add missing event for perf sched record.

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
 
