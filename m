Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757833Ab3CULin (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 07:38:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56766 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757488Ab3CULil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 07:38:41 -0400
Date: Thu, 21 Mar 2013 04:37:04 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-45fa534cffb246872de0cb8af207bea4a09aeb2f@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, fweisbec@gmail.com,
        rostedt@goodmis.org, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, fweisbec@gmail.com,
        rostedt@goodmis.org, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1363173585-9754-6-git-send-email-namhyung@kernel.org>
References: <1363173585-9754-6-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Remove duplicated page_size definition
Git-Commit-ID: 45fa534cffb246872de0cb8af207bea4a09aeb2f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 21 Mar 2013 04:37:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  45fa534cffb246872de0cb8af207bea4a09aeb2f
Gitweb:     http://git.kernel.org/tip/45fa534cffb246872de0cb8af207bea4a09aeb2f
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Wed, 13 Mar 2013 20:19:44 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 15 Mar 2013 13:06:09 -0300

perf tools: Remove duplicated page_size definition

It's defined in util/util.c and gets set from the begining of perf run.
No need to duplicate it.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1363173585-9754-6-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/trace-event-info.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index 3c452b5..5729f43 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -43,8 +43,6 @@
 
 #define VERSION "0.5"
 
-unsigned int page_size;
-
 static const char *output_file = "trace.info";
 static int output_fd;
 
@@ -431,7 +429,6 @@ static void tracing_data_header(void)
 	write_or_die(buf, 1);
 
 	/* save page_size */
-	page_size = sysconf(_SC_PAGESIZE);
 	write_or_die(&page_size, 4);
 }
 
