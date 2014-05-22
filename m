Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751498AbaEVQGw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 12:06:52 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:47323 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbaEVQGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 12:06:49 -0400
Date: Thu, 22 May 2014 17:06:43 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Peter Griffin <peter.griffin@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@st.com, patrice.chotard@st.com,
        srinivas.kandagatla@gmail.com, chris@printf.net,
        ulf.hansson@linaro.org, kernel@stlinux.com, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Subject: Re: [PATCH 2/8] mmc: sdhci-st: STMicroelectronics SDHCI binding
 documentation.
Message-ID: <20140522160643.GI19747@lee--X1>
References: <1400771902-26553-1-git-send-email-peter.griffin@linaro.org>
 <1400771902-26553-3-git-send-email-peter.griffin@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1400771902-26553-3-git-send-email-peter.griffin@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch adds the device tree binding documentation for ST
> SDHCI driver. It contains the differences between the core properties
> in mmc.txt and the properties used by the sdhci-st driver.
> 
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> ---
>  Documentation/devicetree/bindings/mmc/sdhci-st.txt | 26 ++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mmc/sdhci-st.txt
> 
> diff --git a/Documentation/devicetree/bindings/mmc/sdhci-st.txt b/Documentation/devicetree/bindings/mmc/sdhci-st.txt
> new file mode 100644
> index 0000000..ae3dae0
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mmc/sdhci-st.txt
> @@ -0,0 +1,26 @@
> +* STMicroelectronics sdhci-st MMC/SD controller
> +
> +This file documents differences between the core properties in mmc.txt

Where is mmc.txt?

> +and the properties used by the sdhci-st driver
> +
> +Required properties:
> +- compatible: "st,sdhci"
> +- clocks: card clock, must be "mmc".

This isn't correct.  I think you mean it must be a phandle to the
'mmc' clock.  It's also worth referencing the clock DT documentation
here.

> +Optional properties:
> +- reset: to provide a reset to the HC.

What is it; integer, string, phandle, something else?

> +- non-removable: non-removable slot (bindings/mmc/mmc.txt).

This however, _is_ a string, so you need to put it in "'s like you did
with "mmc" above and/or reference the file which documents it.

> +
> +Example:
> +
> +mmc0: sdhci@fe81e000 {
> +	compatible	= "st,sdhci";
> +	status		= "disabled";
> +	reg		= <0xfe81e000 0x1000>;
> +	interrupts	= <GIC_SPI 127 IRQ_TYPE_NONE>;
> +	interrupt-names	= "mmcirq";
> +	pinctrl-names	= "default";
> +	pinctrl-0	= <&pinctrl_mmc0>;
> +	clock-names	= "mmc";

I don't think you need clock-names if you only have one clock.

> +	clocks		= <&clk_s_a1_ls 1>;
> +};

Once fixed you can add my Ack for the next submission:

  Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
