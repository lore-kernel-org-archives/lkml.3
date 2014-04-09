Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933189AbaDIMQ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 08:16:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41221 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932592AbaDIMQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 08:16:27 -0400
Date: Wed, 9 Apr 2014 14:16:18 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 1/3] perf bench: Set more defaults in the 'numa' suite
Message-ID: <20140409121618.GA2556@krava.brq.redhat.com>
References: <1395964219-22173-1-git-send-email-artagnon@gmail.com>
 <1395964219-22173-2-git-send-email-artagnon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395964219-22173-2-git-send-email-artagnon@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2014 at 07:50:17PM -0400, Ramkumar Ramachandra wrote:
> Currently,
> 
>   $ perf bench numa mem
> 
> errors out with usage information. To make this more user-friendly, let
> us provide a minimum set of default values required for a test
> run. As an added bonus,
> 
>   $ perf bench all
> 
> now goes all the way to completion.
> 
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
> ---
>  tools/perf/bench/numa.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/tools/perf/bench/numa.c b/tools/perf/bench/numa.c
> index d4c83c6..20697fb 100644
> --- a/tools/perf/bench/numa.c
> +++ b/tools/perf/bench/numa.c
> @@ -1593,6 +1593,10 @@ static void init_params(struct params *p, const char *name, int argc, const char
>  	p->data_rand_walk		= true;
>  	p->nr_loops			= -1;
>  	p->init_random			= true;
> +	p->mb_global_str		= "1";
> +	p->nr_proc			= 1;
> +	p->nr_threads			= 1;
> +	p->nr_secs			= 5;

hi,
I dont claim to understand this benchmark, but I'm now getting this:

$ ./perf bench numa all
# Running numa/mem benchmark...

SNIP

 ###
 # 1 task will execute (on 1 nodes, 4 CPUs):
 #         -1x     1MB global  shared mem operations
 #         -1x     0MB process shared mem operations
 #         -1x     0MB thread  local  mem operations
 ###
...


'-1x' does not seem right/intentional for default case

thanks,
jirka
