Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169AbaHMWuZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 18:50:25 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:34611 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754121AbaHMWuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 18:50:22 -0400
Date: Wed, 13 Aug 2014 15:50:17 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        David Howells <dhowells@redhat.com>,
        Masanari Iida <standby24x7@gmail.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] doc: memory-barriers.txt: Add barrier() to provide
 ordering
Message-ID: <20140813225017.GD4752@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1407797503-24727-1-git-send-email-bobby.prani@gmail.com>
 <1407797503-24727-2-git-send-email-bobby.prani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407797503-24727-2-git-send-email-bobby.prani@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081322-3532-0000-0000-000003D41661
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 06:51:40PM -0400, Pranith Kumar wrote:
> In the provably false case, add barrier() in both the legs of the if() condition
> to provide ordering.
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> ---
>  Documentation/memory-barriers.txt | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
> index 41a6c9c..0f2903f 100644
> --- a/Documentation/memory-barriers.txt
> +++ b/Documentation/memory-barriers.txt
> @@ -689,9 +689,11 @@ should do something like the following:
>  	q = ACCESS_ONCE(a);
>  	BUILD_BUG_ON(MAX <= 1); /* Order load from a with store to b. */
>  	if (q % MAX) {
> +		barrier();
>  		ACCESS_ONCE(b) = p;
>  		do_something();
>  	} else {
> +		barrier();
>  		ACCESS_ONCE(b) = p;
>  		do_something_else();
>  	}

This section had to be rewritten due to -O3.

							Thanx, Paul

