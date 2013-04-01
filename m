Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758591Ab3DALhP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 07:37:15 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:44674 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757784Ab3DALf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 07:35:28 -0400
X-AuditID: 9c930179-b7c78ae000000e4b-86-515970fe2d5f
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 2/9] perf hists: Free unused mem info of a matched hist entry
Date: Mon,  1 Apr 2013 20:35:18 +0900
Message-Id: <1364816125-12212-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1364816125-12212-1-git-send-email-namhyung@kernel.org>
References: <1364816125-12212-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The mem info is shared between matched entries so one should be freed.

Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/hist.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 9438d576459d..514fc0470e38 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -374,6 +374,12 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 		if (!cmp) {
 			he_stat__add_period(&he->stat, period, weight);
 
+			/*
+			 * This mem info was allocated from machine__resolve_mem
+			 * and will not be used anymore.
+			 */
+			free(entry->mem_info);
+
 			/* If the map of an existing hist_entry has
 			 * become out-of-date due to an exec() or
 			 * similar, update it.  Otherwise we will
-- 
1.7.11.7

