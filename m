Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758619Ab3LBUvu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:51:50 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54081 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758552Ab3LBUtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 15:49:22 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 05/12] perf tools: Add perf_data_file__write interface
Date: Mon,  2 Dec 2013 17:49:02 -0300
Message-Id: <1386017349-24486-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386017349-24486-1-git-send-email-acme@infradead.org>
References: <1386017349-24486-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Adding perf_data_file__write interface to centralize output to files.
The function prototype is:

  ssize_t perf_data_file__write(struct perf_data_file *file,
                                void *buf, size_t size);

Returns number of bytes written or -1 in case of error.

NOTE: Also indenting 'struct perf_data_file' members, no functional
      change done.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1385634619-8129-6-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/data.c |  6 ++++++
 tools/perf/util/data.h | 14 ++++++++------
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/data.c b/tools/perf/util/data.c
index 7d09faf85cf1..1fbcd8bdc11b 100644
--- a/tools/perf/util/data.c
+++ b/tools/perf/util/data.c
@@ -118,3 +118,9 @@ void perf_data_file__close(struct perf_data_file *file)
 {
 	close(file->fd);
 }
+
+ssize_t perf_data_file__write(struct perf_data_file *file,
+			      void *buf, size_t size)
+{
+	return writen(file->fd, buf, size);
+}
diff --git a/tools/perf/util/data.h b/tools/perf/util/data.h
index 8c2df80152a5..2b15d0c95c7f 100644
--- a/tools/perf/util/data.h
+++ b/tools/perf/util/data.h
@@ -9,12 +9,12 @@ enum perf_data_mode {
 };
 
 struct perf_data_file {
-	const char *path;
-	int fd;
-	bool is_pipe;
-	bool force;
-	unsigned long size;
-	enum perf_data_mode mode;
+	const char		*path;
+	int			 fd;
+	bool			 is_pipe;
+	bool			 force;
+	unsigned long		 size;
+	enum perf_data_mode	 mode;
 };
 
 static inline bool perf_data_file__is_read(struct perf_data_file *file)
@@ -44,5 +44,7 @@ static inline unsigned long perf_data_file__size(struct perf_data_file *file)
 
 int perf_data_file__open(struct perf_data_file *file);
 void perf_data_file__close(struct perf_data_file *file);
+ssize_t perf_data_file__write(struct perf_data_file *file,
+			      void *buf, size_t size);
 
 #endif /* __PERF_DATA_H */
-- 
1.8.1.4

