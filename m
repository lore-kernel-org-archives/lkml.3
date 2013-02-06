Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757206Ab3BFE7N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 23:59:13 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:47170 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755404Ab3BFE7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 23:59:12 -0500
X-AuditID: 9c93016f-b7b1fae000006419-ca-5111e31e540d
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 00/11] perf tool: Add PERF_SAMPLE_READ sample read support
References: <1359981185-16819-1-git-send-email-jolsa@redhat.com>
Date: Wed, 06 Feb 2013 13:59:10 +0900
In-Reply-To: <1359981185-16819-1-git-send-email-jolsa@redhat.com> (Jiri Olsa's
	message of "Mon, 4 Feb 2013 13:32:54 +0100")
Message-ID: <87obfyrqap.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  4 Feb 2013 13:32:54 +0100, Jiri Olsa wrote:
> hi,
> adding support to read sample values through the PERF_SAMPLE_READ
> sample type. It's now possible to specify 'S' modifier for an event
> and get its sample value by PERF_SAMPLE_READ.
>
> For group the 'S' modifier will enable sampling only for the leader
> and read all the group member by PERF_SAMPLE_READ smple type with
> PERF_FORMAT_GROUP read format.
>
> This was first introduced in here:
> https://lkml.org/lkml/2012/10/20/75
>
> Example:
>
>   $ perf record -e '{cycles,cache-misses}:S' ls
>   ...
>   $ perf report --group --show-total-period --stdio
>   ...
>   # Samples: 36  of event 'anon group { cycles, cache-misses }'
>   # Event count (approx.): 12585593
>   #
>   #         Overhead                    Period  Command      Shared Object                      Symbol
>   # ................  ........................  .......  .................  ..........................
>   #
>       19.92%   1.20%       2505936          31       ls  [kernel.kallsyms]  [k] mark_held_locks
>       13.74%   0.47%       1729327          12       ls  [kernel.kallsyms]  [k] sched_clock_local
>       13.64%  23.72%       1716147         612       ls  ld-2.14.90.so      [.] check_match.10805
>       13.12%  23.22%       1650778         599       ls  libc-2.14.90.so    [.] _nl_intern_locale_data
>       11.24%  29.19%       1414554         753       ls  [kernel.kallsyms]  [k] sched_clock_cpu
>        8.50%   0.35%       1070150           9       ls  [kernel.kallsyms]  [k] check_chain_key
>   ...
>
>
> The patchset is based on following fix:
> http://lkml.org/lkml/2013/2/4/122
>
> and is available also at:
> git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/linux.git
> perf/group6

For the whole series:

  Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung
