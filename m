Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915Ab3HCTXT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 15:23:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:3900 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752792Ab3HCTXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 15:23:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,808,1367996400"; 
   d="scan'208";a="381404088"
Message-ID: <51FD5899.6060100@intel.com>
Date: Sat, 03 Aug 2013 22:23:05 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH] perf tools: Renaming 'time' variable in perf_time_to_tsc
 due to name shadowing error
References: <1375175954-798-1-git-send-email-namhyung@kernel.org> <20130801120251.GB1032@krava.brq.redhat.com> <51FB2B90.6090602@gmail.com> <20130802133346.GD1711@krava.brq.redhat.com>
In-Reply-To: <20130802133346.GD1711@krava.brq.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/08/2013 4:33 p.m., Jiri Olsa wrote:
> The perf compilation fails with following error:
>        ...
>        CC arch/x86/util/tsc.o
>    arch/x86/util/tsc.c: In function ‘perf_time_to_tsc’:
>    arch/x86/util/tsc.c:13:6: error: declaration of ‘time’ shadows a global declaration [-Werror=shadow]
>    cc1: all warnings being treated as errors
>
> Renaming the 'time' variable to prevent this.

Did you see David did the same patch.

Although David noted the gcc version.  It doesn't happen for gcc 4.7.3. 
  The commit message should probably reflect that it depends on the gcc 
version.

Otherwise:

Acked-by: Adrian Hunter <adrian.hunter@intel.com>


>
> Signed-off-by: Jiri Olsa<jolsa@redhat.com>
> Cc: Arnaldo Carvalho de Melo<acme@redhat.com>
> Cc: Corey Ashford<cjashfor@linux.vnet.ibm.com>
> Cc: Ingo Molnar<mingo@elte.hu>
> Cc: Paul Mackerras<paulus@samba.org>
> Cc: Peter Zijlstra<a.p.zijlstra@chello.nl>
> Cc: Arnaldo Carvalho de Melo<acme@redhat.com>
> Cc: David Ahern<dsahern@gmail.com>
> Cc: Adrian Hunter<adrian.hunter@intel.com>
> ---
>   tools/perf/arch/x86/util/tsc.c |    8 ++++----
>   1 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/tools/perf/arch/x86/util/tsc.c b/tools/perf/arch/x86/util/tsc.c
> index f111744..9570c2b 100644
> --- a/tools/perf/arch/x86/util/tsc.c
> +++ b/tools/perf/arch/x86/util/tsc.c
> @@ -10,11 +10,11 @@
>
>   u64 perf_time_to_tsc(u64 ns, struct perf_tsc_conversion *tc)
>   {
> -	u64 time, quot, rem;
> +	u64 t, quot, rem;
>
> -	time = ns - tc->time_zero;
> -	quot = time / tc->time_mult;
> -	rem  = time % tc->time_mult;
> +	t = ns - tc->time_zero;
> +	quot = t / tc->time_mult;
> +	rem  = t % tc->time_mult;
>   	return (quot<<  tc->time_shift) +
>   	       (rem<<  tc->time_shift) / tc->time_mult;
>   }

