Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007Ab3D0Qdf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 12:33:35 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:52944 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513Ab3D0Qdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 12:33:33 -0400
Date: Sat, 27 Apr 2013 20:33:30 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Borislav Petkov <bp@alien8.de>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, tytso@mit.edu,
        davem@davemloft.net, fweisbec@gmail.com, oleg@redhat.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf/x86/intel/P4: Robistify P4 PMU types
Message-ID: <20130427163330.GS13008@moon>
References: <20130424072630.GB1780@gmail.com>
 <tip-5ac2b5c2721501a8f5c5e1cd4116cbc31ace6886@git.kernel.org>
 <20130426161328.GA16818@pd.tnic>
 <20130426162444.GC17430@moon>
 <20130426163952.GC15361@pd.tnic>
 <20130426164652.GO13008@moon>
 <20130427161407.GD4358@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130427161407.GD4358@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 27, 2013 at 06:14:07PM +0200, Borislav Petkov wrote:
...

Thanks a LOT, Borislav!

> The other trivial test passes too, although branch-misses doesn't get
> counted:
> 
> ./perf stat sleep 1
> 
>  Performance counter stats for 'sleep 1':
> 
>           1.433368 task-clock                #    0.001 CPUs utilized          
>                  1 context-switches          #    0.698 K/sec                  
>                  0 cpu-migrations            #    0.000 K/sec                  
>                147 page-faults               #    0.103 M/sec                  
>             78,446 cycles                    #    0.055 GHz                    
>                  0 stalled-cycles-frontend   #    0.00% frontend cycles idle   
>                  0 stalled-cycles-backend    #    0.00% backend  cycles idle    [27.37%]
>          1,268,044 instructions              #   16.16  insns per cycle         [27.37%]
>            223,742 branches                  #  156.095 M/sec                   [27.37%]
>      <not counted> branch-misses
> 
>        1.002191045 seconds time elapsed

It's known effect. instructions retired and branch-misses can't
run simultaneously since they both use same escr msr register
(if I recall correctly, out of repo at moment).

> However, if I do this, it works:
> 
> ./perf stat -e branch-misses sleep 1
> 
>  Performance counter stats for 'sleep 1':
> 
>              8,583 branch-misses
> 
>        1.001992384 seconds time elapsed

Thanks!
