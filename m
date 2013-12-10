Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563Ab3LJJS4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 04:18:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44256 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010Ab3LJJSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 04:18:51 -0500
Date: Tue, 10 Dec 2013 01:18:24 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-3d7c0144491bd8c21d53b43032274a85efdfe434@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1386076182-14484-8-git-send-email-jolsa@redhat.com>
References: <1386076182-14484-8-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Add build and install plugins targets
Git-Commit-ID: 3d7c0144491bd8c21d53b43032274a85efdfe434
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 10 Dec 2013 01:18:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3d7c0144491bd8c21d53b43032274a85efdfe434
Gitweb:     http://git.kernel.org/tip/3d7c0144491bd8c21d53b43032274a85efdfe434
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Tue, 3 Dec 2013 14:09:21 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 4 Dec 2013 15:19:35 -0300

perf tools: Add build and install plugins targets

Adding 'plugins' target along with the libtraceevent.a, so plugins are
built together with traceevent library.

Adding 'install-traceevent-plugins' Makefile install target, instructing
perf to install plugins into:

  $(HOME)/.traceevent/plugins
    - If installed localy under $HOME

  $(DESTDIR)/$(prefix)/$(libdir)/traceevent/plugins
    - If installed globally

Examples:
  $ make install
  ...
  $ find ~/.traceevent/plugins/
  /home/jolsa/.traceevent/plugins/
  /home/jolsa/.traceevent/plugins/plugin_mac80211.so
  /home/jolsa/.traceevent/plugins/plugin_kvm.so
  /home/jolsa/.traceevent/plugins/plugin_scsi.so
  /home/jolsa/.traceevent/plugins/plugin_sched_switch.so
  /home/jolsa/.traceevent/plugins/plugin_xen.so
  /home/jolsa/.traceevent/plugins/plugin_cfg80211.so
  /home/jolsa/.traceevent/plugins/plugin_function.so
  /home/jolsa/.traceevent/plugins/plugin_kmem.so
  /home/jolsa/.traceevent/plugins/plugin_hrtimer.so
  /home/jolsa/.traceevent/plugins/plugin_jbd2.so

  $ sudo make install DESTDIR=/opt/perf/
  ...
  $ find /opt/perf/lib64/traceevent/plugins/
  /opt/perf/lib64/traceevent/plugins/
  /opt/perf/lib64/traceevent/plugins/plugin_kvm.so
  /opt/perf/lib64/traceevent/plugins/plugin_scsi.so
  /opt/perf/lib64/traceevent/plugins/plugin_mac80211.so
  /opt/perf/lib64/traceevent/plugins/plugin_hrtimer.so
  /opt/perf/lib64/traceevent/plugins/plugin_kmem.so
  /opt/perf/lib64/traceevent/plugins/plugin_jbd2.so
  /opt/perf/lib64/traceevent/plugins/plugin_sched_switch.so
  /opt/perf/lib64/traceevent/plugins/plugin_function.so
  /opt/perf/lib64/traceevent/plugins/plugin_cfg80211.so
  /opt/perf/lib64/traceevent/plugins/plugin_xen.so

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1386076182-14484-8-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile.perf   | 17 ++++++++++++-----
 tools/perf/config/Makefile |  8 ++++++++
 2 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index e416ccc..abc7ac3 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -105,7 +105,7 @@ ifeq ($(config),1)
 include config/Makefile
 endif
 
-export prefix bindir sharedir sysconfdir
+export prefix bindir sharedir sysconfdir DESTDIR
 
 # sparse is architecture-neutral, which means that we need to tell it
 # explicitly what architecture to check for. Fix this up for yours..
@@ -710,13 +710,20 @@ $(LIB_FILE): $(LIB_OBJS)
 # libtraceevent.a
 TE_SOURCES = $(wildcard $(TRACE_EVENT_DIR)*.[ch])
 
-$(LIBTRACEEVENT): $(TE_SOURCES)
-	$(QUIET_SUBDIR0)$(TRACE_EVENT_DIR) $(QUIET_SUBDIR1) O=$(OUTPUT) CFLAGS="-g -Wall $(EXTRA_CFLAGS)" libtraceevent.a
+LIBTRACEEVENT_FLAGS  = $(QUIET_SUBDIR1) O=$(OUTPUT)
+LIBTRACEEVENT_FLAGS += CFLAGS="-g -Wall $(EXTRA_CFLAGS)"
+LIBTRACEEVENT_FLAGS += plugin_dir=$(plugindir_SQ)
+
+$(LIBTRACEEVENT): $(TE_SOURCES) $(OUTPUT)PERF-CFLAGS
+	$(QUIET_SUBDIR0)$(TRACE_EVENT_DIR) $(LIBTRACEEVENT_FLAGS) libtraceevent.a plugins
 
 $(LIBTRACEEVENT)-clean:
 	$(call QUIET_CLEAN, libtraceevent)
 	@$(MAKE) -C $(TRACE_EVENT_DIR) O=$(OUTPUT) clean >/dev/null
 
+install-traceevent-plugins:
+	$(QUIET_SUBDIR0)$(TRACE_EVENT_DIR) $(LIBTRACEEVENT_FLAGS) install_plugins
+
 LIBLK_SOURCES = $(wildcard $(LK_PATH)*.[ch])
 
 # if subdir is set, we've been called from above so target has been built
@@ -785,7 +792,7 @@ cscope:
 
 ### Detect prefix changes
 TRACK_CFLAGS = $(subst ','\'',$(CFLAGS)):\
-             $(bindir_SQ):$(perfexecdir_SQ):$(template_dir_SQ):$(prefix_SQ)
+             $(bindir_SQ):$(perfexecdir_SQ):$(template_dir_SQ):$(prefix_SQ):$(plugindir_SQ)
 
 $(OUTPUT)PERF-CFLAGS: .FORCE-PERF-CFLAGS
 	@FLAGS='$(TRACK_CFLAGS)'; \
@@ -849,7 +856,7 @@ endif
 		$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/tests/attr'; \
 		$(INSTALL) tests/attr/* '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/tests/attr'
 
-install: install-bin try-install-man
+install: install-bin try-install-man install-traceevent-plugins
 
 install-python_ext:
 	$(PYTHON_WORD) util/setup.py --quiet install --root='/$(DESTDIR_SQ)'
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 0761d57..bae1072 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -593,3 +593,11 @@ else
 perfexec_instdir = $(prefix)/$(perfexecdir)
 endif
 perfexec_instdir_SQ = $(subst ','\'',$(perfexec_instdir))
+
+# If we install to $(HOME) we keep the traceevent default:
+# $(HOME)/.traceevent/plugins
+# Otherwise we install plugins into the global $(libdir).
+ifdef DESTDIR
+plugindir=$(libdir)/traceevent/plugins
+plugindir_SQ= $(subst ','\'',$(prefix)/$(plugindir))
+endif
