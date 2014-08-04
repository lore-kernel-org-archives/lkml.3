Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbaHDQVq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 12:21:46 -0400
Received: from mail.kernel.org ([198.145.19.201]:39735 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379AbaHDQVn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:21:43 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        William Cohen <wcohen@redhat.com>,
        Yann Droneaud <ydroneaud@opteya.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 32/33] perf tools: Fix PERF_FLAG_FD_CLOEXEC flag probing event type open counters due to EBUSY error
Date: Mon,  4 Aug 2014 13:17:43 -0300
Message-Id: <1407169064-25625-33-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407169064-25625-1-git-send-email-acme@kernel.org>
References: <1407169064-25625-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

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
index dede0c388ed4..5073c01af618 100644
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
-- 
1.9.3

