Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071AbaB0MDc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 07:03:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41495 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751573AbaB0MDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 07:03:31 -0500
Date: Thu, 27 Feb 2014 13:02:28 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 00/12] perf/core improvements and fixes
Message-ID: <20140227120227.GC9614@krava.brq.redhat.com>
References: <1393271800-17505-1-git-send-email-acme@infradead.org>
 <20140227114658.GA26449@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140227114658.GA26449@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 12:46:58PM +0100, Ingo Molnar wrote:
> 
> * Arnaldo Carvalho de Melo <acme@infradead.org> wrote:
> 
> > From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> > 
> > Hi Ingo,
> > 
> > 	Please consider pulling,
> > 
> > - Arnaldo
> > 
> > The following changes since commit 7e74efcf76c16f851df5c838c143c4a1865ea9fa:
> > 
> >   Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/core (2014-02-22 17:26:24 +0100)
> > 
> > are available in the git repository at:
> > 
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo
> > 
> > for you to fetch changes up to 1029f9fedf87fa6f52096991588fa54ffd159584:
> > 
> >   perf symbols: Check compatible symtab type before loading dso (2014-02-24 16:25:01 -0300)
> > 
> > ----------------------------------------------------------------
> > perf/core improvements and fixes
> > 
> > . Add support for the new DWARF unwinder library in elfutils (Jiri Olsa)
> > 
> > . Fix build race in the generation of bison files (Jiri Olsa)
> > 
> > . Further streamline the feature detection display, trimming it a bit to
> >   show just the libraries detected, using VF=1 gets a more verbose output,
> >   showing the less interesting feature checks as well (Jiri Olsa).
> > 
> > . Check compatible symtab type before loading dso (Namhyung Kim)
> > 
> > . Check return value of filename__read_debuglink() (Stephane Eranian)
> > 
> > Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> > 
> > ----------------------------------------------------------------
> > Arnaldo Carvalho de Melo (1):
> >       perf tools: Warn the user about how to enable libunwind support
> > 
> > Jiri Olsa (9):
> >       perf tests: Fix *.o make tests
> >       perf tests: Add pmu-bison.o make test
> >       perf tools: Fix bison OUTPUT directories dependency
> >       perf tools: Factor features display code
> >       perf tools: Add variable display for VF make output
> >       perf tools: Add feature check for libdw dwarf unwind
> >       perf tools: Add libdw DWARF post unwind support
> >       perf tools: Setup default dwarf post unwinder
> >       perf tests: Add NO_LIBDW_DWARF_UNWIND make test
> > 
> > Namhyung Kim (1):
> >       perf symbols: Check compatible symtab type before loading dso
> > 
> > Stephane Eranian (1):
> >       perf symbols: Check return value of filename__read_debuglink()
> > 
> >  tools/perf/Makefile.perf                           |  24 ++-
> >  tools/perf/arch/x86/Makefile                       |   5 +
> >  tools/perf/arch/x86/util/unwind-libdw.c            |  51 +++++
> >  tools/perf/config/Makefile                         | 232 +++++++++++++++------
> >  tools/perf/config/feature-checks/Makefile          |   6 +-
> >  tools/perf/config/feature-checks/test-all.c        |   5 +
> >  .../feature-checks/test-libdw-dwarf-unwind.c       |  13 ++
> >  tools/perf/tests/make                              |  25 ++-
> >  tools/perf/util/dso.c                              |   4 +-
> >  tools/perf/util/symbol-elf.c                       |   2 +
> >  tools/perf/util/symbol.c                           |  61 +++++-
> >  tools/perf/util/unwind-libdw.c                     | 210 +++++++++++++++++++
> >  tools/perf/util/unwind-libdw.h                     |  21 ++
> >  13 files changed, 569 insertions(+), 90 deletions(-)
> >  create mode 100644 tools/perf/arch/x86/util/unwind-libdw.c
> >  create mode 100644 tools/perf/config/feature-checks/test-libdw-dwarf-unwind.c
> >  create mode 100644 tools/perf/util/unwind-libdw.c
> >  create mode 100644 tools/perf/util/unwind-libdw.h
> 
> Pulled, thanks a lot Arnaldo!
> 
> Btw., the build output looks weird now - on a system that used to pass 
> all feature tests there's this output:
> 
>   BUILD:   Doing 'make -j12' parallel build
> config/Makefile:288: No libdw DWARF unwind found, Please install 
> elfutils-devel/libdw-dev >= 0.158 and/or set LIBDW_DIR
> 
> Auto-detecting system features:
> ...                         dwarf: [ on  ]
> ...                         glibc: [ on  ]
> ...                          gtk2: [ on  ]
> ...                      libaudit: [ on  ]
> ...                        libbfd: [ on  ]
> ...                        libelf: [ on  ]
> ...                       libnuma: [ on  ]
> ...                       libperl: [ on  ]
> ...                     libpython: [ on  ]
> ...                      libslang: [ on  ]
> ...                     libunwind: [ on  ]
> ...            libdw-dwarf-unwind: [ OFF ]
> ...     DWARF post unwind library: libunwind
> 
> but:
> 
>    Package elfutils-devel-0.156-5.fc19.x86_64 already installed and latest version
> 
> Also, the information content of this line is unclear to me:
> 
> ...     DWARF post unwind library: libunwind
> 
> 
> what does that line want to tell?

this tells what DWARF unwind library is compiled
in.. 'libunwind' in this case

the other choice is 'libdw', which was not detected
in your case (and thats what the 1st message tells you)

we discussed with Arnaldo, that we would not display warnings
for missing features by default.. only tell that there are
missing features and display them for verbose (VF=1) output

jirka
