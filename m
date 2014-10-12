Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523AbaJLOam (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 10:30:42 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38318 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbaJLOag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 10:30:36 -0400
Date: Sun, 12 Oct 2014 16:30:33 +0200
From: Pavel Machek <pavel@denx.de>
To: dinguyen@opensource.altera.com
Cc: p.zabel@pengutronix.de, dinh.linux@gmail.com, s.trumtrar@pengutronix.de,
        grant.likely@linaro.org, robh+dt@kernel.org,
        atull@opensource.altera.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] reset: socfpga: use arch_initcall for early
 initialization
Message-ID: <20141012143033.GB378@amd>
References: <1412822646-11257-1-git-send-email-dinguyen@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412822646-11257-1-git-send-email-dinguyen@opensource.altera.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> From: Dinh Nguyen <dinguyen@opensource.altera.com>
> 
> There are certain drivers that are required to get loaded very early using
> arch_initcall. An example of such a driver is the SOCFPGA's FPGA bridge driver.
> This driver has to get loaded early because it needs to enable FPGA components
> that are connected to the bridge.
> 
> This FPGA bridge driver will using the reset controller API to toggle it's
> reset bits, thus, it needs the reset driver to be loaded as early as possible
> in order for it to get used properly.
> 
> Signed-off-by: Dinh Nguyen <dinguyen@opensource.altera.com>

> +static int __init socfpga_reset_init(void)
> +{
> +	return platform_driver_probe(&socfpga_reset_driver,
> +					socfpga_reset_probe);
> +}
> +
> +static void __exit socfpga_reset_exit(void)
> +{
> +	platform_driver_unregister(&socfpga_reset_driver);
> +}
> +
> +arch_initcall(socfpga_reset_init);
> +module_exit(socfpga_reset_exit);

That is quite a strange combination. Driver can be module but needs to
be initialized early? Should we make it always built in?

>  MODULE_AUTHOR("Steffen Trumtrar <s.trumtrar@pengutronix.de");
>  MODULE_DESCRIPTION("Socfpga Reset Controller Driver");

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
