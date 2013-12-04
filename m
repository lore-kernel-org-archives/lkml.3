Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009Ab3LDUIM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 15:08:12 -0500
Received: from merlin.infradead.org ([205.233.59.134]:59454 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933334Ab3LDUH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 15:07:26 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Jiri Olsa <jolsa@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 00/38] perf/core improvements and fixes
Date: Wed,  4 Dec 2013 17:06:24 -0300
Message-Id: <1386187622-2928-1-git-send-email-acme@infradead.org>
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

The following changes since commit 89e3bbd58a6186b832fe2b9419ac2f9ab90e9089:

  Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/core (2013-12-04 10:17:17 +0100)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo

for you to fetch changes up to 6d65894bc028d0342829ea1e64c9e9efad571124:

  tools lib traceevent: Update kvm plugin with is_writable_pte helper (2013-12-04 15:38:14 -0300)

----------------------------------------------------------------
perf/core improvements and fixes:

. Backport libtraceevent plugin support from trace-cmd repository, with
  plugins for jbd2, hrtimer, kmem, kvm, mac80211, sched_switch, function,
  xen, scsi, cfg80211. From Jiri Olsa.

. Retain bfd reference to lookup source line numbers, greatly optimizing, among
  other use cases, 'perf report -s srcline', from Adrian Hunter.

. Do not disable source line lookup just because of 1 failure, from Adrian Hunter.

. Fix random fd closing with no libelf, from Adrian Hunter.

. Do not call perf_event__preprocess_sample() twice in 'perf script,
  from Adrian Hunter.

. Several 'perf kvm' man page corrections, from Dongsheng Yang.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Adrian Hunter (6):
      perf tools: Use asprintf instead of malloc plus snprintf
      perf symbols: Retain bfd reference to lookup source line numbers
      perf symbols: Retain symbol source file name to lookup source line numbers
      perf tools: Do not disable source line lookup just because of 1 failure
      perf symbols: Fix random fd closing with no libelf
      perf script: Do not call perf_event__preprocess_sample() twice)

Dongsheng Yang (5):
      perf tools: Remove condition in machine__get_kernel_start_addr.
      perf target: Move the checking of which map function to call into function.
      perf kvm: Add more detail about buildid-list in man page
      perf kvm: Fix spurious '=' use in man page
      perf kvm: Update the 'record' man page entry for new --guest/--host behavior

Jiri Olsa (27):
      perf tools: Remove stackprotector feature check
      tools lib traceevent: Add plugin support
      tools lib traceevent: Add plugin build support
      tools lib traceevent: Add traceevent_host_bigendian function
      tools lib traceevent: Change pevent_parse_format to include pevent handle
      tools lib traceevent: Harmonize the install messages in lib-traceevent
      perf tools: Add build and install plugins targets
      perf tools: Add filename__read_str util function
      perf tools: Add trace-event object
      perf tools: Add trace-event global object for tracepoint interface
      perf tools: Overload pr_stat traceevent print function
      tools lib traceevent: Add jbd2 plugin
      tools lib traceevent: Add hrtimer plugin
      tools lib traceevent: Add kmem plugin
      tools lib traceevent: Add kvm plugin
      tools lib traceevent: Add mac80211 plugin
      tools lib traceevent: Add sched_switch plugin
      tools lib traceevent: Add function plugin
      tools lib traceevent: Add xen plugin
      tools lib traceevent: Add scsi plugin
      tools lib traceevent: Add cfg80211 plugin
      tools lib traceevent: Remove malloc_or_die from event-plugin.c
      tools lib traceevent: Use static functions in jbd2 plugin
      tools lib traceevent: Use pevent_print_func_field in hrtimer_start handler
      tools lib traceevent: Several cleanups for function plugin
      tools lib traceevent: Remove malloc_or_die from plugin_function.c
      tools lib traceevent: Update kvm plugin with is_writable_pte helper

 tools/lib/traceevent/Makefile                      |  71 +++-
 tools/lib/traceevent/event-parse.c                 |  56 ++-
 tools/lib/traceevent/event-parse.h                 |  19 +-
 tools/lib/traceevent/event-plugin.c                | 215 ++++++++++
 tools/lib/traceevent/plugin_cfg80211.c             |  24 ++
 tools/lib/traceevent/plugin_function.c             | 160 ++++++++
 tools/lib/traceevent/plugin_hrtimer.c              |  78 ++++
 tools/lib/traceevent/plugin_jbd2.c                 |  68 ++++
 tools/lib/traceevent/plugin_kmem.c                 |  72 ++++
 tools/lib/traceevent/plugin_kvm.c                  | 436 +++++++++++++++++++++
 tools/lib/traceevent/plugin_mac80211.c             |  95 +++++
 tools/lib/traceevent/plugin_sched_switch.c         | 148 +++++++
 tools/lib/traceevent/plugin_scsi.c                 | 423 ++++++++++++++++++++
 tools/lib/traceevent/plugin_xen.c                  | 130 ++++++
 tools/perf/Documentation/perf-kvm.txt              |  27 +-
 tools/perf/Makefile.perf                           |  18 +-
 tools/perf/builtin-script.c                        |  13 +-
 tools/perf/builtin-trace.c                         |   5 +-
 tools/perf/config/Makefile                         |  13 +-
 tools/perf/config/feature-checks/Makefile          |   6 +-
 .../config/feature-checks/test-stackprotector.c    |   6 -
 tools/perf/util/debug.c                            |  30 +-
 tools/perf/util/debug.h                            |   2 +
 tools/perf/util/dso.c                              |   3 +
 tools/perf/util/dso.h                              |   5 +
 tools/perf/util/evlist.c                           |   8 +-
 tools/perf/util/evsel.c                            |  44 +--
 tools/perf/util/header.c                           |   8 +-
 tools/perf/util/machine.c                          |  14 +-
 tools/perf/util/python-ext-sources                 |   1 +
 tools/perf/util/session.c                          |  31 +-
 tools/perf/util/session.h                          |   7 +-
 tools/perf/util/srcline.c                          |  66 +++-
 tools/perf/util/symbol-minimal.c                   |   1 +
 tools/perf/util/symbol.c                           |   2 +
 tools/perf/util/target.h                           |  13 +
 tools/perf/util/trace-event-parse.c                |  13 -
 tools/perf/util/trace-event-read.c                 |  20 +-
 tools/perf/util/trace-event.c                      |  82 ++++
 tools/perf/util/trace-event.h                      |  15 +-
 tools/perf/util/util.c                             |  49 +++
 tools/perf/util/util.h                             |   1 +
 42 files changed, 2305 insertions(+), 193 deletions(-)
 create mode 100644 tools/lib/traceevent/event-plugin.c
 create mode 100644 tools/lib/traceevent/plugin_cfg80211.c
 create mode 100644 tools/lib/traceevent/plugin_function.c
 create mode 100644 tools/lib/traceevent/plugin_hrtimer.c
 create mode 100644 tools/lib/traceevent/plugin_jbd2.c
 create mode 100644 tools/lib/traceevent/plugin_kmem.c
 create mode 100644 tools/lib/traceevent/plugin_kvm.c
 create mode 100644 tools/lib/traceevent/plugin_mac80211.c
 create mode 100644 tools/lib/traceevent/plugin_sched_switch.c
 create mode 100644 tools/lib/traceevent/plugin_scsi.c
 create mode 100644 tools/lib/traceevent/plugin_xen.c
 delete mode 100644 tools/perf/config/feature-checks/test-stackprotector.c
 create mode 100644 tools/perf/util/trace-event.c
