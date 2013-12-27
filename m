Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877Ab3L0Ur0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 15:47:26 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35683 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754801Ab3L0UrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 15:47:20 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 36/49] perf tools: Add support for PERF_RECORD_MISC_GUEST_USER in thread__find_addr_map().
Date: Fri, 27 Dec 2013 17:46:52 -0300
Message-Id: <1388177225-17349-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1388177225-17349-1-git-send-email-acme@infradead.org>
References: <1388177225-17349-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>

This patch remove a TODO in thread__find_addr_map() and add support of
PERF_RECORD_MISC_GUEST_USER.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Link: http://lkml.kernel.org/r/3dd652201171a19c910b500984c7c3590e77603b.1387572416.git.yangds.fnst@cn.fujitsu.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index fe2022799161..484e99464a00 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -659,15 +659,10 @@ void thread__find_addr_map(struct thread *thread,
 		al->level = 'g';
 		mg = &machine->kmaps;
 		load_map = true;
+	} else if (cpumode == PERF_RECORD_MISC_GUEST_USER && perf_guest) {
+		al->level = 'u';
 	} else {
-		/*
-		 * 'u' means guest os user space.
-		 * TODO: We don't support guest user space. Might support late.
-		 */
-		if (cpumode == PERF_RECORD_MISC_GUEST_USER && perf_guest)
-			al->level = 'u';
-		else
-			al->level = 'H';
+		al->level = 'H';
 		al->map = NULL;
 
 		if ((cpumode == PERF_RECORD_MISC_GUEST_USER ||
-- 
1.8.1.4

