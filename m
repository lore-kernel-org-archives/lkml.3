Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929Ab3KLOsD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 09:48:03 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:54430 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754516Ab3KLOrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 09:47:13 -0500
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, jolsa@redhat.com, David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH 1/5] perf record: Fix segfault with --no-mmap-pages
Date: Tue, 12 Nov 2013 07:46:53 -0700
Message-Id: <1384267617-3446-2-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.8.3.4 (Apple Git-47)
In-Reply-To: <1384267617-3446-1-git-send-email-dsahern@gmail.com>
References: <1384267617-3446-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian reported a segfault when using --no-out-pages:
$ tools/perf/perf record -vv --no-out-pages uname
Segmentation fault (core dumped)

The same occurs with --no-mmap-pages. Fix by checking that str is non-NULL
before parsing it.

Reported-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/evlist.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 99dc58e5dcc3..3960560f873a 100644
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
-- 
1.8.3.4 (Apple Git-47)

