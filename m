Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513Ab3HCAmm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 20:42:42 -0400
Received: from mga03.intel.com ([143.182.124.21]:33938 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753047Ab3HCAlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 20:41:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,805,1367996400"; 
   d="scan'208";a="277034520"
From: Andi Kleen <andi@firstfloor.org>
To: acme@infradead.org
Cc: eranian@google.com, jolsa@redhat.com, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/5] perf, tools: Remove obsolete dummy execve
Date: Fri,  2 Aug 2013 17:41:09 -0700
Message-Id: <1375490473-1503-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1375490473-1503-1-git-send-email-andi@firstfloor.org>
References: <1375490473-1503-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Minor cleanup.

The dummy execve to pre-resolve the PLT is obsolete since
"enable_on_execve" was added. The counters are only
running after the execve anyways. So just remove it.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/util/evlist.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 8065ce8..62efec9 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -783,13 +783,6 @@ int perf_evlist__prepare_workload(struct perf_evlist *evlist,
 		fcntl(go_pipe[0], F_SETFD, FD_CLOEXEC);
 
 		/*
-		 * Do a dummy execvp to get the PLT entry resolved,
-		 * so we avoid the resolver overhead on the real
-		 * execvp call.
-		 */
-		execvp("", (char **)argv);
-
-		/*
 		 * Tell the parent we're ready to go
 		 */
 		close(child_ready_pipe[1]);
-- 
1.8.3.1

