Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751125AbaLQOul (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 09:50:41 -0500
Received: from mail.kernel.org ([198.145.19.201]:36045 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbaLQOuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 09:50:39 -0500
Date: Wed, 17 Dec 2014 11:50:35 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Borislav Petkov <bp@suse.de>, David Ahern <dsahern@gmail.com>,
        Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>,
        Mitchell Krome <mitchellkrome@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [GIT PULL 00/18] perf/core improvements and fixes
Message-ID: <20141217145035.GE11607@kernel.org>
References: <1418749040-31807-1-git-send-email-acme@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418749040-31807-1-git-send-email-acme@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Dec 16, 2014 at 01:57:02PM -0300, Arnaldo Carvalho de Melo escreveu:
> Hi Ingo,
> 
> 	Please consider pulling,
> 
> - Arnaldo
> 
> The following changes since commit 41e950c033b7df997d4b38653efe6554be9b96a7:
> 
>   Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/urgent (2014-12-12 09:09:52 +0100)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git tags/perf-core-for-mingo

Ingo,

	Please consider pulling the perf-core-for-mingo-2 signed tag
instead, it is exactly the same content modulo removal of some
whitespaces at the end of a few lines in tools/perf/Makefile.perf that
Jiri found while reading those patches,

Thanks,

- Arnaldo
 
> for you to fetch changes up to 67195c75a87232f055ff415fc4624ef01f24fc3d:
> 
>   perf symbols: Fix use after free in filename__read_build_id (2014-12-16 13:38:28 -0300)
> 
> ----------------------------------------------------------------
> perf/core improvements and fixes:
> 
> User visible:
> 
> - The mmap address range for the ring buffer now is calculated using the
>   contents of /proc/sys/kernel/perf_event_mlock_kb.
> 
>   This fixes an -EPERM case where 'trace' was trying to use more than what
>   configured on perf_event_mlock_kb. (Arnaldo Carvalho de Melo)
> 
> Infrastructure:
> 
> - Move bitops definitions so that they match the header file hierarchy
>   in the kernel sources where that code came from. (Arnaldo Carvalho de Melo)
> 
> - Adopt round{down,up}_pow_of_two from the kernel and use it instead of
>   equivalent code, so that we reuse more kernel code and make tools/ look
>   more like kernel source code, to encourage further contributions from
>   kernel hackers (Arnaldo Carvalho de Melo)
> 
> - Fix use after free in filename__read_build_id (Mitchell Krome)
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Arnaldo Carvalho de Melo (17):
>       perf evlist: Fixup brown paper bag on "hint" for --mmap-pages cmdline arg
>       perf evlist: Clarify sterror_mmap variable names
>       perf evlist: Improve the strerror_mmap method
>       perf trace: Let the perf_evlist__mmap autosize the number of pages to use
>       perf evlist: Do not use hard coded value for a mmap_pages default
>       tools: Move __ffs implementation to tools/include/asm-generic/bitops/__ffs.h
>       tools: Move code originally from linux/log2.h to tools/include/linux/
>       tools: Move code originally from asm-generic/atomic.h into tools/include/asm-generic/
>       tools: Whitespace prep patches for moving bitops.h
>       tools lib: Move asm-generic/bitops/find.h code to tools/include and tools/lib
>       tools: Introduce asm-generic/bitops.h
>       tools: Move bitops.h from tools/perf/util to tools/
>       tools: Adopt fls_long and deps
>       tools: Adopt rounddown_pow_of_two and deps
>       perf tools: Make the mmap length autotuning more robust
>       tools: Adopt roundup_pow_of_two
>       perf evlist: Use roundup_pow_of_two
> 
> Mitchell Krome (1):
>       perf symbols: Fix use after free in filename__read_build_id
> 
>  tools/include/asm-generic/bitops.h        |  27 +++++
>  tools/include/asm-generic/bitops/__ffs.h  |  43 +++++++
>  tools/include/asm-generic/bitops/__fls.h  |   1 +
>  tools/include/asm-generic/bitops/atomic.h |  22 ++++
>  tools/include/asm-generic/bitops/find.h   |  33 ++++++
>  tools/include/asm-generic/bitops/fls.h    |   1 +
>  tools/include/asm-generic/bitops/fls64.h  |   1 +
>  tools/include/linux/bitops.h              |  53 +++++++++
>  tools/include/linux/log2.h                | 185 ++++++++++++++++++++++++++++++
>  tools/lib/util/find_next_bit.c            |  89 ++++++++++++++
>  tools/perf/MANIFEST                       |  13 ++-
>  tools/perf/Makefile.perf                  |  14 ++-
>  tools/perf/builtin-trace.c                |   2 +-
>  tools/perf/util/evlist.c                  |  46 ++++++--
>  tools/perf/util/include/linux/bitops.h    | 162 --------------------------
>  tools/perf/util/symbol-minimal.c          |   8 +-
>  tools/perf/util/util.h                    |  29 -----
>  17 files changed, 522 insertions(+), 207 deletions(-)
>  create mode 100644 tools/include/asm-generic/bitops.h
>  create mode 100644 tools/include/asm-generic/bitops/__ffs.h
>  create mode 100644 tools/include/asm-generic/bitops/__fls.h
>  create mode 100644 tools/include/asm-generic/bitops/atomic.h
>  create mode 100644 tools/include/asm-generic/bitops/find.h
>  create mode 100644 tools/include/asm-generic/bitops/fls.h
>  create mode 100644 tools/include/asm-generic/bitops/fls64.h
>  create mode 100644 tools/include/linux/bitops.h
>  create mode 100644 tools/include/linux/log2.h
>  create mode 100644 tools/lib/util/find_next_bit.c
>  delete mode 100644 tools/perf/util/include/linux/bitops.h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
