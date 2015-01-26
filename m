Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812AbbAZRsj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 12:48:39 -0500
Received: from mail.kernel.org ([198.145.29.136]:53024 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753887AbbAZRsf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 12:48:35 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Kan Liang <kan.liang@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 15/26] perf diff: Introduce fmt_to_data_file() helper
Date: Mon, 26 Jan 2015 14:47:18 -0300
Message-Id: <1422294449-12735-16-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1422294449-12735-1-git-send-email-acme@kernel.org>
References: <1422294449-12735-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

The fmt_to_data_file() is to retrieve struct data__file from
perf_hpp_fmt which is embedded in diff_hpp_fmt.  It'll be used by sort
callback functions later.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Kan Liang <kan.liang@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1420677949-6719-5-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-diff.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 3f86737da2c4..ae8f62151b34 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -390,6 +390,15 @@ static void perf_evlist__collapse_resort(struct perf_evlist *evlist)
 	}
 }
 
+static struct data__file *fmt_to_data_file(struct perf_hpp_fmt *fmt)
+{
+	struct diff_hpp_fmt *dfmt = container_of(fmt, struct diff_hpp_fmt, fmt);
+	void *ptr = dfmt - dfmt->idx;
+	struct data__file *d = container_of(ptr, struct data__file, fmt);
+
+	return d;
+}
+
 static struct hist_entry*
 get_pair_data(struct hist_entry *he, struct data__file *d)
 {
@@ -407,8 +416,7 @@ get_pair_data(struct hist_entry *he, struct data__file *d)
 static struct hist_entry*
 get_pair_fmt(struct hist_entry *he, struct diff_hpp_fmt *dfmt)
 {
-	void *ptr = dfmt - dfmt->idx;
-	struct data__file *d = container_of(ptr, struct data__file, fmt);
+	struct data__file *d = fmt_to_data_file(&dfmt->fmt);
 
 	return get_pair_data(he, d);
 }
-- 
1.9.3

