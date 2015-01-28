Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756478AbbA1VXj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 16:23:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40980 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964938AbbA1UuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:50:00 -0500
Date: Wed, 28 Jan 2015 07:07:29 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-ff21cef67e85ae77682560973b8c80ef64125221@git.kernel.org>
Cc: a.p.zijlstra@chello.nl, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        kan.liang@intel.com, jolsa@redhat.com, hpa@zytor.com,
        namhyung@kernel.org, acme@redhat.com, mingo@kernel.org,
        jolsa@kernel.org
Reply-To: jolsa@kernel.org, acme@redhat.com, mingo@kernel.org,
        namhyung@kernel.org, hpa@zytor.com, jolsa@redhat.com,
        kan.liang@intel.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        a.p.zijlstra@chello.nl
In-Reply-To: <1420677949-6719-5-git-send-email-namhyung@kernel.org>
References: <1420677949-6719-5-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf diff: Introduce fmt_to_data_file() helper
Git-Commit-ID: ff21cef67e85ae77682560973b8c80ef64125221
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

Commit-ID:  ff21cef67e85ae77682560973b8c80ef64125221
Gitweb:     http://git.kernel.org/tip/ff21cef67e85ae77682560973b8c80ef64125221
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Thu, 8 Jan 2015 09:45:45 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 21 Jan 2015 13:24:34 -0300

perf diff: Introduce fmt_to_data_file() helper

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
index 3f86737..ae8f621 100644
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
