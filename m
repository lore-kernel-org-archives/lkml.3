Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbaJARIf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 13:08:35 -0400
Received: from mail.kernel.org ([198.145.19.201]:39683 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461AbaJARIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 13:08:34 -0400
Date: Wed, 1 Oct 2014 14:08:29 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH 01/11] perf stat: Fix AGGR_CORE segfault on multi-socket
 system
Message-ID: <20141001170829.GD2799@kernel.org>
References: <1412174192-7010-1-git-send-email-matt@console-pimps.org>
 <1412174192-7010-2-git-send-email-matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412174192-7010-2-git-send-email-matt@console-pimps.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Oct 01, 2014 at 03:36:22PM +0100, Matt Fleming escreveu:
> From: Matt Fleming <matt.fleming@intel.com>
> 
> When printing the stats associated with a counter in AGGR_MODE mode, the
> 'cpu' argument represents an encoded socket and core_id, not a 'cpu'.
> Using it as an index into the any of the *_stats[MAX_NR_CPUS] arrays
> generates a SIGSEGV if the encoded socket id is non-zero.
> 
> Follow the AGGR_GLOBAL case and reset the cpu index to 0.

So, is this still needed after applying Andi's patch:

  perf stat: Fix --per-core on multi socket systems

  https://git.kernel.org/cgit/linux/kernel/git/acme/linux.git/commit/?h=perf/core&id=da88c7f78d842a6938d9adde6af87a2ce262051d

Or should this be applied on top of that one, after fixing up the
conflicts?

- Arnaldo
 
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Matt Fleming <matt.fleming@intel.com>
> ---
>  tools/perf/builtin-stat.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
> index b22c62f80078..53bd6b729498 100644
> --- a/tools/perf/builtin-stat.c
> +++ b/tools/perf/builtin-stat.c
> @@ -965,7 +965,7 @@ static void abs_printout(int id, int nr, struct perf_evsel *evsel, double avg)
>  
>  	aggr_printout(evsel, id, nr);
>  
> -	if (aggr_mode == AGGR_GLOBAL)
> +	if (aggr_mode == AGGR_GLOBAL || aggr_mode == AGGR_CORE)
>  		cpu = 0;
>  
>  	fprintf(output, fmt, avg, csv_sep);
> -- 
> 1.9.3
