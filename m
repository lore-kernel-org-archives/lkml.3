Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857AbaAOBpo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 20:45:44 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:64925 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbaAOBpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 20:45:42 -0500
X-AuditID: 9c930197-b7b7cae000000e34-42-52d5e84401e9
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCHSET 00/17] tools lib traceevent: Plugin unload enhancement
Date: Wed, 15 Jan 2014 10:45:23 +0900
Message-Id: <1389750340-15965-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

When plugins are loaded, they register various event and function
handlers.  But they don't unregister even after the plugins unloaded
so that events could have refererences to non-existing handlers.

This patchset added relevant unregister functions to handle that.

Note that this is not a problem as of now since all of users unload
plugins after finishing their access to events.  But being a generic
library, it should be handled properly IMHO.

The patch 1-4 are resend of the previous die removal series so
independent to this series.

I put the series on the 'libtraceevent/plugin-v1' branch in my tree

  git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git

Any comments are welcome, thanks
Namhyung


Namhyung Kim (17):
  tools lib traceevent: Add state member to struct trace_seq
  tools lib traceevent: Check return value of realloc()
  tools lib traceevent: Get rid of malloc_or_die() in trace_seq_init()
  tools lib traceevent: Get rid of die() finally!!
  tools lib traceevent: Make plugin unload function receive pevent
  tools lib traceevent: Add pevent_unregister_event_handler()
  tools lib traceevent: Add pevent_unregister_print_function()
  tools lib traceevent: Unregister handler when function plugin
    unloaded
  tools lib traceevent: Unregister handler when hrtimer plugin unloaded
  tools lib traceevent: Unregister handler when kmem plugin unloaded
  tools lib traceevent: Unregister handler when kvm plugin unloaded
  tools lib traceevent: Unregister handler when sched_switch plugin
    unloaded
  tools lib traceevent: Unregister handler when mac80211 plugin
    unloaded
  tools lib traceevent: Unregister handler when cfg80211 plugin
    unloaded
  tools lib traceevent: Unregister handler when jbd2 plugin unloaded
  tools lib traceevent: Unregister handler when scsi plugin unloaded
  tools lib traceevent: Unregister handler when xen plugin unloaded

 tools/lib/traceevent/Makefile              |   2 +-
 tools/lib/traceevent/event-parse.c         | 136 ++++++++++++++++++++++++++---
 tools/lib/traceevent/event-parse.h         |  19 +++-
 tools/lib/traceevent/event-plugin.c        |   4 +-
 tools/lib/traceevent/event-utils.h         |   4 -
 tools/lib/traceevent/parse-utils.c         |  44 ----------
 tools/lib/traceevent/plugin_cfg80211.c     |   7 ++
 tools/lib/traceevent/plugin_function.c     |   5 +-
 tools/lib/traceevent/plugin_hrtimer.c      |  10 +++
 tools/lib/traceevent/plugin_jbd2.c         |  11 +++
 tools/lib/traceevent/plugin_kmem.c         |  22 +++++
 tools/lib/traceevent/plugin_kvm.c          |  30 +++++++
 tools/lib/traceevent/plugin_mac80211.c     |   7 ++
 tools/lib/traceevent/plugin_sched_switch.c |  12 +++
 tools/lib/traceevent/plugin_scsi.c         |   7 ++
 tools/lib/traceevent/plugin_xen.c          |   7 ++
 tools/lib/traceevent/trace-seq.c           |  58 ++++++++++--
 tools/perf/util/trace-event.c              |   2 +-
 18 files changed, 310 insertions(+), 77 deletions(-)

-- 
1.7.11.7

