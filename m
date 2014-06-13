Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751746AbaFMAlw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 20:41:52 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:8486 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754267AbaFMAlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 20:41:46 -0400
Date: Thu, 12 Jun 2014 20:41:44 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH] tools lib traceevent: Clean up format of args in jbd2
 plugin
Message-ID: <20140612204144.018410d4@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While synchronizing what's in trace-cmd vs what's in perf, I came
across a change that was made when entering the jbd2 plugin into
the tools/lib/traceevent directory. For example, one of the function
prototypes went from:

unsigned long long process_jbd2_dev_to_name(struct trace_seq *s,
					    unsigned long long *args)

to:

static unsigned long long
process_jbd2_dev_to_name(struct trace_seq *s,
			 unsigned long long *args)

I can understand the line break after the long long, but there's no
reason to keep args on a separate line.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
diff --git a/tools/lib/traceevent/plugin_jbd2.c b/tools/lib/traceevent/plugin_jbd2.c
index 0db714c..5c23d5b 100644
--- a/tools/lib/traceevent/plugin_jbd2.c
+++ b/tools/lib/traceevent/plugin_jbd2.c
@@ -30,8 +30,7 @@
 #define MINOR(dev)	((unsigned int) ((dev) & MINORMASK))
 
 static unsigned long long
-process_jbd2_dev_to_name(struct trace_seq *s,
-			 unsigned long long *args)
+process_jbd2_dev_to_name(struct trace_seq *s, unsigned long long *args)
 {
 	unsigned int dev = args[0];
 
@@ -40,8 +39,7 @@ process_jbd2_dev_to_name(struct trace_seq *s,
 }
 
 static unsigned long long
-process_jiffies_to_msecs(struct trace_seq *s,
-			 unsigned long long *args)
+process_jiffies_to_msecs(struct trace_seq *s, unsigned long long *args)
 {
 	unsigned long long jiffies = args[0];
 
