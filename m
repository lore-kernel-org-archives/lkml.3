Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934149AbaFUJFs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 05:05:48 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33993 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758166AbaFUJFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 05:05:46 -0400
Date: Sat, 21 Jun 2014 11:04:46 +0200
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: tthayer@altera.com
Cc: robherring2@gmail.com, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        linux@arm.linux.org.uk, dinguyen@altera.com, dougthompson@xmission.com,
        grant.likely@linaro.org, bp@alien8.de, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        tthayer.linux@gmail.com, linux-arm-kernel@lists.infradead.org,
        linux-edac@vger.kernel.org
Subject: Re: [PATCHv6 1/3] devicetree: Addition of the Altera SDRAM controller
Message-ID: <20140621090446.GA8053@pengutronix.de>
References: <1403306523-4174-2-git-send-email-tthayer@altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403306523-4174-2-git-send-email-tthayer@altera.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:02:55 up 59 days,  2:34, 18 users,  load average: 0,06, 0,07,
 0,05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: str@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Fri, Jun 20, 2014 at 06:22:01PM -0500, tthayer@altera.com wrote:
> From: Thor Thayer <tthayer@altera.com>
> 
> Addition of the Altera SDRAM Controller bindings and device tree changes.
> 
> v2: Changes to SoC SDRAM EDAC code.
> 
> v3: Implement code suggestions for SDRAM EDAC code.
> 
> v4: Remove syscon from SDRAM controller bindings.
> 
> v5: No Change, bump version for consistency.
> 
> v6: Only map the ctrlcfg register as syscon.
> 
> Signed-off-by: Thor Thayer <tthayer@altera.com>
> ---
>  .../bindings/arm/altera/socfpga-sdram.txt          |   11 +++++++++++
>  arch/arm/boot/dts/socfpga.dtsi                     |    5 +++++
>  2 files changed, 16 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/arm/altera/socfpga-sdram.txt
> 
> diff --git a/Documentation/devicetree/bindings/arm/altera/socfpga-sdram.txt b/Documentation/devicetree/bindings/arm/altera/socfpga-sdram.txt
> new file mode 100644
> index 0000000..5027026
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/altera/socfpga-sdram.txt
> @@ -0,0 +1,11 @@
> +Altera SOCFPGA SDRAM Controller
> +
> +Required properties:
> +- compatible : "altr,sdr-ctl";
> +- reg : Should contain 1 register ranges(address and length)
> +
> +Example:
> +	sdrctl@ffc25000 {
> +		compatible = "altr,sdr-ctl";
> +		reg = <0xffc25000 0x4>;
> +	};
> diff --git a/arch/arm/boot/dts/socfpga.dtsi b/arch/arm/boot/dts/socfpga.dtsi
> index 4676f25..310292e 100644
> --- a/arch/arm/boot/dts/socfpga.dtsi
> +++ b/arch/arm/boot/dts/socfpga.dtsi
> @@ -682,6 +682,11 @@
>  			clocks = <&l4_sp_clk>;
>  		};
>  
> +		sdrctl@ffc25000 {
> +			compatible = "altr,sdr-ctl", "syscon";

Did you forget to add the syscon to the binding documentation?

> +			reg = <0xffc25000 0x4>;
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
