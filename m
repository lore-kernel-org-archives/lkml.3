Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890AbaHOTKl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 15:10:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:59367 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827AbaHOTKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 15:10:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,872,1400050800"; 
   d="scan'208";a="588727747"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 03/24] perf tools: Rename machine__get_kernel_start_addr()
Date: Fri, 15 Aug 2014 22:08:38 +0300
Message-Id: <1408129739-17368-4-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1408129739-17368-1-git-send-email-adrian.hunter@intel.com>
References: <1408129739-17368-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename machine__get_kernel_start_addr() to
machine__get_running_kernel_start() so that
a new function, with a similar name to the
original name, can be added that gets the
kernel start address from the kernel map.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/machine.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index b093b93..37f8dc5 100644
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
1.8.3.2

