Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875AbaHMFUm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 01:20:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45182 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbaHMFUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 01:20:40 -0400
Date: Tue, 12 Aug 2014 22:19:32 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-038fa0b9739d7f375f3f61a2ce4f78ad44329f66@git.kernel.org>
Cc: acme@redhat.com, eranian@google.com, mingo@kernel.org, jolsa@kernel.org,
        peterz@infradead.org, ydroneaud@opteya.com, wcohen@redhat.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, namhyung@gmail.com,
        adrian.hunter@intel.com
Reply-To: mingo@kernel.org, eranian@google.com, acme@redhat.com,
        jolsa@kernel.org, peterz@infradead.org, ydroneaud@opteya.com,
        jolsa@redhat.com, wcohen@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, namhyung@gmail.com,
        adrian.hunter@intel.com
In-Reply-To: <20140803121036.GA1181@krava.brq.redhat.com>
References: <20140803121036.GA1181@krava.brq.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Fix PERF_FLAG_FD_CLOEXEC flag probing event type open counters due to EBUSY error
Git-Commit-ID: 038fa0b9739d7f375f3f61a2ce4f78ad44329f66
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

Commit-ID:  038fa0b9739d7f375f3f61a2ce4f78ad44329f66
Gitweb:     http://git.kernel.org/tip/038fa0b9739d7f375f3f61a2ce4f78ad44329f66
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Sun, 3 Aug 2014 14:10:36 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 12 Aug 2014 12:03:08 -0300

perf tools: Fix PERF_FLAG_FD_CLOEXEC flag probing event type open counters due to EBUSY error

We were using PERF_COUNT_SW_CPU_CLOCK as an probing event type.  Using
expected PERF_TYPE_SOFTWARE type instead.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: William Cohen <wcohen@redhat.com>
Cc: Yann Droneaud <ydroneaud@opteya.com>
Link: http://lkml.kernel.org/r/20140803121036.GA1181@krava.brq.redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/cloexec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/cloexec.c b/tools/perf/util/cloexec.c
index dede0c3..5073c01 100644
--- a/tools/perf/util/cloexec.c
+++ b/tools/perf/util/cloexec.c
@@ -9,7 +9,7 @@ static int perf_flag_probe(void)
 {
 	/* use 'safest' configuration as used in perf_evsel__fallback() */
 	struct perf_event_attr attr = {
-		.type = PERF_COUNT_SW_CPU_CLOCK,
+		.type = PERF_TYPE_SOFTWARE,
 		.config = PERF_COUNT_SW_CPU_CLOCK,
 	};
 	int fd;
