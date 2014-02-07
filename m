Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884AbaBGNN5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 08:13:57 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41594 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019AbaBGLsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:48:36 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Adrian Hunter <adrian.hunter@intel.com>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Waiman Long <Waiman.Long@hp.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Xie XiuQi <xiexiuqi@huawei.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 034/233] perf scripting perl: Fix build error on Fedora 12
Date: Fri,  7 Feb 2014 11:44:13 +0000
Message-Id: <1391773652-25214-35-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

commit 3b16ff89676d9902dc39976aee3cb0314ee37d93 upstream.

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
Cc: Xie XiuQi <xiexiuqi@huawei.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 tools/perf/util/scripting-engines/trace-event-perl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index eacec85..b4741b0 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -282,7 +282,7 @@ static void perl_process_tracepoint(union perf_event *perf_event __maybe_unused,
 
 	event = find_cache_event(evsel);
 	if (!event)
-		die("ug! no event found for type %" PRIu64, evsel->attr.config);
+		die("ug! no event found for type %" PRIu64, (u64)evsel->attr.config);
 
 	pid = raw_field_value(event, "common_pid", data);
 
-- 
1.8.3.2

