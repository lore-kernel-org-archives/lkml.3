Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757971AbaFANdp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 09:33:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21141 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757729AbaFANc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 09:32:28 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Arun Sharma <asharma@fb.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 25/27] perf tools: Reset output/sort order to default
Date: Sun,  1 Jun 2014 15:31:36 +0200
Message-Id: <1401629498-8726-26-git-send-email-jolsa@kernel.org>
In-Reply-To: <1401629498-8726-1-git-send-email-jolsa@kernel.org>
References: <1401629498-8726-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

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
-- 
1.8.3.1

