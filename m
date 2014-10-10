Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228AbaJJHz2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 03:55:28 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:14445 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751446AbaJJHzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 03:55:25 -0400
X-IronPort-AV: E=Sophos;i="5.04,690,1406584800"; 
   d="scan'208";a="100378760"
Date: Fri, 10 Oct 2014 09:55:16 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Fabian Frederick <fabf@skynet.be>
cc: linux-kernel@vger.kernel.org, Dan Mick <dan.mick@inktank.com>,
        Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, Michal Marek <mmarek@suse.cz>,
        cocci@systeme.lip6.fr
Subject: Re: [PATCH 1/1 linux-next] scripts/coccinelle/misc/boolinit.cocci:
 fix assignment warnings
In-Reply-To: <1412925511-3556-1-git-send-email-fabf@skynet.be>
Message-ID: <alpine.DEB.2.10.1410100954590.2402@hadrien>
References: <1412925511-3556-1-git-send-email-fabf@skynet.be>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Julia Lawall <julia.lawall@lip6.fr>

Thanks!

On Fri, 10 Oct 2014, Fabian Frederick wrote:

> Replace "Assignment of bool to 0/1" by "Assignment of 0/1 to bool"
>
> Suggested-by: Dan Mick <dan.mick@inktank.com>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  scripts/coccinelle/misc/boolinit.cocci | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/scripts/coccinelle/misc/boolinit.cocci b/scripts/coccinelle/misc/boolinit.cocci
> index b9abed4..63c4562 100644
> --- a/scripts/coccinelle/misc/boolinit.cocci
> +++ b/scripts/coccinelle/misc/boolinit.cocci
> @@ -145,13 +145,13 @@ cocci.print_main("WARNING: Comparison of bool to 0/1",p)
>  p1 << r3.p1;
>  @@
>
> -cocci.print_main("WARNING: Assignment of bool to 0/1",p1)
> +cocci.print_main("WARNING: Assignment of 0/1 to bool",p1)
>
>  @script:python depends on org@
>  p2 << r3.p2;
>  @@
>
> -cocci.print_main("ERROR: Assignment of bool to non-0/1 constant",p2)
> +cocci.print_main("ERROR: Assignment of non-0/1 constant to bool",p2)
>
>  @script:python depends on report@
>  p << r1.p;
> @@ -169,10 +169,10 @@ coccilib.report.print_report(p[0],"WARNING: Comparison of bool to 0/1")
>  p1 << r3.p1;
>  @@
>
> -coccilib.report.print_report(p1[0],"WARNING: Assignment of bool to 0/1")
> +coccilib.report.print_report(p1[0],"WARNING: Assignment of 0/1 to bool")
>
>  @script:python depends on report@
>  p2 << r3.p2;
>  @@
>
> -coccilib.report.print_report(p2[0],"ERROR: Assignment of bool to non-0/1 constant")
> +coccilib.report.print_report(p2[0],"ERROR: Assignment of non-0/1 constant to bool")
> --
> 1.9.3
>
>
