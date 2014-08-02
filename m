Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbaHBAXH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 20:23:07 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50058 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709AbaHBAXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 20:23:04 -0400
Date: Sat, 2 Aug 2014 02:23:01 +0200
From: Pavel Machek <pavel@denx.de>
To: atull@opensource.altera.com
Cc: gregkh@linuxfoundation.org, jgunthorpe@obsidianresearch.com, hpa@zytor.com,
        monstr@monstr.eu, michal.simek@xilinx.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        pantelis.antoniou@konsulko.com, robh+dt@kernel.org,
        grant.likely@linaro.org, broonie@kernel.org, philip@balister.org,
        rubini@gnudd.com, s.trumtrar@pengutronix.de, jason@lakedaemon.net,
        kyle.teske@ni.com, nico@linaro.org, balbi@ti.com, m.chehab@samsung.com,
        davidb@codeaurora.org, rob@landley.net, davem@davemloft.net,
        cesarb@cesarb.net, sameo@linux.intel.com, akpm@linux-foundation.org,
        linus.walleij@linaro.org, delicious.quinoa@gmail.com,
        dinguyen@opensource.altera.com, yvanderv@opensource.altera.com
Subject: Re: [PATCH 2/3] fpga bus driver
Message-ID: <20140802002301.GC11170@amd.pavel.ucw.cz>
References: <1406932118-13885-1-git-send-email-atull@opensource.altera.com>
 <1406932118-13885-3-git-send-email-atull@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406932118-13885-3-git-send-email-atull@opensource.altera.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Here's a simple example. Start with:
>   * the altera-gpio driver built in to the kernel but not in the
>     device tree.
>   * raw fpga image at /lib/firmware/soc_system.rbf
>   * Load appropriate device tree overlay in configfs by doing
>     $ mkdir /config/device-tree/overlays/1
>     $ echo socfpga_overlay.dtbo > /config/device-tree/overlays/1/path
>   * This results in the FPGA getting programmed and the altera
>     gpio driver getting probed.

Nice!

> +/* Find the fpga manager that is pointed to by a phandle */
> +struct fpga_manager *of_fpga_mgr_dev_lookup(struct device_node *node,
> +					    const char *mgr_property,
> +					    int *ret)
> +{
> +	struct fpga_manager *mgr;
> +	struct device_node *mgr_node;
> +
> +	mgr_node = of_parse_phandle(node, mgr_property, 0);
> +
> +	if (!mgr_node) {
> +		*ret = -ENODEV;
> +		return NULL;

Could IS_ERR_OR_NULL() and friends be used to get reasonable calling
convention?

Thanks,	
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
