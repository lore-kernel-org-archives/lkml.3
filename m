Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964987Ab3DHPa6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 11:30:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37847 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964888Ab3DHPa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 11:30:56 -0400
Date: Mon, 8 Apr 2013 08:30:37 -0700
From: tip-bot for Chen Gang <tipbot@zytor.com>
Message-ID: <tip-67012ab1d2ce871afea4ee55408f233f97d09d07@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fweisbec@gmail.com, gang.chen@asianux.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, gang.chen@asianux.com, tglx@linutronix.de
In-Reply-To: <51624254.30301@asianux.com>
References: <51624254.30301@asianux.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Fix strncpy() use, use strlcpy()
  instead of strncpy()
Git-Commit-ID: 67012ab1d2ce871afea4ee55408f233f97d09d07
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 08 Apr 2013 08:30:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  67012ab1d2ce871afea4ee55408f233f97d09d07
Gitweb:     http://git.kernel.org/tip/67012ab1d2ce871afea4ee55408f233f97d09d07
Author:     Chen Gang <gang.chen@asianux.com>
AuthorDate: Mon, 8 Apr 2013 12:06:44 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 8 Apr 2013 13:26:56 +0200

perf: Fix strncpy() use, use strlcpy() instead of strncpy()

For NUL terminated string we always need to set '\0' at the end.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
Cc: rostedt@goodmis.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/r/51624254.30301@asianux.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/trace/trace.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 4f1dade..3f5046a 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -132,7 +132,7 @@ static char *default_bootup_tracer;
 
 static int __init set_cmdline_ftrace(char *str)
 {
-	strncpy(bootup_tracer_buf, str, MAX_TRACER_SIZE);
+	strlcpy(bootup_tracer_buf, str, MAX_TRACER_SIZE);
 	default_bootup_tracer = bootup_tracer_buf;
 	/* We are using ftrace early, expand it */
 	ring_buffer_expanded = 1;
@@ -162,7 +162,7 @@ static char *trace_boot_options __initdata;
 
 static int __init set_trace_boot_options(char *str)
 {
-	strncpy(trace_boot_options_buf, str, MAX_TRACER_SIZE);
+	strlcpy(trace_boot_options_buf, str, MAX_TRACER_SIZE);
 	trace_boot_options = trace_boot_options_buf;
 	return 0;
 }
