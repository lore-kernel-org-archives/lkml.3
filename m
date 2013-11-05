Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880Ab3KEHiZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 02:38:25 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:47713 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab3KEHiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 02:38:24 -0500
X-AuditID: 9c930179-b7c44ae000000c83-2b-5278a06e3d39
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] perf tools: Allow multiple cpus record for -p option
References: <1383321165-25252-1-git-send-email-jolsa@redhat.com>
Date: Tue, 05 Nov 2013 16:38:22 +0900
In-Reply-To: <1383321165-25252-1-git-send-email-jolsa@redhat.com> (Jiri Olsa's
	message of "Fri, 1 Nov 2013 16:52:45 +0100")
Message-ID: <877gcnz4b5.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  1 Nov 2013 16:52:45 +0100, Jiri Olsa wrote:
> Currently we don't create default CPU map for task related
> target, like:
>
>   $ perf record -p <pid>
>
> This makes record command to disable inherited events.
> which is not desired behaviour (we have special option
> for that (-i) anyway).
>
> Fixing this by creating default CPU map for task related
> processes.
>
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  tools/perf/util/evlist.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
> index 0582f67..52bb127 100644
> --- a/tools/perf/util/evlist.c
> +++ b/tools/perf/util/evlist.c
> @@ -804,7 +804,7 @@ int perf_evlist__create_maps(struct perf_evlist *evlist,
>  		return -1;
>  
>  	if (perf_target__has_task(target))
> -		evlist->cpus = cpu_map__dummy_new();
> +		evlist->cpus = cpu_map__new(target->cpu_list);

Just a side note, if the target has task, the cpu list should be NULL as
task target has a precedence.  Please see perf_target__validate().

But I'm fine with the change itself. :)

Thanks,
Namhyung


>  	else if (!perf_target__has_cpu(target) && !target->uses_mmap)
>  		evlist->cpus = cpu_map__dummy_new();
>  	else
