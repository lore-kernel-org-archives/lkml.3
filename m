Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506Ab3HLKUI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 06:20:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47849 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756489Ab3HLKUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 06:20:00 -0400
Date: Mon, 12 Aug 2013 03:19:47 -0700
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-5c6974f49832a55edc9ca744323778947c104ca0@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, jolsa@redhat.com, ak@linux.intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, jolsa@redhat.com,
        ak@linux.intel.com, tglx@linutronix.de
In-Reply-To: <1375490473-1503-2-git-send-email-andi@firstfloor.org>
References: <1375490473-1503-2-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evlist: Remove obsolete dummy execve
Git-Commit-ID: 5c6974f49832a55edc9ca744323778947c104ca0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 12 Aug 2013 03:19:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5c6974f49832a55edc9ca744323778947c104ca0
Gitweb:     http://git.kernel.org/tip/5c6974f49832a55edc9ca744323778947c104ca0
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Fri, 2 Aug 2013 17:41:09 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 7 Aug 2013 17:35:28 -0300

perf evlist: Remove obsolete dummy execve

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
