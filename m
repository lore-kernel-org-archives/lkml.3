Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745AbaCFPSH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 10:18:07 -0500
Received: from mga09.intel.com ([134.134.136.24]:31902 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752594AbaCFPSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 10:18:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,600,1389772800"; 
   d="scan'208";a="467765971"
Date: Thu, 6 Mar 2014 20:44:40 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Jingchang Lu <b35083@freescale.com>
Cc: dan.carpenter@oracle.com, linux-arm-kernel@lists.infradead.org,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dma: fsl-edma: fix static checker warning of NULL
 dereference
Message-ID: <20140306151440.GH1976@intel.com>
References: <1392965406-10112-1-git-send-email-b35083@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392965406-10112-1-git-send-email-b35083@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 02:50:06PM +0800, Jingchang Lu wrote:
> The static checker reports following warning:
> 	drivers/dma/fsl-edma.c:732 fsl_edma_xlate()
> 	error: we previously assumed 'chan' could be null (see line 737)
> The changes of the loop cursor in the iteration may result in
> NULL dereference when dma_get_slave_channel failed but loop
> will continue. So use list_for_each_entry_safe() instead of
> list_for_each_entry() to against this.
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Jingchang Lu <b35083@freescale.com>

Applied, thanks

-- 
~Vinod
> ---
>  drivers/dma/fsl-edma.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dma/fsl-edma.c b/drivers/dma/fsl-edma.c
> index 9025300..381e793 100644
> --- a/drivers/dma/fsl-edma.c
> +++ b/drivers/dma/fsl-edma.c
> @@ -723,13 +723,13 @@ static struct dma_chan *fsl_edma_xlate(struct of_phandle_args *dma_spec,
>  		struct of_dma *ofdma)
>  {
>  	struct fsl_edma_engine *fsl_edma = ofdma->of_dma_data;
> -	struct dma_chan *chan;
> +	struct dma_chan *chan, *_chan;
>  
>  	if (dma_spec->args_count != 2)
>  		return NULL;
>  
>  	mutex_lock(&fsl_edma->fsl_edma_mutex);
> -	list_for_each_entry(chan, &fsl_edma->dma_dev.channels, device_node) {
> +	list_for_each_entry_safe(chan, _chan, &fsl_edma->dma_dev.channels, device_node) {
>  		if (chan->client_count)
>  			continue;
>  		if ((chan->chan_id / DMAMUX_NR) == dma_spec->args[0]) {
> -- 
> 1.8.0
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe dmaengine" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
