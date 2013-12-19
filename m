Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429Ab3LSNcc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 08:32:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58030 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752961Ab3LSNca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 08:32:30 -0500
Date: Thu, 19 Dec 2013 14:32:12 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 3/6] perf tools: Get rid of a duplicate va_end()
Message-ID: <20131219133212.GC3568@krava.brq.redhat.com>
References: <1387436411-20160-1-git-send-email-namhyung@kernel.org>
 <1387436411-20160-4-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387436411-20160-4-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 04:00:08PM +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> The va_end() in _eprintf() should be removed since the caller also
> invokes va_end().
> 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

Acked-by: Jiri Olsa <jolsa@redhat.com>

jirka

> ---
>  tools/perf/util/debug.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
> index 8640a9121e72..299b55586502 100644
> --- a/tools/perf/util/debug.c
> +++ b/tools/perf/util/debug.c
> @@ -25,7 +25,6 @@ static int _eprintf(int level, const char *fmt, va_list args)
>  			ui_helpline__vshow(fmt, args);
>  		else
>  			ret = vfprintf(stderr, fmt, args);
> -		va_end(args);
>  	}
>  
>  	return ret;
> -- 
> 1.7.11.7
> 
