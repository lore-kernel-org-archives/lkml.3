Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab3BDJ5H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 04:57:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20858 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753308Ab3BDJ5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 04:57:04 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 1/2] perf tools: Fix perf_evsel::exclude_GH handling
Date: Mon,  4 Feb 2013 10:56:42 +0100
Message-Id: <1359971803-2343-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1359971803-2343-1-git-send-email-jolsa@redhat.com>
References: <1359971803-2343-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let the perf_evsel::exclude_GH only prevent the reset of
exclude_host and exclude_guest attributes in case they
were already set.

We cannot reset their values to 0, because they might
have other defaults set by event_attr_init.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/parse-events.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 4e0f5c2..c84f48c 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -699,14 +699,6 @@ static int get_event_modifier(struct event_modifier *mod, char *str,
 	int exclude = eu | ek | eh;
 	int exclude_GH = evsel ? evsel->exclude_GH : 0;
 
-	/*
-	 * We are here for group and 'GH' was not set as event
-	 * modifier and whatever event/group modifier override
-	 * default 'GH' setup.
-	 */
-	if (evsel && !exclude_GH)
-		eH = eG = 0;
-
 	memset(mod, 0, sizeof(*mod));
 
 	while (*str) {
-- 
1.7.11.7

