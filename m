Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab3HVOob (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 10:44:31 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:33735 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852Ab3HVOoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 10:44:30 -0400
From: Robert Richter <rric@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org, Robert Richter <rric@kernel.org>
Subject: [PATCH resent 0/4] perf tools: Persistent events, changes for perf tool integration
Date: Thu, 22 Aug 2013 16:44:01 +0200
Message-Id: <1377182645-12922-1-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set contains userland changes necessary for out-of-the-box
support of persistent events. These patches are follow on patches of
the kernel patches I sent out today:

 [PATCH 00/16] perf, persistent: Kernel updates for perf tool integration

Persistent events are always enabled kernel events. Buffers are mapped
readonly and multiple users are allowed. The persistent event flag of
the event attribute must be set to specify such an event.

The following changes to perf tools are necessary to support
persistent events. A way is needed to specify sysfs entries to set
event flags. For this a new syntax 'attr<num>' was added to the event
parser, see patch #3. We also need to change perf tools to mmap
persistent event buffers readonly.

All patches can be found here:

 git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git persistent-v3

-Robert


Robert Richter (4):
  perf tools: Rename flex conditions to avoid name conflicts
  perf tools: Modify event parser to update event attribute by index
  perf tools: Add attr<num> syntax to event parser
  perf tools: Retry mapping buffers readonly on EACCES

 tools/perf/builtin-record.c     | 11 +++++---
 tools/perf/builtin-top.c        |  8 ++++--
 tools/perf/perf.h               |  1 +
 tools/perf/tests/parse-events.c | 12 ++++++---
 tools/perf/util/parse-events.c  | 59 +++++++++++++++++++----------------------
 tools/perf/util/parse-events.h  | 12 ++++-----
 tools/perf/util/parse-events.l  | 56 +++++++++++++++++++++++---------------
 tools/perf/util/parse-events.y  | 24 ++++++++++-------
 tools/perf/util/pmu.c           | 32 +++++-----------------
 tools/perf/util/pmu.h           |  9 ++-----
 tools/perf/util/pmu.l           |  1 +
 tools/perf/util/pmu.y           | 18 ++++++++++---
 12 files changed, 129 insertions(+), 114 deletions(-)

-- 
1.8.3.2

