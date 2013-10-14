Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932515Ab3JNUXI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:23:08 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39011 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757707Ab3JNUDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:03:06 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 104/161] perf trace: Use socket's beautifiers in socketpair
Date: Mon, 14 Oct 2013 17:01:33 -0300
Message-Id: <1381780950-25642-105-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

For the address family and socket type.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-3a6cwwskobvan823pau76cm4@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 27b0ec88cb23..bf74217be22c 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -652,6 +652,10 @@ static struct syscall_fmt {
 	  .arg_scnprintf = { [0] = SCA_STRARRAY, /* family */
 			     [1] = SCA_SK_TYPE, /* type */ },
 	  .arg_parm	 = { [0] = &strarray__socket_families, /* family */ }, },
+	{ .name	    = "socketpair", .errmsg = true,
+	  .arg_scnprintf = { [0] = SCA_STRARRAY, /* family */
+			     [1] = SCA_SK_TYPE, /* type */ },
+	  .arg_parm	 = { [0] = &strarray__socket_families, /* family */ }, },
 	{ .name	    = "stat",	    .errmsg = true, .alias = "newstat", },
 	{ .name	    = "tgkill",	    .errmsg = true,
 	  .arg_scnprintf = { [2] = SCA_SIGNUM, /* sig */ }, },
-- 
1.8.1.4

