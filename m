Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932270AbaCROry (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 10:47:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27012 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756256AbaCROr3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 10:47:29 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Don Zickus <dzickus@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH 2/6] perf tools: Remove thread__find_map function
Date: Tue, 18 Mar 2014 15:46:52 +0100
Message-Id: <1395154016-26709-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1395154016-26709-1-git-send-email-jolsa@redhat.com>
References: <1395154016-26709-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because it's not used any more.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
---
 tools/perf/util/thread.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index 9a07074..9b29f08 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -44,12 +44,6 @@ void thread__insert_map(struct thread *thread, struct map *map);
 int thread__fork(struct thread *thread, struct thread *parent, u64 timestamp);
 size_t thread__fprintf(struct thread *thread, FILE *fp);
 
-static inline struct map *thread__find_map(struct thread *thread,
-					   enum map_type type, u64 addr)
-{
-	return thread ? map_groups__find(&thread->mg, type, addr) : NULL;
-}
-
 void thread__find_addr_map(struct thread *thread, struct machine *machine,
 			   u8 cpumode, enum map_type type, u64 addr,
 			   struct addr_location *al);
-- 
1.8.3.1

