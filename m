Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834AbaIPK62 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 06:58:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43662 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775AbaIPK6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 06:58:25 -0400
Date: Tue, 16 Sep 2014 03:58:02 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-c88f2096136416b261bd3647cc260935f6e95805@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
        eranian@google.com, hpa@zytor.com, mingo@kernel.org, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com, acme@redhat.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <20140908143107.GG17728@krava.brq.redhat.com>
References: <20140908143107.GG17728@krava.brq.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf:
  Do not check PERF_EVENT_STATE_EXIT on syscall read path
Git-Commit-ID: c88f2096136416b261bd3647cc260935f6e95805
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c88f2096136416b261bd3647cc260935f6e95805
Gitweb:     http://git.kernel.org/tip/c88f2096136416b261bd3647cc260935f6e95805
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Mon, 8 Sep 2014 16:31:07 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 16 Sep 2014 10:30:36 +0200

perf: Do not check PERF_EVENT_STATE_EXIT on syscall read path

Revert PERF_EVENT_STATE_EXIT check on read syscall path.
It breaks standard way to read counter, which is to open
the counter, wait for the monitored process to die and
read the counter.

Reported-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Acked-by: Stephane Eranian <eranian@google.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: David Ahern <dsahern@gmail.com>
Link: http://lkml.kernel.org/r/20140908143107.GG17728@krava.brq.redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index f917dec..733c616 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3601,8 +3601,7 @@ perf_read_hw(struct perf_event *event, char __user *buf, size_t count)
 	 * error state (i.e. because it was pinned but it couldn't be
 	 * scheduled on to the CPU at some point).
 	 */
-	if ((event->state == PERF_EVENT_STATE_ERROR) ||
-	    (event->state == PERF_EVENT_STATE_EXIT))
+	if (event->state == PERF_EVENT_STATE_ERROR)
 		return 0;
 
 	if (count < event->read_size)
