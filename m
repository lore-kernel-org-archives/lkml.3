Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab3KGCeF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 21:34:05 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:40700 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751924Ab3KGCeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 21:34:02 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh8275dh1de097hz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Thu, 7 Nov 2013 10:34:47 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Jisheng Zhang <jszhang@marvell.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: phy: phy-mxs-usb: set the correct platform drvdata
Message-ID: <20131107023446.GC5994@S2101-09.ap.freescale.net>
References: <1383791180-3579-1-git-send-email-jszhang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1383791180-3579-1-git-send-email-jszhang@marvell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 07, 2013 at 10:26:20AM +0800, Jisheng Zhang wrote:
> We need to set mxs_phy rather as the platform drvdata so that we can get
> the correct mxs_phy in mxs_phy_remove().
> 
> Change-Id: I6e1753cc978e2ed3fbb3d1865be0c54031d337d2
> Signed-off-by: Jisheng Zhang <jszhang@marvell.com>

Acked-by: Shawn Guo <shawn.guo@linaro.org>

Change-Id should be dropped though.

Shawn

> ---
>  drivers/usb/phy/phy-mxs-usb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/phy/phy-mxs-usb.c b/drivers/usb/phy/phy-mxs-usb.c
> index fdd33b4..545844b 100644
> --- a/drivers/usb/phy/phy-mxs-usb.c
> +++ b/drivers/usb/phy/phy-mxs-usb.c
> @@ -164,7 +164,7 @@ static int mxs_phy_probe(struct platform_device *pdev)
>  
>  	mxs_phy->clk = clk;
>  
> -	platform_set_drvdata(pdev, &mxs_phy->phy);
> +	platform_set_drvdata(pdev, mxs_phy);
>  
>  	ret = usb_add_phy_dev(&mxs_phy->phy);
>  	if (ret)
> -- 
> 1.8.4.2
> 

