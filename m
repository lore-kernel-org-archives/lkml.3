Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588Ab3IJGlI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 02:41:08 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36381 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044Ab3IJGlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 02:41:06 -0400
Date: Tue, 10 Sep 2013 08:40:44 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: r65073@freescale.com, thierry.reding@gmail.com, grant.likely@linaro.org,
        linux@arm.linux.org.uk, rob@landley.net, ian.campbell@citrix.com,
        swarren@wwwdotorg.org, mark.rutland@arm.com, pawel.moll@arm.com,
        rob.herring@calxeda.com, linux-arm-kernel@lists.infradead.org,
        linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCHv3 2/4] ARM: dts: Add Freescale FTM PWM node for VF610.
Message-ID: <20130910064044.GZ30088@pengutronix.de>
Mail-Followup-To: Xiubo Li <Li.Xiubo@freescale.com>, r65073@freescale.com,
	thierry.reding@gmail.com, grant.likely@linaro.org,
	linux@arm.linux.org.uk, rob@landley.net, ian.campbell@citrix.com,
	swarren@wwwdotorg.org, mark.rutland@arm.com, pawel.moll@arm.com,
	rob.herring@calxeda.com, linux-arm-kernel@lists.infradead.org,
	linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, linux-doc@vger.kernel.org
References: <1378454907-22728-1-git-send-email-Li.Xiubo@freescale.com>
 <1378454907-22728-3-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378454907-22728-3-git-send-email-Li.Xiubo@freescale.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:38:36 up 16 days, 16:09, 41 users,  load average: 0.01, 0.23,
 0.39
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 06, 2013 at 04:08:25PM +0800, Xiubo Li wrote:
> This adds devicetree node for VF610, and there are 8 channels supported
> by default.
> 
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> ---
>  arch/arm/boot/dts/vf610.dtsi | 103 ++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 102 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/vf610.dtsi b/arch/arm/boot/dts/vf610.dtsi
> index 67d929c..44787b5 100644
> --- a/arch/arm/boot/dts/vf610.dtsi
> +++ b/arch/arm/boot/dts/vf610.dtsi
> @@ -140,6 +140,37 @@
>  				clock-names = "pit";
>  			};
>  
> +			pwm0: pwm@40038000 {
> +				compatible = "fsl,vf610-ftm-pwm";
> +				#pwm-cells = <3>;
> +				reg = <0x40038000 0x1000>;
> +				clock-names = "ftm0", "ftm0_fix_sel", "ftm0_ext_sel";
> +				clocks = <&clks VF610_CLK_FTM0>,
> +					<&clks VF610_CLK_FTM0_FIX_SEL>,
> +					<&clks VF610_CLK_FTM0_EXT_SEL>;
> +				pinctrl-names = "ch0-active", "ch0-idle", "ch1-active", "ch1-idle",
> +						"ch2-active", "ch2-idle", "ch3-active", "ch3-idle",
> +						"ch4-active", "ch4-idle", "ch5-active", "ch5-idle",
> +						"ch6-active", "ch6-idle", "ch7-active", "ch7-idle";
> +				pinctrl-0 = <&pinctrl_pwm0_ch0_active>;
> +				pinctrl-1 = <&pinctrl_pwm0_ch0_idle>;
> +				pinctrl-2 = <&pinctrl_pwm0_ch1_active>;
> +				pinctrl-3 = <&pinctrl_pwm0_ch1_idle>;
> +				pinctrl-4 = <&pinctrl_pwm0_ch2_active>;
> +				pinctrl-5 = <&pinctrl_pwm0_ch2_idle>;
> +				pinctrl-6 = <&pinctrl_pwm0_ch3_active>;
> +				pinctrl-7 = <&pinctrl_pwm0_ch3_idle>;
> +				pinctrl-8 = <&pinctrl_pwm0_ch4_active>;
> +				pinctrl-9 = <&pinctrl_pwm0_ch4_idle>;
> +				pinctrl-10 = <&pinctrl_pwm0_ch5_active>;
> +				pinctrl-11 = <&pinctrl_pwm0_ch5_idle>;
> +				pinctrl-12 = <&pinctrl_pwm0_ch6_active>;
> +				pinctrl-13 = <&pinctrl_pwm0_ch6_idle>;
> +				pinctrl-14 = <&pinctrl_pwm0_ch7_active>;
> +				pinctrl-15 = <&pinctrl_pwm0_ch7_idle>;
> +				status = "disabled";
> +			};

This is a SoC file, but the pinmux is board specific. The pinmux
settings probably shouldn't be here.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
