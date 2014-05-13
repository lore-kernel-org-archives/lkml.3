Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1160997AbaEMWMn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 18:12:43 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:60882 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932169AbaEMWF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 18:05:27 -0400
From: Alexis Berlemont <alexis.berlemont@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alexis Berlemont <alexis.berlemont@gmail.com>, jolsa@redhat.com,
        acme@ghostprotocols.net, dsahern@gmail.com, mingo@kernel.org
Subject: [PATCH 10/34] perf kbuild: add missing files and missing flags in Kbuild files
Date: Wed, 14 May 2014 00:03:05 +0200
Message-Id: <1400018609-20486-11-git-send-email-alexis.berlemont@gmail.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1400018609-20486-1-git-send-email-alexis.berlemont@gmail.com>
References: <1400018609-20486-1-git-send-email-alexis.berlemont@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 tools/perf/arch/x86/util/Kbuild                  |  1 +
 tools/perf/scripts/python/Perf-Trace-Util/Kbuild |  3 ++-
 tools/perf/tests/Kbuild                          | 15 +++++++++++++--
 tools/perf/ui/Kbuild                             |  1 +
 tools/perf/ui/browsers/Kbuild                    |  2 ++
 tools/perf/ui/gtk/Kbuild                         |  2 ++
 tools/perf/util/Kbuild                           | 12 +++++++++---
 tools/perf/util/scripting-engines/Kbuild         |  6 +++++-
 8 files changed, 35 insertions(+), 7 deletions(-)

diff --git a/tools/perf/arch/x86/util/Kbuild b/tools/perf/arch/x86/util/Kbuild
index 0ba617a..e033b94 100644
--- a/tools/perf/arch/x86/util/Kbuild
+++ b/tools/perf/arch/x86/util/Kbuild
@@ -1,3 +1,4 @@
 obj-y += dwarf-regs.o
 obj-y += header.o
+obj-y += tsc.o
 obj-$(CONFIG_LIBUNWIND) += unwind.o
diff --git a/tools/perf/scripts/python/Perf-Trace-Util/Kbuild b/tools/perf/scripts/python/Perf-Trace-Util/Kbuild
index 0f32b85..c31ca7c 100644
--- a/tools/perf/scripts/python/Perf-Trace-Util/Kbuild
+++ b/tools/perf/scripts/python/Perf-Trace-Util/Kbuild
@@ -1,4 +1,5 @@
 obj-y += Context.o
 
 CFLAGS_Context.o := $(PYTHON_EMBED_CCOPTS)
-CFLAGS_Context.o += -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-nested-externs
+CFLAGS_Context.o += -Wno-redundant-decls -Wno-strict-prototypes 
+CFLAGS_Context.o += -Wno-unused-parameter -Wno-nested-externs
diff --git a/tools/perf/tests/Kbuild b/tools/perf/tests/Kbuild
index f2998a6..b4e7682 100644
--- a/tools/perf/tests/Kbuild
+++ b/tools/perf/tests/Kbuild
@@ -18,6 +18,17 @@ obj-y += bp_signal.o
 obj-y += bp_signal_overflow.o
 obj-y += sw-clock.o
 obj-y += task-exit.o
+obj-y += code-reading.o
+obj-y += sample-parsing.o
+obj-y += keep-tracking.o
+obj-y += parse-no-sample-id-all.o
 
-CFLAGS_python-use.o += -DPYTHON='"$(PYTHON_WORD)"' -DPYTHONPATH='"python"'
-CFLAGS_attr.o += -DPYTHON='"$(PYTHON_WORD)"' -DBINDIR='"$(bindir_SQ)"'
+
+# TODO: this should only be included if arch = x86
+obj-y += perf-time-to-tsc.o
+
+CFLAGS_python-use.o += -D"PYTHON=KBUILD_STR($(PYTHON_WORD))"
+CFLAGS_python-use.o += -D"PYTHONPATH=KBUILD_STR(python)"
+
+CFLAGS_attr.o += -D"PYTHON=KBUILD_STR($(PYTHON_WORD))"
+CFLAGS_attr.o += -D"BINDIR=KBUILD_STR($(bindir_SQ))"
diff --git a/tools/perf/ui/Kbuild b/tools/perf/ui/Kbuild
index f687132..44ad988 100644
--- a/tools/perf/ui/Kbuild
+++ b/tools/perf/ui/Kbuild
@@ -12,3 +12,4 @@ obj-$(CONFIG_TUI)  += tui/
 obj-$(CONFIG_GTK2) += gtk/
 
 CFLAGS_browser.o += -DENABLE_SLFUTURE_CONST
+CFLAGS_setup.o += -D"LIBDIR=KBUILD_STR($(libdir_SQ))"
\ No newline at end of file
diff --git a/tools/perf/ui/browsers/Kbuild b/tools/perf/ui/browsers/Kbuild
index 43bfcbf..03938aa 100644
--- a/tools/perf/ui/browsers/Kbuild
+++ b/tools/perf/ui/browsers/Kbuild
@@ -4,3 +4,5 @@ obj-$(CONFIG_TUI) += map.o
 obj-$(CONFIG_TUI) += scripts.o
 
 CFLAGS_hists.o += -DENABLE_SLFUTURE_CONST
+CFLAGS_map.o += -DENABLE_SLFUTURE_CONST
+CFLAGS_scripts.o += -DENABLE_SLFUTURE_CONST
diff --git a/tools/perf/ui/gtk/Kbuild b/tools/perf/ui/gtk/Kbuild
index 6964926..83e3e58 100644
--- a/tools/perf/ui/gtk/Kbuild
+++ b/tools/perf/ui/gtk/Kbuild
@@ -5,3 +5,5 @@ obj-y += util.o
 obj-y += helpline.o
 obj-y += progress.o
 obj-y += annotate.o
+
+subdir-ccflags-y := $(GTK_CFLAGS)
\ No newline at end of file
diff --git a/tools/perf/util/Kbuild b/tools/perf/util/Kbuild
index 10d5376..6fb42a6 100644
--- a/tools/perf/util/Kbuild
+++ b/tools/perf/util/Kbuild
@@ -6,6 +6,7 @@ obj-y += build-id.o
 obj-y += callchain.o
 obj-y += cgroup.o
 obj-y += color.o
+obj-y += comm.o
 obj-y += config.o
 obj-y += cpumap.o
 obj-y += ctype.o
@@ -38,6 +39,9 @@ obj-y += session.o
 obj-y += sigchain.o
 obj-y += sort.o
 obj-y += stat.o
+obj-y += record.o
+obj-y += srcline.o
+obj-y += data.o
 obj-y += strbuf.o
 obj-y += strfilter.o
 obj-y += string.o
@@ -54,7 +58,7 @@ obj-$(CONFIG_LIBELF) += probe-finder.o
 
 obj-$(CONFIG_LIBELF_MINIMAL) += symbol-minimal.o
 
-obj-y += sysfs.o
+obj-y += fs.o
 obj-y += target.o
 obj-y += thread.o
 obj-y += thread_map.o
@@ -106,8 +110,10 @@ $(src)/pmu-bison.o: $(src)/pmu-bison.c
 
 CFLAGS_parse-events-flex.o  += -w
 CFLAGS_parse-events-bison.o += -DYYENABLE_NLS=0 -DYYLTYPE_IS_TRIVIAL=0 -w
+CFLAGS_parse-events.o  += -Wno-redundant-decls
 CFLAGS_pmu-flex.o  += -w
 CFLAGS_pmu-bison.o += -DYYENABLE_NLS=0 -DYYLTYPE_IS_TRIVIAL=0 -w
 
-CFLAGS_config.o += -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"'
-CFLAGS_exec_cmd.o += -DPERF_EXEC_PATH='"$(perfexecdir_SQ)"' -DPREFIX='"$(prefix_SQ)"'
+CFLAGS_config.o += -D"ETC_PERFCONFIG=KBUILD_STR($(ETC_PERFCONFIG_SQ))"
+CFLAGS_exec_cmd.o += -D"PERF_EXEC_PATH=KBUILD_STR($(perfexecdir_SQ))"
+CFLAGS_exec_cmd.o += -D"PREFIX=KBUILD_STR($(prefix_SQ))"
diff --git a/tools/perf/util/scripting-engines/Kbuild b/tools/perf/util/scripting-engines/Kbuild
index b6360ee..9898d27 100644
--- a/tools/perf/util/scripting-engines/Kbuild
+++ b/tools/perf/util/scripting-engines/Kbuild
@@ -2,6 +2,10 @@ obj-$(CONFIG_LIBPERL)   += trace-event-perl.o
 obj-$(CONFIG_LIBPYTHON) += trace-event-python.o
 
 CFLAGS_trace-event-perl.o   := $(PERL_EMBED_CCOPTS)
+CFLAGS_trace-event-perl.o   += -Wno-redundant-decls -Wno-strict-prototypes 
+CFLAGS_trace-event-perl.o   += -Wno-unused-parameter -Wno-shadow -Wno-undef 
+CFLAGS_trace-event-perl.o   += -Wno-switch-default
 
 CFLAGS_trace-event-python.o := $(PYTHON_EMBED_CCOPTS)
-CFLAGS_trace-event-python.o += -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-shadow
+CFLAGS_trace-event-python.o += -Wno-redundant-decls -Wno-strict-prototypes 
+CFLAGS_trace-event-python.o += -Wno-unused-parameter -Wno-shadow
-- 
1.9.2

