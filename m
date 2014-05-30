Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934735AbaE3ULJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 16:11:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29374 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752209AbaE3ULG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 16:11:06 -0400
From: Don Zickus <dzickus@redhat.com>
To: jolsa@redhat.com
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, namhyung@gmail.com,
        eranian@google.com, Andi Kleen <andi@firstfloor.org>,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 6/7 V3] perf: Add support to dynamically get cacheline size
Date: Fri, 30 May 2014 16:10:05 -0400
Message-Id: <1401480605-97442-1-git-send-email-dzickus@redhat.com>
In-Reply-To: <1401208087-181977-7-git-send-email-dzickus@redhat.com>
References: <1401208087-181977-7-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Different arches may have different cacheline sizes.  Look it up and set
a global variable for reference.

Signed-off-by: Don Zickus <dzickus@redhat.com>

---
V4: make it super simple using a sysconf (Arnaldo)
V3: remove unneeded cpumap.h (Namhyung Kim)
V2: change to be global and setup in perf.c
    use filename__read_int for setup

revert cacheline size stuff
---
 tools/perf/perf.c      | 1 +
 tools/perf/util/util.c | 1 +
 tools/perf/util/util.h | 1 +
 3 files changed, 3 insertions(+)

diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 431798a..d0374d4 100644
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
1.7.11.7

