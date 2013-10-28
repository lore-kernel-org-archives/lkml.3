Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830Ab3J1Opo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 10:45:44 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51842 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756532Ab3J1Opm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 10:45:42 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/2] perf tools: Fix up /proc/PID/maps parsing
Date: Mon, 28 Oct 2013 11:45:25 -0300
Message-Id: <1382971525-2078-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1382971525-2078-1-git-send-email-acme@infradead.org>
References: <1382971525-2078-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

When introducing support for MMAP2 we considered more parts of each map
representation in /proc/PID/maps, and when disabling it we forgot to
reduce the number of expected parsed/assigned entries in the sscanf
call, fix it to expect the right number of desired fields, 5.

Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Based-on-a-patch-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-vrbo1wik997ahjzl1chm3bdm@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 63df031fc9c7..49096ea58a15 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -213,7 +213,7 @@ static int perf_event__synthesize_mmap_events(struct perf_tool *tool,
 		       &event->mmap.pgoff,
 		       execname);
 
-		if (n != 8)
+		if (n != 5)
 			continue;
 
 		if (prot[2] != 'x')
-- 
1.8.1.4

