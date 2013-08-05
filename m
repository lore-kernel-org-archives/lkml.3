Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081Ab3HEI3B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 04:29:01 -0400
Received: from mga03.intel.com ([143.182.124.21]:57301 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754621Ab3HEI3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 04:29:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,817,1367996400"; 
   d="scan'208";a="341748782"
Message-ID: <51FF63B1.4070808@intel.com>
Date: Mon, 05 Aug 2013 11:34:57 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH] perf x86: Fix compile of util/tsc.c
References: <1374848843-43127-1-git-send-email-dsahern@gmail.com>
In-Reply-To: <1374848843-43127-1-git-send-email-dsahern@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/07/13 17:27, David Ahern wrote:
> On Fedora 18, with gcc 4.6.4 compile fails with:
> 
> arch/x86/util/tsc.c: In function ‘perf_time_to_tsc’:
> arch/x86/util/tsc.c:13:6: error: declaration of ‘time’ shadows a global declaration [-Werror=shadow]
> cc1: all warnings being treated as errors
> make: *** [/tmp/junk/arch/x86/util/tsc.o] Error 1
> make: *** Waiting for unfinished jobs....
> 
> Fix by renaming the local variable.
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>
> Cc: Adrian Hunter <adrian.hunter@intel.com>

Acked-by: Adrian Hunter <adrian.hunter@intel.com>

> ---
>  tools/perf/arch/x86/util/tsc.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/perf/arch/x86/util/tsc.c b/tools/perf/arch/x86/util/tsc.c
> index f111744..9570c2b 100644
> --- a/tools/perf/arch/x86/util/tsc.c
> +++ b/tools/perf/arch/x86/util/tsc.c
> @@ -10,11 +10,11 @@
>  
>  u64 perf_time_to_tsc(u64 ns, struct perf_tsc_conversion *tc)
>  {
> -	u64 time, quot, rem;
> +	u64 t, quot, rem;
>  
> -	time = ns - tc->time_zero;
> -	quot = time / tc->time_mult;
> -	rem  = time % tc->time_mult;
> +	t = ns - tc->time_zero;
> +	quot = t / tc->time_mult;
> +	rem  = t % tc->time_mult;
>  	return (quot << tc->time_shift) +
>  	       (rem << tc->time_shift) / tc->time_mult;
>  }
> 

