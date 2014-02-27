Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593AbaB0MGv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 07:06:51 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:52779 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296AbaB0MGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 07:06:49 -0500
Date: Thu, 27 Feb 2014 17:36:41 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, josh@joshtriplett.org
Subject: [PATCH 27/46] kernel: Mark function as static in
 kernel/trace/trace_selftest.c
Message-ID: <6f07c0ca098678587c811d11ded0045293b090cc.1393493277.git.rashika.kheria@gmail.com>
References: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark function as static in kernel/trace/trace_selftest.c because it is
not used outside this file.

This eliminates the following warning in kernel/trace/trace_selftest.c:
kernel/trace/trace_selftest.c:318:5: warning: no previous prototype for ‘trace_selftest_startup_dynamic_tracing’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/trace/trace_selftest.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index e98fca6..bfecd63 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -315,9 +315,9 @@ static int trace_selftest_ops(int cnt)
 }
 
 /* Test dynamic code modification and ftrace filters */
-int trace_selftest_startup_dynamic_tracing(struct tracer *trace,
-					   struct trace_array *tr,
-					   int (*func)(void))
+static int trace_selftest_startup_dynamic_tracing(struct tracer *trace,
+						  struct trace_array *tr,
+						  int (*func)(void))
 {
 	int save_ftrace_enabled = ftrace_enabled;
 	unsigned long count;
-- 
1.7.9.5

