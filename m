Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185AbaELQBS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 12:01:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53572 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248AbaELQBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 12:01:15 -0400
Date: Mon, 12 May 2014 09:00:53 -0700
From: tip-bot for Dongsheng <tipbot@zytor.com>
Message-ID: <tip-e936e8e459e14af7432a775f8139a79b71e41afc@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, yangds.fnst@cn.fujitsu.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, yangds.fnst@cn.fujitsu.com
In-Reply-To: <6d2f55dc1e02c1e29a5d70bfeb9d6e8863caf2aa.1399273302.git.yangds.fnst@cn.fujitsu.com>
References: <6d2f55dc1e02c1e29a5d70bfeb9d6e8863caf2aa.1399273302.git.yangds.fnst@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Adapt the TASK_STATE_TO_CHAR_STR to new value in kernel space.
Git-Commit-ID: e936e8e459e14af7432a775f8139a79b71e41afc
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

Commit-ID:  e936e8e459e14af7432a775f8139a79b71e41afc
Gitweb:     http://git.kernel.org/tip/e936e8e459e14af7432a775f8139a79b71e41afc
Author:     Dongsheng <yangds.fnst@cn.fujitsu.com>
AuthorDate: Mon, 5 May 2014 16:05:54 +0900
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Mon, 12 May 2014 10:01:49 +0200

perf tools: Adapt the TASK_STATE_TO_CHAR_STR to new value in kernel space.

Currently, TASK_STATE_TO_CHAR_STR in kernel space is already expanded to RSDTtZXxKWP,
but it is still RSDTtZX in perf sched tool.

This patch update TASK_STATE_TO_CHAR_STR to the new value in kernel space.

Signed-off-by: Dongsheng <yangds.fnst@cn.fujitsu.com>
Link: http://lkml.kernel.org/r/6d2f55dc1e02c1e29a5d70bfeb9d6e8863caf2aa.1399273302.git.yangds.fnst@cn.fujitsu.com
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/builtin-sched.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 7eae501..4f0dd21 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -66,7 +66,7 @@ struct sched_atom {
 	struct task_desc	*wakee;
 };
 
-#define TASK_STATE_TO_CHAR_STR "RSDTtZX"
+#define TASK_STATE_TO_CHAR_STR "RSDTtZXxKWP"
 
 enum thread_state {
 	THREAD_SLEEPING = 0,
