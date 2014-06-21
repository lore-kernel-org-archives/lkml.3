Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934387AbaFUJGs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 05:06:48 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34014 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932296AbaFUJGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 05:06:47 -0400
Date: Sat, 21 Jun 2014 11:06:18 +0200
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: tthayer@altera.com
Cc: robherring2@gmail.com, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        linux@arm.linux.org.uk, dinguyen@altera.com, dougthompson@xmission.com,
        grant.likely@linaro.org, bp@alien8.de, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tthayer.linux@gmail.com
Subject: Re: [PATCHv6 2/3] devicetree: Addition of the Altera SDRAM EDAC
Message-ID: <20140621090618.GB8053@pengutronix.de>
References: <1403306523-4174-2-git-send-email-tthayer@altera.com>
 <1403306523-4174-3-git-send-email-tthayer@altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403306523-4174-3-git-send-email-tthayer@altera.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:04:54 up 59 days,  2:36, 18 users,  load average: 0,05, 0,08,
 0,05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: str@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 06:22:02PM -0500, tthayer@altera.com wrote:
> From: Thor Thayer <tthayer@altera.com>
> 
> Addition of the Altera SDRAM EDAC bindings and device tree changes
> 
> v2: Changes to SoC EDAC source code.
> 
> v3: Fix typo in device tree documentation.
> 
> v4,v5: No changes - bump version for consistency.
> 
> v6: Assign ECC registers in SDRAM controller to EDAC
> 
> Signed-off-by: Thor Thayer <tthayer@altera.com>
> ---
>  .../bindings/arm/altera/socfpga-sdram-edac.txt     |   15 +++++++++++++++
>  arch/arm/boot/dts/socfpga.dtsi                     |    6 ++++++
>  2 files changed, 21 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/arm/altera/socfpga-sdram-edac.txt
> 
> diff --git a/Documentation/devicetree/bindings/arm/altera/socfpga-sdram-edac.txt b/Documentation/devicetree/bindings/arm/altera/socfpga-sdram-edac.txt
> new file mode 100644
> index 0000000..540c9cf
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/altera/socfpga-sdram-edac.txt
> @@ -0,0 +1,15 @@
> +Altera SOCFPGA SDRAM Error Detection & Correction [EDAC]
> +
> +Required properties:
> +- compatible : should contain "altr,sdram-edac";
> +- reg : should contain the ECC register range in sdram
> +        controller (address and length).
> +- interrupts : Should contain the SDRAM ECC IRQ in the
> +	appropriate format for the IRQ controller.
> +
> +Example:
> +	sdramedac@0 {
> +		compatible = "altr,sdram-edac";
> +		reg = <0xffc2502C 0x28>;
> +		interrupts = <0 39 4>;
> +	};
> diff --git a/arch/arm/boot/dts/socfpga.dtsi b/arch/arm/boot/dts/socfpga.dtsi
> index 310292e..fe9832e 100644
> --- a/arch/arm/boot/dts/socfpga.dtsi
> +++ b/arch/arm/boot/dts/socfpga.dtsi
> @@ -687,6 +687,12 @@
>  			reg = <0xffc25000 0x4>;
>  		};
>  
> +		sdramedac@0 {
                         ^^^

Please fix the baseaddress (also in the binding doc).

> +			compatible = "altr,sdram-edac";
> +			reg = <0xffc2502C 0x28>;
> +			interrupts = <0 39 4>;
> +		};
> +
>  		rst: rstmgr@ffd05000 {
>  			compatible = "altr,rst-mgr";
>  			reg = <0xffd05000 0x1000>;

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
