Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751541Ab3JTI2Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 04:28:24 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45406 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab3JTI1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 04:27:54 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH 2/3] perf scripting perl: Fix build error on Fedora 12
Date: Sun, 20 Oct 2013 05:27:25 -0300
Message-Id: <1382257646-5808-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1382257646-5808-1-git-send-email-acme@infradead.org>
References: <1382257646-5808-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Cast __u64 to u64 to silence this warning on older distros, such as
Fedora 12:

    CC       /tmp/build/perf/util/scripting-engines/trace-event-perl.o
  cc1: warnings being treated as errors
  util/scripting-engines/trace-event-perl.c: In function ‘perl_process_tracepoint’:
  util/scripting-engines/trace-event-perl.c:285: error: format ‘%lu’ expects type ‘long unsigned int’, but argument 2 has type ‘__u64’
  make[1]: *** [/tmp/build/perf/util/scripting-engines/trace-event-perl.o] Error 1
  make: *** [install] Error 2
  make: Leaving directory `/home/acme/git/linux/tools/perf'
  [acme@fedora12 linux]$

Reported-by: Waiman Long <Waiman.Long@hp.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tom.zanussi@linux.intel.com>
Cc: Waiman Long <Waiman.Long@hp.com>
Link: http://lkml.kernel.org/n/tip-nlxofdqcdjfm0w9o6bgq4kqv@git.kernel.org
Link: http://lkml.kernel.org/r/1381265120-58532-1-git-send-email-Waiman.Long@hp.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/scripting-engines/trace-event-perl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index a85e4ae5f3ac..c0c9795c4f02 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -282,7 +282,7 @@ static void perl_process_tracepoint(union perf_event *perf_event __maybe_unused,
 
 	event = find_cache_event(evsel);
 	if (!event)
-		die("ug! no event found for type %" PRIu64, evsel->attr.config);
+		die("ug! no event found for type %" PRIu64, (u64)evsel->attr.config);
 
 	pid = raw_field_value(event, "common_pid", data);
 
-- 
1.8.1.4

