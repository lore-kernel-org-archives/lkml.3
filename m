Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229AbaAWRFK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 12:05:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55654 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932176AbaAWRFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 12:05:04 -0500
Date: Thu, 23 Jan 2014 09:04:18 -0800
From: tip-bot for Stephane Eranian <tipbot@zytor.com>
Message-ID: <tip-wu6kul8fpapr8iyqm685ewtf@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        eranian@google.com, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, efault@gmx.de, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, acme@redhat.com,
        efault@gmx.de, peterz@infradead.org, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf evsel:
  Remove duplicate member zeroing after free
Git-Commit-ID: de256a4e6b9096070a5305950c7d693395150680
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 23 Jan 2014 09:04:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  de256a4e6b9096070a5305950c7d693395150680
Gitweb:     http://git.kernel.org/tip/de256a4e6b9096070a5305950c7d693395150680
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Mon, 20 Jan 2014 16:15:13 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 20 Jan 2014 16:19:09 -0300

perf evsel: Remove duplicate member zeroing after free

No need to set evsel->fd to NULL after calling perf_evsel__free_fd(), as
this method already does that.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-wu6kul8fpapr8iyqm685ewtf@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 22e18a2..55407c5 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1081,7 +1081,6 @@ void perf_evsel__close(struct perf_evsel *evsel, int ncpus, int nthreads)
 
 	perf_evsel__close_fd(evsel, ncpus, nthreads);
 	perf_evsel__free_fd(evsel);
-	evsel->fd = NULL;
 }
 
 static struct {
