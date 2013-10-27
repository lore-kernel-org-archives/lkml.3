Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546Ab3J0Pes (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 11:34:48 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:43514 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482Ab3J0Per (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 11:34:47 -0400
Message-ID: <526D3294.4000402@gmail.com>
Date: Sun, 27 Oct 2013 09:34:44 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
CC: Corey Ashford <cjashfor@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH 2/4] perf tools: Split -G and --call-graph for top command
References: <20131026120336.GA24439@gmail.com> <1382797536-32303-1-git-send-email-jolsa@redhat.com> <1382797536-32303-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1382797536-32303-3-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/13 8:25 AM, Jiri Olsa wrote:
> diff --git a/tools/perf/Documentation/perf-top.txt b/tools/perf/Documentation/perf-top.txt
> index c16a09e..d311974 100644
> --- a/tools/perf/Documentation/perf-top.txt
> +++ b/tools/perf/Documentation/perf-top.txt
> @@ -143,20 +143,12 @@ Default is to monitor all CPUS.
>   --asm-raw::
>   	Show raw instruction encoding of assembly instructions.
>
> --G [type,min,order]::
> +-G::
> +	Enables call-graph (stack chain/backtrace) recording.
> +
>   --call-graph::
> -        Display call chains using type, min percent threshold and order.
> -	type can be either:
> -	- flat: single column, linear exposure of call chains.
> -	- graph: use a graph tree, displaying absolute overhead rates.
> -	- fractal: like graph, but displays relative rates. Each branch of
> -		 the tree is considered as a new profiled object.
> -
> -	order can be either:
> -	- callee: callee based call graph.
> -	- caller: inverted caller based call graph.
> -
> -	Default: fractal,0.5,callee.
> +	Setup and enable call-graph (stack chain/backtrace) recording,
> +	implies -g.

implies '-G' for perf-top. Given that perf-top is recording and 
analyzing events shouldn't the analysis options (caller/callee and 
callgraph type) be kept here?

Really should have callchains be consistent across perf-commands as -g.

Other than that: Tested-Reviewed-by: David Ahern <dsahern@gmail.com>

David
