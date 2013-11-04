Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894Ab3KDXqG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 18:46:06 -0500
Received: from mail-yh0-f50.google.com ([209.85.213.50]:39598 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab3KDXqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 18:46:04 -0500
Date: Mon, 4 Nov 2013 20:45:51 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Arun Sharma <asharma@fb.com>
Subject: Re: [PATCH 03/14] perf hists: Convert hist entry functions to use
 struct he_stat
Message-ID: <20131104234551.GC7478@ghostprotocols.net>
References: <1383202576-28141-1-git-send-email-namhyung@kernel.org>
 <1383202576-28141-4-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383202576-28141-4-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Oct 31, 2013 at 03:56:05PM +0900, Namhyung Kim escreveu:

> -static void hist_entry__add_cpumode_period(struct hist_entry *he,
> +static void hist_entry__add_cpumode_period(struct he_stat *he_stat,
>  					   unsigned int cpumode, u64 period)

So it is not anymore a 'struct hist_entry' method, but a 'struct
he_stat' one, thus these functions need to be renamed accordingly, in
the above case it should be:

-static void hist_entry__add_cpumode_period(struct hist_entry *he,
+static void he_stat__add_cpumode_period(struct he_stat *he_stat,
+				 	 unsigned int cpumode, u64 period)

>  {
>  	switch (cpumode) {
>  	case PERF_RECORD_MISC_KERNEL:
> -		he->stat.period_sys += period;
> +		he_stat->period_sys += period;
>  		break;
>  	case PERF_RECORD_MISC_USER:
> -		he->stat.period_us += period;
> +		he_stat->period_us += period;
>  		break;
>  	case PERF_RECORD_MISC_GUEST_KERNEL:
> -		he->stat.period_guest_sys += period;
> +		he_stat->period_guest_sys += period;
>  		break;
>  	case PERF_RECORD_MISC_GUEST_USER:
> -		he->stat.period_guest_us += period;
> +		he_stat->period_guest_us += period;
>  		break;
>  	default:
>  		break;
> @@ -223,10 +223,10 @@ static void he_stat__add_stat(struct he_stat *dest, struct he_stat *src)
>  	dest->weight		+= src->weight;
>  }
>  
> -static void hist_entry__decay(struct hist_entry *he)
> +static void hist_entry__decay(struct he_stat *he_stat)

Ditto

>  {
> -	he->stat.period = (he->stat.period * 7) / 8;
> -	he->stat.nr_events = (he->stat.nr_events * 7) / 8;
> +	he_stat->period = (he_stat->period * 7) / 8;
