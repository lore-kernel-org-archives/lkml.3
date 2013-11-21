Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab3KUTnt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 14:43:49 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:39868 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395Ab3KUTns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 14:43:48 -0500
X-Originating-IP: 173.246.103.110
Date: Thu, 21 Nov 2013 11:43:35 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: Re: [PATCH RFC tip/core/rcu 1/3] documentation: Add needed
 ACCESS_ONCE() calls to memory-barriers.txt
Message-ID: <20131121194334.GC14144@jtriplet-mobl1>
References: <20131121174824.GA6611@linux.vnet.ibm.com>
 <1385056127-6980-1-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385056127-6980-1-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 09:48:45AM -0800, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> The Documentation/memory-barriers.txt file was written before the need
> for ACCESS_ONCE() was fully appreciated.  It therefore contains no
> ACCESS_ONCE() calls, which can be a problem when people lift examples
> from it.  This commit therefore adds ACCESS_ONCE() calls.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: David Howells <dhowells@redhat.com>
> ---
>  Documentation/memory-barriers.txt | 204 +++++++++++++++++++++++---------------
>  1 file changed, 124 insertions(+), 80 deletions(-)
> 
> diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
> index c8c42e64e953..eccc83a40ce1 100644
> --- a/Documentation/memory-barriers.txt
> +++ b/Documentation/memory-barriers.txt
> @@ -194,18 +194,20 @@ There are some minimal guarantees that may be expected of a CPU:
>   (*) On any given CPU, dependent memory accesses will be issued in order, with
>       respect to itself.  This means that for:
>  
> -	Q = P; D = *Q;
> +	ACCESS_ONCE(Q) = P; smp_memory_barrier_depends(); D = ACCESS_ONCE(*Q);

That should be smp_read_barrier_depends().

Also, most of the time shouldn't that use rcu_dereference rather than a
raw smp_read_barrier_depends()?

- Josh Triplett
