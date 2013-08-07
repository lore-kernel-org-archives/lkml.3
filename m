Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933569Ab3HGVT3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 17:19:29 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47036 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933397Ab3HGVL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 17:11:28 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 20/47] perf evlist: Remove obsolete dummy execve
Date: Wed,  7 Aug 2013 18:10:47 -0300
Message-Id: <1375909874-22073-21-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1375909874-22073-1-git-send-email-acme@infradead.org>
References: <1375909874-22073-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Minor cleanup.

The dummy execve to pre-resolve the PLT is obsolete since
"enable_on_execve" was added. The counters are only
running after the execve anyways. So just remove it.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Reviewed-by: Jiri Olsa <jolsa@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1375490473-1503-2-git-send-email-andi@firstfloor.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index da2dd92..c7d111f 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -837,13 +837,6 @@ int perf_evlist__prepare_workload(struct perf_evlist *evlist,
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
1.8.1.4

