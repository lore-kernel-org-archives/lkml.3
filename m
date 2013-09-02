Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096Ab3IBITU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 04:19:20 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50073 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069Ab3IBITS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 04:19:18 -0400
Date: Mon, 2 Sep 2013 10:19:14 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, vinod.koul@intel.com, djbw@fb.com
Subject: Re: [PATCH 1/1] dma: imx-dma: Remove redundant NULL check
Message-ID: <20130902081914.GN30088@pengutronix.de>
References: <1378108278-4051-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378108278-4051-1-git-send-email-sachin.kamat@linaro.org>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:18:59 up 8 days, 17:49, 36 users,  load average: 1.29, 1.31, 0.86
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 02, 2013 at 01:21:18PM +0530, Sachin Kamat wrote:
> kfree on a NULL pointer is a no-op. Null pointer check is
> not necessary.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Sascha Hauer <s.hauer@pengutronix.de>

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

Sascha

> ---
>  drivers/dma/imx-dma.c |    6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
> index ff2aab9..78f8ca5 100644
> --- a/drivers/dma/imx-dma.c
> +++ b/drivers/dma/imx-dma.c
> @@ -805,10 +805,8 @@ static void imxdma_free_chan_resources(struct dma_chan *chan)
>  	}
>  	INIT_LIST_HEAD(&imxdmac->ld_free);
>  
> -	if (imxdmac->sg_list) {
> -		kfree(imxdmac->sg_list);
> -		imxdmac->sg_list = NULL;
> -	}
> +	kfree(imxdmac->sg_list);
> +	imxdmac->sg_list = NULL;
>  }
>  
>  static struct dma_async_tx_descriptor *imxdma_prep_slave_sg(
> -- 
> 1.7.9.5
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
