Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838Ab3JRRay (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 13:30:54 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:59281 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756445Ab3JRRaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 13:30:52 -0400
Message-ID: <52617046.9090303@gmail.com>
Date: Fri, 18 Oct 2013 11:30:46 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Waiman Long <Waiman.Long@hp.com>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH v2 3/4] perf-report: add --max-stack option to limit callchain
 stack scan
References: <1382107129-2010-1-git-send-email-Waiman.Long@hp.com> <1382107129-2010-4-git-send-email-Waiman.Long@hp.com>
In-Reply-To: <1382107129-2010-4-git-send-email-Waiman.Long@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/13 8:38 AM, Waiman Long wrote:
> When callgraph data was included in the perf data file, it may take a
> long time to scan all those data and merge them together especially
> if the stored callchains are long and the perf data file itself is
> large, like a Gbyte or so.
>
> The callchain stack is currently limited to PERF_MAX_STACK_DEPTH (127).
> This is a large value. Usually the callgraph data that developers are
> most interested in are the first few levels, the rests are usually
> not looked at.
>
> This patch adds a new --max-stack option to perf-report to limit the
> depth of callchain stack data to look at to reduce the time it takes
> for perf-report to finish its processing. It trades the presence of
> trailing stack information with faster speed.
>
> The following table shows the elapsed time of doing perf-report on a
> perf.data file of size 985,531,828 bytes.
>
> --max_stack	Elapsed Time	Output data size
> -----------	------------	----------------
> not set		   88.0s	124,422,651
> 64		   87.5s	116,303,213
> 32		   87.2s	112,023,804
> 16		   86.6s	 94,326,380
> 8		   59.9s	 33,697,248
> 4		   40.7s	 10,116,637
> -g none		   27.1s	  2,555,810
>
> Signed-off-by: Waiman Long <Waiman.Long@hp.com>
> ---
>   tools/perf/Documentation/perf-report.txt |    8 ++++++++
>   tools/perf/builtin-report.c              |   22 +++++++++++++++++-----
>   tools/perf/builtin-top.c                 |    3 ++-
>   tools/perf/util/machine.c                |   14 +++++++++-----
>   tools/perf/util/machine.h                |    3 ++-
>   tools/perf/util/session.c                |    3 ++-
>   6 files changed, 40 insertions(+), 13 deletions(-)
>

Looks good to me. Acked-by: David Ahern <dsahern@gmail.com>

