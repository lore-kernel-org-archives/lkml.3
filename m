Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271Ab3CMFIP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 01:08:15 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34341 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754532Ab3CMFHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 01:07:41 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>
Subject: [PATCH 3/4] perf: remove unused perf_session__remove_thread
Date: Tue, 12 Mar 2013 23:07:27 -0600
Message-Id: <1363151248-16674-4-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1363151248-16674-1-git-send-email-dsahern@gmail.com>
References: <1363151248-16674-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/util/session.c |   12 ------------
 tools/perf/util/session.h |    1 -
 2 files changed, 13 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index bd85280b..ab265c2 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1365,18 +1365,6 @@ size_t perf_session__fprintf(struct perf_session *session, FILE *fp)
 	return machine__fprintf(&session->machines.host, fp);
 }
 
-void perf_session__remove_thread(struct perf_session *session,
-				 struct thread *th)
-{
-	/*
-	 * FIXME: This one makes no sense, we need to remove the thread from
-	 * the machine it belongs to, perf_session can have many machines, so
-	 * doing it always on ->machines.host is wrong.  Fix when auditing all
-	 * the 'perf kvm' code.
-	 */
-	machine__remove_thread(&session->machines.host, th);
-}
-
 struct perf_evsel *perf_session__find_first_evtype(struct perf_session *session,
 					      unsigned int type)
 {
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index b5c0847..6b51d47 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -72,7 +72,6 @@ void perf_event__attr_swap(struct perf_event_attr *attr);
 int perf_session__create_kernel_maps(struct perf_session *self);
 
 void perf_session__set_id_hdr_size(struct perf_session *session);
-void perf_session__remove_thread(struct perf_session *self, struct thread *th);
 
 static inline
 struct machine *perf_session__find_machine(struct perf_session *self, pid_t pid)
-- 
1.7.10.1

