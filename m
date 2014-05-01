Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182AbaEAG1G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 02:27:06 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:59922 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbaEAG1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 02:27:04 -0400
Date: Thu, 1 May 2014 08:26:59 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jiri Olsa <jolsa@kernel.org>
Cc: Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Borislav Petkov <bp@suse.de>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL 0/6] perf/core improvements and fixes
Message-ID: <20140501062658.GB15071@gmail.com>
References: <1398779270-10271-1-git-send-email-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398779270-10271-1-git-send-email-jolsa@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Olsa <jolsa@kernel.org> wrote:

> hi Ingo,
> please consider pulling
> 
> resending 0/6.. it got lost somehow from previous post..
> 
> thanks,
> jirka
> 
> 
> The following changes since commit 201131998fbf074b03679afedcc29948e63331ef:
> 
>   Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf into perf/core (2014-04-29 08:41:21 +0200)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git tags/perf-core-for-mingo
> 
> for you to fetch changes up to 8ab596afb97bc9e2f9140dc1d993e81749acff42:
> 
>   perf tools ARM64: Wire up perf_regs and unwind support (2014-04-29 15:31:19 +0200)
> 
> ----------------------------------------------------------------
> perf/core improvements and fixes:
> 
> . Wire up perf_regs and unwind support for ARM64 (Jean Pihet)
> 
> . Move u64_swap union to its single user's header, evsel.h (Borislav Petkov)
> 
> . Fix for s390 to properly parse tracepoints plus test code (Alexander Yarygin)
> 
> . Handle EINTR error for readn/writen (Namhyung Kim)
> 
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> 
> ----------------------------------------------------------------
> Alexander Yarygin (3):
>       perf tools: Parse tracepoints with '-' in system name
>       perf tests: Add numeric identifier to evlist_test
>       perf tests: Add a test of kvm-390: trace event
> 
> Borislav Petkov (1):
>       perf tools: Move u64_swap union
> 
> Jean Pihet (1):
>       perf tools ARM64: Wire up perf_regs and unwind support
> 
> Namhyung Kim (1):
>       perf tools: Handle EINTR error for readn/writen
> 
>  tools/perf/arch/arm64/Makefile                |   7 ++
>  tools/perf/arch/arm64/include/perf_regs.h     |  88 ++++++++++++++++
>  tools/perf/arch/arm64/util/dwarf-regs.c       |  80 +++++++++++++++
>  tools/perf/arch/arm64/util/unwind-libunwind.c |  82 +++++++++++++++
>  tools/perf/config/Makefile                    |   8 +-
>  tools/perf/tests/parse-events.c               | 142 ++++++++++++++++++--------
>  tools/perf/util/evsel.h                       |   5 +
>  tools/perf/util/parse-events.y                |  12 +++
>  tools/perf/util/types.h                       |   5 -
>  tools/perf/util/util.c                        |   2 +
>  10 files changed, 380 insertions(+), 51 deletions(-)
>  create mode 100644 tools/perf/arch/arm64/Makefile
>  create mode 100644 tools/perf/arch/arm64/include/perf_regs.h
>  create mode 100644 tools/perf/arch/arm64/util/dwarf-regs.c
>  create mode 100644 tools/perf/arch/arm64/util/unwind-libunwind.c

Pulled, thanks a lot Jiri!

I also merged perf/urgent into perf/core, because a conflict developed 
between the two.

Thanks,

	Ingo
