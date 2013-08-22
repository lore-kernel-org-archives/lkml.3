Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab3HVBax (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 21:30:53 -0400
Received: from mail-db9lp0248.outbound.messaging.microsoft.com ([213.199.154.248]:54601
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752740Ab3HVBaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 21:30:52 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh8275dh1de097hz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Thu, 22 Aug 2013 09:31:47 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
CC: "'Vinod Koul'" <vinod.koul@intel.com>, "'Dan Williams'" <djbw@fb.com>,
        <linux-kernel@vger.kernel.org>,
        "'Andy Shevchenko'" <andriy.shevchenko@linux.intel.com>,
        "'Fabio Estevam'" <fabio.estevam@freescale.com>
Subject: Re: [PATCH] dma: ipu: remove unnecessary platform_set_drvdata()
Message-ID: <20130822013145.GG30533@S2101-09.ap.freescale.net>
References: <003101ce9e54$35dc8910$a1959b30$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <003101ce9e54$35dc8910$a1959b30$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 06:52:54PM +0900, Jingoo Han wrote:
> The driver core clears the driver data to NULL after device_release
> or on probe failure. Thus, it is not needed to manually clear the
> device driver data to NULL.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Acked-by: Shawn Guo <shawn.guo@linaro.org>

> ---
>  drivers/dma/ipu/ipu_idmac.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/dma/ipu/ipu_idmac.c b/drivers/dma/ipu/ipu_idmac.c
> index 608d4a2..cb9c0bc 100644
> --- a/drivers/dma/ipu/ipu_idmac.c
> +++ b/drivers/dma/ipu/ipu_idmac.c
> @@ -1764,7 +1764,6 @@ static int ipu_remove(struct platform_device *pdev)
>  	iounmap(ipu->reg_ic);
>  	iounmap(ipu->reg_ipu);
>  	tasklet_kill(&ipu->tasklet);
> -	platform_set_drvdata(pdev, NULL);
>  
>  	return 0;
>  }
> -- 
> 1.7.10.4
> 
> 

