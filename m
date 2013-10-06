Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438Ab3JFKcr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 06:32:47 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:42273 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586Ab3JFKcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 06:32:45 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Robert Richter <robert.richter@amd.com>, Jiri Olsa <jolsa@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH] perf tool: don't open-code TEST_EVENTS macro
Date: Sun,  6 Oct 2013 15:55:41 +0530
Message-Id: <1381055141-25209-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.4.477.g5d89aa9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TEST_EVENTS macro is open-coded towards the end of
test__parse_events(). While at it, undef it cleanly after its usage.

Cc: Robert Richter <robert.richter@amd.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/perf/tests/parse-events.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/tests/parse-events.c b/tools/perf/tests/parse-events.c
index 48114d1..a6f51ff 100644
--- a/tools/perf/tests/parse-events.c
+++ b/tools/perf/tests/parse-events.c
@@ -1531,9 +1531,9 @@ do {							\
 			return ret;
 	}
 
-	ret1 = test_terms(test__terms, ARRAY_SIZE(test__terms));
-	if (!ret2)
-		ret2 = ret1;
+	TEST_EVENTS(test__terms);
+
+#undef TEST_EVENTS
 
 	return ret2;
 }
-- 
1.8.4.477.g5d89aa9

