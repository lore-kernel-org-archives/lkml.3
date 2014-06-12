Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506AbaFLUz5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 16:55:57 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:42859 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbaFLUz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 16:55:56 -0400
MIME-Version: 1.0
In-Reply-To: <1402587045-5461-1-git-send-email-jolsa@kernel.org>
References: <1402587045-5461-1-git-send-email-jolsa@kernel.org>
Date: Thu, 12 Jun 2014 22:55:55 +0200
Message-ID: <CAFrcx1me4uOBX89nfjfzLpA13=2wVpyyjOEvM61k6QAhQwUZEQ@mail.gmail.com>
Subject: Re: [GIT PULL 00/14] perf/core improvements and fixes
From: Jean Pihet <jean.pihet@linaro.org>
To: Jiri Olsa <jolsa@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,


On 12 June 2014 17:30, Jiri Olsa <jolsa@kernel.org> wrote:
> hi Ingo,
> please consider pulling
>
> thanks,
> jirka
>
> The following changes since commit 7184062b94b4bfac08715fb786fd2df399c5d6ee:
>
>   Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/core (2014-06-12 13:54:42 +0200)
>
> are available in the git repository at:
>
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git tags/perf-core-for-mingo
>
> for you to fetch changes up to 45dc1bb5c1d47f9519e2101f6b073bb4bb1d1f99:
>
>   perf tests: Add test for closing dso objects on EMFILE error (2014-06-12 16:53:23 +0200)
>
> ----------------------------------------------------------------
> perf/core improvements and fixes:
>
> . Honor user freq/interval properly in record command (Namhyung Kim)
>
> . Speedup DWARF unwind (Jiri Olsa)
Here are the results of the performance assessment on ARMv7, FWIW:

The results for unwind_speedup (v4) on ARMv7 are:
- libunwind: between -17% in execution time for light load (i.e. using
not-so-deep backtraces from the stress app.) and -25% for deep
backtrace (the stress_bt app.),
- libdw: no significant improvement (0-3% improvement).

The results for unwind_speedup (v3) on ARMv7 are:
- libunwind: between -29% in execution time for light load (i.e. using
not-so-deep backtraces from the stress app.) and -49% for deep
backtrace (the stress_bt app.),
- libdw: no significant improvement (0-2% improvement).

Note: v3 is faster than v4 by 13-25%, with and without the speed-up
patches. The real cause has been investigated, yet.

Cf. https://wiki.linaro.org/LEG/Engineering/TOOLS/perf-callstack-unwinding#Speed_improvement
for the details.

Regards,
Jean

>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
>
> ----------------------------------------------------------------
> Jiri Olsa (13):
>       perf tools: Cache register accesses for unwind processing
>       perf tools: Separate dso data related variables
>       perf tools: Add data_fd into dso object
>       perf tools: Add global list of opened dso objects
>       perf tools: Add global count of opened dso objects
>       perf tools: Cache dso data file descriptor
>       perf tools: Add file size check and factor dso__data_read_offset
>       perf tools: Allow to close dso fd in case of open failure
>       perf tools: Add dso__data_* interface descriptons
>       perf tests: Spawn child for each test
>       perf tests: Allow reuse of test_file function
>       perf tests: Add test for caching dso file descriptors
>       perf tests: Add test for closing dso objects on EMFILE error
>
> Namhyung Kim (1):
>       perf record: Fix to honor user freq/interval properly
>
>  tools/perf/tests/builtin-test.c    |  42 +++++-
>  tools/perf/tests/dso-data.c        | 214 +++++++++++++++++++++++++++-
>  tools/perf/tests/tests.h           |   2 +
>  tools/perf/util/dso.c              | 279 +++++++++++++++++++++++++++++++++----
>  tools/perf/util/dso.h              |  50 ++++++-
>  tools/perf/util/event.h            |   5 +
>  tools/perf/util/evsel.c            |   4 +-
>  tools/perf/util/perf_regs.c        |  10 +-
>  tools/perf/util/perf_regs.h        |   4 +-
>  tools/perf/util/unwind-libunwind.c |   2 -
>  10 files changed, 574 insertions(+), 38 deletions(-)
