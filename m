Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751377AbaEWV6E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 17:58:04 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:45563 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbaEWV6C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 17:58:02 -0400
MIME-Version: 1.0
In-Reply-To: <1400880835-29537-1-git-send-email-cengelma@gmx.at>
References: <1400880835-29537-1-git-send-email-cengelma@gmx.at>
From: Florian Fainelli <f.fainelli@gmail.com>
Date: Fri, 23 May 2014 14:57:21 -0700
Message-ID: <CAGVrzcY6CCAFO-vrkB7+H+XfSnPT7uhF2VbDzY5YC_XYa7fTRg@mail.gmail.com>
Subject: Re: [PATCH] of: mdio: fix compile warning in of_mdiobus_register_phy()
To: Christian Engelmayer <cengelma@gmx.at>
Cc: netdev <netdev@vger.kernel.org>, Sascha Hauer <s.hauer@pengutronix.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-05-23 14:33 GMT-07:00 Christian Engelmayer <cengelma@gmx.at>:
> Commit de906af1 (net: phy: make of_set_phy_supported work with genphy driver)
> removed the last user of variable 'max_speed' in function
> of_mdiobus_register_phy(), leading to compile warning "unused variable
> ‘max_speed’ [-Wunused-variable]". Thus remove it.
>
> Signed-off-by: Christian Engelmayer <cengelma@gmx.at>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>

> ---
> Compile tested. Applies against branch master in tree
> git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git
> ---
>  drivers/of/of_mdio.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/of/of_mdio.c b/drivers/of/of_mdio.c
> index b857094..7c6e277 100644
> --- a/drivers/of/of_mdio.c
> +++ b/drivers/of/of_mdio.c
> @@ -46,7 +46,6 @@ static int of_mdiobus_register_phy(struct mii_bus *mdio, struct device_node *chi
>         struct phy_device *phy;
>         bool is_c45;
>         int rc;
> -       u32 max_speed = 0;
>         u32 phy_id;
>
>         is_c45 = of_device_is_compatible(child,
> --
> 1.9.1
>



-- 
Florian
