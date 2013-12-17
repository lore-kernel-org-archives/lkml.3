Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611Ab3LQNM5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 08:12:57 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:48863 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443Ab3LQNMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 08:12:54 -0500
Date: Tue, 17 Dec 2013 14:12:49 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, paulus@samba.org,
        mingo@redhat.com, namhyung@kernel.org, artagnon@gmail.com,
        jolsa@redhat.com
Subject: Re: [PATCH 5/5 v2] perf timechart: add emphasize option
Message-ID: <20131217131249.GA28677@gmail.com>
References: <1385995056-20158-1-git-send-email-stfomichev@yandex-team.ru>
 <20131216193800.GA19283@ghostprotocols.net>
 <20131217093855.GA3345@stfomichev-desktop>
 <20131217112303.GB27791@gmail.com>
 <20131217121522.GA6357@stfomichev-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131217121522.GA6357@stfomichev-desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stanislav Fomichev <stfomichev@yandex-team.ru> wrote:

> > Please give a sample usage command line and a sample output. (the 
> > highlighting can be done using ASCII escape sequences in the changelog 
> > as well.)
> Highlighting is done in the generated SVG, so I can't really show it in
> the log or documentation. But I added simple example with -e option.
> 
> >   -e::
> >   --emphasize=<duration_nsecs|task_name>::
> Thanks, added.
> 
> > It's also not made clear that the option can take a numeric input, and 
> > if the input is numeric, it is interpreted as a task name.
> > 
> > So please make features more approachable!
> Added more info to the documentation.
> 
> Attached new patch below.
> 
> ---
> 
> This option highlights tasks (using different color) that run more than given
> duration or tasks with given name.
> 
> Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
> ---
>  tools/perf/Documentation/perf-timechart.txt | 14 ++++++++++++++
>  tools/perf/builtin-timechart.c              | 21 ++++++++++++++++++++-
>  tools/perf/util/svghelper.c                 | 23 ++++++++++++++++++++---
>  tools/perf/util/svghelper.h                 |  4 +++-
>  4 files changed, 57 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/perf/Documentation/perf-timechart.txt b/tools/perf/Documentation/perf-timechart.txt
> index 367c1be0551c..b81e91dd16ce 100644
> --- a/tools/perf/Documentation/perf-timechart.txt
> +++ b/tools/perf/Documentation/perf-timechart.txt
> @@ -56,12 +56,26 @@ $ perf timechart
>  
>    Written 10.2 seconds of trace to output.svg.
>  
> +Record system-wide timechart:
> +
> +  $ perf timechart record
> +
> +  then generate timechart and highlight 'gcc' tasks:
> +
> +  $ perf timechart -e gcc
> +
>  -n::
>  --proc-num::
>          Print task info for at least given number of tasks.
>  -t::
>  --topology::
>          Sort CPUs according to topology.
> +-e::
> +--emphasize=<duration_nsecs|task_name>::
> +	Highlight tasks (using different color) that run more than given
> +	duration or tasks with given name. If number is given it's interpreted
> +	as number of nanoseconds. If non-numeric string is given it's
> +	interpreted as task name.

Looks good to me, thanks!

Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
