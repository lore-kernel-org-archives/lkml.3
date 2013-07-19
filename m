Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030351Ab3GSHzp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:55:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36005 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030254Ab3GSHzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:55:40 -0400
Date: Fri, 19 Jul 2013 00:53:23 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-30d350795e8e57c17eabaab454932889f1ae8159@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
In-Reply-To: <1373556513-3000-5-git-send-email-jolsa@redhat.com>
References: <1373556513-3000-5-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf record: Remove event types pushing
Git-Commit-ID: 30d350795e8e57c17eabaab454932889f1ae8159
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 19 Jul 2013 00:53:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  30d350795e8e57c17eabaab454932889f1ae8159
Gitweb:     http://git.kernel.org/tip/30d350795e8e57c17eabaab454932889f1ae8159
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Thu, 11 Jul 2013 17:28:32 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 15 Jul 2013 16:28:17 -0300

perf record: Remove event types pushing

Removing event types data pushing from record command. It's no longer
needed, because this data is ignored.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1373556513-3000-5-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index ecca62e..1f5243c 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -904,7 +904,6 @@ const struct option record_options[] = {
 int cmd_record(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	int err = -ENOMEM;
-	struct perf_evsel *pos;
 	struct perf_evlist *evsel_list;
 	struct perf_record *rec = &record;
 	char errbuf[BUFSIZ];
@@ -968,11 +967,6 @@ int cmd_record(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (perf_evlist__create_maps(evsel_list, &rec->opts.target) < 0)
 		usage_with_options(record_usage, record_options);
 
-	list_for_each_entry(pos, &evsel_list->entries, node) {
-		if (perf_header__push_event(pos->attr.config, perf_evsel__name(pos)))
-			goto out_free_fd;
-	}
-
 	if (rec->opts.user_interval != ULLONG_MAX)
 		rec->opts.default_interval = rec->opts.user_interval;
 	if (rec->opts.user_freq != UINT_MAX)
