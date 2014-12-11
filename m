Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965202AbaLKV0p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 16:26:45 -0500
Received: from mail.kernel.org ([198.145.19.201]:44188 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965045AbaLKV0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 16:26:42 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Tom Huynh <tom.huynh@freescale.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        Kim Phillips <kim.phillips@freescale.com>,
        Matt Mullins <mmullins@mmlx.us>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 04/18] perf hists browser: Change print format from %lu to %PRIu64
Date: Thu, 11 Dec 2014 18:25:52 -0300
Message-Id: <1418333166-15429-5-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1418333166-15429-1-git-send-email-acme@kernel.org>
References: <1418333166-15429-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Huynh <tom.huynh@freescale.com>

The nr_events variable in tools/perf/ui/browsers/hists.c is of type u64,
so the print format (%lu) causes 'perf report' to show 0 event count
when running with 32-bit userspace without redirection.

This patch fixes that problem by printing nr_events as PRIu64.

Signed-off-by: Tom Huynh <tom.huynh@freescale.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kim Phillips <kim.phillips@freescale.com>
Cc: Matt Mullins <mmullins@mmlx.us>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1417541842-9747-1-git-send-email-tom.huynh@freescale.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/hists.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 502daff76ceb..e6bb04b5b09b 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -1252,7 +1252,7 @@ static int hists__browser_title(struct hists *hists,
 
 	nr_samples = convert_unit(nr_samples, &unit);
 	printed = scnprintf(bf, size,
-			   "Samples: %lu%c of event '%s', Event count (approx.): %lu",
+			   "Samples: %lu%c of event '%s', Event count (approx.): %" PRIu64,
 			   nr_samples, unit, ev_name, nr_events);
 
 
-- 
1.9.3

