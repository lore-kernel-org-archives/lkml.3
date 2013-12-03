Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218Ab3LCNLs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 08:11:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55700 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753477Ab3LCNLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 08:11:44 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 23/28] tools lib traceevent: Use static functions in jbd2 plugin
Date: Tue,  3 Dec 2013 14:09:37 +0100
Message-Id: <1386076182-14484-24-git-send-email-jolsa@redhat.com>
In-Reply-To: <1386076182-14484-1-git-send-email-jolsa@redhat.com>
References: <1386076182-14484-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need for following functions to be global:
  process_jbd2_dev_to_name
  process_jiffies_to_msecs

Making them static.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/lib/traceevent/plugin_jbd2.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/tools/lib/traceevent/plugin_jbd2.c b/tools/lib/traceevent/plugin_jbd2.c
index 5d85de7..2f93f81 100644
--- a/tools/lib/traceevent/plugin_jbd2.c
+++ b/tools/lib/traceevent/plugin_jbd2.c
@@ -29,8 +29,9 @@
 #define MAJOR(dev)	((unsigned int) ((dev) >> MINORBITS))
 #define MINOR(dev)	((unsigned int) ((dev) & MINORMASK))
 
-unsigned long long process_jbd2_dev_to_name(struct trace_seq *s,
-					    unsigned long long *args)
+static unsigned long long
+process_jbd2_dev_to_name(struct trace_seq *s,
+			 unsigned long long *args)
 {
 	unsigned int dev = args[0];
 
@@ -38,8 +39,9 @@ unsigned long long process_jbd2_dev_to_name(struct trace_seq *s,
 	return 0;
 }
 
-unsigned long long process_jiffies_to_msecs(struct trace_seq *s,
-					    unsigned long long *args)
+static unsigned long long
+process_jiffies_to_msecs(struct trace_seq *s,
+			 unsigned long long *args)
 {
 	unsigned long long jiffies = args[0];
 
-- 
1.8.3.1

