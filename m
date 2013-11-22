Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664Ab3KVN5S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 08:57:18 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:59169 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500Ab3KVN5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 08:57:17 -0500
Date: Fri, 22 Nov 2013 05:57:11 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/locking] Documentation/memory-barriers.txt:  Fix a
 typo in the data dependency description
Message-ID: <20131122135710.GQ4138@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <tip-e0edc78f25c020dea66742c05a7fbcb2ff3df629@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-e0edc78f25c020dea66742c05a7fbcb2ff3df629@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13112213-9332-0000-0000-000002438997
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 04:31:17AM -0800, tip-bot for Ingo Molnar wrote:
> Commit-ID:  e0edc78f25c020dea66742c05a7fbcb2ff3df629
> Gitweb:     http://git.kernel.org/tip/e0edc78f25c020dea66742c05a7fbcb2ff3df629
> Author:     Ingo Molnar <mingo@kernel.org>
> AuthorDate: Fri, 22 Nov 2013 11:24:53 +0100
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Fri, 22 Nov 2013 11:46:12 +0100
> 
> Documentation/memory-barriers.txt: Fix a typo in the data dependency description
> 
> This typo has been there forever, it is 7.5 years old, looks like this
> section of our memory ordering documentation is a place where most eyes
> are glazed over already ;-)
> 
> [ Also fix some stray spaces and stray tabs while at it, shrinking the
>   file by 49 bytes. Visual output unchanged. ]
> 
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Link: http://lkml.kernel.org/n/tip-gncea9cb8igosblizfqMXrie@git.kernel.org
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> ---
>  Documentation/memory-barriers.txt | 42 +++++++++++++++++++--------------------
>  1 file changed, 21 insertions(+), 21 deletions(-)
> 
> diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
> index c8c42e6..020cccd 100644
> --- a/Documentation/memory-barriers.txt
> +++ b/Documentation/memory-barriers.txt
> @@ -500,7 +500,7 @@ odd-numbered bank is idle, one can see the new value of the pointer P (&B),
>  but the old value of the variable B (2).
> 
> 
> -Another example of where data dependency barriers might by required is where a
> +Another example of where data dependency barriers might be required is where a

Heh!  It took me no fewer than three reads to spot it even in the diff!  ;-)

							Thanx, Paul

>  number is read from memory and then used to calculate the index for an array
>  access:
> 
> @@ -882,12 +882,12 @@ cache it for later use.
> 
>  Consider:
> 
> -	CPU 1	   		CPU 2
> +	CPU 1			CPU 2
>  	=======================	=======================
> -	 	   		LOAD B
> -	 	   		DIVIDE		} Divide instructions generally
> -	 	   		DIVIDE		} take a long time to perform
> -	 	   		LOAD A
> +				LOAD B
> +				DIVIDE		} Divide instructions generally
> +				DIVIDE		} take a long time to perform
> +				LOAD A
> 
>  Which might appear as this:
> 
> @@ -910,13 +910,13 @@ Which might appear as this:
>  Placing a read barrier or a data dependency barrier just before the second
>  load:
> 
> -	CPU 1	   		CPU 2
> +	CPU 1			CPU 2
>  	=======================	=======================
> -	 	   		LOAD B
> -	 	   		DIVIDE
> -	 	   		DIVIDE
> +				LOAD B
> +				DIVIDE
> +				DIVIDE
>  				<read barrier>
> -	 	   		LOAD A
> +				LOAD A
> 
>  will force any value speculatively obtained to be reconsidered to an extent
>  dependent on the type of barrier used.  If there was no change made to the
> @@ -1887,8 +1887,8 @@ functions:
>       space should suffice for PCI.
> 
>       [*] NOTE! attempting to load from the same location as was written to may
> -     	 cause a malfunction - consider the 16550 Rx/Tx serial registers for
> -     	 example.
> +	 cause a malfunction - consider the 16550 Rx/Tx serial registers for
> +	 example.
> 
>       Used with prefetchable I/O memory, an mmiowb() barrier may be required to
>       force stores to be ordered.
> @@ -1955,19 +1955,19 @@ barriers for the most part act at the interface between the CPU and its cache
>  	                          :
>  	+--------+    +--------+  :   +--------+    +-----------+
>  	|        |    |        |  :   |        |    |           |    +--------+
> -	|  CPU   |    | Memory |  :   | CPU    |    |           |    |	      |
> -	|  Core  |--->| Access |----->| Cache  |<-->|           |    |	      |
> +	|  CPU   |    | Memory |  :   | CPU    |    |           |    |        |
> +	|  Core  |--->| Access |----->| Cache  |<-->|           |    |        |
>  	|        |    | Queue  |  :   |        |    |           |--->| Memory |
> -	|        |    |        |  :   |        |    |           |    |	      |
> -	+--------+    +--------+  :   +--------+    |           |    | 	      |
> +	|        |    |        |  :   |        |    |           |    |        |
> +	+--------+    +--------+  :   +--------+    |           |    |        |
>  	                          :                 | Cache     |    +--------+
>  	                          :                 | Coherency |
>  	                          :                 | Mechanism |    +--------+
>  	+--------+    +--------+  :   +--------+    |           |    |	      |
>  	|        |    |        |  :   |        |    |           |    |        |
>  	|  CPU   |    | Memory |  :   | CPU    |    |           |--->| Device |
> -	|  Core  |--->| Access |----->| Cache  |<-->|           |    | 	      |
> -	|        |    | Queue  |  :   |        |    |           |    | 	      |
> +	|  Core  |--->| Access |----->| Cache  |<-->|           |    |        |
> +	|        |    | Queue  |  :   |        |    |           |    |        |
>  	|        |    |        |  :   |        |    |           |    +--------+
>  	+--------+    +--------+  :   +--------+    +-----------+
>  	                          :
> @@ -2090,7 +2090,7 @@ CPU's caches by some other cache event:
>  	p = &v;		q = p;
>  			<D:request p>
>  	<B:modify p=&v>	<D:commit p=&v>
> -		  	<D:read p>
> +			<D:read p>
>  			x = *q;
>  			<C:read *q>	Reads from v before v updated in cache
>  			<C:unbusy>
> @@ -2115,7 +2115,7 @@ queue before processing any further requests:
>  	p = &v;		q = p;
>  			<D:request p>
>  	<B:modify p=&v>	<D:commit p=&v>
> -		  	<D:read p>
> +			<D:read p>
>  			smp_read_barrier_depends()
>  			<C:unbusy>
>  			<C:commit v=2>
> 

