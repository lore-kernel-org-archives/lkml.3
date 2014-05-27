Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318AbaE0LQg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 07:16:36 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:50483 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273AbaE0LQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 07:16:34 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH] of: mdio: fix compile warning in
 of_mdiobus_register_phy()
To: Christian Engelmayer <cengelma@gmx.at>, netdev@vger.kernel.org
Cc: s.hauer@pengutronix.de, f.fainelli@gmail.com, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christian Engelmayer <cengelma@gmx.at>
In-Reply-To: <1400880835-29537-1-git-send-email-cengelma@gmx.at>
References: <1400880835-29537-1-git-send-email-cengelma@gmx.at>
Date: Tue, 27 May 2014 12:16:28 +0100
Message-Id: <20140527111628.A11E1C4156C@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 May 2014 23:33:55 +0200, Christian Engelmayer <cengelma@gmx.at> wrote:
> Commit de906af1 (net: phy: make of_set_phy_supported work with genphy driver)
> removed the last user of variable 'max_speed' in function
> of_mdiobus_register_phy(), leading to compile warning "unused variable
> ‘max_speed’ [-Wunused-variable]". Thus remove it.
> 
> Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
> ---
> Compile tested. Applies against branch master in tree
> git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git

Acked-by: Grant Likely <grant.likely@linaro.org>

g.

> ---
>  drivers/of/of_mdio.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/of/of_mdio.c b/drivers/of/of_mdio.c
> index b857094..7c6e277 100644
> --- a/drivers/of/of_mdio.c
> +++ b/drivers/of/of_mdio.c
> @@ -46,7 +46,6 @@ static int of_mdiobus_register_phy(struct mii_bus *mdio, struct device_node *chi
>  	struct phy_device *phy;
>  	bool is_c45;
>  	int rc;
> -	u32 max_speed = 0;
>  	u32 phy_id;
>  
>  	is_c45 = of_device_is_compatible(child,
> -- 
> 1.9.1
> 

