Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758875AbaGXMsD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 08:48:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35309 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758527AbaGXMsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 08:48:00 -0400
Date: Thu, 24 Jul 2014 14:47:48 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/6] perf report: Honor column width setting
Message-ID: <20140724124748.GB7652@krava.brq.redhat.com>
References: <1404883694-5342-1-git-send-email-namhyung@kernel.org>
 <1404883694-5342-5-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404883694-5342-5-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 02:28:12PM +0900, Namhyung Kim wrote:
> Set column width and do not change it if user gives -w/--column-widths
> option.  It'll truncate longer symbols than the width if exists.

SNIP

>  
>  static inline void advance_hpp(struct perf_hpp *hpp, int inc)
>  {
> diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
> index 396b0094943d..f89714329c0f 100644
> --- a/tools/perf/util/sort.c
> +++ b/tools/perf/util/sort.c
> @@ -70,7 +70,9 @@ static int hist_entry__thread_snprintf(struct hist_entry *he, char *bf,
>  				       size_t size, unsigned int width)
>  {
>  	const char *comm = thread__comm_str(he->thread);
> -	return repsep_snprintf(bf, size, "%-*s:%5d", width - 6,
> +
> +	width = max(7U, width) - 6;
> +	return repsep_snprintf(bf, size, "%-*.*s:%5d", width, width,
>  			       comm ?: "", he->thread->tid);

I couldn't found what your format string:
  "%-*.*s:%5d", width, width

is supposed to do... it gives me the same result as for:
  "%-*s:%5d", width

you use it on more places so I guess it's not a typo ;-)

thanks,
jirka
