Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303AbaFXS1Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 14:27:24 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:59378 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753712AbaFXS1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 14:27:23 -0400
Date: Tue, 24 Jun 2014 19:27:08 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Andy Gross <agross@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] pinctrl: msm: Add msm8960 definitions
Message-ID: <20140624182708.GA29789@leverpostej>
References: <1403633766-25796-1-git-send-email-bjorn.andersson@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403633766-25796-1-git-send-email-bjorn.andersson@sonymobile.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 07:16:06PM +0100, Bjorn Andersson wrote:
> Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
> ---
> 
> Changes since v1:
>  - Deduplicated functions for alternative pins
> 
>  .../bindings/pinctrl/qcom,msm8960-pinctrl.txt      |  103 ++
>  drivers/pinctrl/Kconfig                            |    8 +
>  drivers/pinctrl/Makefile                           |    1 +
>  drivers/pinctrl/pinctrl-msm8960.c                  | 1146 ++++++++++++++++++++
>  4 files changed, 1258 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/pinctrl/qcom,msm8960-pinctrl.txt
>  create mode 100644 drivers/pinctrl/pinctrl-msm8960.c
> 
> diff --git a/Documentation/devicetree/bindings/pinctrl/qcom,msm8960-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/qcom,msm8960-pinctrl.txt
> new file mode 100644
> index 0000000..6e79eea
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pinctrl/qcom,msm8960-pinctrl.txt
> @@ -0,0 +1,103 @@
> +Qualcomm MSM8960 TLMM block
> +
> +Required properties:
> +- compatible: "qcom,msm8960-pinctrl"
> +- reg: Should be the base address and length of the TLMM block.
> +- interrupts: Should be the parent IRQ of the TLMM block.
> +- interrupt-controller: Marks the device node as an interrupt controller.
> +- #interrupt-cells: Should be two.

There should be a description of valid values for the two cells of an
interrupt-specifier.

> +- gpio-controller: Marks the device node as a GPIO controller.
> +- #gpio-cells : Should be two.
> +                The first cell is the gpio pin number and the
> +                second cell is used for optional parameters.

And what are those optional parameters?

[...]

> +Example:
> +
> +       msmgpio: pinctrl@800000 {
> +               compatible = "qcom,msm8960-pinctrl";
> +               reg = <0x800000 0x4000>;
> +
> +               gpio-controller;
> +               #gpio-cells = <2>;
> +               interrupt-controller;
> +               #interrupt-cells = <2>;
> +                interrupts = <0 32 0x4>;
> +
> +               pinctrl-names = "default";
> +               pinctrl-0 = <&debug_uart>;

The fact that the pinctrl block itself supports pinctrl properties was
not described above.

Thanks,
Mark.
