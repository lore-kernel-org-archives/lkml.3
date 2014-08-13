Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154AbaHMW6D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 18:58:03 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:52254 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046AbaHMWts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 18:49:48 -0400
Date: Wed, 13 Aug 2014 15:49:43 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        David Howells <dhowells@redhat.com>,
        Masanari Iida <standby24x7@gmail.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] doc: memory-barriers.txt: Minor correction in Control
 dependencies
Message-ID: <20140813224943.GC4752@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1407797503-24727-1-git-send-email-bobby.prani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407797503-24727-1-git-send-email-bobby.prani@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081322-1344-0000-0000-00000372CEE9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 06:51:39PM -0400, Pranith Kumar wrote:
> Minor corrections in memory-barriers.txt document.
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> ---
>  Documentation/memory-barriers.txt | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
> index abec3f9..41a6c9c 100644
> --- a/Documentation/memory-barriers.txt
> +++ b/Documentation/memory-barriers.txt
> @@ -627,7 +627,7 @@ proving the value of 'a', and the pair of barrier() invocations are
>  required to prevent the compiler from pulling the two identical stores
>  to 'b' out from the legs of the "if" statement.
> 
> -It is important to note that control dependencies absolutely require a
> +It is important to note that control dependencies absolutely require
>  a conditional.  For example, the following "optimized" version of
>  the above example breaks ordering, which is why the barrier() invocations
>  are absolutely required if you have identical stores in both legs of
> @@ -652,7 +652,7 @@ for example, as follows:
>  		do_something();
>  	} else {
>  		barrier();
> -		ACCESS_ONCE(b) = q / 3;
> +		ACCESS_ONCE(b) = q / 2;
>  		do_something_else();
>  	}

This one is gone due to the two-legged "if" statements being reworked.

> @@ -710,7 +710,7 @@ x and y both being zero:
> 
>  The above two-CPU example will never trigger the assert().  However,
>  if control dependencies guaranteed transitivity (which they do not),
> -then adding the following two CPUs would guarantee a related assertion:
> +then adding the following CPU would guarantee a related assertion:
> 
>  	CPU 2
>  	=====================
> @@ -719,8 +719,8 @@ then adding the following two CPUs would guarantee a related assertion:
>  	assert(!(r1 == 2 && r2 == 1 && x == 2)); /* FAILS!!! */
> 
>  But because control dependencies do -not- provide transitivity, the
> -above assertion can fail after the combined four-CPU example completes.
> -If you need the four-CPU example to provide ordering, you will need
> +above assertion can fail after the combined three-CPU example completes.
> +If you need the three-CPU example to provide ordering, you will need
>  smp_mb() between the loads and stores in the CPU 0 and CPU 1 code fragments,
>  that is, just before or just after the "if" statements.

Nikolay Samofatov beat you to this one by a couple of weeks.

Nevertheless, thank you for your careful review!

							Thanx, Paul

