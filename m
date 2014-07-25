Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934576AbaGYPis (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 11:38:48 -0400
Received: from mail.kernel.org ([198.145.19.201]:35190 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934221AbaGYPip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 11:38:45 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 21/27] perf tools: Fix build on gcc 4.4.7
Date: Fri, 25 Jul 2014 12:37:03 -0300
Message-Id: <1406302629-11790-22-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406302629-11790-1-git-send-email-acme@kernel.org>
References: <1406302629-11790-1-git-send-email-acme@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[acme@sandy linux]$ gcc --version
gcc (GCC) 4.4.7 20120313 (Red Hat 4.4.7-3)
Copyright (C) 2010 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

[acme@sandy linux]$ make O=/tmp/build/perf -C tools/perf install-bin
<SNIP>
  CC       /tmp/build/perf/builtin-trace.o
builtin-trace.c: In function ‘perf_evlist__add_pgfault’:
builtin-trace.c:1997: error: unknown field ‘sample_period’ specified in initializer
make[1]: *** [/tmp/build/perf/builtin-trace.o] Error 1
make: *** [install-bin] Error 2
make: Leaving directory `/home/acme/git/linux/tools/perf'
[acme@sandy linux]$ make O=/tmp/build/perf -C tools/perf install-bin
make O=/tmp/build/perf -C tools/perf install-bin
make: Entering directory `/home/acme/git/linux/tools/perf'

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-qt7h2g5fcf42qiw5hv7mgpjk@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index c4a5a7d7b2cf..a6c375224f46 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1994,10 +1994,10 @@ static int perf_evlist__add_pgfault(struct perf_evlist *evlist,
 	struct perf_event_attr attr = {
 		.type = PERF_TYPE_SOFTWARE,
 		.mmap_data = 1,
-		.sample_period = 1,
 	};
 
 	attr.config = config;
+	attr.sample_period = 1;
 
 	event_attr_init(&attr);
 
-- 
1.9.3

