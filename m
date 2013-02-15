Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758284Ab3BOPFp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 10:05:45 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11895 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754726Ab3BOPFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 10:05:43 -0500
X-Authority-Analysis: v=2.0 cv=It2cgcDg c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=MPEKn9ueenIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=zGjexpQmzOwA:10 a=Jd30bWH-SSQKBtd5NLQA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1360940741.23152.110.camel@gandalf.local.home>
Subject: Re: [RFC] sched: The removal of idle_balance()
From: Steven Rostedt <rostedt@goodmis.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Clark Williams <clark@redhat.com>,
        Andrew Theurer <habanero@us.ibm.com>
Date: Fri, 15 Feb 2013 10:05:41 -0500
In-Reply-To: <20130215074538.GA25845@lge.com>
References: <1360908819.23152.97.camel@gandalf.local.home>
	 <20130215074538.GA25845@lge.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-02-15 at 16:45 +0900, Joonsoo Kim wrote:
> Hello, Steven.

> - Before Patch
> Permance counter stats for 'perf bench sched messaging -g 300' (10 runs):
> 
>       40847.488740 task-clock                #    3.232 CPUs utilized            ( +-  1.24% )
>            511,070 context-switches          #    0.013 M/sec                    ( +-  7.28% )
>            117,882 cpu-migrations            #    0.003 M/sec                    ( +-  5.14% )
>          1,360,501 page-faults               #    0.033 M/sec                    ( +-  0.12% )
>    118,534,394,180 cycles                    #    2.902 GHz                      ( +-  1.23% ) [50.70%]
>    <not supported> stalled-cycles-frontend 
>    <not supported> stalled-cycles-backend  
>     46,217,340,271 instructions              #    0.39  insns per cycle          ( +-  0.56% ) [76.93%]
>      8,592,447,548 branches                  #  210.354 M/sec                    ( +-  0.75% ) [75.50%]
>        273,367,481 branch-misses             #    3.18% of all branches          ( +-  0.26% ) [75.49%]
> 
>       12.639049245 seconds time elapsed                                          ( +-  2.29% )
> 
> - After Patch
>  Performance counter stats for 'perf bench sched messaging -g 300' (10 runs):
> 
>       42053.008632 task-clock                #    2.932 CPUs utilized            ( +-  0.91% )
>            672,759 context-switches          #    0.016 M/sec                    ( +-  2.76% )
>             83,374 cpu-migrations            #    0.002 M/sec                    ( +-  4.46% )
>          1,362,900 page-faults               #    0.032 M/sec                    ( +-  0.20% )
>    121,457,601,848 cycles                    #    2.888 GHz                      ( +-  0.93% ) [50.75%]
>    <not supported> stalled-cycles-frontend 
>    <not supported> stalled-cycles-backend  
>     47,854,828,552 instructions              #    0.39  insns per cycle          ( +-  0.36% ) [77.09%]
>      8,981,553,714 branches                  #  213.577 M/sec                    ( +-  0.42% ) [75.41%]
>        274,229,438 branch-misses             #    3.05% of all branches          ( +-  0.20% ) [75.44%]
> 
>       14.340330678 seconds time elapsed                                          ( +-  1.79% )
> 

Interesting that perf bench gives me a little better performance with
the idle_balance than without too. But hackbench still shows a huge
performance without idle_balance. The funny part about that is perf
bench sched messaging is based off of hackbench??

I would really like to know why hackbench gets a 50% performance without
idle balancing. Perhaps it is some kind of fluke :-/

-- Steve


