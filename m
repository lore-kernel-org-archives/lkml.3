Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208Ab3LAT4i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 14:56:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44333 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921Ab3LAT4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 14:56:37 -0500
Date: Sun, 1 Dec 2013 20:56:34 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH v4 2/3] perf diff: color the Ratio column
Message-ID: <20131201195634.GB1215@krava.brq.redhat.com>
References: <1385732192-27713-1-git-send-email-artagnon@gmail.com>
 <1385732192-27713-3-git-send-email-artagnon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385732192-27713-3-git-send-email-artagnon@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 29, 2013 at 07:06:31PM +0530, Ramkumar Ramachandra wrote:
> In
> 
>   $ perf diff -c ratio
> 
> color the Ratio column using percent_color_snprintf().
> 
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
> ---
>  tools/perf/builtin-diff.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
> index c970aae..25dac6c 100644
> --- a/tools/perf/builtin-diff.c
> +++ b/tools/perf/builtin-diff.c
> @@ -794,6 +794,17 @@ static int __hpp__color_compare(struct perf_hpp_fmt *fmt,
>  		scnprintf(pfmt, 20, "%%%+d.2f%%%%", dfmt->header_width - 1);
>  		return percent_color_snprintf(hpp->buf, hpp->size,
>  					pfmt, fabs(diff));
> +	case COMPUTE_RATIO:
> +		if (he->dummy)
> +			goto dummy_print;
> +		if (pair->diff.computed)
> +			diff = pair->diff.period_ratio;
> +		else
> +			diff = compute_ratio(he, pair);
> +
> +		scnprintf(pfmt, 20, "%%%d.6f", dfmt->header_width);
> +		return percent_color_snprintf(hpp->buf, hpp->size,
> +					pfmt, diff);

ok, lets keep same limits for ratio and wdiff.. unless
we hear otherwise ;-)

Arnaldo,
I think we want to add something like 'value_color_snprintf' ?
to keep percent/values separated..

It'd do the same job, just the name does not fit in here,
because we are printing out ratio values.

thanks,
jirka
