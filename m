Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab3CRQfV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 12:35:21 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:49389
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752770Ab3CRQZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 12:25:58 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 33/54] perf trace: Get rid of a duplicate code
Date: Mon, 18 Mar 2013 13:25:18 -0300
Message-Id: <1363623939-10748-34-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1363623939-10748-1-git-send-email-acme@infradead.org>
References: <1363623939-10748-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Checking of sample.raw_data is duplicated and seems an artifact of some
git auto merging stuff.  Kill it.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1363064360-7641-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index f0c20ef..49fedb5 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -527,13 +527,6 @@ again:
 				continue;
 			}
 
-			if (sample.raw_data == NULL) {
-				printf("%s sample with no payload for tid: %d, cpu %d, raw_size=%d, skipping...\n",
-				       perf_evsel__name(evsel), sample.tid,
-				       sample.cpu, sample.raw_size);
-				continue;
-			}
-
 			handler = evsel->handler.func;
 			handler(trace, evsel, &sample);
 		}
-- 
1.7.1

