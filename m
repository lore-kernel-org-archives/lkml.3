Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498Ab3GIQtr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 12:49:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56776 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113Ab3GIQtq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 12:49:46 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Thomas Renninger <trenn@suse.de>
Subject: [PATCH 3/4] perf tools: Remove event types pushing from record command
Date: Tue,  9 Jul 2013 18:48:58 +0200
Message-Id: <1373388539-9347-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1373388539-9347-1-git-send-email-jolsa@redhat.com>
References: <1373388539-9347-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing event types data pushing from record command. It's
no longer needed, because this data is ignored.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Thomas Renninger <trenn@suse.de>
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
-- 
1.7.11.7

