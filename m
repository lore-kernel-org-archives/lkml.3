Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751677Ab3DHEHP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 00:07:15 -0400
Received: from intranet.asianux.com ([58.214.24.6]:50654 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab3DHEHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 00:07:14 -0400
X-Spam-Score: -100.7
Message-ID: <51624254.30301@asianux.com>
Date: Mon, 08 Apr 2013 12:06:44 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: rostedt@goodmis.org, Frederic Weisbecker <fweisbec@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] kernel: trace: strncpy, using strlcpy instead of strncpy
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  for NUL terminated string, need always set '\0' at the end.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 kernel/trace/trace.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 829b2be..07860b9 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -125,7 +125,7 @@ static bool allocate_snapshot;
 
 static int __init set_cmdline_ftrace(char *str)
 {
-	strncpy(bootup_tracer_buf, str, MAX_TRACER_SIZE);
+	strlcpy(bootup_tracer_buf, str, MAX_TRACER_SIZE);
 	default_bootup_tracer = bootup_tracer_buf;
 	/* We are using ftrace early, expand it */
 	ring_buffer_expanded = true;
@@ -164,7 +164,7 @@ static char *trace_boot_options __initdata;
 
 static int __init set_trace_boot_options(char *str)
 {
-	strncpy(trace_boot_options_buf, str, MAX_TRACER_SIZE);
+	strlcpy(trace_boot_options_buf, str, MAX_TRACER_SIZE);
 	trace_boot_options = trace_boot_options_buf;
 	return 0;
 }
-- 
1.7.7.6
