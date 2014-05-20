Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023AbaETOlF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 10:41:05 -0400
Received: from top.free-electrons.com ([176.31.233.9]:32857 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753158AbaETOlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 10:41:03 -0400
Date: Tue, 20 May 2014 16:40:58 +0200
From: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        sebastian.hesselbarth@gmail.com, tj@kernel.org, kishon@ti.com,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-ide@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/7] phy: add a driver for the Berlin SATA PHY
Message-ID: <20140520144058.GE21579@kwain>
References: <1400576675-25265-1-git-send-email-antoine.tenart@free-electrons.com>
 <1400576675-25265-2-git-send-email-antoine.tenart@free-electrons.com>
 <1821771.zFvTDGF2Ae@amdc1032>
 <20140520140652.GB21579@kwain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140520140652.GB21579@kwain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 04:06:52PM +0200, Antoine Ténart wrote:
> Hi,
> 
> On Tue, May 20, 2014 at 02:34:20PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > On Tuesday, May 20, 2014 11:04:29 AM Antoine Ténart wrote:
> > > +
> > > +static struct phy_berlin_desc desc[] = {
> > > +	{ .val = POWER_DOWN_PHY0 },
> > > +	{ .val = POWER_DOWN_PHY1 },
> > 
> > Only .val entry of struct phy_berlin_desc is initialized and needed,
> > it seems that u32 vals[] should be used instead of desc[].
> 
> Sure.
> 
> > > +
> > > +static int phy_berlin_sata_probe(struct platform_device *pdev)
> > > +{
> > > +	struct device *dev = &pdev->dev;
> > > +	struct phy *phy;
> > > +	struct phy_provider *phy_provider;
> > > +	struct phy_berlin_priv *priv;
> > > +	struct resource *res;
> > > +	int i;
> > > +
> > > +	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
> > > +	if (!priv)
> > > +		return -ENOMEM;
> > > +
> > > +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);

We also need to check res isn't NULL here.

> > > +	priv->base = devm_ioremap(dev, res->start, resource_size(res));
> > > +	if (IS_ERR(priv->base))
> > > +		return PTR_ERR(priv->base);
> > 
> > devm_ioremap() (contrary to devm_ioremap_resource()) returns a valid
> > pointer or NULL so return value checking should be fixed.
> 
> I'll fix this.

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
