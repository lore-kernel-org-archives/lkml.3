Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280AbaKLXOH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 18:14:07 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:63928 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273AbaKLXOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 18:14:05 -0500
Date: Wed, 12 Nov 2014 21:14:00 -0200
From: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Clark Williams <clark.williams@gmail.com>
Subject: [PATCH] ftrace: fix traceoff_on_warning handling on boot command line
Message-ID: <20141112231400.GL12281@uudg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven,

While backporting traceoff_on_warning to 3.10.33-rt we noticed a slightly
difference between what was stated on Documentation/kernel-parameters.txt
and the actual code.

Please consider the following patch for inclusion.

Best regards,
Luis

------

ftrace: fix traceoff_on_warning handling on boot command line

According to the documentation, adding "traceoff_on_warning" to the boot
command line should be enough to enable the feature. But right now it is
necessary to specify "traceoff_on_warning=". Along with fixing that, also
verify if the value passed, if any, is either "0" or "off".

Signed-off-by: Luis Claudio R. Goncalves <lgoncalv@redhat.com>

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index f68981f..a956a60 100644
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


