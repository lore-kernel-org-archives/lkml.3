Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012Ab3HAC5u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 22:57:50 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:59615 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693Ab3HACzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 22:55:46 -0400
X-AuditID: 9c930197-b7bfbae000000e88-c5-51f9ce31c0cf
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 3/9] perf hists: Free srcline when freeing hist_entry
Date: Thu,  1 Aug 2013 11:55:38 +0900
Message-Id: <1375325744-26613-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1375325744-26613-1-git-send-email-namhyung@kernel.org>
References: <1375325744-26613-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

We've been leaked srcline of hist_entry, it should be freed also.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/hist.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 46a0d35a05e1..e6c11ccf138c 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -530,6 +530,7 @@ void hist_entry__free(struct hist_entry *he)
 {
 	free(he->branch_info);
 	free(he->mem_info);
+	free(he->srcline);
 	free(he);
 }
 
-- 
1.7.11.7

