Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759500Ab3DATUZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 15:20:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20642 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759370Ab3DATUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 15:20:22 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        Stephane Eranian <eranian@google.com>
Subject: [RFC 00/27] perf tools: Build changes and kbuild support
Date: Mon,  1 Apr 2013 21:18:23 +0200
Message-Id: <1364843930-17974-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
sending RFC for build changes and kbuild support.

The build changes mostly consists of separating the config
stuff into config/Makefile which is then used for kbuild.

I kept the original/current Makefile in place and put
the kbuild support into Makefile.kbuild. The final touch
would be to move Makefile.kbuild into Makefile. I kept
the original one to have easy way of testing the old
system.

To run the kbuild make:
  $ make -f Makefile.kbuild

In pristine tree above command behaves as the current
Makefile - does the system checks and builds perf.

After that '.config' and '.config-detected' files
are created and managed as explained in last patch
of this set.

It's published in:
git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
perf/kbuild7

I tested this so far on x86_64.

I'm CC-ing Michal Marek and linux-kbuild list on kbuild patches.

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
Cc: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org
Cc: Stephane Eranian <eranian@google.com>
---
Jiri Olsa (27):
      perf tools: Add automated make test suite
      perf tools: Fix tab vs spaces issue in Makefile ifdef/endif
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
      perf tools: Switch to full patch C include directories
      perf tools: Add NO_BIONIC variable to confiure bionic setup
      kbuild: Introduce KBUILD_AUTOCONF variable for auto.conf include
      kbuild: Introduce KCONFIG_AUTOCONFIGDEP variable for conf tool
      perf tools: Kbuild builtin source related fixies
      perf tools: Kbuild source related fixies
      perf tools: Add kbuild support into Makefile.kbuild

 scripts/Makefile.build                           |   3 +-
 scripts/kconfig/confdata.c                       |  11 +-
 scripts/kconfig/lkc.h                            |   1 +
 tools/perf/Kbuild                                |  47 ++
 tools/perf/Kconfig                               | 256 ++++++++++
 tools/perf/Makefile                              | 598 ++++-------------------
 tools/perf/Makefile.kbuild                       | 411 ++++++++++++++++
 tools/perf/arch/Kbuild                           |   3 +
 tools/perf/arch/x86/Kbuild                       |   1 +
 tools/perf/arch/x86/util/Kbuild                  |   3 +
 tools/perf/bench/Kbuild                          |   9 +
 tools/perf/builtin-cmds.h                        |  31 ++
 tools/perf/builtin-help.c                        |   1 +
 tools/perf/builtin-lock.c                        |   2 +
 tools/perf/builtin-report.c                      |   9 +-
 tools/perf/builtin-sched.c                       |   2 +
 tools/perf/config/Makefile                       | 528 ++++++++++++++++++++
 tools/perf/config/Makefile.fix-config            | 104 ++++
 tools/perf/config/Makefile.fix-legacy            |  46 ++
 tools/perf/config/defconfig                      |  54 ++
 tools/perf/perf.c                                |  51 +-
 tools/perf/perf.h                                |   2 +
 tools/perf/scripts/perl/Perf-Trace-Util/Kbuild   |   3 +
 tools/perf/scripts/python/Perf-Trace-Util/Kbuild |   4 +
 tools/perf/tests/Kbuild                          |  23 +
 tools/perf/tests/make                            | 122 +++++
 tools/perf/ui/Kbuild                             |  14 +
 tools/perf/ui/browsers/Kbuild                    |   6 +
 tools/perf/ui/browsers/scripts.c                 |   4 +
 tools/perf/ui/gtk/Kbuild                         |   7 +
 tools/perf/ui/setup.c                            |  10 +-
 tools/perf/ui/stdio/Kbuild                       |   1 +
 tools/perf/ui/tui/Kbuild                         |   4 +
 tools/perf/util/Kbuild                           | 113 +++++
 tools/perf/util/PERF-VERSION-GEN                 |   6 +-
 tools/perf/util/generate-cmdlist.sh              |  18 +-
 tools/perf/util/scripting-engines/Kbuild         |   7 +
 tools/perf/util/setup.py                         |  12 +-
 38 files changed, 2002 insertions(+), 525 deletions(-)
 create mode 100644 tools/perf/Kbuild
 create mode 100644 tools/perf/Kconfig
 create mode 100644 tools/perf/Makefile.kbuild
 create mode 100644 tools/perf/arch/Kbuild
 create mode 100644 tools/perf/arch/x86/Kbuild
 create mode 100644 tools/perf/arch/x86/util/Kbuild
 create mode 100644 tools/perf/bench/Kbuild
 create mode 100644 tools/perf/builtin-cmds.h
 create mode 100644 tools/perf/config/Makefile
 create mode 100644 tools/perf/config/Makefile.fix-config
 create mode 100644 tools/perf/config/Makefile.fix-legacy
 create mode 100644 tools/perf/config/defconfig
 create mode 100644 tools/perf/scripts/perl/Perf-Trace-Util/Kbuild
 create mode 100644 tools/perf/scripts/python/Perf-Trace-Util/Kbuild
 create mode 100644 tools/perf/tests/Kbuild
 create mode 100644 tools/perf/tests/make
 create mode 100644 tools/perf/ui/Kbuild
 create mode 100644 tools/perf/ui/browsers/Kbuild
 create mode 100644 tools/perf/ui/gtk/Kbuild
 create mode 100644 tools/perf/ui/stdio/Kbuild
 create mode 100644 tools/perf/ui/tui/Kbuild
 create mode 100644 tools/perf/util/Kbuild
 create mode 100644 tools/perf/util/scripting-engines/Kbuild
