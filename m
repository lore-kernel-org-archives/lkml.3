Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935313Ab3E3QDr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 12:03:47 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50923 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934513Ab3E3QCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 12:02:12 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 03/66] perf hists: Free unused mem info of a matched hist entry
Date: Thu, 30 May 2013 19:00:36 +0300
Message-Id: <1369929699-8724-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1369929699-8724-1-git-send-email-acme@infradead.org>
References: <1369929699-8724-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The mem info is shared between matched entries so one should be freed.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1364816125-12212-3-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 9438d57..514fc04 100644
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
1.8.1.4

