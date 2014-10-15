Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103AbaJOKB4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 06:01:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54177 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbaJOKBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 06:01:54 -0400
Date: Wed, 15 Oct 2014 03:01:34 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-0cae013cf4450ea0ecb62241a2f3e7565db09f93@git.kernel.org>
Cc: hpa@zytor.com, adrian.hunter@intel.com, linux-kernel@vger.kernel.org,
        mail@milianw.de, paulus@samba.org, tglx@linutronix.de,
        a.p.zijlstra@chello.nl, dsahern@gmail.com, fweisbec@gmail.com,
        mingo@kernel.org, cjashfor@linux.vnet.ibm.com, namhyung@kernel.org,
        acme@redhat.com, jolsa@kernel.org
Reply-To: fweisbec@gmail.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        dsahern@gmail.com, acme@redhat.com, jolsa@kernel.org,
        cjashfor@linux.vnet.ibm.com, mingo@kernel.org, namhyung@kernel.org,
        adrian.hunter@intel.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mail@milianw.de, paulus@samba.org
In-Reply-To: <1412179229-19466-4-git-send-email-jolsa@kernel.org>
References: <1412179229-19466-4-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf kvm stat live:
  Use perf_evlist__add_pollfd return fd position
Git-Commit-ID: 0cae013cf4450ea0ecb62241a2f3e7565db09f93
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

Commit-ID:  0cae013cf4450ea0ecb62241a2f3e7565db09f93
Gitweb:     http://git.kernel.org/tip/0cae013cf4450ea0ecb62241a2f3e7565db09f93
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Wed, 1 Oct 2014 18:00:28 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 3 Oct 2014 09:39:48 -0300

perf kvm stat live: Use perf_evlist__add_pollfd return fd position

With the interface changed in following commit:

  2171a9256862 tools lib fd array: Allow associating an integer cookie with each entry

the perf_evlist__add_pollfd function now returns the fd position in the
pollfd array.

Hence we no longer need to count the fd position, because we get it as
the return value.

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
Link: http://lkml.kernel.org/r/1412179229-19466-4-git-send-email-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kvm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 663d6ed..dc7d704 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -933,10 +933,10 @@ static int kvm_events_live_report(struct perf_kvm_stat *kvm)
 
 	nr_fds++;
 
-	if (perf_evlist__add_pollfd(kvm->evlist, fileno(stdin)) < 0)
+	nr_stdin = perf_evlist__add_pollfd(kvm->evlist, fileno(stdin));
+	if (nr_stdin < 0)
 		goto out;
 
-	nr_stdin = nr_fds;
 	nr_fds++;
 	if (fd_set_nonblock(fileno(stdin)) != 0)
 		goto out;
