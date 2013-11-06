Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab3KFFop (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 00:44:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44314 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027Ab3KFFom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 00:44:42 -0500
Date: Tue, 5 Nov 2013 21:44:02 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-r24wa4bvtccg7mnkessrbbdj@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, jolsa@redhat.com, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf fs: Rename NAME_find_mountpoint()
  to NAME__mountpoint()
Git-Commit-ID: cf38fadade52df937521dd70d4437df1a9354cd9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 05 Nov 2013 21:44:08 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cf38fadade52df937521dd70d4437df1a9354cd9
Gitweb:     http://git.kernel.org/tip/cf38fadade52df937521dd70d4437df1a9354cd9
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 5 Nov 2013 14:48:50 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 5 Nov 2013 15:15:00 -0300

perf fs: Rename NAME_find_mountpoint() to NAME__mountpoint()

Shorten it, "finding" it is an implementation detail, what callers want
is the pathname, not to ask for it to _always_ do the lookup.

And the existing implementation already caches it, i.e. it doesn't
"finds" it on every call.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-r24wa4bvtccg7mnkessrbbdj@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/parse-events.c |  4 ++--
 tools/perf/util/cpumap.c        |  4 ++--
 tools/perf/util/fs.c            | 12 ++++++------
 tools/perf/util/fs.h            |  2 +-
 tools/perf/util/pmu.c           | 15 +++++----------
 5 files changed, 16 insertions(+), 21 deletions(-)

diff --git a/tools/perf/tests/parse-events.c b/tools/perf/tests/parse-events.c
index f47bf45..ef671cd 100644
--- a/tools/perf/tests/parse-events.c
+++ b/tools/perf/tests/parse-events.c
@@ -1456,7 +1456,7 @@ static int test_pmu(void)
 	int ret;
 
 	snprintf(path, PATH_MAX, "%s/bus/event_source/devices/cpu/format/",
-		 sysfs_find_mountpoint());
+		 sysfs__mountpoint());
 
 	ret = stat(path, &st);
 	if (ret)
@@ -1473,7 +1473,7 @@ static int test_pmu_events(void)
 	int ret;
 
 	snprintf(path, PATH_MAX, "%s/bus/event_source/devices/cpu/events/",
-		 sysfs_find_mountpoint());
+		 sysfs__mountpoint());
 
 	ret = stat(path, &st);
 	if (ret) {
diff --git a/tools/perf/util/cpumap.c b/tools/perf/util/cpumap.c
index 4af5a23..a9b48c4 100644
--- a/tools/perf/util/cpumap.c
+++ b/tools/perf/util/cpumap.c
@@ -216,7 +216,7 @@ int cpu_map__get_socket(struct cpu_map *map, int idx)
 
 	cpu = map->map[idx];
 
-	mnt = sysfs_find_mountpoint();
+	mnt = sysfs__mountpoint();
 	if (!mnt)
 		return -1;
 
@@ -279,7 +279,7 @@ int cpu_map__get_core(struct cpu_map *map, int idx)
 
 	cpu = map->map[idx];
 
-	mnt = sysfs_find_mountpoint();
+	mnt = sysfs__mountpoint();
 	if (!mnt)
 		return -1;
 
diff --git a/tools/perf/util/fs.c b/tools/perf/util/fs.c
index a2413e8..77bac4e 100644
--- a/tools/perf/util/fs.c
+++ b/tools/perf/util/fs.c
@@ -88,7 +88,7 @@ static const char *fs__get_mountpoint(struct fs *fs)
 	return fs__read_mounts(fs) ? fs->path : NULL;
 }
 
-static const char *fs__find_mountpoint(int idx)
+static const char *fs__mountpoint(int idx)
 {
 	struct fs *fs = &fs__entries[idx];
 
@@ -98,10 +98,10 @@ static const char *fs__find_mountpoint(int idx)
 	return fs__get_mountpoint(fs);
 }
 
-#define FIND_MOUNTPOINT(name, idx)		\
-const char *name##_find_mountpoint(void)	\
-{						\
-	return fs__find_mountpoint(idx);	\
+#define FS__MOUNTPOINT(name, idx)	\
+const char *name##__mountpoint(void)	\
+{					\
+	return fs__mountpoint(idx);	\
 }
 
-FIND_MOUNTPOINT(sysfs, FS__SYSFS);
+FS__MOUNTPOINT(sysfs, FS__SYSFS);
diff --git a/tools/perf/util/fs.h b/tools/perf/util/fs.h
index 082edbd..a7561c8 100644
--- a/tools/perf/util/fs.h
+++ b/tools/perf/util/fs.h
@@ -1,6 +1,6 @@
 #ifndef __PERF_FS
 #define __PERF_FS
 
-const char *sysfs_find_mountpoint(void);
+const char *sysfs__mountpoint(void);
 
 #endif /* __PERF_FS */
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 45b42df..c232d8d 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -77,9 +77,8 @@ static int pmu_format(const char *name, struct list_head *format)
 {
 	struct stat st;
 	char path[PATH_MAX];
-	const char *sysfs;
+	const char *sysfs = sysfs__mountpoint();
 
-	sysfs = sysfs_find_mountpoint();
 	if (!sysfs)
 		return -1;
 
@@ -166,9 +165,8 @@ static int pmu_aliases(const char *name, struct list_head *head)
 {
 	struct stat st;
 	char path[PATH_MAX];
-	const char *sysfs;
+	const char *sysfs = sysfs__mountpoint();
 
-	sysfs = sysfs_find_mountpoint();
 	if (!sysfs)
 		return -1;
 
@@ -212,11 +210,10 @@ static int pmu_type(const char *name, __u32 *type)
 {
 	struct stat st;
 	char path[PATH_MAX];
-	const char *sysfs;
 	FILE *file;
 	int ret = 0;
+	const char *sysfs = sysfs__mountpoint();
 
-	sysfs = sysfs_find_mountpoint();
 	if (!sysfs)
 		return -1;
 
@@ -241,11 +238,10 @@ static int pmu_type(const char *name, __u32 *type)
 static void pmu_read_sysfs(void)
 {
 	char path[PATH_MAX];
-	const char *sysfs;
 	DIR *dir;
 	struct dirent *dent;
+	const char *sysfs = sysfs__mountpoint();
 
-	sysfs = sysfs_find_mountpoint();
 	if (!sysfs)
 		return;
 
@@ -270,11 +266,10 @@ static struct cpu_map *pmu_cpumask(const char *name)
 {
 	struct stat st;
 	char path[PATH_MAX];
-	const char *sysfs;
 	FILE *file;
 	struct cpu_map *cpus;
+	const char *sysfs = sysfs__mountpoint();
 
-	sysfs = sysfs_find_mountpoint();
 	if (!sysfs)
 		return NULL;
 
