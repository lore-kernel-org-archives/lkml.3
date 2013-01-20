Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623Ab3ATWYw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 17:24:52 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:47499 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515Ab3ATWYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 17:24:51 -0500
Message-ID: <50FC6EB1.4050704@gmail.com>
Date: Sun, 20 Jan 2013 16:24:49 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Cong Ding <dinggnu@gmail.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] of: dma.c: fix memory leakage
References: <1358600805-20193-1-git-send-email-dinggnu@gmail.com>
In-Reply-To: <1358600805-20193-1-git-send-email-dinggnu@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2013 07:06 AM, Cong Ding wrote:
> The memory allocated to ofdma might be a leakage when error occurs.
> 
> Signed-off-by: Cong Ding <dinggnu@gmail.com>

You need to send this to whomever is working on DMA bindings.

Rob

> ---
>  drivers/of/dma.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/of/dma.c b/drivers/of/dma.c
> index 59631b2..583e50e3 100644
> --- a/drivers/of/dma.c
> +++ b/drivers/of/dma.c
> @@ -107,6 +107,7 @@ int of_dma_controller_register(struct device_node *np,
>  	if (!nbcells) {
>  		pr_err("%s: #dma-cells property is missing or invalid\n",
>  		       __func__);
> +		kfree(ofdma);
>  		return -EINVAL;
>  	}
>  
> 
