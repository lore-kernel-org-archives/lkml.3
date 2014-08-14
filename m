Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601AbaHNCXf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 22:23:35 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:52105 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077AbaHNCXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 22:23:33 -0400
Message-ID: <53EC1D9E.1090501@hitachi.com>
Date: Thu, 14 Aug 2014 11:23:26 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Naohiro Aota <naota@elisp.net>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung@kernel.org>
Subject: Re: (ltc-kernel 9923) [PATCH 0/8] perf: Replace strerror with strerror_r
 for thread-safety
References: <20140814022025.3140.33134.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20140814022025.3140.33134.stgit@kbuild-fedora.novalocal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops, this is not a complete series... I'll resend same series.


(2014/08/14 11:20), Masami Hiramatsu wrote:
> Hi,
> 
> Here is a series to get rid of thread-unsafe strerror() from
> perf tools. Of course, there maybe other thread-unsafe functions,
> so this goes just one step forward. :)
> 
> This introduces STRERR_BUFSIZE(=128) macro for allocating local
> buffer, but some strerror_r()s don't use that. If there are
> already a local buffer on the stack, and if it is bigger than
> STRERR_BUFSIZE, I chose it for strerror_r()'s buffer.
> 
> By the way, while doing this cleanup, I've found some confusions
> on the code. Currently perf has 3 ways to output messages except
> for standard (f)printf, pr_XXX, ui__XXX and warning/error functions.
> Is there any differences among those APIs? What is the expected
> use cases for them?
> For example, a pure printf is in kvm_live_open_events@builtin-kvm.c
> but it seems to be ui__error, because the error output next to it
> uses that. However, other parts use pr_XXX too. It seems inconsistent.
> 
> Thank you,
> 
> ---
> 
> Masami Hiramatsu (8):
>       perf probe: Don't use strerror if strlist__add failed
>       perf: Use strerror_r instead of strerror
>       perf probe: Make error messages thread-safe
>       perf/util: Replace strerror with strerror_r for thread-safety
>       perf top: Use strerror_r instead of strerror
>       perf trace: Use strerror_r instead of strerror
>       perf record: Use strerror_r instead of strerror
>       perf test: Use strerror_r instead of strerror
> 
> 
>  tools/perf/builtin-probe.c                |    5 +++-
>  tools/perf/builtin-record.c               |    7 +++---
>  tools/perf/builtin-top.c                  |    2 +-
>  tools/perf/builtin-trace.c                |    6 +++--
>  tools/perf/perf.c                         |   10 ++++++---
>  tools/perf/tests/builtin-test.c           |    4 +++
>  tools/perf/tests/mmap-basic.c             |    7 +++---
>  tools/perf/tests/open-syscall-all-cpus.c  |    5 +++-
>  tools/perf/tests/open-syscall-tp-fields.c |    7 ++++--
>  tools/perf/tests/open-syscall.c           |    3 ++-
>  tools/perf/tests/perf-record.c            |   13 ++++++++---
>  tools/perf/tests/rdpmc.c                  |    6 +++--
>  tools/perf/tests/sw-clock.c               |    6 +++--
>  tools/perf/tests/task-exit.c              |    6 +++--
>  tools/perf/util/cloexec.c                 |    6 +++--
>  tools/perf/util/data.c                    |    8 +++++--
>  tools/perf/util/debug.h                   |    3 +++
>  tools/perf/util/dso.c                     |    8 +++++--
>  tools/perf/util/evlist.c                  |    2 +-
>  tools/perf/util/evsel.c                   |    7 ++++--
>  tools/perf/util/parse-events.c            |    5 +++-
>  tools/perf/util/probe-event.c             |   34 ++++++++++++++++-------------
>  tools/perf/util/probe-finder.c            |    7 ++++--
>  tools/perf/util/run-command.c             |    9 ++++++--
>  tools/perf/util/util.c                    |    5 +++-
>  25 files changed, 121 insertions(+), 60 deletions(-)
> 
> --
> Masami HIRAMATSU
> Software Platform Research Dept. Linux Technology Research Center
> Hitachi, Ltd., Yokohama Research Laboratory
> E-mail: masami.hiramatsu.pt@hitachi.com
> 
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


