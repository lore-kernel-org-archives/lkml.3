Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbaFMG0y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 02:26:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44197 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbaFMG0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 02:26:52 -0400
Date: Thu, 12 Jun 2014 23:26:34 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-c1f9aa0a61bde512a68060883d1c3c1955a546ea@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@kernel.org, jolsa@kernel.org, a.p.zijlstra@chello.nl,
        jean.pihet@linaro.org, acme@kernel.org, namhyung@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, jolsa@kernel.org, a.p.zijlstra@chello.nl,
        jean.pihet@linaro.org, acme@kernel.org, namhyung@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
In-Reply-To: <1401892622-30848-10-git-send-email-jolsa@kernel.org>
References: <1401892622-30848-10-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Add dso__data_* interface descriptons
Git-Commit-ID: c1f9aa0a61bde512a68060883d1c3c1955a546ea
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

Commit-ID:  c1f9aa0a61bde512a68060883d1c3c1955a546ea
Gitweb:     http://git.kernel.org/tip/c1f9aa0a61bde512a68060883d1c3c1955a546ea
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Wed, 7 May 2014 21:09:59 +0200
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Thu, 12 Jun 2014 16:53:22 +0200

perf tools: Add dso__data_* interface descriptons

Adding descriptions/explanations for dso__data_* interface
functions.

Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1401892622-30848-10-git-send-email-jolsa@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/dso.c | 59 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/dso.h | 38 +++++++++++++++++++++++++++++++++
 2 files changed, 97 insertions(+)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index c30752c..819f104 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -205,6 +205,13 @@ static int __open_dso(struct dso *dso, struct machine *machine)
 
 static void check_data_close(void);
 
+/**
+ * dso_close - Open DSO data file
+ * @dso: dso object
+ *
+ * Open @dso's data file descriptor and updates
+ * list/count of open DSO objects.
+ */
 static int open_dso(struct dso *dso, struct machine *machine)
 {
 	int fd = __open_dso(dso, machine);
@@ -231,6 +238,13 @@ static void close_data_fd(struct dso *dso)
 	}
 }
 
+/**
+ * dso_close - Close DSO data file
+ * @dso: dso object
+ *
+ * Close @dso's data file descriptor and updates
+ * list/count of open DSO objects.
+ */
 static void close_dso(struct dso *dso)
 {
 	close_data_fd(dso);
@@ -276,6 +290,11 @@ static bool may_cache_fd(void)
 	return limit > (rlim_t) dso__data_open_cnt;
 }
 
+/*
+ * Check and close LRU dso if we crossed allowed limit
+ * for opened dso file descriptors. The limit is half
+ * of the RLIMIT_NOFILE files opened.
+*/
 static void check_data_close(void)
 {
 	bool cache_fd = may_cache_fd();
@@ -284,11 +303,25 @@ static void check_data_close(void)
 		close_first_dso();
 }
 
+/**
+ * dso__data_close - Close DSO data file
+ * @dso: dso object
+ *
+ * External interface to close @dso's data file descriptor.
+ */
 void dso__data_close(struct dso *dso)
 {
 	close_dso(dso);
 }
 
+/**
+ * dso__data_fd - Get dso's data file descriptor
+ * @dso: dso object
+ * @machine: machine object
+ *
+ * External interface to find dso's file, open it and
+ * returns file descriptor.
+ */
 int dso__data_fd(struct dso *dso, struct machine *machine)
 {
 	enum dso_binary_type binary_type_data[] = {
@@ -445,6 +478,11 @@ static ssize_t dso_cache_read(struct dso *dso, u64 offset,
 		return dso_cache__read(dso, offset, data, size);
 }
 
+/*
+ * Reads and caches dso data DSO__DATA_CACHE_SIZE size chunks
+ * in the rb_tree. Any read to already cached data is served
+ * by cached data.
+ */
 static ssize_t cached_read(struct dso *dso, u64 offset, u8 *data, ssize_t size)
 {
 	ssize_t r = 0;
@@ -504,6 +542,17 @@ static ssize_t data_read_offset(struct dso *dso, u64 offset,
 	return cached_read(dso, offset, data, size);
 }
 
+/**
+ * dso__data_read_offset - Read data from dso file offset
+ * @dso: dso object
+ * @machine: machine object
+ * @offset: file offset
+ * @data: buffer to store data
+ * @size: size of the @data buffer
+ *
+ * External interface to read data from dso file offset. Open
+ * dso data file and use cached_read to get the data.
+ */
 ssize_t dso__data_read_offset(struct dso *dso, struct machine *machine,
 			      u64 offset, u8 *data, ssize_t size)
 {
@@ -513,6 +562,16 @@ ssize_t dso__data_read_offset(struct dso *dso, struct machine *machine,
 	return data_read_offset(dso, offset, data, size);
 }
 
+/**
+ * dso__data_read_addr - Read data from dso address
+ * @dso: dso object
+ * @machine: machine object
+ * @add: virtual memory address
+ * @data: buffer to store data
+ * @size: size of the @data buffer
+ *
+ * External interface to read data from dso address.
+ */
 ssize_t dso__data_read_addr(struct dso *dso, struct map *map,
 			    struct machine *machine, u64 addr,
 			    u8 *data, ssize_t size)
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index da47b13..ad553ba 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -149,6 +149,44 @@ char dso__symtab_origin(const struct dso *dso);
 int dso__read_binary_type_filename(const struct dso *dso, enum dso_binary_type type,
 				   char *root_dir, char *filename, size_t size);
 
+/*
+ * The dso__data_* external interface provides following functions:
+ *   dso__data_fd
+ *   dso__data_close
+ *   dso__data_read_offset
+ *   dso__data_read_addr
+ *
+ * Please refer to the dso.c object code for each function and
+ * arguments documentation. Following text tries to explain the
+ * dso file descriptor caching.
+ *
+ * The dso__data* interface allows caching of opened file descriptors
+ * to speed up the dso data accesses. The idea is to leave the file
+ * descriptor opened ideally for the whole life of the dso object.
+ *
+ * The current usage of the dso__data_* interface is as follows:
+ *
+ * Get DSO's fd:
+ *   int fd = dso__data_fd(dso, machine);
+ *   USE 'fd' SOMEHOW
+ *
+ * Read DSO's data:
+ *   n = dso__data_read_offset(dso_0, &machine, 0, buf, BUFSIZE);
+ *   n = dso__data_read_addr(dso_0, &machine, 0, buf, BUFSIZE);
+ *
+ * Eventually close DSO's fd:
+ *   dso__data_close(dso);
+ *
+ * It is not necessary to close the DSO object data file. Each time new
+ * DSO data file is opened, the limit (RLIMIT_NOFILE/2) is checked. Once
+ * it is crossed, the oldest opened DSO object is closed.
+ *
+ * The dso__delete function calls close_dso function to ensure the
+ * data file descriptor gets closed/unmapped before the dso object
+ * is freed.
+ *
+ * TODO
+*/
 int dso__data_fd(struct dso *dso, struct machine *machine);
 void dso__data_close(struct dso *dso);
 
