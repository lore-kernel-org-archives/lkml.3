Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160Ab3LKLFU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 06:05:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60178 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138Ab3LKLFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 06:05:12 -0500
Date: Wed, 11 Dec 2013 03:04:39 -0800
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-f5ae9c424e4c80c44e9ab7e5ff4a6b79490c23be@git.kernel.org>
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
In-Reply-To: <1386595120-22978-3-git-send-email-adrian.hunter@intel.com>
References: <1386595120-22978-3-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evlist: Fix max mmap_pages
Git-Commit-ID: f5ae9c424e4c80c44e9ab7e5ff4a6b79490c23be
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 11 Dec 2013 03:04:46 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f5ae9c424e4c80c44e9ab7e5ff4a6b79490c23be
Gitweb:     http://git.kernel.org/tip/f5ae9c424e4c80c44e9ab7e5ff4a6b79490c23be
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Mon, 9 Dec 2013 15:18:38 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 9 Dec 2013 15:17:38 -0300

perf evlist: Fix max mmap_pages

'SIZE_MAX / page_size' is an upper limit for the maximum number of mmap
pages, not a lower limit.  Change the condition accordingly.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1386595120-22978-3-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 4d0945c..98ec96b 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -754,7 +754,7 @@ int perf_evlist__parse_mmap_pages(const struct option *opt, const char *str,
 	unsigned long max = UINT_MAX;
 	long pages;
 
-	if (max < SIZE_MAX / page_size)
+	if (max > SIZE_MAX / page_size)
 		max = SIZE_MAX / page_size;
 
 	pages = parse_pages_arg(str, 1, max);
