Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932452AbaFILsm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 07:48:42 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:17997 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751611AbaFILsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 07:48:40 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AucNAIeelVNXQAIw/2dsb2JhbABZgw1SrAMFAZkQgQsXdYQxLyOBGjeIRgHKV4VdiQ8dhCsEj1qKR4FCkgODPjs
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] kernel/trace/ftrace.c: replace kmalloc/snprintf by kasprintf
Date: Mon,  9 Jun 2014 13:47:21 +0200
Message-Id: <1402314441-28851-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 kernel/trace/ftrace.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 4a54a25..92a3316 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1072,9 +1072,7 @@ static __init void ftrace_profile_debugfs(struct dentry *d_tracer)
 
 	for_each_possible_cpu(cpu) {
 		stat = &per_cpu(ftrace_profile_stats, cpu);
-
-		/* allocate enough for function name + cpu number */
-		name = kmalloc(32, GFP_KERNEL);
+		name = kasprintf(GFP_KERNEL, "function%d", cpu);
 		if (!name) {
 			/*
 			 * The files created are permanent, if something happens
@@ -1086,7 +1084,6 @@ static __init void ftrace_profile_debugfs(struct dentry *d_tracer)
 			return;
 		}
 		stat->stat = function_stats;
-		snprintf(name, 32, "function%d", cpu);
 		stat->stat.name = name;
 		ret = register_stat_tracer(&stat->stat);
 		if (ret) {
@@ -1097,7 +1094,6 @@ static __init void ftrace_profile_debugfs(struct dentry *d_tracer)
 			return;
 		}
 	}
-
 	entry = debugfs_create_file("function_profile_enabled", 0644,
 				    d_tracer, NULL, &ftrace_profile_fops);
 	if (!entry)
-- 
1.8.4.5

