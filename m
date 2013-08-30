Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921Ab3H3TUL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 15:20:11 -0400
Received: from gate.crashing.org ([63.228.1.57]:47005 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753716Ab3H3TUJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 15:20:09 -0400
Subject: Re: [PATCH 4/4] Documentation: Add device tree bindings for Freescale FTM PWM
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1377054462-6283-5-git-send-email-Li.Xiubo@freescale.com>
Date: Fri, 30 Aug 2013 14:19:12 -0500
Cc: <r65073@freescale.com>, <thierry.reding@gmail.com>,
        <grant.likely@linaro.org>, <linux@arm.linux.org.uk>, <rob@landley.net>,
        <ian.campbell@citrix.com>, <swarren@wwwdotorg.org>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>,
        <rob.herring@calxeda.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-pwm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <5EFBF478-CFCC-4E66-A279-25F4A338B05B@kernel.crashing.org>
References: <1377054462-6283-1-git-send-email-Li.Xiubo@freescale.com> <1377054462-6283-5-git-send-email-Li.Xiubo@freescale.com>
To: Xiubo Li <Li.Xiubo@freescale.com>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Should have at least something w/regards to a commit message.

On Aug 20, 2013, at 10:07 PM, Xiubo Li wrote:

> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> ---
> .../devicetree/bindings/pwm/fsl-ftm-pwm.txt        | 52 ++++++++++++++++++++++
> 1 file changed, 52 insertions(+)
> create mode 100644 Documentation/devicetree/bindings/pwm/fsl-ftm-pwm.txt
> 
> diff --git a/Documentation/devicetree/bindings/pwm/fsl-ftm-pwm.txt b/Documentation/devicetree/bindings/pwm/fsl-ftm-pwm.txt
> new file mode 100644
> index 0000000..698965b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pwm/fsl-ftm-pwm.txt
> @@ -0,0 +1,52 @@
> +Freescale FTM PWM controller
> +
> +Required properties:
> +- compatible: should be "fsl,vf610-ftm-pwm"
> +- reg: physical base address and length of the controller's registers
> +- #pwm-cells: Should be 3. Number of cells being used to specify PWM property.
> +  First cell specifies the per-chip channel index of the PWM to use, the
> +  second cell is the period in nanoseconds and bit 0 in the third cell is
> +  used to encode the polarity of PWM output. Set bit 0 of the third in PWM
> +  specifier to 1 for inverse polarity & set to 0 for normal polarity.
> +- fsl,pwm-clk-ps: the ftm0 pwm clock's prescaler, divide-by 2^n(n = 0 ~ 7).
> +- fsl,pwm-cpwm: Center-Aligned PWM (CPWM) mode.

Should describe this in more detail, what does the value actually mean for what modes there are?

> +- fsl,pwm-number: the number of PWM devices, and is must equal to the number
> +  of "fsl,pwm-channels".

If they must be equal why do we need both?

> +- fsl,pwm-channels: the channels' order which is be used for pwm in ftm0
> +  module, and they must be one or some of 0 ~ 7, because the ftm0 only has
> +  8 channels can be used.
> +- for very channel, the revlatived the pinctrl should be at least two state

revlatived?

> +  {"enN", "dsN"}, which "en" means "enable", "ds" means "disable" and "N"
> +  means the order of the channel.
> +
> +Example:
> +
> +pwm0: pwm@40038000 {
> +	      compatible = "fsl,vf610-ftm-pwm";
> +	      reg = <0x40038000 0x1000>;
> +	      #pwm-cells = <3>;
> +	      pinctrl-names = "en0", "ds0", "en3", "ds3";
> +	      pinctrl-0 = <&pinctrl_pwm0_ch0_en>;
> +	      pinctrl-1 = <&pinctrl_pwm0_ch0_ds>;
> +	      pinctrl-2 = <&pinctrl_pwm0_ch3_en>;
> +	      pinctrl-3 = <&pinctrl_pwm0_ch3_ds>;
> +	      fsl,pwm-clk-ps = <7>;
> +	      fsl,pwm-cpwm = <0>;
> +	      fsl,pwm-number = <2>;
> +	      fsl,pwm-channels = <0 3>;
> +	      ...
> +      };
> +
> +leds {
> +	compatible = "pwm-leds";
> +	led {
> +		label = "fsl_led";
> +		pwms = <&pwm0 0 10000000 0>;
> +		max-brightness = <127>;
> +	};
> +	backlight {
> +		label = "fsl_backlight";
> +		pwms = <&pwm0 3 10000000 1>;
> +		max-brightness = <100>;
> +	};
> +};
> -- 
> 1.8.0
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

