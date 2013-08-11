Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107Ab3HKVQr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 17:16:47 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:3772 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754959Ab3HKVQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 17:16:45 -0400
X-IronPort-AV: E=Sophos;i="4.89,858,1367964000"; 
   d="scan'208";a="29068496"
Date: Sun, 11 Aug 2013 23:16:37 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
cc: linux-kernel@vger.kernel.org, cocci@systeme.lip6.fr,
        Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH v3] coccinelle: replace 0/1 with false/true in functions
 returning bool
In-Reply-To: <1376255112-22787-1-git-send-email-linux@rasmusvillemoes.dk>
Message-ID: <alpine.DEB.2.02.1308112315150.2072@localhost6.localdomain6>
References: <1376071193-21146-1-git-send-email-linux@rasmusvillemoes.dk> <1376255112-22787-1-git-send-email-linux@rasmusvillemoes.dk>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Julia Lawall <Julia.Lawall@lip6.fr>


On Sun, 11 Aug 2013, Rasmus Villemoes wrote:

> This semantic patch replaces "return {0,1};" with "return
> {false,true};" in functions returning bool.
> 
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> ---
> v2: Simplified script, and eliminate whitespace mangling at the same
> time. Thanks to Julia Lawall.
> 
> v3: Further improvements from Julia. In particular, it now also does
> header files.
> 
>  scripts/coccinelle/misc/boolreturn.cocci |   58 ++++++++++++++++++++++++++++++
>  1 file changed, 58 insertions(+)
>  create mode 100644 scripts/coccinelle/misc/boolreturn.cocci
> 
> diff --git a/scripts/coccinelle/misc/boolreturn.cocci b/scripts/coccinelle/misc/boolreturn.cocci
> new file mode 100644
> index 0000000..a43c7b0
> --- /dev/null
> +++ b/scripts/coccinelle/misc/boolreturn.cocci
> @@ -0,0 +1,58 @@
> +/// Return statements in functions returning bool should use
> +/// true/false instead of 1/0.
> +//
> +// Confidence: High
> +// Options: --no-includes --include-headers
> +
> +virtual patch
> +virtual report
> +virtual context
> +
> +@r1 depends on patch@
> +identifier fn;
> +typedef bool;
> +symbol false;
> +symbol true;
> +@@
> +
> +bool fn ( ... )
> +{
> +<...
> +return
> +(
> +- 0
> ++ false
> +|
> +- 1
> ++ true
> +)
> +  ;
> +...>
> +}
> +
> +@r2 depends on report || context@
> +identifier fn;
> +position p;
> +@@
> +
> +bool fn ( ... )
> +{
> +<...
> +return
> +(
> +* 0@p
> +|
> +* 1@p
> +)
> +  ;
> +...>
> +}
> +
> +
> +@script:python depends on report@
> +p << r2.p;
> +fn << r2.fn;
> +@@
> +
> +msg = "WARNING: return of 0/1 in function '%s' with return type bool" % fn
> +coccilib.report.print_report(p[0], msg)
> -- 
> 1.7.9.5
> 
> 
