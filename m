Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480Ab3EVCV6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 22:21:58 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:55433 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617Ab3EVCV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 22:21:57 -0400
X-AuditID: 85900ec0-d42c9b900000151e-7b-519c2bc25880
Subject: [PATCH v2 0/5] Add glob pattern matching support on trigger and
 kprobe-event
To: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Tom Zanussi <tom.zanussi@intel.com>
Date: Wed, 22 May 2013 11:19:03 +0900
Message-ID: <20130522021903.4299.85911.stgit@mhiramat-M0-7522>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is a series of ftrace/perf updates to support multiple
event select operation by glob-based wild cards.

I've ported strglobmatch from perf-tools (with recursive call
limitation) for this use. It is easier to use (just replacing
strcmp) but slower than current parser-based matching.
I don't care about the speed of matching because the all of
the matching which I've introduced in this series are done
on slow-path.

Changes in v2:
 - Update the comment of patch [2/5] for explaining more
   detail of the backgroud.

---

Masami Hiramatsu (5):
      [BUGFIX] tracing: Returns -EBUSY when event_enable_func fails to get module
      perf: Swap the parameters of strglobmatch
      lib/string: Add a generic wildcard string matching function
      tracing/kprobes: Allow user to delete kprobe events by wild cards
      tracing: Support enable/disable multiple events trigger by wild cards


 Documentation/trace/ftrace.txt      |   12 ++-
 Documentation/trace/kprobetrace.txt |   19 +++--
 include/linux/string.h              |    8 ++
 kernel/trace/trace_events.c         |  121 +++++++++++++++++++++++++----------
 kernel/trace/trace_kprobe.c         |   97 ++++++++++++++++++++--------
 lib/string.c                        |   91 ++++++++++++++++++++++++++
 tools/perf/util/parse-events.c      |   14 ++--
 tools/perf/util/probe-event.c       |    2 -
 tools/perf/util/strfilter.c         |    2 -
 tools/perf/util/string.c            |   16 ++---
 tools/perf/util/util.h              |    4 +
 11 files changed, 295 insertions(+), 91 deletions(-)

-- 
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
IT Management Research Dept. and Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
