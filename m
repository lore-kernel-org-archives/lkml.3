Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933750Ab3LINfx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 08:35:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43859 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933431Ab3LINfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 08:35:47 -0500
Date: Mon, 9 Dec 2013 14:35:29 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/4] perf tools: Fix max mmap_pages
Message-ID: <20131209133529.GA30360@krava.brq.redhat.com>
References: <1386595120-22978-1-git-send-email-adrian.hunter@intel.com>
 <1386595120-22978-3-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386595120-22978-3-git-send-email-adrian.hunter@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 09, 2013 at 03:18:38PM +0200, Adrian Hunter wrote:
> 'SIZE_MAX / page_size' is an upper limit for
> the maximum number of mmap pages, not a lower
> limit.  Change the condition accordingly.
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>  tools/perf/util/evlist.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
> index 4d0945c..98ec96b 100644
> --- a/tools/perf/util/evlist.c
> +++ b/tools/perf/util/evlist.c
> @@ -754,7 +754,7 @@ int perf_evlist__parse_mmap_pages(const struct option *opt, const char *str,
>  	unsigned long max = UINT_MAX;
>  	long pages;
>  
> -	if (max < SIZE_MAX / page_size)
> +	if (max > SIZE_MAX / page_size)
>  		max = SIZE_MAX / page_size;

I agree with the change.. but it looks like the check
is superfluos, maybe we want to define max as:

   unsigned long max = SIZE_MAX / page_size

?

jirka
>  
>  	pages = parse_pages_arg(str, 1, max);
> -- 
> 1.7.11.7
> 
