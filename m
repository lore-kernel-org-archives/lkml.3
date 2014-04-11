Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934589AbaDKKdB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 06:33:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23869 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756804AbaDKKc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 06:32:56 -0400
Date: Fri, 11 Apr 2014 12:32:53 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH v2] perf list: Fix --raw-dump argument
Message-ID: <20140411103253.GA1107@krava.brq.redhat.com>
References: <1397176953-2006-1-git-send-email-artagnon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397176953-2006-1-git-send-email-artagnon@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 08:42:33PM -0400, Ramkumar Ramachandra wrote:
> While adding usage information, 44d742e (perf list: Add usage,
> 2013-10-30) broke
> 
>   $ perf list --raw-dump
> 
> Fix this by making raw-dump a subcommand.

you need to update perf-completion.sh now
also please add it to perf list man page as well

thanks,
jirka

> 
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
> ---
>  tools/perf/builtin-list.c     | 2 +-
>  tools/perf/perf-completion.sh | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/builtin-list.c b/tools/perf/builtin-list.c
> index 011195e..c74aef5 100644
> --- a/tools/perf/builtin-list.c
> +++ b/tools/perf/builtin-list.c
> @@ -53,7 +53,7 @@ int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
>  			print_hwcache_events(NULL, false);
>  		else if (strcmp(argv[i], "pmu") == 0)
>  			print_pmu_events(NULL, false);
> -		else if (strcmp(argv[i], "--raw-dump") == 0)
> +		else if (strcmp(argv[i], "raw-dump") == 0)
>  			print_events(NULL, true);
>  		else {
>  			char *sep = strchr(argv[i], ':'), *s;
> diff --git a/tools/perf/perf-completion.sh b/tools/perf/perf-completion.sh
> index ae3a576..8f518f0 100644
> --- a/tools/perf/perf-completion.sh
> +++ b/tools/perf/perf-completion.sh
> @@ -119,7 +119,7 @@ __perf_main ()
>  		fi
>  	# List possible events for -e option
>  	elif [[ $prev == "-e" && "${words[1]}" == @(record|stat|top) ]]; then
> -		evts=$($cmd list --raw-dump)
> +		evts=$($cmd list raw-dump)
>  		__perfcomp_colon "$evts" "$cur"
>  	# List subcommands for 'perf kvm'
>  	elif [[ $prev == "kvm" ]]; then
> -- 
> 1.9.2.667.ge5b74e1
> 
