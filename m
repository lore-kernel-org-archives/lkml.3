Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965220AbaFCSgh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 14:36:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44997 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933373AbaFCSge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 14:36:34 -0400
Date: Tue, 3 Jun 2014 11:36:21 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-d69b2962a0aebd431cdda939f4418dd606e2f77e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, namhyung@kernel.org, fweisbec@gmail.com,
        tglx@linutronix.de, asharma@fb.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, namhyung@kernel.org, fweisbec@gmail.com,
        tglx@linutronix.de, asharma@fb.com
In-Reply-To: <1401335910-16832-26-git-send-email-namhyung@kernel.org>
References: <1401335910-16832-26-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Reset output/sort order to default
Git-Commit-ID: d69b2962a0aebd431cdda939f4418dd606e2f77e
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

Commit-ID:  d69b2962a0aebd431cdda939f4418dd606e2f77e
Gitweb:     http://git.kernel.org/tip/d69b2962a0aebd431cdda939f4418dd606e2f77e
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Fri, 23 May 2014 10:59:01 +0900
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Sun, 1 Jun 2014 14:35:10 +0200

perf tools: Reset output/sort order to default

When reset_output_field() is called, also reset field/sort order to
NULL so that it can have the default values.  It's needed for testing.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
CC: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/r/1401335910-16832-26-git-send-email-namhyung@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/sort.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 9da8931..254f583 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -1582,6 +1582,9 @@ void reset_output_field(void)
 	sort__has_sym = 0;
 	sort__has_dso = 0;
 
+	field_order = NULL;
+	sort_order = NULL;
+
 	reset_dimensions();
 	perf_hpp__reset_output_field();
 }
