Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322AbaHXPAM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 11:00:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34194 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701AbaHXPAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 11:00:08 -0400
Date: Sun, 24 Aug 2014 07:58:30 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-4b99375b38fa137f501cfa60b70e3f0a9da39c93@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
In-Reply-To: <1408129739-17368-4-git-send-email-adrian.hunter@intel.com>
References: <1408129739-17368-4-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf machine:
  Rename machine__get_kernel_start_addr() method
Git-Commit-ID: 4b99375b38fa137f501cfa60b70e3f0a9da39c93
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

Commit-ID:  4b99375b38fa137f501cfa60b70e3f0a9da39c93
Gitweb:     http://git.kernel.org/tip/4b99375b38fa137f501cfa60b70e3f0a9da39c93
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Fri, 15 Aug 2014 22:08:38 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 22 Aug 2014 13:12:11 -0300

perf machine: Rename machine__get_kernel_start_addr() method

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
 
