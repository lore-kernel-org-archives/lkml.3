Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757882Ab3HHOlc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 10:41:32 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:50765 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006Ab3HHOla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 10:41:30 -0400
Date: Thu, 8 Aug 2013 11:41:24 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Runzhen Wang <runzhen@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2] perf kvm: Update documentation with live command
Message-ID: <20130808144124.GC2851@ghostprotocols.net>
References: <1375926999-75129-1-git-send-email-dsahern@gmail.com>
 <1375926999-75129-2-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375926999-75129-2-git-send-email-dsahern@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Aug 07, 2013 at 09:56:39PM -0400, David Ahern escreveu:
> Update perf-kvm documentation with new live subcommand. Add -p/--pid option
> for perf-kvm-stat-report as well.

Minor nitpicks, that I'm fixing up, below. Applied.
 
> Signed-off-by: David Ahern <dsahern@gmail.com>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> Cc: Runzhen Wang <runzhen@linux.vnet.ibm.com>
> ---
>  tools/perf/Documentation/perf-kvm.txt |   46 +++++++++++++++++++++++++++++++--
>  1 file changed, 44 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/Documentation/perf-kvm.txt b/tools/perf/Documentation/perf-kvm.txt
> index 326f2cb..ac84db2 100644
> --- a/tools/perf/Documentation/perf-kvm.txt
> +++ b/tools/perf/Documentation/perf-kvm.txt
> @@ -13,6 +13,7 @@ SYNOPSIS
>  	{top|record|report|diff|buildid-list}
>  'perf kvm' [--host] [--guest] [--guestkallsyms=<path> --guestmodules=<path>
>  	| --guestvmlinux=<path>] {top|record|report|diff|buildid-list|stat}
> +'perf kvm stat [record|report|live] [<options>]
>  
>  DESCRIPTION
>  -----------
> @@ -50,6 +51,10 @@ There are a couple of variants of perf kvm:
>    'perf kvm stat report' reports statistical data which includes events
>    handled time, samples, and so on.
>  
> +  'perf kvm stat live' reports statistical data in a live mode (similar to
> +  record + report but with statistical data updated live at a given display
> +  rate).
> +
>  OPTIONS
>  -------
>  -i::
> @@ -85,13 +90,50 @@ STAT REPORT OPTIONS
>  --vcpu=<value>::
>         analyze events which occures on this vcpu. (default: all vcpus)
>  
> ---events=<value>::
> -       events to be analyzed. Possible values: vmexit, mmio, ioport.


> +--event=<value>::
> +       event to be analyzed. Possible values: vmexit, mmio, ioport.
>         (default: vmexit)
>  -k::
>  --key=<value>::
>         Sorting key. Possible values: sample (default, sort by samples

Here you start, correctly, with a capital letter.

>         number), time (sort by average time).
> +-p::
> +--pid=::
> +    Analyze events only for given process ID(s) (comma separated list).
> +
> +STAT LIVE OPTIONS
> +-----------------
> +-d::
> +--display::
> +        Time in seconds between display updates
> +
> +-m::
> +--mmap-pages=::
> +    Number of mmap data pages. Must be a power of two.
> +
> +-a::
> +--all-cpus::
> +        System-wide collection from all CPUs.
> +
> +-p::
> +--pid=::
> +    Analyze events only for given process ID(s) (comma separated list).
> +
> +--vcpu=<value>::
> +       analyze events which occures on this vcpu. (default: all vcpus)

Here you don't.

> +
> +
> +--event=<value>::
> +       event to be analyzed. Possible values: vmexit, mmio, ioport.
> +       (default: vmexit)

Ditto

> +-k::
> +--key=<value>::
> +       Sorting key. Possible values: sample (default, sort by samples
> +       number), time (sort by average time).
> +
> +--duration=<value>::
> +       Show events other than HLT that take longer than duration usecs.
>  
>  SEE ALSO
>  --------
> -- 
> 1.7.10.1
