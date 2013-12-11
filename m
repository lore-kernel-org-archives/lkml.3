Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709Ab3LKMlu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:41:50 -0500
Received: from mga09.intel.com ([134.134.136.24]:60746 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453Ab3LKMlr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:41:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,871,1378882800"; 
   d="scan'208";a="422886911"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v0 48/71] perf session: Make perf_event__itrace_swap() non-static
Date: Wed, 11 Dec 2013 14:37:00 +0200
Message-Id: <1386765443-26966-49-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Make it possible for the Instruction Trace decoder
to read and byte-swap Instruction Tracing events
directly from file.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/session.c | 4 ++--
 tools/perf/util/session.h | 1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 55aead5..49c89e7 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -505,8 +505,8 @@ static void perf_event__itrace_info_swap(union perf_event *event,
 	mem_bswap_64(event->itrace_info.priv, size);
 }
 
-static void perf_event__itrace_swap(union perf_event *event,
-				    bool sample_id_all __maybe_unused)
+void perf_event__itrace_swap(union perf_event *event,
+			     bool sample_id_all __maybe_unused)
 {
 	event->itrace.size      = bswap_64(event->itrace.size);
 	event->itrace.offset    = bswap_64(event->itrace.offset);
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index a7873c0..25aa9e7 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -61,6 +61,7 @@ struct perf_session *perf_session__new(struct perf_data_file *file,
 void perf_session__delete(struct perf_session *session);
 
 void perf_event_header__bswap(struct perf_event_header *hdr);
+void perf_event__itrace_swap(union perf_event *event, bool sample_id_all);
 
 int __perf_session__process_events(struct perf_session *session,
 				   u64 data_offset, u64 data_size, u64 size,
-- 
1.8.5.1

