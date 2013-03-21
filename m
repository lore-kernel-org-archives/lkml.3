Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324Ab3CUKLQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 06:11:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:12444 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754219Ab3CUKLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 06:11:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,884,1355126400"; 
   d="scan'208";a="305535409"
Date: Thu, 21 Mar 2013 15:16:09 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] DMA: OF: Check properties value before running
 be32_to_cpup() on it
Message-ID: <20130321094609.GM10326@intel.com>
References: <0a0ef15d47393fe9d24a395c38068b871f913776.1363337257.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0a0ef15d47393fe9d24a395c38068b871f913776.1363337257.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 15, 2013 at 02:18:20PM +0530, Viresh Kumar wrote:
> In of_dma_controller_register() routine we are calling of_get_property() as an
> parameter to be32_to_cpup(). In case the property doesn't exist we will get a
> crash.
> 
> This patch changes this code to check if we got a valid property first and then
> runs be32_to_cpup() on it.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
> 
> My mails are broken, i have pushed this patch here:
I noticed you used git send-email. Usually it will send patch properly
independent of whatever MUA you use. So I have the patch and its applied now :)

--
~Vinod 
> 
> http://git.linaro.org/gitweb?p=people/vireshk/linux.git;a=shortlog;h=refs/heads/dma-of-fix
> 
>  drivers/dma/of-dma.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dma/of-dma.c b/drivers/dma/of-dma.c
> index 69d04d2..09c7ad1 100644
> --- a/drivers/dma/of-dma.c
> +++ b/drivers/dma/of-dma.c
> @@ -93,6 +93,7 @@ int of_dma_controller_register(struct device_node *np,
>  {
>  	struct of_dma	*ofdma;
>  	int		nbcells;
> +	const __be32	*prop;
>  
>  	if (!np || !of_dma_xlate) {
>  		pr_err("%s: not enough information provided\n", __func__);
> @@ -103,8 +104,11 @@ int of_dma_controller_register(struct device_node *np,
>  	if (!ofdma)
>  		return -ENOMEM;
>  
> -	nbcells = be32_to_cpup(of_get_property(np, "#dma-cells", NULL));
> -	if (!nbcells) {
> +	prop = of_get_property(np, "#dma-cells", NULL);
> +	if (prop)
> +		nbcells = be32_to_cpup(prop);
> +
> +	if (!prop || !nbcells) {
>  		pr_err("%s: #dma-cells property is missing or invalid\n",
>  		       __func__);
>  		kfree(ofdma);
> -- 
> 1.7.12.rc2.18.g61b472e
> 
> 
