Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932762AbaEMMLV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 08:11:21 -0400
Received: from top.free-electrons.com ([176.31.233.9]:38514 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759525AbaEMMLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 08:11:18 -0400
Date: Tue, 13 May 2014 14:11:15 +0200
From: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        sebastian.hesselbarth@gmail.com, tj@kernel.org,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/6] phy: add a driver for the Berlin SATA PHY
Message-ID: <20140513121115.GB3213@kwain>
References: <1399886217-20474-1-git-send-email-antoine.tenart@free-electrons.com>
 <1399886217-20474-2-git-send-email-antoine.tenart@free-electrons.com>
 <5370C2B6.8030908@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5370C2B6.8030908@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, May 12, 2014 at 06:16:46PM +0530, Kishon Vijay Abraham I wrote:
> On Monday 12 May 2014 02:46 PM, Antoine Ténart wrote:

[…]

> > +struct phy_desc {
> 
> to be consistent, lets name it phy_berlin_desc.
> > +	struct phy	*phy;
> > +	u32		val;
> > +	unsigned	index;
> > +};

Sure.

[…]

> > +static int phy_berlin_sata_probe(struct platform_device *pdev)
> > +{
> > +	struct phy *phy;
> > +	struct phy_provider *phy_provider;
> > +	struct priv *priv;
> > +	struct resource *res;
> > +	int i;
> > +
> > +	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
> > +	if (!priv)
> > +		return -ENOMEM;
> > +
> > +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +	priv->base = devm_ioremap(&pdev->dev, res->start, resource_size(res));
> > +	if (IS_ERR(priv->base))
> > +		return PTR_ERR(priv->base);
> > +
> > +	phy = devm_phy_create(&pdev->dev, &phy_berlin_sata_ops, NULL);
> > +	if (IS_ERR(phy))
> > +		return PTR_ERR(phy);
> > +
> > +	dev_set_drvdata(&pdev->dev, priv);
> > +	spin_lock_init(&priv->lock);
> > +
> > +	for (i = 0; i < BERLIN_SATA_PHY_NB; i++) {
> 
> huh.. this should come from dt data. For devices which have multiple PHYs, each
> PHY should be modelled as the sub-node of the *PHY provider* device node.

I'll update, with the bindings suggested by Sebastian.

Thanks for the review!

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
