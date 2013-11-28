Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758238Ab3K1Kbm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 05:31:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59175 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758002Ab3K1KbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 05:31:08 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5/7] perf tools: Add perf_data_file__write interface
Date: Thu, 28 Nov 2013 11:30:17 +0100
Message-Id: <1385634619-8129-6-git-send-email-jolsa@redhat.com>
In-Reply-To: <1385634619-8129-1-git-send-email-jolsa@redhat.com>
References: <1385634619-8129-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding perf_data_file__write interface to centralize
output to files. The function prototype is:

  ssize_t perf_data_file__write(struct perf_data_file *file,
                                void *buf, size_t size);

Returns number of bytes written or -1 in case of error.

NOTE Indenting 'struct perf_data_file' members,
     no functional change done.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/data.c |  6 ++++++
 tools/perf/util/data.h | 14 ++++++++------
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/data.c b/tools/perf/util/data.c
index 7d09faf..1fbcd8b 100644
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
index 8c2df80..2b15d0c 100644
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
1.8.3.1

