Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564Ab3AKPsh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 10:48:37 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44843 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403Ab3AKPsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 10:48:36 -0500
Date: Fri, 11 Jan 2013 15:47:53 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Michal Bachraty <michal.bachraty@streamunlimited.com>
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] cpsw: Add support to read cpu MAC address
Message-ID: <20130111154753.GB23505@n2100.arm.linux.org.uk>
References: <1357917302-32550-1-git-send-email-michal.bachraty@streamunlimited.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357917302-32550-1-git-send-email-michal.bachraty@streamunlimited.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2013 at 04:15:02PM +0100, Michal Bachraty wrote:
> +	if (!request_mem_region(priv->conf_res->start,
> +			resource_size(priv->conf_res), ndev->name)) {
> +		dev_err(priv->dev, "failed request i/o region\n");
> +		ret = -ENXIO;
> +		goto clean_clk_ret;
> +	}
> +
> +	regs = ioremap(priv->conf_res->start,
> +				resource_size(priv->conf_res));
> +	if (!regs) {
> +		dev_err(priv->dev, "unable to map i/o region\n");
> +		goto clean_configuration_iores_ret;
> +	}

In this day and age where error paths don't get any testing, and are
frequently buggy, where we have alternative APIs which make those paths
more reliable, I think we should do everything to make use of that.

And, to prove the point, your error paths are buggy.  Yes, you release
the mem region correctly (well done for picking the right interface for
that!) but the ioremap() is never cleaned up.

So, any chance of converting the above to devm_request_and_ioremap() ?

Thanks.
