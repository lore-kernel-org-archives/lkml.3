Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935768Ab3BTPcm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 10:32:42 -0500
Received: from mail.skyhub.de ([78.46.96.112]:50989 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933505Ab3BTPci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 10:32:38 -0500
From: Borislav Petkov <bp@alien8.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 0/7] perf: A tools library
Date: Wed, 20 Feb 2013 16:32:26 +0100
Message-Id: <1361374353-30385-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Hi,

so this is a pretty old intention which I had put on the backburner due
to work-related stuff but here it is again. Basically we want to carve
out stuff in tools/ which is generic enough to be shared between the
different tools instead of replicating it among them.

And this is a first go at sharing the debugfs searching and setting code
between perf and vm/page-types.c which had an older debugfs_mount et.
al. version.

Please take a look at let me know whether the direction is ok. It builds
and works fine here but I could've missed something so consider this
RFC-ish of nature.

Thanks.

Borislav Petkov (7):
  perf, debugfs: Remove a write-only variable
  perf: Honor parallel jobs
  perf: Correct Makefile.include
  perf: Carve out debugfs
  perf: Extract perf-specific stuff from debugfs.c
  perf: Do not allow empty debugfs-dir option
  tools/vm: Switch to liblk library

 Makefile                              |  4 +-
 tools/Makefile                        | 16 ++++++-
 tools/lib/lk/Makefile                 | 35 +++++++++++++++
 tools/{perf/util => lib/lk}/debugfs.c | 49 ++++++++------------
 tools/lib/lk/debugfs.h                | 29 ++++++++++++
 tools/perf/Makefile                   | 34 +++++++++++---
 tools/perf/builtin-kvm.c              |  2 +-
 tools/perf/builtin-probe.c            |  2 +-
 tools/perf/perf.c                     | 12 +++--
 tools/perf/tests/parse-events.c       |  2 +-
 tools/perf/util/debugfs.h             | 12 -----
 tools/perf/util/evlist.c              |  2 +-
 tools/perf/util/evsel.c               |  2 +-
 tools/perf/util/parse-events.c        |  2 +-
 tools/perf/util/probe-event.c         |  2 +-
 tools/perf/util/python-ext-sources    |  1 -
 tools/perf/util/setup.py              |  3 +-
 tools/perf/util/trace-event-info.c    |  4 +-
 tools/perf/util/util.c                | 27 +++++++++++
 tools/perf/util/util.h                |  7 ++-
 tools/scripts/Makefile.include        |  6 ++-
 tools/vm/Makefile                     | 17 +++++--
 tools/vm/page-types.c                 | 85 +++--------------------------------
 23 files changed, 201 insertions(+), 154 deletions(-)
 create mode 100644 tools/lib/lk/Makefile
 rename tools/{perf/util => lib/lk}/debugfs.c (68%)
 create mode 100644 tools/lib/lk/debugfs.h
 delete mode 100644 tools/perf/util/debugfs.h

-- 
1.8.1.3.535.ga923c31

