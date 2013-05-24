Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986Ab3EXMnE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 08:43:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31822 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754459Ab3EXMnC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 08:43:02 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Stephane Eranian <eranian@google.com>, Sam Ravnborg <sam@ravnborg.org>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCHv3 00/25] perf tools: Makefile changes
Date: Fri, 24 May 2013 14:35:03 +0200
Message-Id: <1369398928-9809-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
this patchset mostly consists of moving the config 'CHK'
stuff into config/Makefile which will be also used for
kbuild afterwards.

I'm sending now just the Makefile changes separated from
the kbuild stuff, which will come later.

The original RFC is here:
http://marc.info/?l=linux-kernel&m=136484403415600&w=2

The v2 is in here:
http://marc.info/?l=linux-kernel&m=136679633709975&w=2

The patchset is tested via automated make test by running:
  $ make -f tests/make 

v3 changes:
  - tests/make changes suggested by Nmahyung
  - typo fixes suggested by David
  - patch 2 already merged

v2 changes:
  - adding make clean all support (and test)
  - de-CAPSizing the test/make test
  - several line breaking changes, ommiting usage of '\'
  - '?=' operator removal for STRIP
  - tabs to spaces conversion for Makefile non-commands lines

Changes could be reached in here:
git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
perf/core_make

thanks for comments,
jirka

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Stephane Eranian <eranian@google.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: David Ahern <dsahern@gmail.com>
---
Jiri Olsa (25):
      perf tools: Add automated make test suite
      perf tools: Move arch check into config/Makefile
      perf tools: Move programs check into config/Makefile
      perf tools: Move compiler and linker flags check into config/Makefile
      perf tools: Move libelf check config into config/Makefile
      perf tools: Move libdw check config into config/Makefile
      perf tools: Move libunwind check config into config/Makefile
      perf tools: Move libaudit check config into config/Makefile
      perf tools: Move slang check config into config/Makefile
      perf tools: Move gtk2 check config into config/Makefile
      perf tools: Move libperl check config into config/Makefile
      perf tools: Move libpython check config into config/Makefile
      perf tools: Move libbfd check config into config/Makefile
      perf tools: Move stdlib check config into config/Makefile
      perf tools: Move libnuma check config into config/Makefile
      perf tools: Move paths config into config/Makefile
      perf tools: Final touches for CHK config move
      perf tools: Merge all *CFLAGS* make variable into CFLAGS
      perf tools: Merge all *LDFLAGS* make variable into LDFLAGS
      perf tools: Switch to full path C include directories
      perf tools: Add NO_BIONIC variable to confiure bionic setup
      perf tools: Replace tabs with spaces for all non-commands statements
      perf tools: Replace multiple line assignment with multiple statements
      perf tools: Remove '?=' Makefile STRIP assignment
      perf tools: Add missing liblk.a dependency for python/perf.so

 tools/perf/Makefile        | 630 ++++++++++++++++++--------------------------------------------------------------------------------------
 tools/perf/config/Makefile | 477 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/tests/make      | 138 +++++++++++++++++++++++
 tools/perf/util/setup.py   |   5 +-
 4 files changed, 728 insertions(+), 522 deletions(-)
 create mode 100644 tools/perf/config/Makefile
 create mode 100644 tools/perf/tests/make
