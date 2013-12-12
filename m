Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197Ab3LLHl1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 02:41:27 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62115 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751870Ab3LLHlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 02:41:25 -0500
X-IronPort-AV: E=Sophos;i="4.95,469,1384272000"; 
   d="scan'208";a="9242842"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: acme@redhat.com, dsahern@gmail.com
Cc: linux-kernel@vger.kernel.org, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 1/6] perf tools: Add long_name for call-graph option.
Date: Thu, 12 Dec 2013 15:39:25 -0500
Message-Id: <761a4bdc646650d31955f9e539c3b7f5def20472.1386873922.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/12 15:41:03,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/12 15:41:05,
	Serialize complete at 2013/12/12 15:41:05
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am not sure why the -g option in record and top has no long_name
for it.

Example:
	# perf record --[TAB]
	--all-cpus          --count             --freq              --no-delay          --period            --realtime          --uid
	--branch-any        --cpu               --group             --no-inherit        --per-thread        --stat              --verbose
	--branch-filter     --data              --mmap-pages        --no-samples        --pid               --tid               --weight
	--call-graph        --event             --no-buildid        --(null)            --quiet             --timestamp
	--cgroup            --filter            --no-buildid-cache  --output            --raw-samples       --transaction

There is a --(null) here, it is not clear enough to user.

This patch add a "call-graph" long_name for it.

Verification:
	# perf record --[TAB]
	--all-cpus          --count             --freq              --no-delay          --per-thread        --stat              --verbose
	--branch-any        --cpu               --group             --no-inherit        --pid               --tid               --weight
	--branch-filter     --data              --mmap-pages        --no-samples        --quiet             --timestamp
	--call-graph        --event             --no-buildid        --output            --raw-samples       --transaction
	--cgroup            --filter            --no-buildid-cache  --period            --realtime          --uid

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 tools/perf/builtin-record.c | 2 +-
 tools/perf/builtin-top.c    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index c1c1200..7460c8f 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -844,7 +844,7 @@ const struct option record_options[] = {
 		     perf_evlist__parse_mmap_pages),
 	OPT_BOOLEAN(0, "group", &record.opts.group,
 		    "put the counters into a counter group"),
-	OPT_CALLBACK_NOOPT('g', NULL, &record.opts,
+	OPT_CALLBACK_NOOPT('g', "call-graph", &record.opts,
 			   NULL, "enables call-graph recording" ,
 			   &record_callchain_opt),
 	OPT_CALLBACK(0, "call-graph", &record.opts,
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 03d37a7..a734a1b 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1084,7 +1084,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 		   " abort, in_tx, transaction"),
 	OPT_BOOLEAN('n', "show-nr-samples", &symbol_conf.show_nr_samples,
 		    "Show a column with the number of samples"),
-	OPT_CALLBACK_NOOPT('g', NULL, &top.record_opts,
+	OPT_CALLBACK_NOOPT('g', "call-graph", &top.record_opts,
 			   NULL, "enables call-graph recording",
 			   &callchain_opt),
 	OPT_CALLBACK(0, "call-graph", &top.record_opts,
-- 
1.8.2.1

