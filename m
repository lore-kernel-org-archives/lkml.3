Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376AbaF0OMr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 10:12:47 -0400
Received: from mail.kernel.org ([198.145.19.201]:46490 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753039AbaF0OMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 10:12:46 -0400
Date: Fri, 27 Jun 2014 11:12:41 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jiri Olsa <jolsa@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 3/5] perf tools: Fix wrong condition for allocation
 failure
Message-ID: <20140627141240.GG18773@kernel.org>
References: <1403871661-18474-1-git-send-email-jolsa@kernel.org>
 <1403871661-18474-4-git-send-email-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403871661-18474-4-git-send-email-jolsa@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jun 27, 2014 at 02:20:59PM +0200, Jiri Olsa escreveu:
> Check real allocated pointer for NULL.

Thanks, applied.

- Arnaldo
 
> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Link: http://lkml.kernel.org/n/tip-5rfzbalwjphmdzzil74eazyl@git.kernel.org
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  tools/perf/builtin-stat.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
> index 65a151e..3e80aa1 100644
> --- a/tools/perf/builtin-stat.c
> +++ b/tools/perf/builtin-stat.c
> @@ -184,7 +184,7 @@ static void perf_evsel__reset_stat_priv(struct perf_evsel *evsel)
>  static int perf_evsel__alloc_stat_priv(struct perf_evsel *evsel)
>  {
>  	evsel->priv = zalloc(sizeof(struct perf_stat));
> -	if (evsel == NULL)
> +	if (evsel->priv == NULL)
>  		return -ENOMEM;
>  	perf_evsel__reset_stat_priv(evsel);
>  	return 0;
> -- 
> 1.8.3.1
