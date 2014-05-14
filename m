Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780AbaENKVj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 06:21:39 -0400
Received: from top.free-electrons.com ([176.31.233.9]:45367 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754332AbaENKVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 06:21:36 -0400
Date: Wed, 14 May 2014 12:21:22 +0200
From: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        sebastian.hesselbarth@gmail.com, tj@kernel.org,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-ide@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/6] phy: add a driver for the Berlin SATA PHY
Message-ID: <20140514102122.GA11140@kwain>
References: <1400060942-10588-1-git-send-email-antoine.tenart@free-electrons.com>
 <1400060942-10588-2-git-send-email-antoine.tenart@free-electrons.com>
 <537341AF.5030105@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <537341AF.5030105@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, May 14, 2014 at 03:43:03PM +0530, Kishon Vijay Abraham I wrote:
> Hi,
> 
> On Wednesday 14 May 2014 03:18 PM, Antoine Ténart wrote:

[…]

> > +#define to_berlin_sata_phy_priv(desc)	\
> > +	container_of((desc), struct phy_berlin_priv, phys[(desc)->index])
> > +
> > +struct phy_berlin_desc {
> > +	struct phy	*phy;
> > +	u32		val;
> > +	unsigned	index;
> > +};
> > +
> > +struct phy_berlin_priv {
> > +	void __iomem	*base;
> > +	spinlock_t	lock;
> > +	struct phy_berlin_desc	phys[BERLIN_SATA_PHY_NB];
> 
> Can't we do away with hardcoding BERLIN_SATA_PHY_NB?

We can't if we want to be able to use the container_of macro in
to_berlin_sata_phy_priv(). And we want a common structure to store the
common spinlock and base address.

[…]

> > +		/*
> > +		 * By default the PHY node is used to request and match a PHY.
> > +		 * We describe one PHY per sub-node here. Use the right node.
> > +		 */
> > +		phy->dev.of_node = child;
> > +
> > +		priv->phys[phy_id].phy = phy;
> > +		priv->phys[phy_id].val = desc[phy_id].val;
> > +		priv->phys[phy_id].index = phy_id;
> > +		phy_set_drvdata(phy, &priv->phys[phy_id]);
> > +
> > +		/* Make sure the PHY is off */
> > +		phy_berlin_sata_power_off(phy);
> > +
> > +		phy_provider = devm_of_phy_provider_register(&phy->dev,
> > +							     of_phy_simple_xlate);
> > +		if (IS_ERR(phy_provider))
> > +			return PTR_ERR(phy_provider);
> 
> was this intentional? registering multiple PHY providers?

Yes. Each sub-node describe a PHY and register as a PHY provider. This
allow to reference the PHY as <&sata_phy0> and not <&sata_phy 0>. It
would be confusing to have a sub-node sata_phy0 and to use its parent
to access it.

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
