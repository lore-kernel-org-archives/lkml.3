Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171AbaBSPxu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 10:53:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27017 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753654AbaBSPxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 10:53:47 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Ahern <dsahern@gmail.com>, Jean Pihet <jean.pihet@linaro.org>
Subject: [RFC 0/6] perf tools: Factor features display code
Date: Wed, 19 Feb 2014 16:52:53 +0100
Message-Id: <1392825179-5228-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
sending factored code for detected features display.

The main reason for this was the rest of the libdw
DWARF unwind patchset, so I attached it as well to
show up the benefit (patch 5).

Basically I'm splitting the detected features output
to 'detected libraries' (displayed now by default)
and the rest. Please check patch 1 changelog for
all the factoring details.

The factored code now allows the detection code to
easily display which of the DWARF unwind libraries
is compiled in.

It passed tests/make suite.

You can try in here:
  git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
  perf/libdw_unwind10

thanks for comments,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jean Pihet <jean.pihet@linaro.org>
---
Jiri Olsa (6):
      perf tools: Factor features display code
      perf tools: Add variable display for VF make output
      perf tools: Add feature check for libdw dwarf unwind
      perf tools: Add libdw DWARF post unwind support
      perf tools: Setup default dwarf post unwinder
      perf tests: Add NO_LIBDW_DWARF_UNWIND make test

 tools/perf/Makefile.perf                                   |  14 ++++-
 tools/perf/arch/x86/Makefile                               |   5 ++
 tools/perf/arch/x86/util/unwind-libdw.c                    |  51 ++++++++++++++++
 tools/perf/config/Makefile                                 | 232 ++++++++++++++++++++++++++++++++++++++++++++++++++++--------------------
 tools/perf/config/feature-checks/Makefile                  |   6 +-
 tools/perf/config/feature-checks/test-all.c                |   5 ++
 tools/perf/config/feature-checks/test-libdw-dwarf-unwind.c |  13 ++++
 tools/perf/tests/make                                      |   3 +
 tools/perf/util/unwind-libdw.c                             | 210 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/unwind-libdw.h                             |  21 +++++++
 10 files changed, 494 insertions(+), 66 deletions(-)
 create mode 100644 tools/perf/arch/x86/util/unwind-libdw.c
 create mode 100644 tools/perf/config/feature-checks/test-libdw-dwarf-unwind.c
 create mode 100644 tools/perf/util/unwind-libdw.c
 create mode 100644 tools/perf/util/unwind-libdw.h
