Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbaAPCbW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 21:31:22 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:58256 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429AbaAPCbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 21:31:21 -0500
X-AuditID: 9c93017e-b7b63ae000000e6a-c7-52d744778c28
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCHSET 00/12] tools lib traceevent: Plugin unload enhancement (v2)
Date: Thu, 16 Jan 2014 11:31:06 +0900
Message-Id: <1389839478-5887-1-git-send-email-namhyung@kernel.org>
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

 * changes in v2)
  - add ack and review tags from Steve and Jiri
  - improve message on handler unregister (Steve)
  - cleanup coding style issue (Steve)


I put the series on the 'libtraceevent/plugin-v2' branch in my tree

  git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git

Any comments are welcome, thanks
Namhyung


Namhyung Kim (12):
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
 12 files changed, 237 insertions(+), 14 deletions(-)

-- 
1.7.11.7

