Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057Ab3JTTca (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 15:32:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52632 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab3JTTcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 15:32:19 -0400
Date: Sun, 20 Oct 2013 12:31:12 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-nlxofdqcdjfm0w9o6bgq4kqv@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, tom.zanussi@linux.intel.com, jolsa@redhat.com,
        Waiman.Long@hp.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, tom.zanussi@linux.intel.com, jolsa@redhat.com,
        fweisbec@gmail.com, Waiman.Long@hp.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1381265120-58532-1-git-send-email-Waiman.Long@hp.com>
References: <1381265120-58532-1-git-send-email-Waiman.Long@hp.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf scripting perl:
  Fix build error on Fedora 12
Git-Commit-ID: 3b16ff89676d9902dc39976aee3cb0314ee37d93
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 20 Oct 2013 12:31:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3b16ff89676d9902dc39976aee3cb0314ee37d93
Gitweb:     http://git.kernel.org/tip/3b16ff89676d9902dc39976aee3cb0314ee37d93
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 14 Oct 2013 18:25:12 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 17 Oct 2013 16:24:26 -0300

perf scripting perl: Fix build error on Fedora 12

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
index a85e4ae..c0c9795 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -282,7 +282,7 @@ static void perl_process_tracepoint(union perf_event *perf_event __maybe_unused,
 
 	event = find_cache_event(evsel);
 	if (!event)
-		die("ug! no event found for type %" PRIu64, evsel->attr.config);
+		die("ug! no event found for type %" PRIu64, (u64)evsel->attr.config);
 
 	pid = raw_field_value(event, "common_pid", data);
 
