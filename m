Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932878Ab3LDPla (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 10:41:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58290 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932773Ab3LDPl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 10:41:26 -0500
Date: Wed, 4 Dec 2013 07:40:41 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-6f9a317f2a2d4950880ecfa7eea53ed79f85255f@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, efault@gmx.de,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, efault@gmx.de, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1385634619-8129-6-git-send-email-jolsa@redhat.com>
References: <1385634619-8129-6-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Add perf_data_file__write interface
Git-Commit-ID: 6f9a317f2a2d4950880ecfa7eea53ed79f85255f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 04 Dec 2013 07:40:48 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6f9a317f2a2d4950880ecfa7eea53ed79f85255f
Gitweb:     http://git.kernel.org/tip/6f9a317f2a2d4950880ecfa7eea53ed79f85255f
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Thu, 28 Nov 2013 11:30:17 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 2 Dec 2013 09:22:46 -0300

perf tools: Add perf_data_file__write interface

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
