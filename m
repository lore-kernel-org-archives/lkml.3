Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab3IYS27 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 14:28:59 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:38839 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab3IYS26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 14:28:58 -0400
Date: Wed, 25 Sep 2013 20:28:54 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 0/6] perf/urgent fixes
Message-ID: <20130925182854.GC16693@gmail.com>
References: <1380129628-16808-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380129628-16808-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> 
> Hi Ingo,
> 
> 	Please consider pulling,
> 
> - Arnaldo
> 
> The following changes since commit cf3b425dd8d99e01214515a6754f9e69ecc6dce8:
> 
>   perf/x86/intel: Add model number for Avoton Silvermont (2013-09-23 10:22:00 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-urgent-for-mingo
> 
> for you to fetch changes up to de95ab53645a2f0015e0f68ee723f18dce2b8b51:
> 
>   perf symbols: Demangle cloned functions (2013-09-25 12:58:21 -0300)
> 
> ----------------------------------------------------------------
> perf/urgent fixes:
> 
> . It was possible to use an uninitialized buffer when reading
>   kernel modules information and checking if the file was a
>   /proc/sys/kernel/kptr_restrict'ed one, fix for this from
>   Adrian Hunter.
> 
> . The libbfd demangler doesn't handle cloned functions (e.g. symbol.clone.NUM),
>   feed it unsuffixed symbol names, workaround from Andi Kleen.
> 
> . Fix segfault in 'perf trace' when processing perf.data files with PERF_RECORD_MMAP2
>   records, recently added but not handled in this tool, from David Ahern.
> 
> . Fix libdl related build in old systems like Fedora 12, from David Ahern.
> 
> . Make 'perf kmem' work again on non NUMA machines, fix from Jiri Olsa.
> 
> . Fix probing symbols with optimization suffix in 'perf probe' where some
>   operations that are entirely user level and involves vmlinux/DWARF were working
>   but when the symbol name was fed to the kprobes tracer, the in kernel code
>   would use /proc/kallsyms where the name had the suffix, from Masami Hiramatsu.
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Adrian Hunter (1):
>       perf machine: Fix path unpopulated in machine__create_modules()
> 
> Andi Kleen (1):
>       perf symbols: Demangle cloned functions
> 
> David Ahern (2):
>       perf trace: Add mmap2 handler
>       perf tools: Explicitly add libdl dependency
> 
> Jiri Olsa (1):
>       perf kmem: Make it work again on non NUMA machines
> 
> Masami Hiramatsu (1):
>       perf probe: Fix probing symbols with optimization suffix
> 
>  tools/perf/builtin-kmem.c      |  2 +-
>  tools/perf/builtin-trace.c     |  1 +
>  tools/perf/config/Makefile     |  2 +-
>  tools/perf/util/machine.c      |  2 +-
>  tools/perf/util/probe-finder.c | 77 ++++++++++++++++++++++--------------------
>  tools/perf/util/probe-finder.h |  3 ++
>  tools/perf/util/symbol-elf.c   | 27 ++++++++++++++-
>  7 files changed, 74 insertions(+), 40 deletions(-)

Pulled, thanks a lot Arnaldo!

	Ingo
