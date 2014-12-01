Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197AbaLATGx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 14:06:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53376 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854AbaLATGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 14:06:50 -0500
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 0/8] perf buildid-cache: Add clean command
Date: Mon,  1 Dec 2014 20:06:21 +0100
Message-Id: <1417460789-13874-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
adding 'perf buildid-cache clean' command to allow removal
files from '~/.debug` cache plus other fixes.

Basically the clean command allows to display/remove cache
files/sizes like:

Display cache files older than 3 days:
  $ perf buildid-cache clean 3d

Remove cache files older than 3 days:
  $ perf buildid-cache clean 3d -r
    
Total cache removal:
  $ perf buildid-cache clean -r

Remove and display items bigger than 200M
  $ perf buildid-cache clean -r -a 200M


Also available in here:
  git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
  perf/core_buildid_cache_clean

thanks,
jirka


Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
Jiri Olsa (8):
      perf tools: Use single strcmp call instead of two
      perf tools: Remove extra debugdir variables
      perf tools: Add --buildid-dir option to set cache directory
      perf buildid-cache: Add clean command
      perf buildid-cache: Add automated tests
      perf buildid cache: Fix -a segfault
      perf buildid-cache: Fix kallsyms removal
      perf buildid-cache: Try to remove empty directories

 tools/perf/Documentation/perf-buildid-cache.txt |  59 +++++++++++
 tools/perf/Documentation/perf.txt               |   4 +
 tools/perf/Makefile.perf                        |   7 +-
 tools/perf/builtin-buildid-cache.c              | 501 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 tools/perf/perf.c                               |  14 ++-
 tools/perf/tests/buildid-cache.c                |  88 ++++++++++++++++
 tools/perf/tests/buildid-cache.sh               |  60 +++++++++++
 tools/perf/tests/builtin-test.c                 |   8 ++
 tools/perf/tests/tests.h                        |   1 +
 tools/perf/util/build-id.c                      |  53 ++++++++--
 tools/perf/util/config.c                        |  10 +-
 tools/perf/util/util.h                          |   2 +-
 12 files changed, 781 insertions(+), 26 deletions(-)
 create mode 100644 tools/perf/tests/buildid-cache.c
 create mode 100755 tools/perf/tests/buildid-cache.sh
