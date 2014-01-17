Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611AbaAQO7E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 09:59:04 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36326 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbaAQO5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 09:57:45 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        "David A. Long" <dave.long@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Oleg Nesterov <oleg@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>, yrl.pp-manager.tt@hitachi.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 00/19] perf/core improvements and fixes
Date: Fri, 17 Jan 2014 11:57:06 -0300
Message-Id: <1389970645-12075-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>

Hi Ingo,

	Please consider pulling,

- Arnaldo

The following changes since commit 3e7e09dbd1080de5dcf10092830e39bc2e2932ec:

  Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/core (2014-01-16 09:34:01 +0100)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo

for you to fetch changes up to 2a29190c040c0b11e39197c67abf6f87e0a61f9a:

  perf tools: Remove unnecessary callchain cursor state restore on unmatch (2014-01-17 11:25:24 -0300)

----------------------------------------------------------------
Developer stuff:

. Improve callchain processing by removing unnecessary work. (Frederic Weisbecker)

. Fix comm override error handling (Frederic Weisbecker)

. Improve 'perf probe' exit path, release resources (Masami Hiramatsu)

. Improve libtraceevent plugins exit path, allowing the registering of
  an unregister handler to be called at exit time (Namhyung Kim)

. Add an alias to the build test makefile (make -C tools/perf build-test)
  (Namhyung Kim)

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Frederic Weisbecker (3):
      perf tools: Do proper comm override error handling
      perf callchain: Spare double comparison of callchain first entry
      perf tools: Remove unnecessary callchain cursor state restore on unmatch

Masami Hiramatsu (3):
      perf probe: Release allocated probe_trace_event if failed
      perf probe: Release all dynamically allocated parameters
      perf symbols: Export elf_section_by_name and reuse

Namhyung Kim (13):
      tools lib traceevent: Add pevent_unregister_event_handler()
      tools lib traceevent: Add pevent_unregister_print_function()
      tools lib traceevent: Unregister handler when function plugin is unloaded
      tools lib traceevent: Unregister handler when hrtimer plugin is unloaded
      tools lib traceevent: Unregister handler when kmem plugin is unloaded
      tools lib traceevent: Unregister handler when kvm plugin is unloaded
      tools lib traceevent: Unregister handler when sched_switch plugin is unloaded
      tools lib traceevent: Unregister handler when mac80211 plugin is unloaded
      tools lib traceevent: Unregister handler when cfg80211 plugin is unloaded
      tools lib traceevent: Unregister handler when jbd2 plugin is is unloaded
      tools lib traceevent: Unregister handler when scsi plugin is unloaded
      tools lib traceevent: Unregister handler when xen plugin is unloaded
      perf tools: Add 'build-test' make target

 tools/lib/traceevent/event-parse.c         | 136 ++++++++++++++++++++++++++---
 tools/lib/traceevent/event-parse.h         |   5 ++
 tools/lib/traceevent/plugin_cfg80211.c     |   6 ++
 tools/lib/traceevent/plugin_function.c     |   3 +
 tools/lib/traceevent/plugin_hrtimer.c      |  10 +++
 tools/lib/traceevent/plugin_jbd2.c         |   9 ++
 tools/lib/traceevent/plugin_kmem.c         |  22 +++++
 tools/lib/traceevent/plugin_kvm.c          |  29 ++++++
 tools/lib/traceevent/plugin_mac80211.c     |   7 ++
 tools/lib/traceevent/plugin_sched_switch.c |  12 +++
 tools/lib/traceevent/plugin_scsi.c         |   6 ++
 tools/lib/traceevent/plugin_xen.c          |   6 ++
 tools/perf/Makefile                        |   6 ++
 tools/perf/builtin-probe.c                 |  48 ++++++++--
 tools/perf/util/callchain.c                |  23 +++--
 tools/perf/util/comm.c                     |  19 ++--
 tools/perf/util/comm.h                     |   2 +-
 tools/perf/util/probe-event.c              | 111 +++++++++++++----------
 tools/perf/util/probe-event.h              |   6 ++
 tools/perf/util/symbol-elf.c               |   5 +-
 tools/perf/util/symbol.h                   |   5 ++
 tools/perf/util/thread.c                   |   5 +-
 tools/perf/util/unwind.c                   |  20 +----
 23 files changed, 389 insertions(+), 112 deletions(-)
