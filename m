Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669Ab3EMMCL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 08:02:11 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:56586 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab3EMMBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 08:01:15 -0400
X-AuditID: 85900ec0-d38c8b900000151e-a2-5190d609c0f7
Subject: [PATCH 2/3] [CLEANUP/SPARSE] tracing/kprobes: Fix a sparse warning
 for incorrect type in assignment
To: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Tom Zanussi <tom.zanussi@intel.com>
Date: Mon, 13 May 2013 20:58:37 +0900
Message-ID: <20130513115837.6545.23322.stgit@mhiramat-M0-7522>
In-Reply-To: <20130513115824.6545.47677.stgit@mhiramat-M0-7522>
References: <20130513115824.6545.47677.stgit@mhiramat-M0-7522>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a sparse warning about the rcu operated pointer is
defined without __rcu address space.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
---
 kernel/trace/trace_kprobe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 0a3d8d5..81c5109 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -35,7 +35,7 @@ struct trace_probe {
 	const char		*symbol;	/* symbol name */
 	struct ftrace_event_class	class;
 	struct ftrace_event_call	call;
-	struct ftrace_event_file	**files;
+	struct ftrace_event_file * __rcu *files;
 	ssize_t			size;		/* trace entry size */
 	unsigned int		nr_args;
 	struct probe_arg	args[];

