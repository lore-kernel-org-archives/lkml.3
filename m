Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598AbaG1I3O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 04:29:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42663 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbaG1I1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 04:27:17 -0400
Date: Mon, 28 Jul 2014 01:26:32 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-qt7h2g5fcf42qiw5hv7mgpjk@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de, dzickus@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de, dzickus@redhat.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix build on gcc 4.4.7
Git-Commit-ID: 0524798cc3d74546e83ebd795e9a5ed44481eaa6
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

Commit-ID:  0524798cc3d74546e83ebd795e9a5ed44481eaa6
Gitweb:     http://git.kernel.org/tip/0524798cc3d74546e83ebd795e9a5ed44481eaa6
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 23 Jul 2014 18:15:09 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 23 Jul 2014 18:15:09 -0300

perf tools: Fix build on gcc 4.4.7

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
index c4a5a7d..a6c3752 100644
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
 
