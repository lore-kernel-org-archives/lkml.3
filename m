Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965107Ab3DHPcH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 11:32:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37870 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964999Ab3DHPcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 11:32:04 -0400
Date: Mon, 8 Apr 2013 08:31:49 -0700
From: tip-bot for Chen Gang <tipbot@zytor.com>
Message-ID: <tip-75761cc15877c155b3849b4e0e0cb3f897faf471@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fweisbec@gmail.com, gang.chen@asianux.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, gang.chen@asianux.com, tglx@linutronix.de
In-Reply-To: <516243B7.9020405@asianux.com>
References: <516243B7.9020405@asianux.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] ftrace: Fix strncpy() use, use strlcpy()
  instead of strncpy()
Git-Commit-ID: 75761cc15877c155b3849b4e0e0cb3f897faf471
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 08 Apr 2013 08:31:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  75761cc15877c155b3849b4e0e0cb3f897faf471
Gitweb:     http://git.kernel.org/tip/75761cc15877c155b3849b4e0e0cb3f897faf471
Author:     Chen Gang <gang.chen@asianux.com>
AuthorDate: Mon, 8 Apr 2013 12:12:39 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 8 Apr 2013 13:26:56 +0200

ftrace: Fix strncpy() use, use strlcpy() instead of strncpy()

For NUL terminated string we always need to set '\0' at the end.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
Cc: rostedt@goodmis.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/r/516243B7.9020405@asianux.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/trace/ftrace.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 6893d5a..db14374 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3441,14 +3441,14 @@ static char ftrace_filter_buf[FTRACE_FILTER_SIZE] __initdata;
 
 static int __init set_ftrace_notrace(char *str)
 {
-	strncpy(ftrace_notrace_buf, str, FTRACE_FILTER_SIZE);
+	strlcpy(ftrace_notrace_buf, str, FTRACE_FILTER_SIZE);
 	return 1;
 }
 __setup("ftrace_notrace=", set_ftrace_notrace);
 
 static int __init set_ftrace_filter(char *str)
 {
-	strncpy(ftrace_filter_buf, str, FTRACE_FILTER_SIZE);
+	strlcpy(ftrace_filter_buf, str, FTRACE_FILTER_SIZE);
 	return 1;
 }
 __setup("ftrace_filter=", set_ftrace_filter);
