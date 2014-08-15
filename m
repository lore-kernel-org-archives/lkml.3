Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751385AbaHONQS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 09:16:18 -0400
Received: from vps0.lunn.ch ([178.209.37.122]:34275 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751073AbaHONQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 09:16:17 -0400
Date: Fri, 15 Aug 2014 15:10:26 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Peter Griffin <peter.griffin@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kishon@ti.com, kgene.kim@samsung.com, maxime.ripard@free-electrons.com,
        linux-samsung-soc@vger.kernel.org, lee.jones@linaro.org,
        patches@linaro.org
Subject: Re: [PATCH 2/9] phy: phy-mvebu-sata: Add missing error check for
 devm_kzalloc
Message-ID: <20140815131026.GA17800@lunn.ch>
References: <1408106416-19044-1-git-send-email-peter.griffin@linaro.org>
 <1408106416-19044-3-git-send-email-peter.griffin@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408106416-19044-3-git-send-email-peter.griffin@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2014 at 01:40:09PM +0100, Peter Griffin wrote:
> Currently this driver is missing a check on the return value of devm_kzalloc,
> which would cause a NULL pointer dereference in a OOM situation.
> 
> This patch adds the aformentioned missing check.
> 
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>

Acked-by: Andrew Lunn <andrew@lunn.ch>

Thanks
	Andrew

> ---
>  drivers/phy/phy-mvebu-sata.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/phy/phy-mvebu-sata.c b/drivers/phy/phy-mvebu-sata.c
> index cc3c0e1..10bb8e5 100644
> --- a/drivers/phy/phy-mvebu-sata.c
> +++ b/drivers/phy/phy-mvebu-sata.c
> @@ -89,6 +89,8 @@ static int phy_mvebu_sata_probe(struct platform_device *pdev)
>  	struct phy *phy;
>  
>  	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
> +	if (!priv)
> +		return -ENOMEM;
>  
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	priv->base = devm_ioremap_resource(&pdev->dev, res);
> -- 
> 1.9.1
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
