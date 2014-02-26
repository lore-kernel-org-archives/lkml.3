Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbaBZPpq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 10:45:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24343 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753283AbaBZPpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 10:45:44 -0500
From: Don Zickus <dzickus@redhat.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: acme@ghostprotocols.net, jolsa@redhat.com, eranian@google.com,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 2/2] perf: Use tid in mmap/mmap2 events to find maps
Date: Wed, 26 Feb 2014 10:45:27 -0500
Message-Id: <1393429527-167840-3-git-send-email-dzickus@redhat.com>
In-Reply-To: <1393429527-167840-1-git-send-email-dzickus@redhat.com>
References: <1393429527-167840-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we can properly synthesize threads system-wide, make sure
the mmap and mmap2 events use tids instead of pids to locate their
maps.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 tools/perf/util/machine.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 813e94e..eb26544 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1026,7 +1026,7 @@ int machine__process_mmap2_event(struct machine *machine,
 	}
 
 	thread = machine__findnew_thread(machine, event->mmap2.pid,
-					event->mmap2.pid);
+					event->mmap2.tid);
 	if (thread == NULL)
 		goto out_problem;
 
@@ -1074,7 +1074,7 @@ int machine__process_mmap_event(struct machine *machine, union perf_event *event
 	}
 
 	thread = machine__findnew_thread(machine, event->mmap.pid,
-					 event->mmap.pid);
+					 event->mmap.tid);
 	if (thread == NULL)
 		goto out_problem;
 
-- 
1.7.11.7

