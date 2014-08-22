Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932684AbaHVQaU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 12:30:20 -0400
Received: from mail.kernel.org ([198.145.19.201]:33758 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932149AbaHVQaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 12:30:13 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 08/16] perf machine: Rename machine__get_kernel_start_addr() method
Date: Fri, 22 Aug 2014 13:29:20 -0300
Message-Id: <1408724968-3441-9-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408724968-3441-1-git-send-email-acme@kernel.org>
References: <1408724968-3441-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Rename machine__get_kernel_start_addr() to
machine__get_running_kernel_start() so that a new function, with a
similar name to the original name, can be added that gets the kernel
start address from the kernel map.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1408129739-17368-4-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/machine.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index b093b93607fb..37f8dc557ec0 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -593,8 +593,8 @@ const char *ref_reloc_sym_names[] = {"_text", "_stext", NULL};
  * Returns the name of the start symbol in *symbol_name. Pass in NULL as
  * symbol_name if it's not that important.
  */
-static u64 machine__get_kernel_start_addr(struct machine *machine,
-					  const char **symbol_name)
+static u64 machine__get_running_kernel_start(struct machine *machine,
+					     const char **symbol_name)
 {
 	char filename[PATH_MAX];
 	int i;
@@ -621,7 +621,7 @@ static u64 machine__get_kernel_start_addr(struct machine *machine,
 int __machine__create_kernel_maps(struct machine *machine, struct dso *kernel)
 {
 	enum map_type type;
-	u64 start = machine__get_kernel_start_addr(machine, NULL);
+	u64 start = machine__get_running_kernel_start(machine, NULL);
 
 	for (type = 0; type < MAP__NR_TYPES; ++type) {
 		struct kmap *kmap;
@@ -940,7 +940,7 @@ int machine__create_kernel_maps(struct machine *machine)
 {
 	struct dso *kernel = machine__get_kernel(machine);
 	const char *name;
-	u64 addr = machine__get_kernel_start_addr(machine, &name);
+	u64 addr = machine__get_running_kernel_start(machine, &name);
 	if (!addr)
 		return -1;
 
-- 
1.9.3

