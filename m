Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076Ab3LPPck (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 10:32:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47608 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754676Ab3LPP1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 10:27:37 -0500
Date: Mon, 16 Dec 2013 07:27:15 -0800
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-71db07b12eace6a3619335d03eaf3cbe2de131ed@git.kernel.org>
Cc: acme@redhat.com, eranian@google.com, mingo@redhat.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, jolsa@redhat.com,
        fweisbec@gmail.com, ak@linux.intel.com, dsahern@gmail.com,
        tglx@linutronix.de, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, namhyung@gmail.com,
        adrian.hunter@intel.com
Reply-To: mingo@kernel.org, mingo@redhat.com, eranian@google.com,
        acme@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        ak@linux.intel.com, tglx@linutronix.de, hpa@zytor.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, namhyung@gmail.com,
        adrian.hunter@intel.com
In-Reply-To: <1386765443-26966-21-git-send-email-alexander.shishkin@linux.intel.com>
References: <1386765443-26966-21-git-send-email-alexander.shishkin@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Move mem_bswap32/64 to util.c
Git-Commit-ID: 71db07b12eace6a3619335d03eaf3cbe2de131ed
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 16 Dec 2013 07:27:21 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  71db07b12eace6a3619335d03eaf3cbe2de131ed
Gitweb:     http://git.kernel.org/tip/71db07b12eace6a3619335d03eaf3cbe2de131ed
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Wed, 11 Dec 2013 14:36:32 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 13 Dec 2013 10:30:21 -0300

perf tools: Move mem_bswap32/64 to util.c

Move functions mem_bswap_32() and mem_bswap_64() so they can be reused.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1386765443-26966-21-git-send-email-alexander.shishkin@linux.intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c | 21 ---------------------
 tools/perf/util/session.h |  2 --
 tools/perf/util/util.c    | 22 ++++++++++++++++++++++
 tools/perf/util/util.h    |  3 +++
 4 files changed, 25 insertions(+), 23 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index e748f29..989b2e3 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -247,27 +247,6 @@ void perf_tool__fill_defaults(struct perf_tool *tool)
 	}
 }
  
-void mem_bswap_32(void *src, int byte_size)
-{
-	u32 *m = src;
-	while (byte_size > 0) {
-		*m = bswap_32(*m);
-		byte_size -= sizeof(u32);
-		++m;
-	}
-}
-
-void mem_bswap_64(void *src, int byte_size)
-{
-	u64 *m = src;
-
-	while (byte_size > 0) {
-		*m = bswap_64(*m);
-		byte_size -= sizeof(u64);
-		++m;
-	}
-}
-
 static void swap_sample_id_all(union perf_event *event, void *data)
 {
 	void *end = (void *) event + event->header.size;
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 2a3955e..9c25d49 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -74,8 +74,6 @@ int perf_session__resolve_callchain(struct perf_session *session,
 
 bool perf_session__has_traces(struct perf_session *session, const char *msg);
 
-void mem_bswap_64(void *src, int byte_size);
-void mem_bswap_32(void *src, int byte_size);
 void perf_event__attr_swap(struct perf_event_attr *attr);
 
 int perf_session__create_kernel_maps(struct perf_session *session);
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 8f63dba..42ad667 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -10,6 +10,7 @@
 #include <string.h>
 #include <errno.h>
 #include <limits.h>
+#include <byteswap.h>
 #include <linux/kernel.h>
 
 /*
@@ -515,3 +516,24 @@ int perf_event_paranoid(void)
 
 	return value;
 }
+
+void mem_bswap_32(void *src, int byte_size)
+{
+	u32 *m = src;
+	while (byte_size > 0) {
+		*m = bswap_32(*m);
+		byte_size -= sizeof(u32);
+		++m;
+	}
+}
+
+void mem_bswap_64(void *src, int byte_size)
+{
+	u64 *m = src;
+
+	while (byte_size > 0) {
+		*m = bswap_64(*m);
+		byte_size -= sizeof(u64);
+		++m;
+	}
+}
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 1e7d413..a1eea3e 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -323,5 +323,8 @@ int filename__read_int(const char *filename, int *value);
 int filename__read_str(const char *filename, char **buf, size_t *sizep);
 int perf_event_paranoid(void);
 
+void mem_bswap_64(void *src, int byte_size);
+void mem_bswap_32(void *src, int byte_size);
+
 const char *get_filename_for_perf_kvm(void);
 #endif /* GIT_COMPAT_UTIL_H */
