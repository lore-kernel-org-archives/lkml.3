Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010AbaALSst (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 13:48:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45392 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358AbaALScq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 13:32:46 -0500
Date: Sun, 12 Jan 2014 10:32:07 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-txsgu9umb0i86ijk888r1a0o@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf top: Use hist_entry__inc_addr_sample
Git-Commit-ID: 618afb294e288db086fce59de4419644215265e5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 12 Jan 2014 10:32:13 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  618afb294e288db086fce59de4419644215265e5
Gitweb:     http://git.kernel.org/tip/618afb294e288db086fce59de4419644215265e5
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 18 Dec 2013 17:08:07 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 19 Dec 2013 11:34:23 -0300

perf top: Use hist_entry__inc_addr_sample

Since it has a hist_entry, no need to skip the hist layer and use the
underlying symbol one.

Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-txsgu9umb0i86ijk888r1a0o@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 73df9c0..2c6cb66 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -190,7 +190,7 @@ static void perf_top__record_precise_ip(struct perf_top *top,
 		return;
 
 	ip = he->ms.map->map_ip(he->ms.map, ip);
-	err = symbol__inc_addr_samples(sym, he->ms.map, counter, ip);
+	err = hist_entry__inc_addr_samples(he, counter, ip);
 
 	pthread_mutex_unlock(&notes->lock);
 
