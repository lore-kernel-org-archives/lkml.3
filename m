Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983AbaHNI7m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 04:59:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36322 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbaHNIp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 04:45:58 -0400
Date: Thu, 14 Aug 2014 01:44:57 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-c6fa35659c5fae5f9aeb6874b177baeb2adbc02e@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org, jolsa@kernel.org,
        peterz@infradead.org, namhyung@gmail.com, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        jolsa@kernel.org, peterz@infradead.org, namhyung@kernel.org,
        namhyung@gmail.com, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1407855871-15024-3-git-send-email-adrian.hunter@intel.com>
References: <1407855871-15024-3-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Fix one of the probe events to exclude kernel
Git-Commit-ID: c6fa35659c5fae5f9aeb6874b177baeb2adbc02e
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

Commit-ID:  c6fa35659c5fae5f9aeb6874b177baeb2adbc02e
Gitweb:     http://git.kernel.org/tip/c6fa35659c5fae5f9aeb6874b177baeb2adbc02e
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Tue, 12 Aug 2014 18:04:29 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 13 Aug 2014 16:20:33 -0300

perf tools: Fix one of the probe events to exclude kernel

When probing the kernel API the kernel should be excluded otherwise the
probe will fail for users with insufficient privilege to profile the
kernel.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1407855871-15024-3-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/record.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/record.c b/tools/perf/util/record.c
index fe8079e..58267a8 100644
--- a/tools/perf/util/record.c
+++ b/tools/perf/util/record.c
@@ -47,7 +47,7 @@ out_delete:
 
 static bool perf_probe_api(setup_probe_fn_t fn)
 {
-	const char *try[] = {"cycles:u", "instructions:u", "cpu-clock", NULL};
+	const char *try[] = {"cycles:u", "instructions:u", "cpu-clock:u", NULL};
 	struct cpu_map *cpus;
 	int cpu, ret, i = 0;
 
