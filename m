Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771AbaGTV4Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 17:56:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36749 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846AbaGTV4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 17:56:21 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 01/19] perf tools: Fix accounting of ordered samples queue
Date: Sun, 20 Jul 2014 23:55:45 +0200
Message-Id: <1405893363-21967-2-git-send-email-jolsa@kernel.org>
In-Reply-To: <1405893363-21967-1-git-send-email-jolsa@kernel.org>
References: <1405893363-21967-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Properly account flushed samples within the ordered
samples queue.

Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/session.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index eac14ce0ae8d..ff6a69afe045 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -511,6 +511,7 @@ static int flush_sample_queue(struct perf_session *s,
 		os->last_flush = iter->timestamp;
 		list_del(&iter->list);
 		list_add(&iter->list, &os->sample_cache);
+		os->nr_samples--;
 
 		if (show_progress)
 			ui_progress__update(&prog, 1);
@@ -523,8 +524,6 @@ static int flush_sample_queue(struct perf_session *s,
 			list_entry(head->prev, struct sample_queue, list);
 	}
 
-	os->nr_samples = 0;
-
 	return 0;
 }
 
-- 
1.8.3.1

