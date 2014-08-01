Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632AbaHAMdo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 08:33:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12292 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754874AbaHAMdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 08:33:41 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 1/3] perf: Do not allow to create kernel events without handler
Date: Fri,  1 Aug 2014 14:33:00 +0200
Message-Id: <1406896382-18404-2-git-send-email-jolsa@kernel.org>
In-Reply-To: <1406896382-18404-1-git-send-email-jolsa@kernel.org>
References: <1406896382-18404-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Force kernel events to specify the handler, because
there's no use for kernel perf event without it.

Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/events/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 1cf24b3e42ec..75c4ff8d1590 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7355,6 +7355,9 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 	struct perf_event *event;
 	int err;
 
+	if (WARN_ON(!overflow_handler))
+		return NULL;
+
 	/*
 	 * Get the target context (task or percpu):
 	 */
-- 
1.8.3.1

