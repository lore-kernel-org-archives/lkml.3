Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751777AbaJXHB0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 03:01:26 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36782 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbaJXHBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 03:01:24 -0400
Date: Fri, 24 Oct 2014 09:00:42 +0200
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: atull@opensource.altera.com
Cc: jgunthorpe@obsidianresearch.com, hpa@zytor.com, monstr@monstr.eu,
        michal.simek@xilinx.com, rdunlap@infradead.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, pantelis.antoniou@konsulko.com,
        robh+dt@kernel.org, grant.likely@linaro.org, iws@ovro.caltech.edu,
        linux-doc@vger.kernel.org, pavel@denx.de, broonie@kernel.org,
        philip@balister.org, rubini@gnudd.com, jason@lakedaemon.net,
        kyle.teske@ni.com, nico@linaro.org, balbi@ti.com, m.chehab@samsung.com,
        davidb@codeaurora.org, rob@landley.net, davem@davemloft.net,
        cesarb@cesarb.net, sameo@linux.intel.com, akpm@linux-foundation.org,
        linus.walleij@linaro.org, mgerlach@opensource.altera.com,
        delicious.quinoa@gmail.com, dinguyen@opensource.altera.com,
        yvanderv@opensource.altera.com
Subject: Re: [PATCH v2 2/3] ARM: dts: socfpga: fpga bridges bindings docs
Message-ID: <20141024070042.GL10262@pengutronix.de>
References: <1414108267-22058-1-git-send-email-atull@opensource.altera.com>
 <1414108267-22058-3-git-send-email-atull@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414108267-22058-3-git-send-email-atull@opensource.altera.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:50:33 up 8 days, 18:04, 68 users,  load average: 0,01, 0,04, 0,05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: str@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Thu, Oct 23, 2014 at 06:51:06PM -0500, atull@opensource.altera.com wrote:
> From: Alan Tull <atull@opensource.altera.com>

(...)

> diff --git a/Documentation/devicetree/bindings/fpga/altera-hps2fpga-bridge.txt b/Documentation/devicetree/bindings/fpga/altera-hps2fpga-bridge.txt
> new file mode 100644
> index 0000000..bc24a2e
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/fpga/altera-hps2fpga-bridge.txt
> @@ -0,0 +1,53 @@
> +Altera FPGA/HPS Bridge Driver
> +
> +This driver manages a bridge between a FPGA and a host processor system (HPS).
> +User space can enable or disable the bridge by writing a "1" or a "0",
> +respectively, to its enable file under bridge's entry in
> +/sys/class/fpga-bridge.  Typically, one disables the bridges before
> +reprogramming the FPGA.  Once the FPGA is reprogrammed, the bridges are
> +reenabled.
> +

NAK.

This is all linux specific and doesn't belong here.

> +Required properties:
> +
> + - compatible     : should contain one of:
> +                     "altr,socfpga-hps2fpga-bridge"
> +                     "altr,socfpga-lwhps2fpga-bridge"
> +                     "altr,socfpga-fpga2hps-bridge"
> +
> + - clocks         : clocks used by this module
> +
> + - altr,l3-syscon : phandle of the l3 interconnect module
> +

L3 shouldn't be a syscon. Have you tried dumping the regmap in the debugfs if L3
is a syscon? Doesn't work.

> +Optional properties:
> + - label          : name that you want this bridge to show up as under
> +                    /sys/class/fpga-bridge.  Default is br<device#> if this is
> +                    not specified.
> +

Why? Linux-specific.

> + - init-val       : 0 if driver should disable bridge at startup
> +                    1 if driver should enable bridge at startup
> +                    driver leaves bridge in current state if property not
> +                    specified.
> +

Configuration in the DT? Really?

> +Example:
> +	hps_fpgabridge0: fpgabridge@0 {
> +		compatible = "altr,socfpga-hps2fpga-bridge";
> +		label = "hps2fpga";
> +		altr,l3-syscon = <&l3regs>;
> +		clocks = <&l4_main_clk>;
> +		init-val = <1>;
> +	};
> +
> +	hps_fpgabridge1: fpgabridge@1 {
> +		compatible = "altr,socfpga-lwhps2fpga-bridge";
> +		label = "lwhps2fpga";
> +		altr,l3-syscon = <&l3regs>;
> +		clocks = <&l4_main_clk>;
> +		init-val = <0>;
> +	};
> +
> +	hps_fpgabridge2: fpgabridge@2 {
> +		compatible = "altr,socfpga-fpga2hps-bridge";
> +		label = "fpga2hps";
> +		altr,l3-syscon = <&l3regs>;
> +		clocks = <&l4_main_clk>;
> +	};

The bridges are the buses into the FPGA. This has to be accomodated.
The bridges have two specified memory ranges: one the address space
of the bus, the second the register space for configuration.

This binding does NOT correctly describe the hardware. Sorry.

Regards,
Steffen

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
