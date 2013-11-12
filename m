Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932225Ab3KLWAe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 17:00:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40260 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932349Ab3KLV5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 16:57:19 -0500
Date: Tue, 12 Nov 2013 13:57:06 -0800
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-8973504be70b2986a2081eeff7d9a4210dec295d@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, jolsa@redhat.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1384267617-3446-2-git-send-email-dsahern@gmail.com>
References: <1384267617-3446-2-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf record: Fix segfault with --no-mmap-pages
Git-Commit-ID: 8973504be70b2986a2081eeff7d9a4210dec295d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 12 Nov 2013 13:57:12 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8973504be70b2986a2081eeff7d9a4210dec295d
Gitweb:     http://git.kernel.org/tip/8973504be70b2986a2081eeff7d9a4210dec295d
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Tue, 12 Nov 2013 07:46:53 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 12 Nov 2013 16:30:54 -0300

perf record: Fix segfault with --no-mmap-pages

Adrian reported a segfault when using --no-out-pages:

$ tools/perf/perf record -vv --no-out-pages uname
Segmentation fault (core dumped)

The same occurs with --no-mmap-pages. Fix by checking that str is
non-NULL before parsing it.

Signed-off-by: David Ahern <dsahern@gmail.com>
Reported-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/r/1384267617-3446-2-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 99dc58e..3960560 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -719,6 +719,9 @@ int perf_evlist__parse_mmap_pages(const struct option *opt, const char *str,
 		{ .tag  = 0 },
 	};
 
+	if (str == NULL)
+		return -1;
+
 	val = parse_tag_value(str, tags);
 	if (val != (unsigned long) -1) {
 		/* we got file size value */
