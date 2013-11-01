Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019Ab3KANgi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 09:36:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50500 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283Ab3KANgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 09:36:37 -0400
Date: Fri, 1 Nov 2013 11:36:26 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Michael Hudson-Doyle <michael.hudson@linaro.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Will Deacon <will.deacon@arm.com>, Jean Pihet <jean.pihet@linaro.org>
Subject: Re: [PATCH v2] perf tools: Remove cast of non-variadic function to
 variadic
Message-ID: <20131101133626.GA6409@infradead.org>
References: <87zjppvw7y.fsf@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zjppvw7y.fsf@canonical.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Oct 31, 2013 at 04:47:45PM -0700, Michael Hudson-Doyle escreveu:
> -int percent_color_snprintf(char *bf, size_t size, const char *fmt, double percent)
> +int percent_color_snprintf(char *bf, size_t size, const char *fmt, ...)
>  {
> -	const char *color = get_percent_color(percent);
> +	va_list args;
> +	double percent;
> +	const char *color;
> +
> +	va_start(args, fmt);
> +	percent = va_arg(args, double);
> +	va_end(args);
> +	color = get_percent_color(percent);
>  	return color_snprintf(bf, size, color, fmt, percent);
>  }

As a bug fix I'm merging this now, but I wonder if, since we're doing
the va_start/end dance here, can't we call some color_vsnprintf variant
so as to avoid doing it twice?

I'll look into that after going thru more urgent stuff.

- Arnaldo
