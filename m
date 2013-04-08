Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005Ab3DHENK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 00:13:10 -0400
Received: from intranet.asianux.com ([58.214.24.6]:39284 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480Ab3DHENJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 00:13:09 -0400
X-Spam-Score: -100.7
Message-ID: <516243B7.9020405@asianux.com>
Date: Mon, 08 Apr 2013 12:12:39 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: rostedt@goodmis.org, Frederic Weisbecker <fweisbec@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] kernel: trace: ftrace: strncpy, using strlcpy instead of
 strncpy
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  for NUL terminated string, need always set '\0' at the end.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 kernel/trace/ftrace.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index dfd33f0..fa984b7 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3492,14 +3492,14 @@ static char ftrace_filter_buf[FTRACE_FILTER_SIZE] __initdata;
 
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
-- 
1.7.7.6
