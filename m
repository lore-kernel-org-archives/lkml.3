Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698AbaKSQEo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 11:04:44 -0500
Received: from mail.kernel.org ([198.145.19.201]:51553 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756690AbaKSQEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 11:04:42 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Kan Liang <kan.liang@intel.com>,
        Andi Kleen <ak@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 12/16] perf diff: Add missing handler for PERF_RECORD_MMAP2 events
Date: Wed, 19 Nov 2014 13:03:32 -0300
Message-Id: <1416413016-19110-13-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1416413016-19110-1-git-send-email-acme@kernel.org>
References: <1416413016-19110-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kan Liang <kan.liang@intel.com>

Without mmap2, perf diff fails to find the symbol name. The default
symbol sort key doesn't work well.

Signed-off-by: Kan Liang <kan.liang@intel.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1416328700-1836-2-git-send-email-kan.liang@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-diff.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 25114c9a6801..1ce425d101a9 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -357,6 +357,7 @@ static int diff__process_sample_event(struct perf_tool *tool __maybe_unused,
 static struct perf_tool tool = {
 	.sample	= diff__process_sample_event,
 	.mmap	= perf_event__process_mmap,
+	.mmap2	= perf_event__process_mmap2,
 	.comm	= perf_event__process_comm,
 	.exit	= perf_event__process_exit,
 	.fork	= perf_event__process_fork,
-- 
1.9.3

