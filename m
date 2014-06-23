Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803AbaFWIA0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:00:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1524 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752377AbaFWH7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 03:59:34 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 7/7] tools lib traceevent: Clean up format of args in jbd2 plugin
Date: Mon, 23 Jun 2014 09:59:18 +0200
Message-Id: <1403510358-4573-8-git-send-email-jolsa@kernel.org>
In-Reply-To: <1403510358-4573-1-git-send-email-jolsa@kernel.org>
References: <1403510358-4573-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

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
Link: http://lkml.kernel.org/r/20140612204144.018410d4@gandalf.local.home
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/lib/traceevent/plugin_jbd2.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

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
 
-- 
1.8.3.1

