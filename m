Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102Ab3CULmS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 07:42:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56843 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739Ab3CULmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 07:42:13 -0400
Date: Thu, 21 Mar 2013 04:40:39 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-736b05a0462aff65140865bacd5e04d1813e73e1@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1363326533-3310-2-git-send-email-namhyung@kernel.org>
References: <1363326533-3310-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evsel: Cleanup perf_evsel__exit()
Git-Commit-ID: 736b05a0462aff65140865bacd5e04d1813e73e1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 21 Mar 2013 04:40:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  736b05a0462aff65140865bacd5e04d1813e73e1
Gitweb:     http://git.kernel.org/tip/736b05a0462aff65140865bacd5e04d1813e73e1
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Fri, 15 Mar 2013 14:48:49 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 15 Mar 2013 13:06:10 -0300

perf evsel: Cleanup perf_evsel__exit()

Use perf_evsel__free_* because they do the same thing and ensures the
pointer has NULL value at the end.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1363326533-3310-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index dc16231..7fde9fb 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -673,9 +673,8 @@ void perf_evsel__free_counts(struct perf_evsel *evsel)
 void perf_evsel__exit(struct perf_evsel *evsel)
 {
 	assert(list_empty(&evsel->node));
-	xyarray__delete(evsel->fd);
-	xyarray__delete(evsel->sample_id);
-	free(evsel->id);
+	perf_evsel__free_fd(evsel);
+	perf_evsel__free_id(evsel);
 }
 
 void perf_evsel__delete(struct perf_evsel *evsel)
