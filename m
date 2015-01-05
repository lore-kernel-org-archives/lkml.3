Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890AbbAEJWg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 04:22:36 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55777 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417AbbAEJWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 04:22:32 -0500
Date: Mon, 5 Jan 2015 10:21:53 +0100
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Walter Lozano <walter@vanguardiasur.com.ar>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ARM: socfpga: dts: Add adxl34x
Message-ID: <20150105092153.GJ13070@pengutronix.de>
References: <1419462712-14151-1-git-send-email-walter@vanguardiasur.com.ar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419462712-14151-1-git-send-email-walter@vanguardiasur.com.ar>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:15:16 up 81 days, 20:28, 113 users,  load average: 0,09, 0,27,
 0,30
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: str@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Wed, Dec 24, 2014 at 08:11:52PM -0300, Walter Lozano wrote:
> This patch adds the DTS bindings for the adxl34x digital
> accelerometer.
> 
> Signed-off-by: Walter Lozano <walter@vanguardiasur.com.ar>
> ---
>  arch/arm/boot/dts/socfpga_cyclone5_sockit.dts |   16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/socfpga_cyclone5_sockit.dts b/arch/arm/boot/dts/socfpga_cyclone5_sockit.dts
> index 16ea6f5..d343e03 100644
> --- a/arch/arm/boot/dts/socfpga_cyclone5_sockit.dts
> +++ b/arch/arm/boot/dts/socfpga_cyclone5_sockit.dts
> @@ -60,6 +60,22 @@
>  	rxc-skew-ps = <2000>;
>  };
>  
> +&gpio2 {
> +	status = "okay";
> +};
> +
> +&i2c1 {
> +	status = "okay";
> +
> +	accel1: accelerometer@53 {
> +		compatible = "adxl34x";
> +		reg = <0x53>;
> +
> +		interrupt-parent = <&portc>;
> +		interrupts = <3 2>;
> +	};
> +};
> +
>  &mmc0 {
>  	vmmc-supply = <&regulator_3_3v>;
>  	vqmmc-supply = <&regulator_3_3v>;

I just gave it a short spin. I get some interrupts and the position property
changes, so it seems to work:

	Acked-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>

Regards,
Steffen

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
