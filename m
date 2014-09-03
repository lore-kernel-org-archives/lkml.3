Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756374AbaICPIE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 11:08:04 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:52426 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751AbaICPIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 11:08:02 -0400
Date: Wed, 3 Sep 2014 08:07:51 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] doc: memory-barriers.txt: Correct example for
 reorderings
Message-ID: <20140903150751.GV5001@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1409715269-17390-1-git-send-email-bobby.prani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409715269-17390-1-git-send-email-bobby.prani@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14090315-0928-0000-0000-000004897645
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2014 at 11:34:29PM -0400, Pranith Kumar wrote:
> Correct the example of memory orderings in memory-barriers.txt
> 
> Commit 615cc2c9cf95 "Documentation/memory-barriers.txt: fix important typo re
> memory barriers" changed the assignment to x and y. Change the rest of the
> example to match this change.
> 
> Reported-by: Ganesh Rapolu <ganesh.rapolu@hotmail.com>
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>

Queued, thank you!

							Thanx, Paul

> ---
>  Documentation/memory-barriers.txt | 22 +++++++++++-----------
>  1 file changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
> index a4de88f..02f5de8 100644
> --- a/Documentation/memory-barriers.txt
> +++ b/Documentation/memory-barriers.txt
> @@ -121,22 +121,22 @@ For example, consider the following sequence of events:
>  The set of accesses as seen by the memory system in the middle can be arranged
>  in 24 different combinations:
> 
> -	STORE A=3,	STORE B=4,	x=LOAD A->3,	y=LOAD B->4
> -	STORE A=3,	STORE B=4,	y=LOAD B->4,	x=LOAD A->3
> -	STORE A=3,	x=LOAD A->3,	STORE B=4,	y=LOAD B->4
> -	STORE A=3,	x=LOAD A->3,	y=LOAD B->2,	STORE B=4
> -	STORE A=3,	y=LOAD B->2,	STORE B=4,	x=LOAD A->3
> -	STORE A=3,	y=LOAD B->2,	x=LOAD A->3,	STORE B=4
> -	STORE B=4,	STORE A=3,	x=LOAD A->3,	y=LOAD B->4
> +	STORE A=3,	STORE B=4,	y=LOAD A->3,	x=LOAD B->4
> +	STORE A=3,	STORE B=4,	x=LOAD B->4,	y=LOAD A->3
> +	STORE A=3,	y=LOAD A->3,	STORE B=4,	x=LOAD B->4
> +	STORE A=3,	y=LOAD A->3,	x=LOAD B->2,	STORE B=4
> +	STORE A=3,	x=LOAD B->2,	STORE B=4,	y=LOAD A->3
> +	STORE A=3,	x=LOAD B->2,	y=LOAD A->3,	STORE B=4
> +	STORE B=4,	STORE A=3,	y=LOAD A->3,	x=LOAD B->4
>  	STORE B=4, ...
>  	...
> 
>  and can thus result in four different combinations of values:
> 
> -	x == 1, y == 2
> -	x == 1, y == 4
> -	x == 3, y == 2
> -	x == 3, y == 4
> +	x == 2, y == 1
> +	x == 2, y == 3
> +	x == 4, y == 1
> +	x == 4, y == 3
> 
> 
>  Furthermore, the stores committed by a CPU to the memory system may not be
> -- 
> 2.1.0
> 

