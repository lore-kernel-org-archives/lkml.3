Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346Ab3CRQmf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 12:42:35 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:49318
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752323Ab3CRQZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 12:25:54 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 35/54] perf session: Remove unused perf_session__remove_thread method
Date: Mon, 18 Mar 2013 13:25:20 -0300
Message-Id: <1363623939-10748-36-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1363623939-10748-1-git-send-email-acme@infradead.org>
References: <1363623939-10748-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Should have been removed on this changeset, that removed the last user
of it:

  743eb868657bdb1b26c7b24077ca21c67c82c777

    perf tools: Resolve machine earlier and pass it to perf_event_ops

Signed-off-by: David Ahern <dsahern@gmail.com>
Link: http://lkml.kernel.org/r/1363151248-16674-4-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c |   12 ------------
 tools/perf/util/session.h |    1 -
 2 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index bd85280..ab265c2 100644
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
1.7.1

