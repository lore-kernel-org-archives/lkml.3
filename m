Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757956Ab3K1KbD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 05:31:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55760 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757601Ab3K1Ka5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 05:30:57 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/7] perf tools: Use correct return type for readn function
Date: Thu, 28 Nov 2013 11:30:14 +0100
Message-Id: <1385634619-8129-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1385634619-8129-1-git-send-email-jolsa@redhat.com>
References: <1385634619-8129-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changing readn function return type to ssize_t because
read returns ssize_t not int.

Changing callers holding variable types as well.

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
 tools/perf/util/header.c  | 18 +++++++++---------
 tools/perf/util/session.c |  2 +-
 tools/perf/util/util.c    |  4 ++--
 tools/perf/util/util.h    |  2 +-
 4 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 1cd0357..3e755f2 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1709,7 +1709,7 @@ static int process_nrcpus(struct perf_file_section *section __maybe_unused,
 			  struct perf_header *ph, int fd,
 			  void *data __maybe_unused)
 {
-	size_t ret;
+	ssize_t ret;
 	u32 nr;
 
 	ret = readn(fd, &nr, sizeof(nr));
@@ -1753,7 +1753,7 @@ static int process_total_mem(struct perf_file_section *section __maybe_unused,
 			     void *data __maybe_unused)
 {
 	uint64_t mem;
-	size_t ret;
+	ssize_t ret;
 
 	ret = readn(fd, &mem, sizeof(mem));
 	if (ret != sizeof(mem))
@@ -1822,7 +1822,7 @@ static int process_cmdline(struct perf_file_section *section __maybe_unused,
 			   struct perf_header *ph, int fd,
 			   void *data __maybe_unused)
 {
-	size_t ret;
+	ssize_t ret;
 	char *str;
 	u32 nr, i;
 	struct strbuf sb;
@@ -1858,7 +1858,7 @@ static int process_cpu_topology(struct perf_file_section *section __maybe_unused
 				struct perf_header *ph, int fd,
 				void *data __maybe_unused)
 {
-	size_t ret;
+	ssize_t ret;
 	u32 nr, i;
 	char *str;
 	struct strbuf sb;
@@ -1914,7 +1914,7 @@ static int process_numa_topology(struct perf_file_section *section __maybe_unuse
 				 struct perf_header *ph, int fd,
 				 void *data __maybe_unused)
 {
-	size_t ret;
+	ssize_t ret;
 	u32 nr, node, i;
 	char *str;
 	uint64_t mem_total, mem_free;
@@ -1974,7 +1974,7 @@ static int process_pmu_mappings(struct perf_file_section *section __maybe_unused
 				struct perf_header *ph, int fd,
 				void *data __maybe_unused)
 {
-	size_t ret;
+	ssize_t ret;
 	char *name;
 	u32 pmu_num;
 	u32 type;
@@ -2534,7 +2534,7 @@ static int check_magic_endian(u64 magic, uint64_t hdr_sz,
 int perf_file_header__read(struct perf_file_header *header,
 			   struct perf_header *ph, int fd)
 {
-	int ret;
+	ssize_t ret;
 
 	lseek(fd, 0, SEEK_SET);
 
@@ -2628,7 +2628,7 @@ static int perf_file_header__read_pipe(struct perf_pipe_file_header *header,
 				       struct perf_header *ph, int fd,
 				       bool repipe)
 {
-	int ret;
+	ssize_t ret;
 
 	ret = readn(fd, header, sizeof(*header));
 	if (ret <= 0)
@@ -2669,7 +2669,7 @@ static int read_attr(int fd, struct perf_header *ph,
 	struct perf_event_attr *attr = &f_attr->attr;
 	size_t sz, left;
 	size_t our_sz = sizeof(f_attr->attr);
-	int ret;
+	ssize_t ret;
 
 	memset(f_attr, 0, sizeof(*f_attr));
 
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index b0b15e2..4ce146b 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1158,7 +1158,7 @@ static int __perf_session__process_pipe_events(struct perf_session *session,
 	void *buf = NULL;
 	int skip = 0;
 	u64 head;
-	int err;
+	ssize_t err;
 	void *p;
 
 	perf_tool__fill_defaults(tool);
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 28a0a89..9440481 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -151,12 +151,12 @@ unsigned long convert_unit(unsigned long value, char *unit)
 	return value;
 }
 
-int readn(int fd, void *buf, size_t n)
+ssize_t readn(int fd, void *buf, size_t n)
 {
 	void *buf_start = buf;
 
 	while (n) {
-		int ret = read(fd, buf, n);
+		ssize_t ret = read(fd, buf, n);
 
 		if (ret <= 0)
 			return ret;
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index c8f362d..9f6b928 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -253,7 +253,7 @@ bool strlazymatch(const char *str, const char *pat);
 int strtailcmp(const char *s1, const char *s2);
 char *strxfrchar(char *s, char from, char to);
 unsigned long convert_unit(unsigned long value, char *unit);
-int readn(int fd, void *buf, size_t size);
+ssize_t readn(int fd, void *buf, size_t n);
 
 struct perf_event_attr;
 
-- 
1.8.3.1

