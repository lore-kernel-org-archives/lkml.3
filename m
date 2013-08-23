Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620Ab3HWCn2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 22:43:28 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:6404 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754499Ab3HWCn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 22:43:26 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh8275dh1de097hz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Fri, 23 Aug 2013 10:44:32 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
CC: "'Andrew Morton'" <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "'Evgeniy Polyakov'" <zbr@ioremap.net>,
        "'Martin Fuzzey'" <mfuzzey@parkeon.com>
Subject: Re: [PATCH] w1: mxc_w1: remove unnecessary platform_set_drvdata()
Message-ID: <20130823024430.GB594@S2101-09.ap.freescale.net>
References: <002901ce9ede$3cfa5490$b6eefdb0$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <002901ce9ede$3cfa5490$b6eefdb0$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-FOPE-CRA-Verdict: 70.37.183.190$parkeon.com%21616%4%sigmatel.com%False%False%0$
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%PARKEON.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 11:20:58AM +0900, Jingoo Han wrote:
> The driver core clears the driver data to NULL after device_release
> or on probe failure. Thus, it is not needed to manually clear the
> device driver data to NULL.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Acked-by: Shawn Guo <shawn.guo@linaro.org>

> ---
>  drivers/w1/masters/mxc_w1.c |    2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/w1/masters/mxc_w1.c b/drivers/w1/masters/mxc_w1.c
> index 47e12cf..15c7251 100644
> --- a/drivers/w1/masters/mxc_w1.c
> +++ b/drivers/w1/masters/mxc_w1.c
> @@ -152,8 +152,6 @@ static int mxc_w1_remove(struct platform_device *pdev)
>  
>  	clk_disable_unprepare(mdev->clk);
>  
> -	platform_set_drvdata(pdev, NULL);
> -
>  	return 0;
>  }
>  
> -- 
> 1.7.10.4
> 
> 

