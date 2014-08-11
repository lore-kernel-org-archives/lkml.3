Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197AbaHKD1M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 23:27:12 -0400
Received: from gate.crashing.org ([63.228.1.57]:53582 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763AbaHKD1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 23:27:10 -0400
Message-ID: <1407725838.4508.57.camel@pasglop>
Subject: Re: [PATCH 4/14] powerpc/pseries: delete unneeded test before
 of_node_put
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Date: Mon, 11 Aug 2014 12:57:18 +1000
In-Reply-To: <1407492475-26283-6-git-send-email-Julia.Lawall@lip6.fr>
References: <1407492475-26283-6-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-08-08 at 12:07 +0200, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Of_node_put supports NULL as its argument, so the initial test is not
> necessary.
> 
> Suggested by Uwe Kleine-König.
> 
> The semantic patch that fixes this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression e;
> @@
> 
> -if (e)
>    of_node_put(e);
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

> 
> ---
>  arch/powerpc/platforms/pseries/iommu.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/powerpc/platforms/pseries/iommu.c b/arch/powerpc/platforms/pseries/iommu.c
> index 33b552f..2ea6831 100644
> --- a/arch/powerpc/platforms/pseries/iommu.c
> +++ b/arch/powerpc/platforms/pseries/iommu.c
> @@ -575,8 +575,7 @@ static void pci_dma_bus_setup_pSeries(struct pci_bus *bus)
>  	while (isa_dn && isa_dn != dn)
>  		isa_dn = isa_dn->parent;
>  
> -	if (isa_dn_orig)
> -		of_node_put(isa_dn_orig);
> +	of_node_put(isa_dn_orig);
>  
>  	/* Count number of direct PCI children of the PHB. */
>  	for (children = 0, tmp = dn->child; tmp; tmp = tmp->sibling)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


