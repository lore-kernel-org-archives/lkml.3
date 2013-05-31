Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769Ab3EaMRB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 08:17:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57467 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642Ab3EaMQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 08:16:53 -0400
Date: Fri, 31 May 2013 05:16:31 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-8e72a67a7fcbdaa45d1b08f8ce601a37a4e9e163@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1369394201-20044-2-git-send-email-jolsa@redhat.com>
References: <1369394201-20044-2-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests: Fix attr test for record -d option
Git-Commit-ID: 8e72a67a7fcbdaa45d1b08f8ce601a37a4e9e163
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

Commit-ID:  8e72a67a7fcbdaa45d1b08f8ce601a37a4e9e163
Gitweb:     http://git.kernel.org/tip/8e72a67a7fcbdaa45d1b08f8ce601a37a4e9e163
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Fri, 24 May 2013 13:16:37 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 29 May 2013 15:11:10 +0300

perf tests: Fix attr test for record -d option

The sample type for '-d' option is changed, because of the memory
profiling patches from Stephane. The '-d' now adds PERF_SAMPLE_DATA_SRC
sample_type.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1369394201-20044-2-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/attr/test-record-data | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/perf/tests/attr/test-record-data b/tools/perf/tests/attr/test-record-data
index 6627c3e..716e143 100644
--- a/tools/perf/tests/attr/test-record-data
+++ b/tools/perf/tests/attr/test-record-data
@@ -4,5 +4,8 @@ args    = -d kill >/dev/null 2>&1
 
 [event:base-record]
 sample_period=4000
-sample_type=271
+
+# sample_type = PERF_SAMPLE_IP | PERF_SAMPLE_TID | PERF_SAMPLE_TIME |
+# PERF_SAMPLE_ADDR | PERF_SAMPLE_PERIOD | PERF_SAMPLE_DATA_SRC
+sample_type=33039
 mmap_data=1
