Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393Ab3GKAcu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 20:32:50 -0400
Received: from intranet.asianux.com ([58.214.24.6]:21727 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210Ab3GKAcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 20:32:48 -0400
X-Spam-Score: -100.8
Message-ID: <51DDFCF8.2090808@asianux.com>
Date: Thu, 11 Jul 2013 08:31:52 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
CC: "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] kernel: trace: remove __init from race_selftest_startup_function()
 and trace_selftest_startup_function_graph()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Like other trace_selftest_startup_*, trace_selftest_startup_function()
and trace_selftest_startup_function_graph() need in normal section, or
may cause section mismatch.

The related warnings:

    LD      kernel/trace/built-in.o
  WARNING: kernel/trace/built-in.o(.data+0x154c): Section mismatch in reference from the variable function_trace to the function .init.text:trace_selftest_startup_function()
  The variable function_trace references
  the function __init trace_selftest_startup_function()
  If the reference is valid then annotate the
  variable with __init* or __refdata (see linux/init.h) or name the variable:
  *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 kernel/trace/trace_selftest.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index a7329b7..e341b9d 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -640,7 +640,7 @@ out:
  * Enable ftrace, sleep 1/10 second, and then read the trace
  * buffer to see if all is in order.
  */
-__init int
+int
 trace_selftest_startup_function(struct tracer *trace, struct trace_array *tr)
 {
 	int save_ftrace_enabled = ftrace_enabled;
@@ -734,7 +734,7 @@ static int trace_graph_entry_watchdog(struct ftrace_graph_ent *trace)
  * Pretty much the same than for the function tracer from which the selftest
  * has been borrowed.
  */
-__init int
+int
 trace_selftest_startup_function_graph(struct tracer *trace,
 					struct trace_array *tr)
 {
-- 
1.7.7.6
