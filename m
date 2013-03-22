Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546Ab3CVCyR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 22:54:17 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:52070 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677Ab3CVCyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 22:54:15 -0400
X-AuditID: 9c930179-b7c78ae000000e4b-b6-514bc7d5c75a
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] perf evsel: Fix format string in perf_evsel__open_strerror()
Date: Fri, 22 Mar 2013 11:54:11 +0900
Message-Id: <1363920851-30398-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

In case of EPERM or EACCESS, there was a debious "%s" before actual
string so that an user would see "You may not have permission to
collect %sstats." instead of "You may not ... system-wide stats.".

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/evsel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 1adb824610f0..b190d57e926e 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1495,7 +1495,7 @@ int perf_evsel__open_strerror(struct perf_evsel *evsel,
 	switch (err) {
 	case EPERM:
 	case EACCES:
-		return scnprintf(msg, size, "%s",
+		return scnprintf(msg, size,
 		 "You may not have permission to collect %sstats.\n"
 		 "Consider tweaking /proc/sys/kernel/perf_event_paranoid:\n"
 		 " -1 - Not paranoid at all\n"
-- 
1.7.11.7

