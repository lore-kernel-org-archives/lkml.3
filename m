Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932168AbbAHAsG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 19:48:06 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:42587 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932107AbbAHAsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 19:48:02 -0500
X-Original-SENDERIP: 10.177.220.203
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Kan Liang <kan.liang@intel.com>
Subject: [PATCH 4/7] perf diff: Introduce fmt_to_data_file() helper
Date: Thu,  8 Jan 2015 09:45:45 +0900
Message-Id: <1420677949-6719-5-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1420677949-6719-1-git-send-email-namhyung@kernel.org>
References: <1420677949-6719-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fmt_to_data_file() is to retrieve struct data__file from
perf_hpp_fmt which is embedded in diff_hpp_fmt.  It'll be used by sort
callback functions later.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
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
2.1.3

