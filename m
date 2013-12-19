Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471Ab3LSOZv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 09:25:51 -0500
Received: from mail-ig0-f173.google.com ([209.85.213.173]:36364 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755408Ab3LSOZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 09:25:42 -0500
Date: Thu, 19 Dec 2013 09:25:36 -0500
From: Matt Porter <mporter@linaro.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: balbi@ti.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Christian Daudt <bcm@fixthebug.org>,
        Paul Zimmerman <paulz@synopsys.com>, Tomasz Figa <t.figa@samsung.com>,
        Kamil Debski <k.debski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Dinh Nguyen <dinh.linux@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linux USB List <linux-usb@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>
Subject: Re: [PATCH v7 8/9] phy: add Broadcom Kona USB2 PHY driver
Message-ID: <20131219142536.GG15814@beef>
References: <1387309356-17195-1-git-send-email-mporter@linaro.org>
 <1387309356-17195-9-git-send-email-mporter@linaro.org>
 <20131218162554.GF4970@saruman.home>
 <52B288EF.1040006@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52B288EF.1040006@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 11:19:35AM +0530, Kishon Vijay Abraham I wrote:
> Hi Felipe,
> 
> On Wednesday 18 December 2013 09:55 PM, Felipe Balbi wrote:
> > On Tue, Dec 17, 2013 at 02:42:35PM -0500, Matt Porter wrote:
> >> Add a driver for the internal Broadcom Kona USB 2.0 PHY found
> >> on the BCM281xx family of SoCs.
> >>
> >> Signed-off-by: Matt Porter <mporter@linaro.org>
> > 
> > Kishon, are you ok with this driver ?
> 
> yeah. Since this patch touches phy/Kconfig (and Makefile) and there is one more
> PHY driver to be merged that also modifies Kconfig there might be conflicts. So
> thought I should be taking this patch?
> > 
> >> +static int bcm_kona_usb2_probe(struct platform_device *pdev)
> >> +{
> >> +	struct device *dev = &pdev->dev;
> >> +	struct bcm_kona_usb *phy;
> >> +	struct resource *res;
> >> +	struct phy *gphy;
> >> +	struct phy_provider *phy_provider;
> >> +
> >> +	phy = devm_kzalloc(dev, sizeof(*phy), GFP_KERNEL);
> >> +	if (!phy)
> >> +		return -ENOMEM;
> >> +
> >> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> >> +	phy->regs = devm_ioremap_resource(&pdev->dev, res);
> >> +	if (IS_ERR(phy->regs))
> >> +		return PTR_ERR(phy->regs);
> >> +
> >> +	platform_set_drvdata(pdev, phy);
> >> +
> >> +	phy_provider = devm_of_phy_provider_register(dev,
> >> +			of_phy_simple_xlate);
> >> +	if (IS_ERR(phy_provider))
> >> +		return PTR_ERR(phy_provider);
> >> +
> >> +	gphy = devm_phy_create(dev, &ops, NULL);
> >> +	if (IS_ERR(gphy))
> >> +		return PTR_ERR(gphy);
> >> +
> >> +	/* The Kona PHY supports an 8-bit wide UTMI interface */
> >> +	phy_set_bus_width(gphy, 8);
> >> +
> >> +	phy_set_drvdata(gphy, phy);
> > 
> > I think this set_drvdata() should be done before registering the
> > provider, no ?
> 
> hmm, right.

I sent a v8 series update that addresses this issue.

-Matt
