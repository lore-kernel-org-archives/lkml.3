Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426Ab3CULaX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 07:30:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56635 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155Ab3CULaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 07:30:21 -0400
Date: Thu, 21 Mar 2013 04:28:57 -0700
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-c1ad050caad5fbff13fd2f54f49e184bd71de90d@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1363151248-16674-4-git-send-email-dsahern@gmail.com>
References: <1363151248-16674-4-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf session:
  Remove unused perf_session__remove_thread method
Git-Commit-ID: c1ad050caad5fbff13fd2f54f49e184bd71de90d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 21 Mar 2013 04:29:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c1ad050caad5fbff13fd2f54f49e184bd71de90d
Gitweb:     http://git.kernel.org/tip/c1ad050caad5fbff13fd2f54f49e184bd71de90d
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Tue, 12 Mar 2013 23:07:27 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 15 Mar 2013 13:06:08 -0300

perf session: Remove unused perf_session__remove_thread method

Should have been removed on this changeset, that removed the last user
of it:

  743eb868657bdb1b26c7b24077ca21c67c82c777

    perf tools: Resolve machine earlier and pass it to perf_event_ops

Signed-off-by: David Ahern <dsahern@gmail.com>
Link: http://lkml.kernel.org/r/1363151248-16674-4-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c | 12 ------------
 tools/perf/util/session.h |  1 -
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
