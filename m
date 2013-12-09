Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933726Ab3LINLc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 08:11:32 -0500
Received: from mga02.intel.com ([134.134.136.20]:42365 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933607Ab3LINL3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 08:11:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,857,1378882800"; 
   d="scan'208";a="449172936"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 4/4] perf tools: Fix display of incorrect mmap pages
Date: Mon,  9 Dec 2013 15:18:40 +0200
Message-Id: <1386595120-22978-5-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1386595120-22978-1-git-send-email-adrian.hunter@intel.com>
References: <1386595120-22978-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'mmap_pages' is 'unsigned int' not 'int' e.g.

  perf record -m2147483648 uname
  Permission error mapping pages.
  Consider increasing /proc/sys/kernel/perf_event_mlock_kb,
  or try again with a smaller value of -m/--mmap_pages.
  (current value: -2147483648)

Fixed:

  perf record -m2147483648 uname
  Permission error mapping pages.
  Consider increasing /proc/sys/kernel/perf_event_mlock_kb,
  or try again with a smaller value of -m/--mmap_pages.
  (current value: 2147483648)

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/builtin-record.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index d93e2ee..c1c1200 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -224,7 +224,7 @@ try_again:
 			       "Consider increasing "
 			       "/proc/sys/kernel/perf_event_mlock_kb,\n"
 			       "or try again with a smaller value of -m/--mmap_pages.\n"
-			       "(current value: %d)\n", opts->mmap_pages);
+			       "(current value: %u)\n", opts->mmap_pages);
 			rc = -errno;
 		} else {
 			pr_err("failed to mmap with %d (%s)\n", errno, strerror(errno));
-- 
1.7.11.7

