Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbaFRPIK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 11:08:10 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:35707 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695AbaFRPIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 11:08:07 -0400
MIME-Version: 1.0
In-Reply-To: <1403103172-19856-3-git-send-email-lee.jones@linaro.org>
References: <1403103172-19856-1-git-send-email-lee.jones@linaro.org>
	<1403103172-19856-3-git-send-email-lee.jones@linaro.org>
Date: Wed, 18 Jun 2014 17:08:07 +0200
Message-ID: <CAG374jChjAZksvYv0eQN+L1a2Zc4D2w+nU+OTuX_cCHP-aaPHA@mail.gmail.com>
Subject: Re: [PATCH 3/7] ARM: stih416: Add DT nodes for PWM
From: Gabriel Fernandez <gabriel.fernandez@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-pwm@vger.kernel.org, "kernel@stlinux.com" <kernel@stlinux.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Patrice Chotard <patrice.chotard@st.com>, ajitpal.singh@st.com,
        thierry.reding@gmail.com, Maxime Coquelin <maxime.coquelin@st.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,
minor remark below..

On 18 June 2014 16:52, Lee Jones <lee.jones@linaro.org> wrote:
> Supply top level nodes for the STiH416 based development boards.
> The Pinctrl configuration has already been applied, so the only
> missing piece of the DT puzzle is for a board's DTB to enable
> the nodes.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  arch/arm/boot/dts/stih416.dtsi | 40 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 40 insertions(+)
>
> diff --git a/arch/arm/boot/dts/stih416.dtsi b/arch/arm/boot/dts/stih416.dtsi
> index 06473c5..8af159e 100644
> --- a/arch/arm/boot/dts/stih416.dtsi
> +++ b/arch/arm/boot/dts/stih416.dtsi
> @@ -236,5 +236,45 @@
>                         resets  = <&powerdown STIH416_KEYSCAN_POWERDOWN>,
>                                   <&softreset STIH416_KEYSCAN_SOFTRESET>;
>                 };
> +
> +               /* SAS PWM Module */
> +               pwm0: pwm@fed10000 {
> +                       compatible      = "st,sti-pwm";
> +                       status          = "disabled";
> +                       #pwm-cells      = <2>;
> +                       reg             = <0xfed10000 0x68>;
> +
> +                       pinctrl-names   = "default";
> +                        pinctrl-0 =    <&pinctrl_pwm0_chan0_default
del space

> +                                       &pinctrl_pwm0_chan1_default
> +                                       &pinctrl_pwm0_chan2_default
> +                                       &pinctrl_pwm0_chan3_default>;
> +
> +                       clock-names     = "pwm";
> +                       clocks          = <&clk_sysin>;
> +               };
> +
> +               /* SBC PWM Module */
> +               pwm1: pwm@fe510000 {
> +                       compatible      = "st,sti-pwm";
> +                       status          = "disabled";
> +                       #pwm-cells      = <2>;
> +                       reg             = <0xfe510000 0x68>;
> +
> +                       pinctrl-names   = "default";
> +                       pinctrl-0 =     <&pinctrl_pwm1_chan0_default
> +                                       /*
> +                                        * Shared with SBC_OBS_NOTRST.  Don't
> +                                        * enable unless you really know what
> +                                        * you're doing.
> +                                        *
> +                                        * &pinctrl_pwm1_chan1_default
> +                                        */
> +                                       &pinctrl_pwm1_chan2_default
> +                                       &pinctrl_pwm1_chan3_default>;
> +
> +                       clock-names     = "pwm";
> +                       clocks          = <&clk_sysin>;
> +               };
>         };
>  };
> --
> 1.8.3.2
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
