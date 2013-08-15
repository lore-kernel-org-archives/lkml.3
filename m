Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760669Ab3HOH6N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 03:58:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54027 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086Ab3HOH6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 03:58:08 -0400
Date: Thu, 15 Aug 2013 00:57:32 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-326f59bf645ea6c99709c67d9712df46019fa7a8@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        efault@gmx.de, peterz@infradead.org, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1375961547-30267-9-git-send-email-adrian.hunter@intel.com>
References: <1375961547-30267-9-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Remove filter parameter of thread__find_addr_map()
Git-Commit-ID: 326f59bf645ea6c99709c67d9712df46019fa7a8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 15 Aug 2013 00:57:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  326f59bf645ea6c99709c67d9712df46019fa7a8
Gitweb:     http://git.kernel.org/tip/326f59bf645ea6c99709c67d9712df46019fa7a8
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Thu, 8 Aug 2013 14:32:27 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 12 Aug 2013 10:31:12 -0300

perf tools: Remove filter parameter of thread__find_addr_map()

Now that the symbol filter is recorded on the machine there is no need
to pass it to thread__find_addr_map().  So remove it.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1375961547-30267-9-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-inject.c     | 2 +-
 tools/perf/builtin-script.c     | 4 ++--
 tools/perf/tests/code-reading.c | 2 +-
 tools/perf/util/build-id.c      | 2 +-
 tools/perf/util/event.c         | 9 ++++-----
 tools/perf/util/thread.h        | 2 +-
 tools/perf/util/unwind.c        | 4 ++--
 7 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index f012a98..1d8de2e 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -206,7 +206,7 @@ static int perf_event__inject_buildid(struct perf_tool *tool,
 	}
 
 	thread__find_addr_map(thread, machine, cpumode, MAP__FUNCTION,
-			      event->ip.ip, &al, NULL);
+			      event->ip.ip, &al);
 
 	if (al.map != NULL) {
 		if (!al.map->dso->hit) {
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index a7d623f..2ad9d5b 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -361,10 +361,10 @@ static void print_sample_addr(union perf_event *event,
 		return;
 
 	thread__find_addr_map(thread, machine, cpumode, MAP__FUNCTION,
-			      sample->addr, &al, NULL);
+			      sample->addr, &al);
 	if (!al.map)
 		thread__find_addr_map(thread, machine, cpumode, MAP__VARIABLE,
-				      sample->addr, &al, NULL);
+				      sample->addr, &al);
 
 	al.cpu = sample->cpu;
 	al.sym = NULL;
diff --git a/tools/perf/tests/code-reading.c b/tools/perf/tests/code-reading.c
index 8e0943b..eec1421 100644
--- a/tools/perf/tests/code-reading.c
+++ b/tools/perf/tests/code-reading.c
@@ -147,7 +147,7 @@ static int read_object_code(u64 addr, size_t len, u8 cpumode,
 	pr_debug("Reading object code for memory address: %#"PRIx64"\n", addr);
 
 	thread__find_addr_map(thread, machine, cpumode, MAP__FUNCTION, addr,
-			      &al, NULL);
+			      &al);
 	if (!al.map || !al.map->dso) {
 		pr_debug("thread__find_addr_map failed\n");
 		return -1;
diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
index 3a0f508..5295625 100644
--- a/tools/perf/util/build-id.c
+++ b/tools/perf/util/build-id.c
@@ -33,7 +33,7 @@ int build_id__mark_dso_hit(struct perf_tool *tool __maybe_unused,
 	}
 
 	thread__find_addr_map(thread, machine, cpumode, MAP__FUNCTION,
-			      event->ip.ip, &al, NULL);
+			      event->ip.ip, &al);
 
 	if (al.map != NULL)
 		al.map->dso->hit = 1;
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 9d301c9..49713ae 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -592,7 +592,7 @@ int perf_event__process(struct perf_tool *tool __maybe_unused,
 void thread__find_addr_map(struct thread *self,
 			   struct machine *machine, u8 cpumode,
 			   enum map_type type, u64 addr,
-			   struct addr_location *al, symbol_filter_t filter)
+			   struct addr_location *al)
 {
 	struct map_groups *mg = &self->mg;
 	bool load_map = false;
@@ -663,7 +663,7 @@ try_again:
 		 * must be done prior to using kernel maps.
 		 */
 		if (load_map)
-			map__load(al->map, filter);
+			map__load(al->map, machine->symbol_filter);
 		al->addr = al->map->map_ip(al->map, al->addr);
 	}
 }
@@ -672,8 +672,7 @@ void thread__find_addr_location(struct thread *thread, struct machine *machine,
 				u8 cpumode, enum map_type type, u64 addr,
 				struct addr_location *al)
 {
-	thread__find_addr_map(thread, machine, cpumode, type, addr, al,
-			      machine->symbol_filter);
+	thread__find_addr_map(thread, machine, cpumode, type, addr, al);
 	if (al->map != NULL)
 		al->sym = map__find_symbol(al->map, al->addr,
 					   machine->symbol_filter);
@@ -709,7 +708,7 @@ int perf_event__preprocess_sample(const union perf_event *event,
 		machine__create_kernel_maps(machine);
 
 	thread__find_addr_map(thread, machine, cpumode, MAP__FUNCTION,
-			      event->ip.ip, al, machine->symbol_filter);
+			      event->ip.ip, al);
 	dump_printf(" ...... dso: %s\n",
 		    al->map ? al->map->dso->long_name :
 			al->level == 'H' ? "[hypervisor]" : "<not found>");
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index 0ab47d8..13c62c9 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -41,7 +41,7 @@ static inline struct map *thread__find_map(struct thread *self,
 
 void thread__find_addr_map(struct thread *thread, struct machine *machine,
 			   u8 cpumode, enum map_type type, u64 addr,
-			   struct addr_location *al, symbol_filter_t filter);
+			   struct addr_location *al);
 
 void thread__find_addr_location(struct thread *thread, struct machine *machine,
 				u8 cpumode, enum map_type type, u64 addr,
diff --git a/tools/perf/util/unwind.c b/tools/perf/util/unwind.c
index abac3f9..2f891f7 100644
--- a/tools/perf/util/unwind.c
+++ b/tools/perf/util/unwind.c
@@ -272,7 +272,7 @@ static struct map *find_map(unw_word_t ip, struct unwind_info *ui)
 	struct addr_location al;
 
 	thread__find_addr_map(ui->thread, ui->machine, PERF_RECORD_MISC_USER,
-			      MAP__FUNCTION, ip, &al, NULL);
+			      MAP__FUNCTION, ip, &al);
 	return al.map;
 }
 
@@ -349,7 +349,7 @@ static int access_dso_mem(struct unwind_info *ui, unw_word_t addr,
 	ssize_t size;
 
 	thread__find_addr_map(ui->thread, ui->machine, PERF_RECORD_MISC_USER,
-			      MAP__FUNCTION, addr, &al, NULL);
+			      MAP__FUNCTION, addr, &al);
 	if (!al.map) {
 		pr_debug("unwind: no map for %lx\n", (unsigned long)addr);
 		return -1;
