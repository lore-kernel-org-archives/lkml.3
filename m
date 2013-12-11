Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751489Ab3LKTuw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 14:50:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34660 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191Ab3LKTuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 14:50:51 -0500
Date: Wed, 11 Dec 2013 17:50:46 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] perf completion: complete 'perf kvm'
Message-ID: <20131211195046.GA2295@infradead.org>
References: <1386758056-24618-1-git-send-email-artagnon@gmail.com>
 <1386758056-24618-2-git-send-email-artagnon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386758056-24618-2-git-send-email-artagnon@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Dec 11, 2013 at 04:04:15PM +0530, Ramkumar Ramachandra escreveu:
> Currently, there is no way to enumerate the subcommands under 'perf
> kvm', so hardcode them.

[acme@ssdandy linux]$ perf kvm -h 2>&1 | grep usage
 usage: perf kvm [<options>] {top|record|report|diff|buildid-list|stat}

Can't you use this somehow?

I'm applying it tho as it is better than the current situation.

- Arnaldo
 
> Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
> ---
>  tools/perf/perf-completion.sh | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/tools/perf/perf-completion.sh b/tools/perf/perf-completion.sh
> index 4949488..496e2ab 100644
> --- a/tools/perf/perf-completion.sh
> +++ b/tools/perf/perf-completion.sh
> @@ -121,6 +121,10 @@ __perf_main ()
>  	elif [[ $prev == "-e" && "${words[1]}" == @(record|stat|top) ]]; then
>  		evts=$($cmd list --raw-dump)
>  		__perfcomp_colon "$evts" "$cur"
> +	# List subcommands for 'perf kvm'
> +	elif [[ $prev == "kvm" ]]; then
> +		subcmds="top record report diff buildid-list stat"
> +		__perfcomp_colon "$subcmds" "$cur"
>  	# List long option names
>  	elif [[ $cur == --* ]];  then
>  		subcmd=${words[1]}
> -- 
> 1.8.5.rc0.5.g70ebc73.dirty
