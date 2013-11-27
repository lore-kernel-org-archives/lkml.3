Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757642Ab3K0S4C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 13:56:02 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:40703 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756866Ab3K0S4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 13:56:00 -0500
MIME-Version: 1.0
In-Reply-To: <1385459735-722-1-git-send-email-shh.xie@gmail.com>
References: <1385459735-722-1-git-send-email-shh.xie@gmail.com>
From: Florian Fainelli <f.fainelli@gmail.com>
Date: Wed, 27 Nov 2013 10:55:19 -0800
Message-ID: <CAGVrzcZsev7N_YKEhK_2673sPVk5sd+PYL2H8BsRuAn-ETAKWQ@mail.gmail.com>
Subject: Re: [PATCH 5/5][v2] phylib: Add of_phy_attach
To: shh.xie@gmail.com
Cc: David Miller <davem@davemloft.net>, jg1.han@samsung.com,
        mugunthanvnm <mugunthanvnm@ti.com>, netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "emilian.medve" <Emilian.Medve@freescale.com>,
        madalin.bucur@freescale.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/11/26  <shh.xie@gmail.com>:
> From: Andy Fleming <afleming@freescale.com>
>
> 10G PHYs don't currently support running the state machine, which
> is implicitly setup via of_phy_connect(). Therefore, it is necessary
> to implement an OF version of phy_attach(), which does everything
> except start the state machine.
>
> Signed-off-by: Andy Fleming <afleming@freescale.com>
> Signed-off-by: Shaohui Xie <Shaohui.Xie@freescale.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>

> ---
> v2: no changes.
>
>  drivers/of/of_mdio.c    | 19 +++++++++++++++++++
>  include/linux/of_mdio.h |  9 +++++++++
>  2 files changed, 28 insertions(+)
>
> diff --git a/drivers/of/of_mdio.c b/drivers/of/of_mdio.c
> index d5a57a9..21076ac 100644
> --- a/drivers/of/of_mdio.c
> +++ b/drivers/of/of_mdio.c
> @@ -247,3 +247,22 @@ struct phy_device *of_phy_connect_fixed_link(struct net_device *dev,
>         return IS_ERR(phy) ? NULL : phy;
>  }
>  EXPORT_SYMBOL(of_phy_connect_fixed_link);
> +
> +/**
> + * of_phy_attach - Attach to a PHY without starting the state machine
> + * @dev: pointer to net_device claiming the phy
> + * @phy_np: Node pointer for the PHY
> + * @flags: flags to pass to the PHY
> + * @iface: PHY data interface type
> + */
> +struct phy_device *of_phy_attach(struct net_device *dev,
> +               struct device_node *phy_np, u32 flags, phy_interface_t iface)
> +{
> +       struct phy_device *phy = of_phy_find_device(phy_np);
> +
> +       if (!phy)
> +               return NULL;
> +
> +       return phy_attach_direct(dev, phy, flags, iface) ? NULL : phy;
> +}
> +EXPORT_SYMBOL(of_phy_attach);
> diff --git a/include/linux/of_mdio.h b/include/linux/of_mdio.h
> index 8163107..108583a 100644
> --- a/include/linux/of_mdio.h
> +++ b/include/linux/of_mdio.h
> @@ -19,6 +19,9 @@ extern struct phy_device *of_phy_connect(struct net_device *dev,
>                                          struct device_node *phy_np,
>                                          void (*hndlr)(struct net_device *),
>                                          u32 flags, phy_interface_t iface);
> +struct phy_device *of_phy_attach(struct net_device *dev,
> +                                struct device_node *phy_np, u32 flags,
> +                                phy_interface_t iface);
>  extern struct phy_device *of_phy_connect_fixed_link(struct net_device *dev,
>                                          void (*hndlr)(struct net_device *),
>                                          phy_interface_t iface);
> @@ -44,6 +47,12 @@ static inline struct phy_device *of_phy_connect(struct net_device *dev,
>         return NULL;
>  }
>
> +static inline struct phy_device *of_phy_attach(struct net_device *dev,
> +               struct device_node *phy_np, u32 flags, phy_interface_t iface)
> +{
> +       return NULL;
> +}
> +
>  static inline struct phy_device *of_phy_connect_fixed_link(struct net_device *dev,
>                                                            void (*hndlr)(struct net_device *),
>                                                            phy_interface_t iface)
> --
> 1.8.4.1
>
>



-- 
Florian
