Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108AbaE0R62 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 13:58:28 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:35490 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951AbaE0R6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 13:58:24 -0400
From: Vince Weaver <vincent.weaver@maine.edu>
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Tue, 27 May 2014 14:02:30 -0400 (EDT)
To: Vince Weaver <vincent.weaver@maine.edu>
cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>
Subject: Re: perf: fuzzer getting stuck with slow memory leak
In-Reply-To: <alpine.DEB.2.10.1405271327470.1839@vincent-weaver-1.umelst.maine.edu>
Message-ID: <alpine.DEB.2.10.1405271400240.4012@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.10.1405271327470.1839@vincent-weaver-1.umelst.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2014, Vince Weaver wrote:

> Not a useful trace though, due to the dreaded EVENTS_DROPPED 
> happening right when things would be interesting.
> 
> CPU:0 [148307 EVENTS DROPPED]
>      perf_fuzzer-2940  [000]   396.172211: kmalloc:              (T.1267+0xe) call_site=ffffffff810d027d ptr=0xffff8800be516b00 bytes_req=216 bytes_alloc=256 gfp_flags=GFP_KERNEL|GFP_ZERO
>      perf_fuzzer-2940  [000]   396.172211: function:             perf_lock_task_context
>      perf_fuzzer-2940  [000]   396.172211: function:             alloc_perf_context

for what it's worth the even that seems to trigger this is a 
SW_EMULATION_FAULTS event.  Odd.

     perf_fuzzer-2989  [001]  1994.514398: sys_enter:		NR 298 (699f28, bad, 0, ffffffff, 2, 7fff361a3360)
     perf_fuzzer-2989  [001]  1994.514399: bprint:		SYSC_perf_event_open: VMW: perf_event_open type=1 config=8 period=0 pid=2989 cpu=0 group=-1 flags=2
     perf_fuzzer-2989  [001]  1994.514400: kmalloc:		(T.1267+0xe) call_site=ffffffff810d027d ptr=0xffff880119d1f400 bytes_req=936 bytes_alloc=1024 gfp_flags=GFP_KERNEL|GFP_ZERO
     perf_fuzzer-2989  [001]  1994.514401: kmalloc:		(T.1267+0xe) call_site=ffffffff810d027d ptr=0xffff8800cbbbd000 bytes_req=2064 bytes_alloc=4096 gfp_flags=GFP_KERNEL|GFP_ZERO
     perf_fuzzer-2989  [001]  1994.514401: kmalloc:     	(T.1267+0xe) call_site=ffffffff810d027d ptr=0xffff880119fcd000 bytes_req=2064 bytes_alloc=4096 gfp_flags=GFP_KERNEL|GFP_ZERO
     perf_fuzzer-2989  [001]  1994.514402: kmalloc:		(T.1267+0xe) call_site=ffffffff810d027d ptr=0xffff8800c9344400 bytes_req=216 bytes_alloc=256 gfp_flags=GFP_KERNEL|GFP_ZERO
	(repeat forever)

Vince
