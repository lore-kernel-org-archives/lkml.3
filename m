Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbaLVEoE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 23:44:04 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:50449 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779AbaLVEnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 23:43:40 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH 7/7] perf tools: Set attr.task bit for a tracking event
Date: Mon, 22 Dec 2014 13:44:15 +0900
Message-Id: <1419223455-4362-8-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419223455-4362-1-git-send-email-namhyung@kernel.org>
References: <1419223455-4362-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The perf_event_attr.task bit is to track task (fork and exit) events
but it missed to be set by perf_evsel__config().  While it was not a
problem in practice since setting other bits (comm/mmap) ended up
being in same result, it'd be good to set it explicitly anyway.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/evsel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 1e90c8557ede..e17d2b1624bc 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -709,6 +709,7 @@ void perf_evsel__config(struct perf_evsel *evsel, struct record_opts *opts)
 	if (opts->sample_weight)
 		perf_evsel__set_sample_bit(evsel, WEIGHT);
 
+	attr->task  = track;
 	attr->mmap  = track;
 	attr->mmap2 = track && !perf_missing_features.mmap2;
 	attr->comm  = track;
-- 
2.1.3

