Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881AbaDAF26 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 01:28:58 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34241 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbaDAF25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 01:28:57 -0400
Date: Tue, 1 Apr 2014 07:28:07 +0200
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: tthayer@altera.com
Cc: dinguyen@altera.com, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, devicetree@hellion.org.uk, galak@codeaurora.org,
        rob@landley.net, linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/2] dts: socfpga: Add bindings for Altera SoC SDRAM
 controller
Message-ID: <20140401052807.GN5052@pengutronix.de>
References: <1396303627-29198-1-git-send-email-tthayer@altera.com>
 <1396303627-29198-2-git-send-email-tthayer@altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396303627-29198-2-git-send-email-tthayer@altera.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 07:25:30 up 219 days, 14:56, 49 users,  load average: 0,12, 0,08,
 0,10
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: str@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Mon, Mar 31, 2014 at 05:07:06PM -0500, tthayer@altera.com wrote:
> From: Thor Thayer <tthayer@altera.com>
> 
> Addition of the Altera SDRAM controller bindings and device
> tree changes to the Altera SoC project.
> 
> Signed-off-by: Thor Thayer <tthayer@altera.com>
> To: Rob Herring <rob.herring@calxeda.com>
> To: Pawel Moll <pawel.moll@arm.com>
> To: Mark Rutland <mark.rutland@arm.com>
> To: Ian Campbell <ijc+devicetree@hellion.org.uk>
> To: Kumar Gala <galak@codeaurora.org>
> To: Rob Landley <rob@landley.net>
> To: Russell King <linux@arm.linux.org.uk>
> To: Dinh Nguyen <dinguyen@altera.com>
> Cc: devicetree@vger.kernel.org
> Cc: linux-doc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> ---
>  .../bindings/arm/altera/socfpga-sdram.txt          |   14 ++++++++++++++
>  arch/arm/boot/dts/socfpga.dtsi                     |    5 +++++
>  2 files changed, 19 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/arm/altera/socfpga-sdram.txt
> 
> diff --git a/Documentation/devicetree/bindings/arm/altera/socfpga-sdram.txt b/Documentation/devicetree/bindings/arm/altera/socfpga-sdram.txt
> new file mode 100644
> index 0000000..351ab7b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/altera/socfpga-sdram.txt
> @@ -0,0 +1,14 @@
> +Altera SOCFPGA SDRAM Controller
> +
> +Required properties:
> +- compatible : "altr,sdr-ctl", "syscon";
> +                Note that syscon is invoked for this device to support the FPGA
> +		bridge driver and possibly other devices in the future.  See
> +		also Documentation/devicetree/bindings/mfd/syscon.txt

This note is really linux specific (and specific to some vendor kernel driver
for that matter). I think you should remove that.

> +- reg : Should contain 1 register ranges(address and length)
> +
> +Example:
> +	sdrctl@0xffc25000 {
> +		compatible = "altr,sdr-ctl", "syscon";
> +		reg = <0xffc25000 0x1000>;
> +	};
> diff --git a/arch/arm/boot/dts/socfpga.dtsi b/arch/arm/boot/dts/socfpga.dtsi
> index 9e78c1d..3634de7 100644
> --- a/arch/arm/boot/dts/socfpga.dtsi
> +++ b/arch/arm/boot/dts/socfpga.dtsi
> @@ -528,6 +528,11 @@
>  			reg-io-width = <4>;
>  		};
>  
> +		sdrctl@0xffc25000 {
> +			compatible = "altr,sdr-ctl", "syscon";
> +			reg = <0xffc25000 0x1000>;
> +		};
> +
>  		rstmgr@ffd05000 {
>  			compatible = "altr,rst-mgr";
>  			reg = <0xffd05000 0x1000>;

Regards,
Steffen

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
