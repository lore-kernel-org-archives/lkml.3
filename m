Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262AbbAQKGz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 05:06:55 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:46495 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbbAQKGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 05:06:50 -0500
Date: Sat, 17 Jan 2015 11:06:45 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Alexey Brodkin <abrodkin@synopsys.com>, Borislav Petkov <bp@suse.de>,
        Cody P Schafer <dev@codyps.com>, David Ahern <dsahern@gmail.com>,
        Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jan Beulich <JBeulich@suse.com>, Jiri Olsa <jolsa@redhat.com>,
        Li Zefan <lizefan@huawei.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Michael Ellerman <mpe@ellerman.id.au>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Vineet Gupta <vgupta@synopsys.com>, Wang Nan <wangnan0@huawei.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 00/10] perf/urgent fixes
Message-ID: <20150117100645.GA14534@gmail.com>
References: <1421443362-10709-1-git-send-email-acme@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421443362-10709-1-git-send-email-acme@kernel.org>
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
> The following changes since commit 33636732dcd7cc738a5913bb730d663c6b03c8fb:
> 
>   perf/x86/intel: Fix bug for "cycles:p" and "cycles:pp" on SLM (2015-01-16 09:06:59 +0100)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git tags/perf-urgent-for-mingo
> 
> for you to fetch changes up to 6bcf9c1ff3ec22fd81eba336737d9865476509b1:
> 
>   perf tools powerpc: Use dwfl_report_elf() instead of offline. (2015-01-16 17:49:30 -0300)
> 
> ----------------------------------------------------------------
> perf/urgent fixes:
> 
> User visible:
> 
> - Fix segfault when using both the map symtab viewer and annotation
>   in the TUI (Namhyung Kim).
> 
> Developer stuff:
> 
> - uClibc build fixes (Alexey Brodkin, Vineet Gupta).
> 
> - bitops/hweight were moved from tools/perf/ too tools/include, move
>   some leftovers (Arnaldo Carvalho de Melo)
> 
> - Fix dwarf unwind x86_64 build error (Namhyung Kim)
> 
> - Fix __machine__findnew_thread() error path (Namhyung Kim)
> 
> - Propagate error code when write(2) failed in 'perf probe' (Namhyung Kim)
> 
> - Use dwfl_report_elf() instead of offline in powerpc bits to
>   properly handle non prelinked DSOs (Sukadev Bhattiprolu).
> 
> - Fix dwarf unwind using libunwind in 'perf test' (Wang Nan)
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Alexey Brodkin (1):
>       perf tools: Fix statfs.f_type data type mismatch build error with uclibc
> 
> Arnaldo Carvalho de Melo (1):
>       tools: Remove bitops/hweight usage of bits in tools/perf
> 
> Namhyung Kim (4):
>       perf probe: Propagate error code when write(2) failed
>       perf tools: Fix building error in x86_64 when dwarf unwind is on
>       perf machine: Fix __machine__findnew_thread() error path
>       perf tools: Fix segfault for symbol annotation on TUI
> 
> Sukadev Bhattiprolu (1):
>       perf tools powerpc: Use dwfl_report_elf() instead of offline.
> 
> Vineet Gupta (2):
>       perf tools: Elide strlcpy warning with uclibc
>       perf tools: Avoid build splat for syscall numbers with uclibc
> 
> Wang Nan (1):
>       perf test: Fix dwarf unwind using libunwind.
> 
>  tools/include/asm-generic/bitops.h                |  2 ++
>  tools/include/asm-generic/bitops/arch_hweight.h   |  1 +
>  tools/include/asm-generic/bitops/const_hweight.h  |  1 +
>  tools/include/asm-generic/bitops/hweight.h        |  7 +++++
>  tools/include/linux/bitops.h                      |  7 ++++-
>  tools/lib/api/fs/debugfs.c                        |  2 +-
>  tools/lib/api/fs/fs.c                             |  2 +-
>  tools/perf/MANIFEST                               |  6 ++++
>  tools/perf/Makefile.perf                          | 11 +++++--
>  tools/perf/arch/powerpc/util/skip-callchain-idx.c | 19 +++++++-----
>  tools/perf/bench/sched-pipe.c                     |  2 +-
>  tools/perf/builtin-top.c                          |  1 -
>  tools/perf/config/Makefile                        |  2 +-
>  tools/perf/config/Makefile.arch                   | 26 ++++++++--------
>  tools/perf/perf-sys.h                             |  1 -
>  tools/perf/tests/dwarf-unwind.c                   | 36 +++++++++++++++++++++--
>  tools/perf/util/annotate.h                        |  8 +----
>  tools/perf/util/cache.h                           |  2 ++
>  tools/perf/util/hweight.c                         | 31 -------------------
>  tools/perf/util/include/asm/hweight.h             |  8 -----
>  tools/perf/util/machine.c                         |  4 ++-
>  tools/perf/util/probe-event.c                     |  4 ++-
>  tools/perf/util/python-ext-sources                |  2 +-
>  tools/perf/util/unwind-libunwind.c                | 28 +++++++++++++++++-
>  24 files changed, 131 insertions(+), 82 deletions(-)
>  create mode 100644 tools/include/asm-generic/bitops/arch_hweight.h
>  create mode 100644 tools/include/asm-generic/bitops/const_hweight.h
>  create mode 100644 tools/include/asm-generic/bitops/hweight.h
>  delete mode 100644 tools/perf/util/hweight.c
>  delete mode 100644 tools/perf/util/include/asm/hweight.h

Pulled, thanks a lot Arnaldo!

	Ingo
