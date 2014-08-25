Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933129AbaHYOq3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 10:46:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13391 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933032AbaHYOqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 10:46:20 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Jen-Cheng(Tommy) Huang" <tommy24@gatech.edu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/9] perf: Remove redundant parent context check from context_equiv
Date: Mon, 25 Aug 2014 16:45:35 +0200
Message-Id: <1408977943-16594-2-git-send-email-jolsa@kernel.org>
In-Reply-To: <1408977943-16594-1-git-send-email-jolsa@kernel.org>
References: <1408977943-16594-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As described in commit:
  1f9a7268c67f perf: Do not allow optimized switch for non-cloned events
we dont allow optimized switch for non cloned contexts.

There's no need now to check if one of the context is parent
of the other in context_equiv function.

Cc: Andi Kleen <andi@firstfloor.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jen-Cheng(Tommy) Huang <tommy24@gatech.edu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/events/core.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index d8cb4d21a346..4ad4ba2bc106 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2257,14 +2257,6 @@ static int context_equiv(struct perf_event_context *ctx1,
 	if (ctx1->pin_count || ctx2->pin_count)
 		return 0;
 
-	/* If ctx1 is the parent of ctx2 */
-	if (ctx1 == ctx2->parent_ctx && ctx1->generation == ctx2->parent_gen)
-		return 1;
-
-	/* If ctx2 is the parent of ctx1 */
-	if (ctx1->parent_ctx == ctx2 && ctx1->parent_gen == ctx2->generation)
-		return 1;
-
 	/*
 	 * If ctx1 and ctx2 have the same parent; we flatten the parent
 	 * hierarchy, see perf_event_init_context().
-- 
1.8.3.1

