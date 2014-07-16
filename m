Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760894AbaGPTQ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 15:16:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44083 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760821AbaGPTQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 15:16:25 -0400
Date: Wed, 16 Jul 2014 12:15:42 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-yc144ai5jye3yl3h5yxw0scd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de, dzickus@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de, dzickus@redhat.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hists browser: Left justify column headers
Git-Commit-ID: 1561880d7b114a65e307d1ac9a0991dc715355b3
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

Commit-ID:  1561880d7b114a65e307d1ac9a0991dc715355b3
Gitweb:     http://git.kernel.org/tip/1561880d7b114a65e307d1ac9a0991dc715355b3
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 7 Jul 2014 15:23:44 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 7 Jul 2014 15:23:44 -0300

perf hists browser: Left justify column headers

Looks better and avoids it moving to the end of the screen as the column
width changes over time in 'perf top'.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-yc144ai5jye3yl3h5yxw0scd@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/sort.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 1ec57dd..14e5a03 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -1215,7 +1215,7 @@ static int __sort__hpp_header(struct perf_hpp_fmt *fmt, struct perf_hpp *hpp,
 	hse = container_of(fmt, struct hpp_sort_entry, hpp);
 	len = hists__col_len(&evsel->hists, hse->se->se_width_idx);
 
-	return scnprintf(hpp->buf, hpp->size, "%*s", len, hse->se->se_header);
+	return scnprintf(hpp->buf, hpp->size, "%-*s", len, hse->se->se_header);
 }
 
 static int __sort__hpp_width(struct perf_hpp_fmt *fmt,
