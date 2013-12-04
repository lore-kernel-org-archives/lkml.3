Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932816Ab3LDPlH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 10:41:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58266 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932404Ab3LDPlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 10:41:04 -0500
Date: Wed, 4 Dec 2013 07:40:13 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-727ebd544f85285a223ecc6a2a57ef90202cdc7b@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, efault@gmx.de,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, efault@gmx.de, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1385634619-8129-3-git-send-email-jolsa@redhat.com>
References: <1385634619-8129-3-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Use correct return type for readn function
Git-Commit-ID: 727ebd544f85285a223ecc6a2a57ef90202cdc7b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 04 Dec 2013 07:40:19 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  727ebd544f85285a223ecc6a2a57ef90202cdc7b
Gitweb:     http://git.kernel.org/tip/727ebd544f85285a223ecc6a2a57ef90202cdc7b
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Thu, 28 Nov 2013 11:30:14 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 2 Dec 2013 09:22:45 -0300

perf tools: Use correct return type for readn function

Changing readn function return type to ssize_t because read returns
ssize_t not int.

Changing callers holding variable types as well.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1385634619-8129-3-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
 
