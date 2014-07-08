Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932256AbaGHTEb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:04:31 -0400
Received: from mail.kernel.org ([198.145.19.201]:58348 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932217AbaGHTE1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:04:27 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stanislav Fomichev <stfomichev@yandex-team.ru>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 16/16] perf trace: Fix build on 32-bit systems
Date: Tue,  8 Jul 2014 16:03:04 -0300
Message-Id: <1404846184-20075-17-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1404846184-20075-1-git-send-email-acme@kernel.org>
References: <1404846184-20075-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

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
index b94dffc5fa85..c4a5a7d7b2cf 100644
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
-- 
1.9.3

