Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123AbaLVOpN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 09:45:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33649 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754806AbaLVOpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 09:45:11 -0500
Date: Mon, 22 Dec 2014 15:43:15 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>, dev@codyps.com,
        peterz@infradead.org, hbabu@us.ibm.com, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v6 4/4] tools/perf: Document parameterized and symbolic
 events
Message-ID: <20141222144315.GC29096@krava.brq.redhat.com>
References: <1419234567-22784-1-git-send-email-sukadev@linux.vnet.ibm.com>
 <1419234567-22784-5-git-send-email-sukadev@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419234567-22784-5-git-send-email-sukadev@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 21, 2014 at 11:49:27PM -0800, Sukadev Bhattiprolu wrote:
> From: Cody P Schafer <cody@linux.vnet.ibm.com>
> 
> Changelog[v6]:
> 	- [Sukadev Bhattiprolu]: Update documentation of perf-list and
> 	  perf-record; Added documentation for perf-stat.
> 
> CC: Haren Myneni <hbabu@us.ibm.com>
> CC: Cody P Schafer <dev@codyps.com>
> Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> ---
>  tools/perf/Documentation/perf-list.txt   | 13 +++++++++++++
>  tools/perf/Documentation/perf-record.txt | 12 ++++++++++++
>  tools/perf/Documentation/perf-stat.txt   | 20 ++++++++++++++++----
>  3 files changed, 41 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/perf/Documentation/perf-list.txt b/tools/perf/Documentation/perf-list.txt
> index cbb4f74..d8be6fa 100644
> --- a/tools/perf/Documentation/perf-list.txt
> +++ b/tools/perf/Documentation/perf-list.txt
> @@ -89,6 +89,19 @@ raw encoding of 0x1A8 can be used:
>  You should refer to the processor specific documentation for getting these
>  details. Some of them are referenced in the SEE ALSO section below.
>  
> +PARAMETERIZED EVENTS
> +--------------------
> +
> +Some pmu events listed by 'perf-list' will be displayed with '$x' in them. For
> +example:

s/$x/?/                                                         ^^^^

> +
> +  hv_gpci/dtbp_ptitc,phys_processor_idx=?/
> +
> +This means that when provided as an event, a value for '?' must
> +also be supplied. For example:
> +
> +  perf stat -C 0 -e 'hv_gpci/dtbp_ptitc,phys_processor_idx=0x2/' ...
> +
>  OPTIONS
>  -------
>  
> diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
> index af9a54e..acdcf3b 100644
> --- a/tools/perf/Documentation/perf-record.txt
> +++ b/tools/perf/Documentation/perf-record.txt
> @@ -33,6 +33,18 @@ OPTIONS
>          - a raw PMU event (eventsel+umask) in the form of rNNN where NNN is a
>  	  hexadecimal event descriptor.

SNIP

> +
> +	- a symbolically formed event like 'pmu/config=M,config1=N,config3=K/'
> +
> +          where M, N, K are numbers (in decimal, hex, octal format). Acceptable
> +          values for each of 'config', 'config1' and 'config2' are defined by
> +          corresponding entries in /sys/bus/event_sources/devices/<pmu>/format/*
> +          param1 and param2 are defined as formats for the PMU in:
> +	  /sys/bus/event_sources/devices/<pmu>/format/*

   ^^^^ misaligned tab

> +
>          - a hardware breakpoint event in the form of '\mem:addr[:access]'
>            where addr is the address in memory you want to break in.
>            Access is the memory access type (read, write, execute) it can
> diff --git a/tools/perf/Documentation/perf-stat.txt b/tools/perf/Documentation/perf-stat.txt
> index 29ee857..04e150d 100644
> --- a/tools/perf/Documentation/perf-stat.txt
> +++ b/tools/perf/Documentation/perf-stat.txt
> @@ -25,10 +25,22 @@ OPTIONS
>  

thanks,
jirka
