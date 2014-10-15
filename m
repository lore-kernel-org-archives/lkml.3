Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124AbaJOKB6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 06:01:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54178 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbaJOKBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 06:01:54 -0400
Date: Wed, 15 Oct 2014 03:01:17 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-fe636adda6caff6022e61b37202495dbf68e1410@git.kernel.org>
Cc: mail@milianw.de, fweisbec@gmail.com, mingo@kernel.org,
        linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        tglx@linutronix.de, namhyung@kernel.org, a.p.zijlstra@chello.nl,
        cjashfor@linux.vnet.ibm.com, jolsa@kernel.org, acme@redhat.com,
        dsahern@gmail.com, hpa@zytor.com, paulus@samba.org
Reply-To: mingo@kernel.org, mail@milianw.de, fweisbec@gmail.com,
        adrian.hunter@intel.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, jolsa@kernel.org,
        namhyung@kernel.org, a.p.zijlstra@chello.nl, hpa@zytor.com,
        paulus@samba.org, acme@redhat.com, dsahern@gmail.com
In-Reply-To: <1412179229-19466-3-git-send-email-jolsa@kernel.org>
References: <1412179229-19466-3-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf kvm stat live:
  Fix perf_evlist__add_pollfd error handling
Git-Commit-ID: fe636adda6caff6022e61b37202495dbf68e1410
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

Commit-ID:  fe636adda6caff6022e61b37202495dbf68e1410
Gitweb:     http://git.kernel.org/tip/fe636adda6caff6022e61b37202495dbf68e1410
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Wed, 1 Oct 2014 18:00:27 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 3 Oct 2014 09:39:47 -0300

perf kvm stat live: Fix perf_evlist__add_pollfd error handling

With the interface changed in following commit:

  2171a9256862 tools lib fd array: Allow associating an integer cookie with each entry

the perf_evlist__add_pollfd function now returns the fd position in the
pollfd array.

We need to change this function's error check condition.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Milian Wolff <mail@milianw.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1412179229-19466-3-git-send-email-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kvm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index d8bf227..663d6ed 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -928,12 +928,12 @@ static int kvm_events_live_report(struct perf_kvm_stat *kvm)
 		goto out;
 	}
 
-	if (perf_evlist__add_pollfd(kvm->evlist, kvm->timerfd))
+	if (perf_evlist__add_pollfd(kvm->evlist, kvm->timerfd) < 0)
 		goto out;
 
 	nr_fds++;
 
-	if (perf_evlist__add_pollfd(kvm->evlist, fileno(stdin)))
+	if (perf_evlist__add_pollfd(kvm->evlist, fileno(stdin)) < 0)
 		goto out;
 
 	nr_stdin = nr_fds;
