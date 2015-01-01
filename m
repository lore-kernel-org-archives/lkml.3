Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057AbbAAPa4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 10:30:56 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:35372 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041AbbAAPaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 10:30:52 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alex Converse <aconverse@google.com>,
        Namhyung Kim <namhyung@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] tools: perf: util: annotate.c:  Remove unused function
Date: Thu,  1 Jan 2015 16:33:52 +0100
Message-Id: <1420126432-27493-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function hist_entry__annotate() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 tools/perf/util/annotate.c |    5 -----
 tools/perf/util/annotate.h |    2 --
 2 files changed, 7 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 7dabde1..f0551e2 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -1404,11 +1404,6 @@ int symbol__tty_annotate(struct symbol *sym, struct map *map,
 	return 0;
 }
 
-int hist_entry__annotate(struct hist_entry *he, size_t privsize)
-{
-	return symbol__annotate(he->ms.sym, he->ms.map, privsize);
-}
-
 bool ui__has_annotation(void)
 {
 	return use_browser == 1 && sort__has_sym;
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index 112d6e2..49b6996 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -141,8 +141,6 @@ void symbol__annotate_zero_histograms(struct symbol *sym);
 
 int symbol__annotate(struct symbol *sym, struct map *map, size_t privsize);
 
-int hist_entry__annotate(struct hist_entry *he, size_t privsize);
-
 int symbol__annotate_init(struct map *map __maybe_unused, struct symbol *sym);
 int symbol__annotate_printf(struct symbol *sym, struct map *map,
 			    struct perf_evsel *evsel, bool full_paths,
-- 
1.7.10.4

