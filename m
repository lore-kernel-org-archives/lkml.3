Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807Ab3EIFrh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 01:47:37 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:58078 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638Ab3EIFrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 01:47:33 -0400
X-AuditID: 85900ec0-d60ccb900000151e-97-518b3873a02a
Subject: [PATCH 11/11] tracing/kprobes: Support soft-mode disabling
To: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Tom Zanussi <tom.zanussi@intel.com>
Date: Thu, 09 May 2013 14:44:54 +0900
Message-ID: <20130509054454.30398.7237.stgit@mhiramat-M0-7522>
In-Reply-To: <20130509054405.30398.73831.stgit@mhiramat-M0-7522>
References: <20130509054405.30398.73831.stgit@mhiramat-M0-7522>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support soft-mode disabling on kprobe-based dynamic events.
Soft-disabling is just ignoring recording if the soft disabled
flag is set.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Tom Zanussi <tom.zanussi@intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 kernel/trace/trace_kprobe.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index fee865d..636d45f 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -845,6 +845,9 @@ __kprobe_trace_func(struct trace_probe *tp, struct pt_regs *regs,
 
 	WARN_ON(call != ftrace_file->event_call);
 
+	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &ftrace_file->flags))
+		return;
+
 	local_save_flags(irq_flags);
 	pc = preempt_count();
 
@@ -893,6 +896,9 @@ __kretprobe_trace_func(struct trace_probe *tp, struct kretprobe_instance *ri,
 
 	WARN_ON(call != ftrace_file->event_call);
 
+	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &ftrace_file->flags))
+		return;
+
 	local_save_flags(irq_flags);
 	pc = preempt_count();
 

