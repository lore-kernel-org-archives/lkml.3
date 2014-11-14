Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423001AbaKNX1a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 18:27:30 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:5309 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S935409AbaKNXYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 18:24:55 -0500
Message-Id: <20141114232452.223632967@goodmis.org>
User-Agent: quilt/0.61-1
Date: Fri, 14 Nov 2014 18:24:03 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>
Subject: [for-next][PATCH 2/9] tracing: Fix traceoff_on_warning handling on boot command line
References: <20141114232401.493543108@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0002-tracing-Fix-traceoff_on_warning-handling-on-boot-com.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>

According to the documentation, adding "traceoff_on_warning" to the boot
command line should be enough to enable the feature. But right now it is
necessary to specify "traceoff_on_warning=". Along with fixing that, also
verify if the value passed, if any, is either "0" or "off".

Link: http://lkml.kernel.org/r/20141112231400.GL12281@uudg.org

Signed-off-by: Luis Claudio R. Goncalves <lgoncalv@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 8a528392b1f4..75798ab8eb88 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -155,10 +155,11 @@ __setup("ftrace_dump_on_oops", set_ftrace_dump_on_oops);
 
 static int __init stop_trace_on_warning(char *str)
 {
-	__disable_trace_on_warning = 1;
+	if ((strcmp(str, "=0") != 0 && strcmp(str, "=off") != 0))
+		__disable_trace_on_warning = 1;
 	return 1;
 }
-__setup("traceoff_on_warning=", stop_trace_on_warning);
+__setup("traceoff_on_warning", stop_trace_on_warning);
 
 static int __init boot_alloc_snapshot(char *str)
 {
-- 
2.1.1


