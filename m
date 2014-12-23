Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571AbaLWELf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 23:11:35 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:45344 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734AbaLWELd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 23:11:33 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
Date: Tue, 23 Dec 2014 13:12:13 +0900
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH 4/7] perf diff: Fix to sort by baseline field by default
Message-ID: <20141223041213.GC14960@sejong>
References: <1419223455-4362-1-git-send-email-namhyung@kernel.org>
 <1419223455-4362-5-git-send-email-namhyung@kernel.org>
 <20141222144513.GB2717@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141222144513.GB2717@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2014 at 11:45:13AM -0300, Arnaldo Carvalho de Melo wrote:
> Looks better, here I tried running 'perf record usleep 1'  in quick
> succession to then run 'perf diff'  before and after this patch, got:
> 
> Before:
> 
> [ssdandy ~]$ cat /tmp/before
> # Event 'cycles'
> #
> # Baseline    Delta  Shared Object     Symbol                        
> # ........  .......  ................  ..............................
> #
>             +36.29%  [kernel.vmlinux]  [k] __split_vma.isra.31       
>     34.55%           [kernel.vmlinux]  [k] copy_user_generic_unrolled
>              +2.45%  [kernel.vmlinux]  [k] local_clock               
>      0.11%   +0.02%  [kernel.vmlinux]  [k] native_write_msr_safe     
>      2.12%           [kernel.vmlinux]  [k] perf_event_comm_output    
>             +61.13%  [kernel.vmlinux]  [k] unmap_page_range          
>     63.22%           libc-2.17.so      [.] 0x000000000007c3e0        
> [acme@ssdandy ~]$
> 
> After:
> 
> [acme@ssdandy linux]$ perf diff
> # Event 'cycles'
> #
> # Baseline    Delta  Shared Object     Symbol                        
> # ........  .......  ................  ..............................
> #
>     63.22%           libc-2.17.so      [.] 0x000000000007c3e0        
>     34.55%           [kernel.vmlinux]  [k] copy_user_generic_unrolled
>      2.12%           [kernel.vmlinux]  [k] perf_event_comm_output    
>      0.11%   +0.02%  [kernel.vmlinux]  [k] native_write_msr_safe     
>             +36.29%  [kernel.vmlinux]  [k] __split_vma.isra.31       
>              +2.45%  [kernel.vmlinux]  [k] local_clock               
>             +61.13%  [kernel.vmlinux]  [k] unmap_page_range          
> [acme@ssdandy linux]$
> 
> Which was ok up to the point where symbols that only appeared on the
> second run were not sorted by delta, can you fix that?

I'll do that later.


> 
> Please let me know if it is better to apply this one then a followup to
> sort the deltas or if a combined patch to achieve both is best.

I prefer applying this for now and then improve sorting later..

> 
> I.e.:
> 
> [acme@ssdandy linux]$ perf diff
> # Event 'cycles'
> #
> # Baseline    Delta  Shared Object     Symbol                        
> # ........  .......  ................  ..............................
> #
>     63.22%           libc-2.17.so      [.] 0x000000000007c3e0        
>     34.55%           [kernel.vmlinux]  [k] copy_user_generic_unrolled
>      2.12%           [kernel.vmlinux]  [k] perf_event_comm_output    
>      0.11%   +0.02%  [kernel.vmlinux]  [k] native_write_msr_safe     
>             +61.13%  [kernel.vmlinux]  [k] unmap_page_range          
>             +36.29%  [kernel.vmlinux]  [k] __split_vma.isra.31       
>              +2.45%  [kernel.vmlinux]  [k] local_clock               
> 
> [acme@ssdandy linux]$
> 
> Humm, but then wouldn't we be more interested in sorting _everything_ by
> delta?

I don't understand whay you said..  what do you mean by 'everything be
delta'?  Is that something other than perf diff -o 1 ?

Thanks,
Namhyung
