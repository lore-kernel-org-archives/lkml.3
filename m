Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055Ab3LJUbm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 15:31:42 -0500
Received: from merlin.infradead.org ([205.233.59.134]:34322 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009Ab3LJUbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 15:31:39 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 31/34] perf symbols: Rename filename argument
Date: Tue, 10 Dec 2013 17:31:13 -0300
Message-Id: <1386707476-12370-12-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386707476-12370-1-git-send-email-acme@infradead.org>
References: <1386707476-12370-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

The 'file' is more commonly associated with a file descriptor of
some sort, rename it to 'filename' as this is the more common idiom
for a file name argument.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-0ehaawv5xc83w6ag03c5hi10@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/dso.c | 32 ++++++++++++++++----------------
 tools/perf/util/dso.h |  2 +-
 2 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index fbc66fde6b30..582b5d344aa3 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -29,7 +29,7 @@ char dso__symtab_origin(const struct dso *dso)
 }
 
 int dso__binary_type_file(const struct dso *dso, enum dso_binary_type type,
-			  char *root_dir, char *file, size_t size)
+			  char *root_dir, char *filename, size_t size)
 {
 	char build_id_hex[BUILD_ID_SIZE * 2 + 1];
 	int ret = 0;
@@ -38,30 +38,30 @@ int dso__binary_type_file(const struct dso *dso, enum dso_binary_type type,
 	case DSO_BINARY_TYPE__DEBUGLINK: {
 		char *debuglink;
 
-		strncpy(file, dso->long_name, size);
-		debuglink = file + dso->long_name_len;
-		while (debuglink != file && *debuglink != '/')
+		strncpy(filename, dso->long_name, size);
+		debuglink = filename + dso->long_name_len;
+		while (debuglink != filename && *debuglink != '/')
 			debuglink--;
 		if (*debuglink == '/')
 			debuglink++;
 		filename__read_debuglink(dso->long_name, debuglink,
-					 size - (debuglink - file));
+					 size - (debuglink - filename));
 		}
 		break;
 	case DSO_BINARY_TYPE__BUILD_ID_CACHE:
 		/* skip the locally configured cache if a symfs is given */
 		if (symbol_conf.symfs[0] ||
-		    (dso__build_id_filename(dso, file, size) == NULL))
+		    (dso__build_id_filename(dso, filename, size) == NULL))
 			ret = -1;
 		break;
 
 	case DSO_BINARY_TYPE__FEDORA_DEBUGINFO:
-		snprintf(file, size, "%s/usr/lib/debug%s.debug",
+		snprintf(filename, size, "%s/usr/lib/debug%s.debug",
 			 symbol_conf.symfs, dso->long_name);
 		break;
 
 	case DSO_BINARY_TYPE__UBUNTU_DEBUGINFO:
-		snprintf(file, size, "%s/usr/lib/debug%s",
+		snprintf(filename, size, "%s/usr/lib/debug%s",
 			 symbol_conf.symfs, dso->long_name);
 		break;
 
@@ -75,14 +75,14 @@ int dso__binary_type_file(const struct dso *dso, enum dso_binary_type type,
 		while (last_slash != dso->long_name && *last_slash != '/')
 			last_slash--;
 
-		len = scnprintf(file, size, "%s", symbol_conf.symfs);
+		len = scnprintf(filename, size, "%s", symbol_conf.symfs);
 		dir_size = last_slash - dso->long_name + 2;
 		if (dir_size > (size - len)) {
 			ret = -1;
 			break;
 		}
-		len += scnprintf(file + len, dir_size, "%s",  dso->long_name);
-		len += scnprintf(file + len , size - len, ".debug%s",
+		len += scnprintf(filename + len, dir_size, "%s",  dso->long_name);
+		len += scnprintf(filename + len , size - len, ".debug%s",
 								last_slash);
 		break;
 	}
@@ -96,7 +96,7 @@ int dso__binary_type_file(const struct dso *dso, enum dso_binary_type type,
 		build_id__sprintf(dso->build_id,
 				  sizeof(dso->build_id),
 				  build_id_hex);
-		snprintf(file, size,
+		snprintf(filename, size,
 			 "%s/usr/lib/debug/.build-id/%.2s/%s.debug",
 			 symbol_conf.symfs, build_id_hex, build_id_hex + 2);
 		break;
@@ -104,23 +104,23 @@ int dso__binary_type_file(const struct dso *dso, enum dso_binary_type type,
 	case DSO_BINARY_TYPE__VMLINUX:
 	case DSO_BINARY_TYPE__GUEST_VMLINUX:
 	case DSO_BINARY_TYPE__SYSTEM_PATH_DSO:
-		snprintf(file, size, "%s%s",
+		snprintf(filename, size, "%s%s",
 			 symbol_conf.symfs, dso->long_name);
 		break;
 
 	case DSO_BINARY_TYPE__GUEST_KMODULE:
-		snprintf(file, size, "%s%s%s", symbol_conf.symfs,
+		snprintf(filename, size, "%s%s%s", symbol_conf.symfs,
 			 root_dir, dso->long_name);
 		break;
 
 	case DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE:
-		snprintf(file, size, "%s%s", symbol_conf.symfs,
+		snprintf(filename, size, "%s%s", symbol_conf.symfs,
 			 dso->long_name);
 		break;
 
 	case DSO_BINARY_TYPE__KCORE:
 	case DSO_BINARY_TYPE__GUEST_KCORE:
-		snprintf(file, size, "%s", dso->long_name);
+		snprintf(filename, size, "%s", dso->long_name);
 		break;
 
 	default:
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index 99f3c647d683..e1cc50698137 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -129,7 +129,7 @@ int dso__kernel_module_get_build_id(struct dso *dso, const char *root_dir);
 
 char dso__symtab_origin(const struct dso *dso);
 int dso__binary_type_file(const struct dso *dso, enum dso_binary_type type,
-			  char *root_dir, char *file, size_t size);
+			  char *root_dir, char *filename, size_t size);
 
 int dso__data_fd(struct dso *dso, struct machine *machine);
 ssize_t dso__data_read_offset(struct dso *dso, struct machine *machine,
-- 
1.8.1.4

