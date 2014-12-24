Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925AbaLXJp5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 04:45:57 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43502 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbaLXJp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 04:45:56 -0500
Date: Wed, 24 Dec 2014 10:45:17 +0100
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Walter Lozano <walter@vanguardiasur.com.ar>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: socfpga: dts: Add adxl34x
Message-ID: <20141224094516.GI13070@pengutronix.de>
References: <1419339862-29852-1-git-send-email-walter@vanguardiasur.com.ar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419339862-29852-1-git-send-email-walter@vanguardiasur.com.ar>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:27:23 up 69 days, 20:41, 62 users,  load average: 0,05, 0,09,
 0,06
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: str@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Tue, Dec 23, 2014 at 10:04:22AM -0300, Walter Lozano wrote:
> This patch adds the DTS bindings for the adxl34x digital
> accelerometer.
> 

Thanks for doing this. Does the ADXL34 work now? Last time I
tried it, I didn't get any interrupts, but as I didn't really
care for the accelerometer I didn't dig deeper.

> Signed-off-by: Walter Lozano <walter@vanguardiasur.com.ar>
> ---
>  arch/arm/boot/dts/socfpga_cyclone5_sockit.dts |   17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/socfpga_cyclone5_sockit.dts b/arch/arm/boot/dts/socfpga_cyclone5_sockit.dts
> index 16ea6f5..f99d7dec 100644
> --- a/arch/arm/boot/dts/socfpga_cyclone5_sockit.dts
> +++ b/arch/arm/boot/dts/socfpga_cyclone5_sockit.dts
> @@ -68,3 +68,20 @@
>  &usb1 {
>  	status = "okay";
>  };
> +
> +&gpio2 {
> +	status = "okay";
> +};
> +
> +&i2c1{
       ^^^

Add a space here and ...

> +	status = "okay";
> +
> +	accel1: accel1@53{
			^^^
here. Also, this should be accelerometer@53.

> +		compatible = "adxl34x";
> +		reg = <0x53>;
> +
> +		interrupt-parent = < &portc >;
				   ^^^    ^^^
Please remove the spaces here.
> +		interrupts = <3 2>;
> +
> +	};
> +};

Finally, please sort the nodes alphabetically and not just append them.

Regards,
Steffen

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
