Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330AbaIIE7V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 00:59:21 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:40895 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbaIIE7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 00:59:19 -0400
Date: Tue, 9 Sep 2014 06:59:14 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>, Jiri Olsa <jolsa@redhat.com>,
        Kyle McMartin <kyle@mcmartin.ca>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 00/13] perf/core improvements and fixes
Message-ID: <20140909045914.GA6770@gmail.com>
References: <1410211089-28668-1-git-send-email-acme@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410211089-28668-1-git-send-email-acme@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@kernel.org> wrote:

> Hi Ingo,
> 
> 	Please consider pulling,
> 
> - Arnaldo
> 
> The following changes since commit 39b5a56ec0be5effe9b7d0f18cb27724bf2e5d47:
> 
>   Merge branch 'rfc/perf' into perf/core, because it's ready for inclusion (2014-08-24 22:35:42 +0200)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git tags/perf-core-for-mingo
> 
> for you to fetch changes up to fa3480cb0a96c8af9ded1a8c836c91bd5704bda1:
> 
>   perf tools: Add perf_pmu__scan_file() (2014-09-08 17:16:06 -0300)
> 
> ----------------------------------------------------------------
> perf/core improvements and fixes:
> 
> User visible:
> 
> o Add +field argument support for --sort option (Jiri Olsa)
> 
> Infrastructure:
> 
> o More intel PT prep work, from Adrian Hunter, including:
> 
>   - Let a user specify a PMU event without any config terms
>   - Add perf-with-kcore script
>   - Build programs to copy 32-bit compatibility VDSOs
>   - Add support for 32-bit compatibility VDSOs
>   - Let default config be defined for a PMU
>   - Add perf_pmu__scan_file()
> 
> o Add feature checks to .gitignore (Alexander Shishkin)
> 
> o "perf kvm stat report" improvements by Alexander Yarygin:
>   o  Save pid string in opts.target.pid
>   o  Enable the target.system_wide flag
>   o  Unify the title bar output
> 
> o Fix build issue on powerpc when DWARF support is disabled (Anton Blanchard)
> 
> o Allow to specify lib compile variable for spec usage (Jiri Olsa)
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Adrian Hunter (6):
>       perf tools: Let a user specify a PMU event without any config terms
>       perf tools: Add perf-with-kcore script
>       perf tools: Build programs to copy 32-bit compatibility VDSOs
>       perf tools: Add support for 32-bit compatibility VDSOs
>       perf tools: Let default config be defined for a PMU
>       perf tools: Add perf_pmu__scan_file()
> 
> Alexander Shishkin (1):
>       perf tools: Add feature checks to .gitignore
> 
> Alexander Yarygin (3):
>       perf kvm stat report: Save pid string in opts.target.pid
>       perf kvm stat report: Enable the target.system_wide flag
>       perf kvm stat report: Unify the title bar output
> 
> Anton Blanchard (1):
>       perf tools powerpc: Fix build issue when DWARF support is disabled
> 
> Jiri Olsa (2):
>       perf tools: Add +field argument support for --sort option
>       perf tools: Allow to specify lib compile variable for spec usage
> 
>  tools/perf/.gitignore            |   2 +
>  tools/perf/Makefile.perf         |  42 ++++++-
>  tools/perf/arch/powerpc/Makefile |   2 +-
>  tools/perf/builtin-kvm.c         |  23 ++--
>  tools/perf/config/Makefile       |  33 ++++-
>  tools/perf/config/Makefile.arch  |   8 ++
>  tools/perf/perf-read-vdso.c      |  59 +++++++++
>  tools/perf/perf-with-kcore.sh    | 259 +++++++++++++++++++++++++++++++++++++++
>  tools/perf/tests/pmu.c           |   2 +-
>  tools/perf/util/kvm-stat.h       |   1 -
>  tools/perf/util/parse-events.c   |  13 +-
>  tools/perf/util/parse-events.y   |  10 ++
>  tools/perf/util/pmu.c            |  79 +++++++++---
>  tools/perf/util/pmu.h            |  12 +-
>  tools/perf/util/sort.c           |  37 +++++-
>  tools/perf/util/vdso.c           | 170 ++++++++++++++++++++++++-
>  tools/perf/util/vdso.h           |   4 +-
>  17 files changed, 712 insertions(+), 44 deletions(-)
>  create mode 100644 tools/perf/perf-read-vdso.c
>  create mode 100644 tools/perf/perf-with-kcore.sh

Hm, so I'm getting this error, when trying to profile a 32-bit 
ELF binary on a 64-bit kernel, on a testbox:

 $ perf record ~/hackbench  10
 Time: 0.115
 [ perf record: Woken up 1 times to write data ]
 [ perf record: Captured and wrote 0.373 MB perf.data (~16279 samples) ]
 sh: perf-read-vdso32: command not found

comet:~/tip> file ~/hackbench 
/home/mingo/hackbench: ELF 32-bit LSB executable, Intel 80386, version 1 (SYSV), dynamically linked (uses shared libs), for GNU/Linux 2.2.5, not stripped

64-bit executables work fine:

 $ perf record perf bench sched pipe
 # Running 'sched/pipe' benchmark:
 # Executed 1000000 pipe operations between two processes

      Total time: 13.374 [sec]

       13.374352 usecs/op
           74769 ops/sec
 [ perf record: Woken up 14 times to write data ]
 [ perf record: Captured and wrote 3.602 MB perf.data (~157354 samples) ]

The kernel is an older one:

 $ uname -a
 Linux comet 3.14.17-100.fc19.x86_64 #1 SMP Thu Aug 14 17:17:26 
 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux

Thanks,

	Ingo
