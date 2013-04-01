Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757990Ab3DALfc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 07:35:32 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:59262 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757945Ab3DALfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 07:35:30 -0400
X-AuditID: 9c930179-b7c78ae000000e4b-90-515970feea0e
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 9/9] perf hists: Move column length setting code
Date: Mon,  1 Apr 2013 20:35:25 +0900
Message-Id: <1364816125-12212-10-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1364816125-12212-1-git-send-email-namhyung@kernel.org>
References: <1364816125-12212-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

They are set to constant length so no need to update every time.

Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/hist.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 1fb1535940f8..e144aefc76e6 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -56,6 +56,12 @@ void hists__reset_col_len(struct hists *hists)
 	hists__set_col_len(hists, HISTC_ADDR, BITS_PER_LONG / 4 + 2);
 	hists__set_col_len(hists, HISTC_ADDR_FROM, BITS_PER_LONG / 4 + 2);
 	hists__set_col_len(hists, HISTC_ADDR_TO, BITS_PER_LONG / 4 + 2);
+	hists__set_col_len(hists, HISTC_LOCAL_WEIGHT, 12);
+	hists__set_col_len(hists, HISTC_GLOBAL_WEIGHT, 12);
+	hists__set_col_len(hists, HISTC_MEM_LOCKED, 6);
+	hists__set_col_len(hists, HISTC_MEM_TLB, 22);
+	hists__set_col_len(hists, HISTC_MEM_SNOOP, 12);
+	hists__set_col_len(hists, HISTC_MEM_LVL, 21 + 3);
 }
 
 static void hists__set_unres_dso_col_len(struct hists *hists, int dso)
@@ -156,13 +162,6 @@ void hists__calc_col_len(struct hists *hists, struct hist_entry *h)
 		hists__new_col_len(hists, HISTC_MEM_DADDR_SYMBOL, symlen);
 		hists__set_unres_dso_col_len(hists, HISTC_MEM_DADDR_DSO);
 	}
-
-	hists__new_col_len(hists, HISTC_MEM_LOCKED, 6);
-	hists__new_col_len(hists, HISTC_MEM_TLB, 22);
-	hists__new_col_len(hists, HISTC_MEM_SNOOP, 12);
-	hists__new_col_len(hists, HISTC_MEM_LVL, 21 + 3);
-	hists__new_col_len(hists, HISTC_LOCAL_WEIGHT, 12);
-	hists__new_col_len(hists, HISTC_GLOBAL_WEIGHT, 12);
 }
 
 void hists__output_recalc_col_len(struct hists *hists, int max_rows)
-- 
1.7.11.7

