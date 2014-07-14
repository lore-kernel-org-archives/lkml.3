Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468AbaGNLd1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 07:33:27 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:50693 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832AbaGNLdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 07:33:20 -0400
Date: Mon, 14 Jul 2014 12:33:13 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: linux-kernel@vger.kernel.org, sergei.shtylyov@cogentembedded.com,
        antoine.tenart@free-electrons.com, gregkh@linuxfoundation.org
Subject: Re: [PATCH 1/2] phy: core: Fix of_phy_provider_lookup to return PHY
 provider for sub node
Message-ID: <20140714113313.GM2954@lee--X1>
References: <1405333502-24385-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1405333502-24385-1-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2014, Kishon Vijay Abraham I wrote:

> Fixed of_phy_provider_lookup to return 'phy_provider' if _of_phy_get
> passes the node pointer of the sub-node of phy provider node. This is
> needed when phy provider implements multiple PHYs and each PHY is
> modelled as the sub-node of PHY provider device node.
> 
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

This should be an Acked-by, but otherwise patch looks good.

> ---
>  drivers/phy/phy-core.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
> index 75c9739..527e744 100644
> --- a/drivers/phy/phy-core.c
> +++ b/drivers/phy/phy-core.c
> @@ -87,10 +87,15 @@ static struct phy *phy_lookup(struct device *device, const char *port)
>  static struct phy_provider *of_phy_provider_lookup(struct device_node *node)
>  {
>  	struct phy_provider *phy_provider;
> +	struct device_node *child;
>  
>  	list_for_each_entry(phy_provider, &phy_provider_list, list) {
>  		if (phy_provider->dev->of_node == node)
>  			return phy_provider;
> +
> +		for_each_child_of_node(phy_provider->dev->of_node, child)
> +			if (child == node)
> +				return phy_provider;
>  	}
>  
>  	return ERR_PTR(-EPROBE_DEFER);

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
