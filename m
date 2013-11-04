Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152Ab3KDUVT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 15:21:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49983 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343Ab3KDUVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 15:21:14 -0500
Date: Mon, 4 Nov 2013 12:20:52 -0800
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-026359658aecd348bc5c4a136a26f204b169103b@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1383313899-15987-6-git-send-email-adrian.hunter@intel.com>
References: <1383313899-15987-6-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evlist:
  Add a debug print if event buffer mmap fails
Git-Commit-ID: 026359658aecd348bc5c4a136a26f204b169103b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 04 Nov 2013 12:20:57 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  026359658aecd348bc5c4a136a26f204b169103b
Gitweb:     http://git.kernel.org/tip/026359658aecd348bc5c4a136a26f204b169103b
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Fri, 1 Nov 2013 15:51:33 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 4 Nov 2013 12:21:41 -0300

perf evlist: Add a debug print if event buffer mmap fails

Add a debug print if mmap of the perf event ring buffer fails.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1383313899-15987-6-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 0582f67..1c173cc 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -607,6 +607,8 @@ static int __perf_evlist__mmap(struct perf_evlist *evlist,
 	evlist->mmap[idx].base = mmap(NULL, evlist->mmap_len, prot,
 				      MAP_SHARED, fd, 0);
 	if (evlist->mmap[idx].base == MAP_FAILED) {
+		pr_debug2("failed to mmap perf event ring buffer, error %d\n",
+			  errno);
 		evlist->mmap[idx].base = NULL;
 		return -1;
 	}
