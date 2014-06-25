Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032AbaFYFuM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 01:50:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36214 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992AbaFYFuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 01:50:09 -0400
Date: Tue, 24 Jun 2014 22:49:58 -0700
From: tip-bot for Steven Rostedt <tipbot@zytor.com>
Message-ID: <tip-1545d8aca9ac1cb3f503fb9c29543d539d99c7af@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <20140612204144.018410d4@gandalf.local.home>
References: <20140612204144.018410d4@gandalf.local.home>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent:
  Clean up format of args in jbd2 plugin
Git-Commit-ID: 1545d8aca9ac1cb3f503fb9c29543d539d99c7af
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1545d8aca9ac1cb3f503fb9c29543d539d99c7af
Gitweb:     http://git.kernel.org/tip/1545d8aca9ac1cb3f503fb9c29543d539d99c7af
Author:     Steven Rostedt <rostedt@goodmis.org>
AuthorDate: Thu, 12 Jun 2014 20:41:44 -0400
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Thu, 19 Jun 2014 18:18:37 +0200

tools lib traceevent: Clean up format of args in jbd2 plugin

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
 
