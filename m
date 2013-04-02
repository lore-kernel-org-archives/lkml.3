Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761857Ab3DBJwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 05:52:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51066 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760029Ab3DBJwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 05:52:17 -0400
Date: Tue, 2 Apr 2013 02:51:54 -0700
From: tip-bot for Stephane Eranian <tipbot@zytor.com>
Message-ID: <tip-ccf49bfc6bb1025788637417780e9f1eeae9fc37@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        namhyung.kim@lge.com, jolsa@redhat.com, ak@linux.intel.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        namhyung.kim@lge.com, jolsa@redhat.com, ak@linux.intel.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1359040242-8269-14-git-send-email-eranian@google.com>
References: <1359040242-8269-14-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf record: Add support for mem access profiling
Git-Commit-ID: ccf49bfc6bb1025788637417780e9f1eeae9fc37
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 02 Apr 2013 02:52:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ccf49bfc6bb1025788637417780e9f1eeae9fc37
Gitweb:     http://git.kernel.org/tip/ccf49bfc6bb1025788637417780e9f1eeae9fc37
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Thu, 24 Jan 2013 16:10:37 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 1 Apr 2013 12:20:28 -0300

perf record: Add support for mem access profiling

We use the -W option to obtain the cost of the memory accesses.

Data address sampling is obtained via the -d option.

Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1359040242-8269-14-git-send-email-eranian@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 5c4ca51..07b1a3a 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -554,6 +554,9 @@ void perf_evsel__config(struct perf_evsel *evsel,
 		perf_evsel__set_sample_bit(evsel, CPU);
 	}
 
+	if (opts->sample_address)
+		attr->sample_type	|= PERF_SAMPLE_DATA_SRC;
+
 	if (opts->no_delay) {
 		attr->watermark = 0;
 		attr->wakeup_events = 1;
