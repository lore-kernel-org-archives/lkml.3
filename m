Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326AbbABPhh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 10:37:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44777 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752304AbbABPhe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 10:37:34 -0500
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Adrian Hunter <adrian.hunter@intel.com>,
        Alexis Berlemont <alexis.berlemont@gmail.com>,
        Andi Kleen <ak@linux.intel.com>, Anton Blanchard <anton@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Borislav Petkov <bp@suse.de>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Florian Fainelli <florian@openwrt.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Mark Salter <msalter@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
        Stephane Eranian <eranian@google.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [RFC/PATCHSET 00/30] perf tools: New build framework
Date: Fri,  2 Jan 2015 16:35:42 +0100
Message-Id: <1420212972-21595-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
I'm following up on latest post from Alexis:
  http://marc.info/?l=linux-kernel&m=141427580405357&w=2

Since it's actually small portion of kbuild that perf needs,
I realized it's actually better to steal it than 'reconfigure'
kbuild to be usable for perf.

Also this patchset is kind of incremental version of the latest:
  perf tools: Add kbuild support into Makefile.kbuild
so it should be easier to review.

NOTE I couldn't find any copyright/credit messages in the kbuild
system, but would be happy to include it if someone suggests one.

The stolen parts are in files:
  Makefile.kbuild
  Build.include

The idea and more details are explained in the 'Documentation/Build'
file. The basic idea is the same as in kbuild system, with some minor
changes to allow for multiple binaries build definitions.

User provides 'Build' files with objects definitions like:
  perf-y += perf.o
  perf-y += builtin-bench.o
  ...

  libperf-y += util/
  ...

and the build framework outputs files:
  perf-in.o
  libperf-in.o

which are then linked into appropriate binaries/libraries.
(perf libperf.a libperf-gtk.so)


This patchset does not include the user configuration changes
support (which is the ultimate goal), but last 2 patches shows
how easy it's now to disable some parts of the perf code:
      perf tools: Add support to configure builtin commands inclusion
      perf tools: Disable test code

Also now we have the full dependency check ((gcc -Wp,-MD,... stuff) and
build command line is stored/checked automatically by the build system.

The patchset is also available in:
  git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
  perf/build

All tests/make tests pass. I tested only x86_64 arch.. any
feedback from other archs would be great ;-)

thanks for comments,
jirka


Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexis Berlemont <alexis.berlemont@gmail.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Anton Blanchard <anton@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Borislav Petkov <bp@suse.de>
Cc: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Florian Fainelli <florian@openwrt.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Mark Salter <msalter@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Will Deacon <will.deacon@arm.com>
---
Jiri Olsa (30):
      perf tools: Add new build framework support
      perf build: Add detected config framework support
      perf build: Add subdir framework support
      perf build: Add bench objects building
      perf build: Add tests objects building
      perf build: Add builtin objects building
      perf build: Add libperf objects building
      perf build: Add probe objects building
      perf build: Add dwarf objects building
      perf build: Add dwarf unwind objects building
      perf build: Add ui objects building
      perf build: Add slang objects building
      perf build: Add gtk objects building
      perf build: Add scripts objects building
      perf build: Add perf regs objects building
      perf build: Add zlib objects building
      perf build: Add perf.o object building
      perf build: Add arch x86 objects building
      perf build: Add arch arm objects building
      perf build: Add arch arm64 objects building
      perf build: Add arch powerpc objects building
      perf build: Add arch s390 objects building
      perf build: Add arch sh objects building
      perf build: Add arch sparc objects building
      perf build: Add single target build framework support
      perf make: Remove directory dependency rules
      perf make: Remove uneeded variables
      perf make: Remove PERF-CFLAGS file
      perf tools: Add support to configure builtin commands inclusion
      perf tools: Disable test code

 tools/perf/Build                                |  48 ++
 tools/perf/Build.include                        |  75 ++++
 tools/perf/Documentation/Build                  | 123 +++++
 tools/perf/Makefile.build                       | 122 +++++
 tools/perf/Makefile.perf                        | 566 +++---------------------
 tools/perf/arch/Build                           |   2 +
 tools/perf/arch/arm/Build                       |   2 +
 tools/perf/arch/arm/Makefile                    |  11 -
 tools/perf/arch/arm/tests/Build                 |   2 +
 tools/perf/arch/arm/util/Build                  |   4 +
 tools/perf/arch/arm64/Build                     |   3 +
 tools/perf/arch/arm64/Makefile                  |   4 -
 tools/perf/arch/arm64/util/Build                |   2 +
 tools/perf/arch/powerpc/Build                   |   1 +
 tools/perf/arch/powerpc/Makefile                |   3 -
 tools/perf/arch/powerpc/util/Build              |   4 +
 tools/perf/arch/s390/Build                      |   1 +
 tools/perf/arch/s390/Makefile                   |   3 -
 tools/perf/arch/s390/util/Build                 |   4 +
 tools/perf/arch/sh/Build                        |   1 +
 tools/perf/arch/sh/Makefile                     |   1 -
 tools/perf/arch/sh/util/Build                   |   1 +
 tools/perf/arch/sparc/Build                     |   1 +
 tools/perf/arch/sparc/Makefile                  |   1 -
 tools/perf/arch/sparc/util/Build                |   1 +
 tools/perf/arch/x86/Build                       |   2 +
 tools/perf/arch/x86/Makefile                    |  15 -
 tools/perf/arch/x86/tests/Build                 |   2 +
 tools/perf/arch/x86/util/Build                  |   8 +
 tools/perf/bench/Build                          |  11 +
 tools/perf/builtin-cmds.h                       |  29 ++
 tools/perf/builtin-help.c                       |   1 +
 tools/perf/config.default                       |  23 +
 tools/perf/config/Makefile                      |  43 ++
 tools/perf/perf-sys.h                           |   2 +-
 tools/perf/perf.c                               |   5 +
 tools/perf/scripts/Build                        |   2 +
 tools/perf/scripts/perl/Perf-Trace-Util/Build   |   3 +
 tools/perf/scripts/python/Perf-Trace-Util/Build |   3 +
 tools/perf/tests/Build                          |  43 ++
 tools/perf/ui/Build                             |  14 +
 tools/perf/ui/browsers/Build                    |  10 +
 tools/perf/ui/gtk/Build                         |   9 +
 tools/perf/ui/tui/Build                         |   4 +
 tools/perf/util/Build                           | 137 ++++++
 tools/perf/util/generate-cmdlist.sh             |  10 +
 tools/perf/util/scripting-engines/Build         |   6 +
 47 files changed, 827 insertions(+), 541 deletions(-)
 create mode 100644 tools/perf/Build
 create mode 100644 tools/perf/Build.include
 create mode 100644 tools/perf/Documentation/Build
 create mode 100644 tools/perf/Makefile.build
 create mode 100644 tools/perf/arch/Build
 create mode 100644 tools/perf/arch/arm/Build
 create mode 100644 tools/perf/arch/arm/tests/Build
 create mode 100644 tools/perf/arch/arm/util/Build
 create mode 100644 tools/perf/arch/arm64/Build
 create mode 100644 tools/perf/arch/arm64/util/Build
 create mode 100644 tools/perf/arch/powerpc/Build
 create mode 100644 tools/perf/arch/powerpc/util/Build
 create mode 100644 tools/perf/arch/s390/Build
 create mode 100644 tools/perf/arch/s390/util/Build
 create mode 100644 tools/perf/arch/sh/Build
 create mode 100644 tools/perf/arch/sh/util/Build
 create mode 100644 tools/perf/arch/sparc/Build
 create mode 100644 tools/perf/arch/sparc/util/Build
 create mode 100644 tools/perf/arch/x86/Build
 create mode 100644 tools/perf/arch/x86/tests/Build
 create mode 100644 tools/perf/arch/x86/util/Build
 create mode 100644 tools/perf/bench/Build
 create mode 100644 tools/perf/builtin-cmds.h
 create mode 100644 tools/perf/config.default
 create mode 100644 tools/perf/scripts/Build
 create mode 100644 tools/perf/scripts/perl/Perf-Trace-Util/Build
 create mode 100644 tools/perf/scripts/python/Perf-Trace-Util/Build
 create mode 100644 tools/perf/tests/Build
 create mode 100644 tools/perf/ui/Build
 create mode 100644 tools/perf/ui/browsers/Build
 create mode 100644 tools/perf/ui/gtk/Build
 create mode 100644 tools/perf/ui/tui/Build
 create mode 100644 tools/perf/util/Build
 create mode 100644 tools/perf/util/scripting-engines/Build
