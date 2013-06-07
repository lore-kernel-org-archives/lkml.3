Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854Ab3FGWWZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 18:22:25 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:56451 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999Ab3FGWWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 18:22:24 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, peterz@infradead.org, fweisbec@gmail.com,
        jolsa@redhat.com, namhyung@kernel.org, eranian@google.com,
        David Ahern <dsahern@gmail.com>
Subject: [RFC PATCH 0/4] perf: timehist command
Date: Fri,  7 Jun 2013 16:22:10 -0600
Message-Id: <1370643734-9579-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have commented a few times over the years about a perf-based command
that does a time history analysis of task scheduling. Internal to the
product I work on it has been extremely helpful debugging systems with
heavy CPU contention - understanding which tasks are consuming cpu cycles
over a given time window; when, why and how long a task was off the CPU
and how much time did the task get when it was scheduled; inefficiencies
from process bombs (shell scripts); and more.

This is the first exported version of that command. It contains the
basic features. It is also availabe at:
    https://github.com/dsahern/linux/commits/timehist-basic-3.9

We rely on the version that also provides time-of-day correlations.
e.g., task X raised an alarm at time Y due to lack of access to a
CPU. Take time Y from the log file and correlate with perf data to
gain some insights into what was happening before, during and after
the time of interest. The time-of-day version can be found here:
    https://github.com/dsahern/linux/commits/timehist-timeofday-3.9

The command currently uses the context-switch event -- for legacy reasons
with the kernel version we use. The command needs to be updated to
leverage the many scheduling tracepoints and with it updating the data
that can be generated from the analysis. Until then throwing it out for
comments and in case others find it useful.

David Ahern (4):
  perf: move setup_list from symbol.c to strlist.c
  perf: add methods for setting/retrieving priv element of thread struct
  perf: sample after exit loses thread correlation
  perf: add timehist command

 tools/perf/Makefile           |    2 ++
 tools/perf/builtin-inject.c   |    2 +-
 tools/perf/builtin-kmem.c     |    3 ++-
 tools/perf/builtin-kvm.c      |    3 ++-
 tools/perf/builtin-lock.c     |    3 ++-
 tools/perf/builtin-sched.c    |   17 +++++++-------
 tools/perf/builtin-script.c   |    3 ++-
 tools/perf/builtin-trace.c    |    9 +++++---
 tools/perf/builtin.h          |    1 +
 tools/perf/perf.c             |    1 +
 tools/perf/perf.h             |    6 +++++
 tools/perf/tests/hists_link.c |    2 +-
 tools/perf/util/build-id.c    |   11 ++++-----
 tools/perf/util/event.c       |   11 +++++++--
 tools/perf/util/machine.c     |   49 ++++++++++++++++++++++++++++++++---------
 tools/perf/util/machine.h     |    6 +++--
 tools/perf/util/session.c     |    2 +-
 tools/perf/util/strlist.c     |   15 +++++++++++++
 tools/perf/util/strlist.h     |    2 ++
 tools/perf/util/symbol.c      |   14 ------------
 tools/perf/util/thread.h      |   12 +++++++++-
 21 files changed, 121 insertions(+), 53 deletions(-)

-- 
1.7.10.1

