Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470AbbABVAq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 16:00:46 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:49416 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbbABVAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 16:00:45 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Waiman Long <Waiman.Long@hp.com>,
        Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] tools: perf: util: dso:  Remove some unused functions
Date: Fri,  2 Jan 2015 22:03:45 +0100
Message-Id: <1420232625-3628-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
dso__data_size() dso__data_status_seen()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 tools/perf/util/dso.c |   34 ----------------------------------
 tools/perf/util/dso.h |    3 ---
 2 files changed, 37 deletions(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 0247acf..8f0b6a3 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -359,18 +359,6 @@ out:
 	return dso->data.fd;
 }
 
-bool dso__data_status_seen(struct dso *dso, enum dso_data_status_seen by)
-{
-	u32 flag = 1 << by;
-
-	if (dso->data.status_seen & flag)
-		return true;
-
-	dso->data.status_seen |= flag;
-
-	return false;
-}
-
 static void
 dso_cache__free(struct rb_root *root)
 {
@@ -546,28 +534,6 @@ static int data_file_size(struct dso *dso)
 	return 0;
 }
 
-/**
- * dso__data_size - Return dso data size
- * @dso: dso object
- * @machine: machine object
- *
- * Return: dso data size
- */
-off_t dso__data_size(struct dso *dso, struct machine *machine)
-{
-	int fd;
-
-	fd = dso__data_fd(dso, machine);
-	if (fd < 0)
-		return fd;
-
-	if (data_file_size(dso))
-		return -1;
-
-	/* For now just estimate dso data size is close to file size */
-	return dso->data.file_size;
-}
-
 static ssize_t data_read_offset(struct dso *dso, u64 offset,
 				u8 *data, ssize_t size)
 {
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index acb651a..bd99f25 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -184,7 +184,6 @@ int dso__read_binary_type_filename(const struct dso *dso, enum dso_binary_type t
  * The dso__data_* external interface provides following functions:
  *   dso__data_fd
  *   dso__data_close
- *   dso__data_size
  *   dso__data_read_offset
  *   dso__data_read_addr
  *
@@ -222,13 +221,11 @@ int dso__read_binary_type_filename(const struct dso *dso, enum dso_binary_type t
 int dso__data_fd(struct dso *dso, struct machine *machine);
 void dso__data_close(struct dso *dso);
 
-off_t dso__data_size(struct dso *dso, struct machine *machine);
 ssize_t dso__data_read_offset(struct dso *dso, struct machine *machine,
 			      u64 offset, u8 *data, ssize_t size);
 ssize_t dso__data_read_addr(struct dso *dso, struct map *map,
 			    struct machine *machine, u64 addr,
 			    u8 *data, ssize_t size);
-bool dso__data_status_seen(struct dso *dso, enum dso_data_status_seen by);
 
 struct map *dso__new_map(const char *name);
 struct dso *dso__kernel_findnew(struct machine *machine, const char *name,
-- 
1.7.10.4

