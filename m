Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932268AbaELJ2r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 05:28:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19049 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753008AbaELJ1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 05:27:32 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Dongsheng <yangds.fnst@cn.fujitsu.com>,
        Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 2/6] perf tools: Adapt the TASK_STATE_TO_CHAR_STR to new value in kernel space.
Date: Mon, 12 May 2014 11:27:09 +0200
Message-Id: <1399886833-15472-3-git-send-email-jolsa@kernel.org>
In-Reply-To: <1399886833-15472-1-git-send-email-jolsa@kernel.org>
References: <1399886833-15472-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dongsheng <yangds.fnst@cn.fujitsu.com>

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
-- 
1.8.3.1

