Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161010AbaDPNJt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 09:09:49 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48132 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756247AbaDPNJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 09:09:46 -0400
Date: Wed, 16 Apr 2014 15:09:43 +0200
From: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
To: Joe Perches <joe@perches.com>
Cc: sebastian.hesselbarth@gmail.com, chris@printf.net, anton@enomsg.org,
        alexandre.belloni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] mmc: sdhci: add a driver for Berlin SoCs
Message-ID: <20140416130943.GF17754@kwain>
References: <1397652011-21284-1-git-send-email-antoine.tenart@free-electrons.com>
 <1397652011-21284-2-git-send-email-antoine.tenart@free-electrons.com>
 <1397652994.30935.5.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1397652994.30935.5.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe,

On Wed, Apr 16, 2014 at 05:56:34AM -0700, Joe Perches wrote:
> On Wed, 2014-04-16 at 14:40 +0200, Antoine Ténart wrote:
> > Add a Driver to support the SDHCI controller of the Marvell Berlin SoCs.
> > This controller supports 3 sockets.
> 
> trivial notes:
> 
> > diff --git a/drivers/mmc/host/sdhci-berlin.c b/drivers/mmc/host/sdhci-berlin.c
> []
> > +static struct sdhci_ops sdhci_berlin_ops = {
> > +	.get_max_clock = sdhci_pltfm_clk_get_max_clock,
> > +};
> > +
> > +static struct sdhci_pltfm_data sdhci_berlin2_pdata = {
> > +	.quirks	= SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN |
> > +		  SDHCI_QUIRK_BROKEN_ADMA |
> > +		  SDHCI_QUIRK_BROKEN_TIMEOUT_VAL,
> > +	.ops = &sdhci_berlin_ops,
> > +};
> > +
> > +static struct sdhci_pltfm_data sdhci_berlin2q_pdata = {
> > +	.quirks	= SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN |
> > +		  SDHCI_QUIRK_INVERTED_WRITE_PROTECT |
> > +		  SDHCI_QUIRK_BROKEN_TIMEOUT_VAL,
> > +	.ops = &sdhci_berlin_ops,
> > +};
> 
> Perhaps const?

Yes, sure. I'll fix that.

> 
> > +static int sdhci_berlin_probe(struct platform_device *pdev)
> > +{
> []
> > +	host = sdhci_pltfm_init(pdev,
> > +				(struct sdhci_pltfm_data *)device->data, 0);
> 
> Unnecessary cast?  Maybe:
> 
> 	host = sdhci_pltfm_init(pdev, device->data, 0);

Right.

> 
> > +	if (IS_ERR(host))
> > +		return PTR_ERR(host);
> > +
> > +	pltfm_host = sdhci_priv(host);
> > +
> > +	clk = devm_clk_get(dev, NULL);
> > +	if (IS_ERR(clk)) {
> > +		dev_err(dev, "could not get clock: %ld\n", PTR_ERR(clk));
> > +		ret = PTR_ERR(clk);
> 
> PTR_ERR is an int.  Does this produce a compile warning?

It does, I had a warning.

> Maybe reverse these lines and use ret?
> 
> 		ret = PTR_ERR(clk);
> 		dev_err(dev, count not get clock: %d\n", ret);

That's better. Will do.

Thanks !

Antoine


-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
