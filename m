Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab3HWJXw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 05:23:52 -0400
Received: from mail-bk0-f67.google.com ([209.85.214.67]:35350 "EHLO
	mail-bk0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610Ab3HWJXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 05:23:50 -0400
Date: Fri, 23 Aug 2013 11:10:52 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: r65073@freescale.com, grant.likely@linaro.org, linux@arm.linux.org.uk,
        rob@landley.net, ian.campbell@citrix.com, swarren@wwwdotorg.org,
        mark.rutland@arm.com, pawel.moll@arm.com, rob.herring@calxeda.com,
        linux-arm-kernel@lists.infradead.org, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 4/4] Documentation: Add device tree bindings for
 Freescale FTM PWM
Message-ID: <20130823091052.GG3535@ulmo>
References: <1377054462-6283-1-git-send-email-Li.Xiubo@freescale.com>
 <1377054462-6283-5-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QWpDgw58+k1mSFBj"
Content-Disposition: inline
In-Reply-To: <1377054462-6283-5-git-send-email-Li.Xiubo@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QWpDgw58+k1mSFBj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 21, 2013 at 11:07:42AM +0800, Xiubo Li wrote:
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> ---
>  .../devicetree/bindings/pwm/fsl-ftm-pwm.txt        | 52 ++++++++++++++++++++++
>  1 file changed, 52 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/pwm/fsl-ftm-pwm.txt

It used to be that device tree bindings documentation was squashed into
the same commit as the driver. I see some point in splitting this up
given that this will eventually go into a completely separate tree, but
I just want to make sure this is now the official way of splitting
patches so I can tell that to people in good conscience.

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
> +- fsl,pwm-number: the number of PWM devices, and is must equal to the number
> +  of "fsl,pwm-channels".
> +- fsl,pwm-channels: the channels' order which is be used for pwm in ftm0
> +  module, and they must be one or some of 0 ~ 7, because the ftm0 only has
> +  8 channels can be used.
> +- for very channel, the revlatived the pinctrl should be at least two state
> +  {"enN", "dsN"}, which "en" means "enable", "ds" means "disable" and "N"
> +  means the order of the channel.

This is missing a description of the clocks and clock-names properties.

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

And this mixes tabs and spaces for indentation.

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

I don't think I like this at all. This example suggests to use the
pwm-leds driver for backlight control. Why not use pwm-backlight
instead?

Thierry

--QWpDgw58+k1mSFBj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSFyccAAoJEN0jrNd/PrOhBEAQAK8LA/WTKf5g90mRw544QJze
P5Bh09dONDLSNA251OUnfFJqCTyVhKxQ878krafalRZecLmdUE23WjBpCLY4tK8K
qMgOYWYcbc8R9N6np/4xNuqn3SXtDfK/fOZ9fWMXMfaBrnCrlwb8KDLJUO4R32l8
WPWzJ1Ady+bRirulD2z9TVUd2Q7cD2hxDTf3GovW1eKVEurRyA8w1wKhnqNHiC+F
z1YHE4x8HP9cGt66ng1mcDF+NPr1tiEEUk2CPxtKKbtInyID7su82fswNAKc9bKi
4y4+LvCa6TDKHrVBMC5i3peZXcPUqsQdARaVVC/D6Em9MhoYaRlnoksgkbdZWUC4
pTz0jpuuakQf3ytSVgWhiIMO87KAFcWZUt1IgOF5GprcdC1MK7HS6VMWML86fhtZ
BSVdfXlaoIZv5PvDFzLhZvi+gSopcrIwEkiSs2sjqjidhiSwlZ3lummKGxmGR9jS
RrdVzmTUEBmlsl8EgRgrWfinqvDDeMOm6OKoI9q/WFludObtDW8Z3xmYtpsxJOLe
lAMsOJ8YGCDEqV51TZIJ0cvCjxBZnHO/BzS6u0qJhICCfhzwMpN771hEhwyXEsNh
8GLz32ZLmI5khGguYPpXAOSlEJZuNYZes5IQ5o5glUDMtUAAUxsC0AKqhJHiKPwA
1O93EW6SFp5RkwMw1KER
=z8bv
-----END PGP SIGNATURE-----

--QWpDgw58+k1mSFBj--
