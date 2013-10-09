Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756987Ab3JIJtk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 05:49:40 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:58167 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497Ab3JIJti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 05:49:38 -0400
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 0/4] tools/perf/build: Improve 'make', 'make install' and 'make clean' output
Date: Wed,  9 Oct 2013 11:49:25 +0200
Message-Id: <1381312169-17354-1-git-send-email-mingo@kernel.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series improves perf's default 'make', 'make install' and 'make clean'
output messages: less console spam, more summaries, more consistency.

For example the new 'make install' output is now:

  comet:~/tip/tools/perf> make install
    BUILD:   Doing 'make -j12' parallel build
    SUBDIR   Documentation
    INSTALL  Documentation-man
    INSTALL  binaries
    INSTALL  libexec
    INSTALL  perf-archive
    INSTALL  perl-scripts
    INSTALL  python-scripts
    INSTALL  bash_completion-script
    INSTALL  tests

The Git tree can be found at:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git tmp.perf

(The commits are top of the build system speedup patches.)

Thanks,

	Ingo

===============>
Ingo Molnar (4):
  tools/perf/build: Implement summary output for 'make clean'
  tools/build: Harmonize the various build messages in perf, lib-traceevent, lib-lk
  tools/perf/build: Align perf version output to other build messages
  tools/perf/build: Implement summary output for 'make install'

 tools/lib/traceevent/Makefile     | 18 +++++++--------
 tools/perf/Documentation/Makefile | 62 +++++++++++++++++++++++++++-----------------------
 tools/perf/Makefile               |  2 +-
 tools/perf/Makefile.perf          | 72 +++++++++++++++++++++++++++++++++--------------------------
 tools/perf/config/utilities.mak   |  8 +++++++
 tools/perf/util/PERF-VERSION-GEN  |  2 +-
 tools/scripts/Makefile.include    | 23 ++++++++++---------
 7 files changed, 105 insertions(+), 82 deletions(-)

-- 
1.8.3.1

