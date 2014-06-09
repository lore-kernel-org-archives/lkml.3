Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932223AbaFIUEY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 16:04:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4398 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754562AbaFIUDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 16:03:05 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Don Zickus <dzickus@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 13/15] perf tools: Add support to dynamically get cacheline size
Date: Mon,  9 Jun 2014 22:02:28 +0200
Message-Id: <1402344150-14860-14-git-send-email-jolsa@kernel.org>
In-Reply-To: <1402344150-14860-1-git-send-email-jolsa@kernel.org>
References: <1402344150-14860-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Don Zickus <dzickus@redhat.com>

Different arches may have different cacheline sizes.  Look it up and set
a global variable for reference.

Signed-off-by: Don Zickus <dzickus@redhat.com>
Link: http://lkml.kernel.org/r/1401480605-97442-1-git-send-email-dzickus@redhat.com
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/perf.c      | 1 +
 tools/perf/util/util.c | 1 +
 tools/perf/util/util.h | 1 +
 3 files changed, 3 insertions(+)

diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 78f7b92..95c58fc 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -458,6 +458,7 @@ int main(int argc, const char **argv)
 
 	/* The page_size is placed in util object. */
 	page_size = sysconf(_SC_PAGE_SIZE);
+	cacheline_size = sysconf(_SC_LEVEL1_DCACHE_LINESIZE);
 
 	cmd = perf_extract_argv0_path(argv[0]);
 	if (!cmd)
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 7fff6be..95aefa7 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -17,6 +17,7 @@
  * XXX We need to find a better place for these things...
  */
 unsigned int page_size;
+int cacheline_size;
 
 bool test_attr__enabled;
 
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index b03da44..6686436 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -304,6 +304,7 @@ char *rtrim(char *s);
 void dump_stack(void);
 
 extern unsigned int page_size;
+extern int cacheline_size;
 
 void get_term_dimensions(struct winsize *ws);
 
-- 
1.8.3.1

