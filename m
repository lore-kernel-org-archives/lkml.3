Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933425AbbAIK6Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:58:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58768 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932463AbbAIK6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:58:22 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1417824042-539-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1417824042-539-1-git-send-email-linux@rasmusvillemoes.dk>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: dhowells@redhat.com, Rusty Russell <rusty@rustcorp.com.au>,
        d.kasatkin@samsung.com, linux-kernel@vger.kernel.org,
        keyrings@linux-nfs.org
Subject: Re: [PATCH 1/2] MPILIB: Fix comparison of negative MPIs
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2179.1420801081.1@warthog.procyon.org.uk>
Date: Fri, 09 Jan 2015 10:58:01 +0000
Message-ID: <2180.1420801081@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think you're right - *adding* the two sizes makes no sense.  cc'ing Dmitry
also for his check.

David


Rasmus Villemoes <linux@rasmusvillemoes.dk> wrote:

> If u and v both represent negative integers and their limb counts
> happen to differ, mpi_cmp will always return a positive value - this
> is obviously bogus. u is smaller than v if and only if it is larger in
> absolute value.
> 
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> ---
>  lib/mpi/mpi-cmp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/mpi/mpi-cmp.c b/lib/mpi/mpi-cmp.c
> index 1871e7b61ca0..3801694240d8 100644
> --- a/lib/mpi/mpi-cmp.c
> +++ b/lib/mpi/mpi-cmp.c
> @@ -57,7 +57,7 @@ int mpi_cmp(MPI u, MPI v)
>  	if (usize != vsize && !u->sign && !v->sign)
>  		return usize - vsize;
>  	if (usize != vsize && u->sign && v->sign)
> -		return vsize + usize;
> +		return vsize - usize;
>  	if (!usize)
>  		return 0;
>  	cmp = mpihelp_cmp(u->d, v->d, usize);
> -- 
> 2.1.3
> 
