Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab3GTMWh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 08:22:37 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:47082 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719Ab3GTMWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 08:22:17 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] of/irq: Avoid calling list_first_entry() for empty list
To: Axel Lin <axel.lin@ingics.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Stephen Warren <swarren@nvidia.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <1371973807.23555.1.camel@phoenix>
References: <1371973807.23555.1.camel@phoenix>
Date: Sat, 20 Jul 2013 06:35:18 +0100
Message-Id: <20130720053519.41B773E170B@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Jun 2013 15:50:07 +0800, Axel Lin <axel.lin@ingics.com> wrote:
> list_first_entry() expects the list is not empty, we need to check if list is
> empty before calling list_first_entry(). Thus use list_first_entry_or_null()
> instead of list_first_entry().
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Applied, thanks.

g.

> ---
>  drivers/of/irq.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/of/irq.c b/drivers/of/irq.c
> index a3c1c5a..5c645c7 100644
> --- a/drivers/of/irq.c
> +++ b/drivers/of/irq.c
> @@ -482,8 +482,9 @@ void __init of_irq_init(const struct of_device_id *matches)
>  		}
>  
>  		/* Get the next pending parent that might have children */
> -		desc = list_first_entry(&intc_parent_list, typeof(*desc), list);
> -		if (list_empty(&intc_parent_list) || !desc) {
> +		desc = list_first_entry_or_null(&intc_parent_list,
> +						typeof(*desc), list);
> +		if (!desc) {
>  			pr_err("of_irq_init: children remain, but no parents\n");
>  			break;
>  		}
> -- 
> 1.8.1.2
> 
> 
> 

