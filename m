Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932834Ab3CUJ34 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 05:29:56 -0400
Received: from mga14.intel.com ([143.182.124.37]:45334 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754118Ab3CUJ3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 05:29:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,884,1355126400"; 
   d="scan'208";a="217276099"
Date: Thu, 21 Mar 2013 14:34:47 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Markus Pargmann <mpa@pengutronix.de>
Cc: kernel@pengutronix.de, jon-hunter@ti.com, djbw@fb.com,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] DMA: of: Constant names
Message-ID: <20130321090447.GJ10326@intel.com>
References: <1361720169-3832-1-git-send-email-mpa@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361720169-3832-1-git-send-email-mpa@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 24, 2013 at 04:36:09PM +0100, Markus Pargmann wrote:
> No DMA of-function alters the name, so this patch changes the name arguments
> to be constant. Most drivers will probably request DMA channels using a
> constant name.
> 
> Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
Applied thanks

--
~Vinod
> ---
>  drivers/dma/dmaengine.c   | 2 +-
>  drivers/dma/of-dma.c      | 6 +++---
>  include/linux/dmaengine.h | 4 ++--
>  include/linux/of_dma.h    | 4 ++--
>  4 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
> index 242b8c0..779f43a 100644
> --- a/drivers/dma/dmaengine.c
> +++ b/drivers/dma/dmaengine.c
> @@ -555,7 +555,7 @@ EXPORT_SYMBOL_GPL(__dma_request_channel);
>   * @dev:	pointer to client device structure
>   * @name:	slave channel name
>   */
> -struct dma_chan *dma_request_slave_channel(struct device *dev, char *name)
> +struct dma_chan *dma_request_slave_channel(struct device *dev, const char *name)
>  {
>  	/* If device-tree is present get slave info from here */
>  	if (dev->of_node)
> diff --git a/drivers/dma/of-dma.c b/drivers/dma/of-dma.c
> index 69d04d2..6036cd0 100644
> --- a/drivers/dma/of-dma.c
> +++ b/drivers/dma/of-dma.c
> @@ -172,8 +172,8 @@ EXPORT_SYMBOL_GPL(of_dma_controller_free);
>   * specifiers, matches the name provided. Returns 0 if the name matches and
>   * a valid pointer to the DMA specifier is found. Otherwise returns -ENODEV.
>   */
> -static int of_dma_match_channel(struct device_node *np, char *name, int index,
> -				struct of_phandle_args *dma_spec)
> +static int of_dma_match_channel(struct device_node *np, const char *name,
> +				int index, struct of_phandle_args *dma_spec)
>  {
>  	const char *s;
>  
> @@ -198,7 +198,7 @@ static int of_dma_match_channel(struct device_node *np, char *name, int index,
>   * Returns pointer to appropriate dma channel on success or NULL on error.
>   */
>  struct dma_chan *of_dma_request_slave_channel(struct device_node *np,
> -					      char *name)
> +					      const char *name)
>  {
>  	struct of_phandle_args	dma_spec;
>  	struct of_dma		*ofdma;
> diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> index f593999..f062f89 100644
> --- a/include/linux/dmaengine.h
> +++ b/include/linux/dmaengine.h
> @@ -968,7 +968,7 @@ enum dma_status dma_sync_wait(struct dma_chan *chan, dma_cookie_t cookie);
>  enum dma_status dma_wait_for_async_tx(struct dma_async_tx_descriptor *tx);
>  void dma_issue_pending_all(void);
>  struct dma_chan *__dma_request_channel(dma_cap_mask_t *mask, dma_filter_fn fn, void *fn_param);
> -struct dma_chan *dma_request_slave_channel(struct device *dev, char *name);
> +struct dma_chan *dma_request_slave_channel(struct device *dev, const char *name);
>  void dma_release_channel(struct dma_chan *chan);
>  #else
>  static inline enum dma_status dma_wait_for_async_tx(struct dma_async_tx_descriptor *tx)
> @@ -984,7 +984,7 @@ static inline struct dma_chan *__dma_request_channel(dma_cap_mask_t *mask,
>  	return NULL;
>  }
>  static inline struct dma_chan *dma_request_slave_channel(struct device *dev,
> -							 char *name)
> +							 const char *name)
>  {
>  	return NULL;
>  }
> diff --git a/include/linux/of_dma.h b/include/linux/of_dma.h
> index d15073e..ce6a8ab 100644
> --- a/include/linux/of_dma.h
> +++ b/include/linux/of_dma.h
> @@ -40,7 +40,7 @@ extern int of_dma_controller_register(struct device_node *np,
>  		void *data);
>  extern int of_dma_controller_free(struct device_node *np);
>  extern struct dma_chan *of_dma_request_slave_channel(struct device_node *np,
> -						     char *name);
> +						     const char *name);
>  extern struct dma_chan *of_dma_simple_xlate(struct of_phandle_args *dma_spec,
>  		struct of_dma *ofdma);
>  #else
> @@ -58,7 +58,7 @@ static inline int of_dma_controller_free(struct device_node *np)
>  }
>  
>  static inline struct dma_chan *of_dma_request_slave_channel(struct device_node *np,
> -						     char *name)
> +						     const char *name)
>  {
>  	return NULL;
>  }
> -- 
> 1.8.1.2
> 
