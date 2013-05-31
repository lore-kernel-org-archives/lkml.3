Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051Ab3EaMST (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 08:18:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57484 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755399Ab3EaMSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 08:18:11 -0400
Date: Fri, 31 May 2013 05:17:48 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-66cd3f3a6ce6b69537ee62b2f2ea1775be139dff@git.kernel.org>
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
In-Reply-To: <1369394201-20044-3-git-send-email-jolsa@redhat.com>
References: <1369394201-20044-3-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests:
  Fix exclude_guest|exclude_host checking for attr tests
Git-Commit-ID: 66cd3f3a6ce6b69537ee62b2f2ea1775be139dff
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

Commit-ID:  66cd3f3a6ce6b69537ee62b2f2ea1775be139dff
Gitweb:     http://git.kernel.org/tip/66cd3f3a6ce6b69537ee62b2f2ea1775be139dff
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Fri, 24 May 2013 13:16:38 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 29 May 2013 15:15:19 +0300

perf tests: Fix exclude_guest|exclude_host checking for attr tests

We have a one of the event open fallback case in __perf_evsel__open
where we zero exclude_guest|exclude_host fields.

This means there's no way for attr tests to find out what's the right
value for those fields, so we need to check for both 0 and 1. Luckily we
still have other event parsing tests for those fields.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1369394201-20044-3-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/attr/base-record | 4 ++--
 tools/perf/tests/attr/base-stat   | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/tests/attr/base-record b/tools/perf/tests/attr/base-record
index b4fc835..e9bd639 100644
--- a/tools/perf/tests/attr/base-record
+++ b/tools/perf/tests/attr/base-record
@@ -27,8 +27,8 @@ watermark=0
 precise_ip=0
 mmap_data=0
 sample_id_all=1
-exclude_host=0
-exclude_guest=1
+exclude_host=0|1
+exclude_guest=0|1
 exclude_callchain_kernel=0
 exclude_callchain_user=0
 wakeup_events=0
diff --git a/tools/perf/tests/attr/base-stat b/tools/perf/tests/attr/base-stat
index 748ee94..91cd48b 100644
--- a/tools/perf/tests/attr/base-stat
+++ b/tools/perf/tests/attr/base-stat
@@ -27,8 +27,8 @@ watermark=0
 precise_ip=0
 mmap_data=0
 sample_id_all=0
-exclude_host=0
-exclude_guest=1
+exclude_host=0|1
+exclude_guest=0|1
 exclude_callchain_kernel=0
 exclude_callchain_user=0
 wakeup_events=0
