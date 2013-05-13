Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab3EMMBW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 08:01:22 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:56598 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab3EMMBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 08:01:18 -0400
X-AuditID: 85900ec0-d4ccab900000151e-a3-5190d60b3076
Subject: [PATCH 3/3] [CLEANUP/SPARSE] tracing/kprobes: Make print_*probe_event
 static
To: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Tom Zanussi <tom.zanussi@intel.com>
Date: Mon, 13 May 2013 20:58:39 +0900
Message-ID: <20130513115839.6545.83067.stgit@mhiramat-M0-7522>
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

According to sparse warning, print_*probe_event static because
those functions are not directly called from outside.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
---
 kernel/trace/trace_kprobe.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 81c5109..9f46e98 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -962,7 +962,7 @@ kretprobe_trace_func(struct trace_probe *tp, struct kretprobe_instance *ri,
 }
 
 /* Event entry printers */
-enum print_line_t
+static enum print_line_t
 print_kprobe_event(struct trace_iterator *iter, int flags,
 		   struct trace_event *event)
 {
@@ -998,7 +998,7 @@ partial:
 	return TRACE_TYPE_PARTIAL_LINE;
 }
 
-enum print_line_t
+static enum print_line_t
 print_kretprobe_event(struct trace_iterator *iter, int flags,
 		      struct trace_event *event)
 {

