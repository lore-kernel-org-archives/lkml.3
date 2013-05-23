Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758493Ab3EWLGb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 07:06:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:46454 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757978Ab3EWLGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 07:06:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,728,1363158000"; 
   d="scan'208";a="338794526"
Date: Thu, 23 May 2013 16:00:03 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Arnd Bergmann <arnd@arndb.de>, Jon Hunter <jon-hunter@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] dma: of: Remove restriction that #dma-cells can't
 be 0
Message-ID: <20130523103003.GD30200@intel.com>
References: <1366619613-30639-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366619613-30639-1-git-send-email-lars@metafoo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 22, 2013 at 10:33:32AM +0200, Lars-Peter Clausen wrote:
> There is no sensible reason why #dma-cells shouldn't be allowed to be 0. It is
> completely up to the DMA controller how many additional parameters, besides the
> phandle, it needs to identify a channel. E.g. for DMA controller with only one
> channel or for DMA controllers which don't have a restriction on which channel
> can be used for which peripheral it completely legitimate to not require any
> additional parameters.
> 
> Also fixes the following warning:
> 	drivers/dma/of-dma.c: In function 'of_dma_controller_register':
> 	drivers/dma/of-dma.c:67:7: warning: 'nbcells' may be used uninitialized in this function
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Applied, both thanks

Sorry looks like I missed applying them earlier...

--
~Vinod

> ---
>  drivers/dma/of-dma.c | 11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/dma/of-dma.c b/drivers/dma/of-dma.c
> index 7aa0864..268cc8a 100644
> --- a/drivers/dma/of-dma.c
> +++ b/drivers/dma/of-dma.c
> @@ -64,7 +64,6 @@ int of_dma_controller_register(struct device_node *np,
>  				void *data)
>  {
>  	struct of_dma	*ofdma;
> -	int		nbcells;
>  	const __be32	*prop;
>  
>  	if (!np || !of_dma_xlate) {
> @@ -77,18 +76,16 @@ int of_dma_controller_register(struct device_node *np,
>  		return -ENOMEM;
>  
>  	prop = of_get_property(np, "#dma-cells", NULL);
> -	if (prop)
> -		nbcells = be32_to_cpup(prop);
> -
> -	if (!prop || !nbcells) {
> -		pr_err("%s: #dma-cells property is missing or invalid\n",
> +	if (!prop) {
> +		pr_err("%s: #dma-cells property is missing\n",
>  		       __func__);
>  		kfree(ofdma);
>  		return -EINVAL;
>  	}
>  
> +
>  	ofdma->of_node = np;
> -	ofdma->of_dma_nbcells = nbcells;
> +	ofdma->of_dma_nbcells = be32_to_cpup(prop);
>  	ofdma->of_dma_xlate = of_dma_xlate;
>  	ofdma->of_dma_data = data;
>  
> -- 
> 1.8.0
> 
