Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894AbaD0K3S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 06:29:18 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:20094 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753387AbaD0K3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 06:29:17 -0400
X-IronPort-AV: E=Sophos;i="4.97,936,1389740400"; 
   d="scan'208";a="70551481"
Date: Sun, 27 Apr 2014 12:29:14 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Javier Martinez Canillas <javier@dowhile0.org>
cc: Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, Michal Marek <mmarek@suse.cz>,
        cocci@systeme.lip6.fr, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] scripts/coccinelle: use BIT() macro if possible
In-Reply-To: <1398558586-28931-1-git-send-email-javier@dowhile0.org>
Message-ID: <alpine.DEB.2.02.1404271228100.2006@localhost6.localdomain6>
References: <1398558586-28931-1-git-send-email-javier@dowhile0.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 27 Apr 2014, Javier Martinez Canillas wrote:

> Using the BIT() macro instead of manually shifting bits
> makes the code less error prone and also more readable.
> 
> Signed-off-by: Javier Martinez Canillas <javier@dowhile0.org>
> ---
> 
> An example of the patches that can be obtained with this spatch:
> 
> http://www.mail-archive.com/linux-gpio@vger.kernel.org/msg02722.html
> 
>  scripts/coccinelle/api/bit.cocci | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
>  create mode 100644 scripts/coccinelle/api/bit.cocci
> 
> diff --git a/scripts/coccinelle/api/bit.cocci b/scripts/coccinelle/api/bit.cocci
> new file mode 100644
> index 0000000..a5df73a
> --- /dev/null
> +++ b/scripts/coccinelle/api/bit.cocci
> @@ -0,0 +1,25 @@
> +// Use the macro BIT() macro if possible
> +//
> +// Confidence: High
> +// Copyright (C) 2014 Javier Martinez Canillas.  GPLv2.
> +// URL: http://coccinelle.lip6.fr/
> +// Options: --include-headers
> +
> +@hasbitops@
> +@@
> +
> +#include <linux/bitops.h>

Here you could say:

@usesbit@
@@
BIT(...)


> +@depends on hasbitops@

and then here it would be

@depends on hasbitops && usesbit@

julia

> +expression E;
> +@@
> +
> +- 1 << E
> ++ BIT(E)
> +
> +@depends on hasbitops@
> +expression E;
> +@@
> +
> +- BIT((E))
> ++ BIT(E)
> -- 
> 1.9.1
> 
> 
