Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855Ab3H3Rad (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 13:30:33 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47097 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755102Ab3H3Rac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 13:30:32 -0400
Date: Fri, 30 Aug 2013 19:30:08 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: r65073@freescale.com, thierry.reding@gmail.com, grant.likely@linaro.org,
        linux@arm.linux.org.uk, rob@landley.net, ian.campbell@citrix.com,
        swarren@wwwdotorg.org, mark.rutland@arm.com, pawel.moll@arm.com,
        rob.herring@calxeda.com, linux-arm-kernel@lists.infradead.org,
        linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCHv2 4/4] Documentation: Add device tree bindings for
 Freescale FTM PWM.
Message-ID: <20130830173008.GC30069@pengutronix.de>
Mail-Followup-To: Xiubo Li <Li.Xiubo@freescale.com>, r65073@freescale.com,
	thierry.reding@gmail.com, grant.likely@linaro.org,
	linux@arm.linux.org.uk, rob@landley.net, ian.campbell@citrix.com,
	swarren@wwwdotorg.org, mark.rutland@arm.com, pawel.moll@arm.com,
	rob.herring@calxeda.com, linux-arm-kernel@lists.infradead.org,
	linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, linux-doc@vger.kernel.org
References: <1377856132-11290-1-git-send-email-Li.Xiubo@freescale.com>
 <1377856132-11290-5-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377856132-11290-5-git-send-email-Li.Xiubo@freescale.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 19:27:51 up 6 days,  2:58, 33 users,  load average: 0.02, 0.03, 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 05:48:52PM +0800, Xiubo Li wrote:
> This patch adds the document for Freescale FTM PWM driver under
> Documentation/devicetree/bindings/pwm/.
> 
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> ---
>  .../devicetree/bindings/pwm/pwm-fsl-ftm.txt        | 40 ++++++++++++++++++++++
>  1 file changed, 40 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/pwm/pwm-fsl-ftm.txt
> 
> diff --git a/Documentation/devicetree/bindings/pwm/pwm-fsl-ftm.txt b/Documentation/devicetree/bindings/pwm/pwm-fsl-ftm.txt
> new file mode 100644
> index 0000000..b2b5214
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pwm/pwm-fsl-ftm.txt
> @@ -0,0 +1,40 @@
> +Freescale FTM PWM controller
> +
> +Required properties:
> +- compatible: Should be "fsl,vf610-ftm-pwm"
> +- reg: Physical base address and length of the controller's registers
> +- #pwm-cells: Should be 3. See pwm.txt in this directory for a description of
> +  the cells format.
> +- clock-names : Includes the following module clock source entries:
> +    "ftm0" (system clock),
> +    "ftm0_fix_sel" (fixed frequency clock),
> +    "ftm0_ext_sel" (external clock)
> +- clocks : Must contain an entry list for entries in clock-names.
> +- fsl,pwm-counter-clk: The FTM PWM counter clock source, should be one of the
> +  entries in clock-names.
> +- fsl,pwm-avaliable-chs: The FTM channels ID list of current board which are
> +  available as PWM function.
> +- For each channel's pinctrl, the "chN-active" and "chN-idle" states should be
> +  implemented at same time.
> +
> +Example:
> +
> +pwm0: pwm@40038000 {
> +		compatible = "fsl,vf610-ftm-pwm";
> +		reg = <0x40038000 0x1000>;
> +		#pwm-cells = <3>;
> +		clock-names = "ftm0", "ftm0_fix_sel", "ftm0_ext_sel";
> +		clocks = <&clks VF610_CLK_FTM0>,
> +			<&clks VF610_CLK_FTM0_FIX_SEL>,
> +			<&clks VF610_CLK_FTM0_EXT_SEL>;
> +		pinctrl-names = "ch0-active", "ch0-idle", "ch1-active", "ch1-idle",
> +		....;
> +		pinctrl-0 = <&pinctrl_pwm0_ch0_active>;
> +		pinctrl-1 = <&pinctrl_pwm0_ch0_idle>;
> +		pinctrl-2 = <&pinctrl_pwm0_ch1_active>;
> +		pinctrl-3 = <&pinctrl_pwm0_ch1_idle>;
> +		...
> +		fsl,pwm-counter-clk = "ftm0_ext_sel";
> +		fsl,pwm-avaliable-chs = <0 3 5 6>;

I don't think this proerty is useful. Just enable all channels. I think
this was mentioned before.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
