Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935036AbaGPTTn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 15:19:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44210 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760722AbaGPTS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 15:18:27 -0400
Date: Wed, 16 Jul 2014 12:17:46 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-843p3aqbw531eqiu2hah8o9p@git.kernel.org>
Cc: eranian@google.com, acme@redhat.com, mingo@kernel.org,
        peterz@infradead.org, efault@gmx.de, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        dzickus@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, namhyung@kernel.org,
        stfomichev@yandex-team.ru, adrian.hunter@intel.com
Reply-To: mingo@kernel.org, acme@redhat.com, eranian@google.com, efault@gmx.de,
        peterz@infradead.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, dzickus@redhat.com,
        hpa@zytor.com, paulus@samba.org, linux-kernel@vger.kernel.org,
        namhyung@kernel.org, stfomichev@yandex-team.ru,
        adrian.hunter@intel.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace: Fix build on 32-bit systems
Git-Commit-ID: 4414a3c51028aea2ae2fe06c0377490eaa6abbfd
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

Commit-ID:  4414a3c51028aea2ae2fe06c0377490eaa6abbfd
Gitweb:     http://git.kernel.org/tip/4414a3c51028aea2ae2fe06c0377490eaa6abbfd
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 8 Jul 2014 15:39:21 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 8 Jul 2014 15:39:21 -0300

perf trace: Fix build on 32-bit systems

    CC       /tmp/build/perf/builtin-trace.o
  builtin-trace.c: In function 'print_location':
  builtin-trace.c:1792:4: error: format '%lx' expects argument of type 'long unsigned int', but argument 4 has type 'u64' [-Werror=format]
  builtin-trace.c:1794:3: error: format '%lx' expects argument of type 'long unsigned int', but argument 3 has type 'u64' [-Werror=format]
  builtin-trace.c:1796:3: error: format '%lx' expects argument of type 'long unsigned int', but argument 3 has type 'u64' [-Werror=format]
  cc1: all warnings being treated as errors
  make[1]: *** [/tmp/build/perf/builtin-trace.o] Error 1
  make[1]: *** Waiting for unfinished jobs....
  make: *** [install-bin] Error 2
  make: Leaving directory `/home/acme/git/linux/tools/perf'

  acme@linux-goap:~/git/linux> uname -a
  Linux linux-goap 3.7.10-1.16-desktop #1 SMP PREEMPT Fri May 31 20:21:23 UTC 2013 (97c14ba) i686 i686 i386 GNU/Linux

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-843p3aqbw531eqiu2hah8o9p@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index b94dffc..c4a5a7d 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1788,12 +1788,12 @@ static void print_location(FILE *f, struct perf_sample *sample,
 		fprintf(f, "%s@", al->map->dso->long_name);
 
 	if ((verbose || print_sym) && al->sym)
-		fprintf(f, "%s+0x%lx", al->sym->name,
+		fprintf(f, "%s+0x%" PRIx64, al->sym->name,
 			al->addr - al->sym->start);
 	else if (al->map)
-		fprintf(f, "0x%lx", al->addr);
+		fprintf(f, "0x%" PRIx64, al->addr);
 	else
-		fprintf(f, "0x%lx", sample->addr);
+		fprintf(f, "0x%" PRIx64, sample->addr);
 }
 
 static int trace__pgfault(struct trace *trace,
