Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595AbaDYOVy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 10:21:54 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:50829 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753812AbaDYOVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 10:21:52 -0400
Date: Fri, 25 Apr 2014 15:20:49 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        devicetree@vger.kernel.org, Nadav Haklai <nadavh@marvell.com>,
        Rob Herring <robh+dt@kernel.org>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Grant Likely <grant.likely@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 02/18] usb: host: xhci-plat: Add clocks support
Message-ID: <20140425142049.GR26756@n2100.arm.linux.org.uk>
References: <1398434836-18908-1-git-send-email-gregory.clement@free-electrons.com> <1398434836-18908-3-git-send-email-gregory.clement@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398434836-18908-3-git-send-email-gregory.clement@free-electrons.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 04:07:00PM +0200, Gregory CLEMENT wrote:
> +#if defined(CONFIG_HAVE_CLK)
> +static int try_enable_clk(struct platform_device *pdev)
> +{
> +	struct clk *clk = devm_clk_get(&pdev->dev, NULL);
> +
> +	/* Not all platforms have a clk so it is not an error if the clock
> +	   does not exists. */
> +	if (!IS_ERR(clk))
> +		if (clk_prepare_enable(clk))
> +			return  -ENODEV;
> +	return 0;
> +}
> +
> +static int try_disable_clk(struct platform_device *pdev)
> +{
> +	struct clk *clk = devm_clk_get(&pdev->dev, NULL);
> +
> +	/* Not all platforms have a clk so it is not an error if the clock
> +	   does not exists. */
> +	if (!IS_ERR(clk))
> +		clk_disable_unprepare(clk);
> +
> +	return 0;
> +}

OMG.

You do realise that clk_get() ref-counts against the module which
provided the clock, so this is akin to an explicit leaking module
ref-counts.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
