Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751357AbaDOVta (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 17:49:30 -0400
Received: from www.linutronix.de ([62.245.132.108]:60581 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbaDOVt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 17:49:28 -0400
Date: Tue, 15 Apr 2014 23:49:39 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Vince Weaver <vincent.weaver@maine.edu>
cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [perf] more perf_fuzzer memory corruption
In-Reply-To: <alpine.DEB.2.10.1404151729230.17264@vincent-weaver-1.um.maine.edu>
Message-ID: <alpine.DEB.2.02.1404152348160.22697@ionos.tec.linutronix.de>
References: <alpine.DEB.2.10.1404151729230.17264@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Apr 2014, Vince Weaver wrote:
> 
> Still tracking memory corruption bugs found by the perf_fuzzer, I have 
> about 10 different log splats that I think might all be related to the 
> same underlying problem.
> 
> Anyway I managed to trigger this using the perf_fuzzer:
> 
> [  221.065278] Slab corruption (Not tainted): kmalloc-2048 start=ffff8800cd15e800, len=2048
> [  221.074062] 040: 6b 6b 6b 6b 6b 6b 6b 6b 98 72 57 cd 00 88 ff ff  kkkkkkkk.rW.....
> [  221.082321] Prev obj: start=ffff8800cd15e000, len=2048
> [  221.087933] 000: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> [  221.096224] 010: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> 
> And luckily I had ftrace running at the time.
> 
> The allocation of this block is by perf_event
> 
> perf_fuzzer-2520  [001]   182.980563: kmalloc:              (perf_event_alloc+0x55) call_site=ffffffff811399b5 ptr=0xffff8800cd15e800 bytes_req=1272 bytes_alloc=2048 gfp_flags=GFP_KERNEL|GFP_ZERO
> perf_fuzzer-2520  [000]   183.628515: kmalloc:              (perf_event_alloc+0x55) call_site=ffffffff811399b5 ptr=0xffff8800cd15e800 bytes_req=1272 bytes_alloc=2048 gfp_flags=GFP_KERNEL|GFP_ZERO
> perf_fuzzer-2520  [000]   183.628521: kfree:                (perf_event_alloc+0x2f7) call_site=ffffffff81139c57 ptr=0xffff8800cd15e800
> perf_fuzzer-2520  [000]   183.628844: kmalloc:              (perf_event_alloc+0x55) call_site=ffffffff811399b5 ptr=0xffff8800cd15e800 bytes_req=1272 bytes_alloc=2048 gfp_flags=GFP_KERNEL|GFP_ZERO
> ...(thousands of times of kmalloc/kfree)
> 
> Is it worth wading through this mess to try to track down what happened?

Definitely worth a try. Can you upload the trace file and provide the
URL or send it offlist in private mail if you cannot provide a public URL.

Thanks,

	tglx
