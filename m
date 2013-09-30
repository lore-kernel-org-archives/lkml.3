Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946Ab3I3Irj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 04:47:39 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:56522 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267Ab3I3Irh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 04:47:37 -0400
X-AuditID: 9c930179-b7c8bae000006c65-62-52493aa75616
From: Namhyung Kim <namhyung@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/3] perf stat: Don't require a workload when using system wide or CPU options
References: <1380400080-9211-1-git-send-email-dsahern@gmail.com>
	<1380400080-9211-3-git-send-email-dsahern@gmail.com>
Date: Mon, 30 Sep 2013 17:47:34 +0900
In-Reply-To: <1380400080-9211-3-git-send-email-dsahern@gmail.com> (David
	Ahern's message of "Sat, 28 Sep 2013 14:27:59 -0600")
Message-ID: <87li2eofvd.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Sat, 28 Sep 2013 14:27:59 -0600, David Ahern wrote:
> perf-stat can do system wide counters or one or more cpus. For
> these options do not require a workload to be specified.
>
> Signed-off-by: David Ahern <dsahern@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Namhyung Kim <namhyung.kim@lge.com>
> Cc: Stephane Eranian <eranian@google.com>
> ---
>  tools/perf/builtin-stat.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
> index 6cc0aa2..60239fe 100644
> --- a/tools/perf/builtin-stat.c
> +++ b/tools/perf/builtin-stat.c
> @@ -1517,8 +1517,10 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
>  	} else if (big_num_opt == 0) /* User passed --no-big-num */
>  		big_num = false;
>  
> -	if (!argc && !perf_target__has_task(&target))
> +	if (!argc && !perf_target__has_task(&target) &&
> +	    !perf_target__has_cpu(&target))

You can use perf_target__none() for this.

Btw I found a bug in setting child_pid (which introduced by me ;) during
this review.  Will send a fix.

Thanks,
Namhyung


>  		usage_with_options(stat_usage, options);
> +
>  	if (run_count < 0) {
>  		usage_with_options(stat_usage, options);
>  	} else if (run_count == 0) {
