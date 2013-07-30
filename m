Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823Ab3G3SQW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 14:16:22 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:58034 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756060Ab3G3SQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 14:16:20 -0400
Message-ID: <51F802F0.3030907@wwwdotorg.org>
Date: Tue, 30 Jul 2013 12:16:16 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: grant.likely@linaro.org, rob.herring@calxeda.com, linus.walleij@linaro.org,
        linux-doc@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH] pinctrl: tegra: add valid function name on DT document
References: <1375182261-30946-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1375182261-30946-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2013 05:04 AM, Laxman Dewangan wrote:
> Add valid property name for the property "nvidia,function" in
> DT binding document of Tegra pincontrol.

I have applied this to Tegra's for-3.12/dt branch, but I fixed up quite
a few issues along the way...

> diff --git a/Documentation/devicetree/bindings/pinctrl/nvidia,tegra114-pinmux.txt b/Documentation/devicetree/bindings/pinctrl/nvidia,tegra114-pinmux.txt

> @@ -69,6 +69,16 @@ Valid values for pin and group names are:
>      gpio_w2_aud_pw2, gpio_w3_aud_pw3, usb_vbus_en0_pn4, usb_vbus_en1_pn5,
>      sdmmc3_clk_lb_in_pee5, sdmmc3_clk_lb_out_pee4, reset_out_n.
>  
> +The valid names for the nvidia,functions are:
> +    blink, cec, cldvfs, clk12, cpu, dap, dap1, dap2, dev3, displaya,

For consistency with other lists in the document, I added a blank line
between those two lines, and reworded the first of those lines to be
written in the same style as equivalent text for other lists.

> +    displaya_alt, displayb, dtv, emc_dll, extperiph1, extperiph2,
> +    extperiph3, gmi, gmi_alt, hda, hsi, i2c1, i2c2, i2c3, i2c4, i2cpwr,
> +    i2s0, i2s1, i2s2, i2s3, i2s4, irda, kbc, nand, nand_alt, owr, pmi,
> +    pwm0, pwm1, pwm2, pwm3, pwron, reset_out_n, rsvd1, rsvd2, rsvd3,
> +    rsvd4, sdmmc1, sdmmc2, sdmmc3, sdmmc4, soc, spdif, spi1, spi2, spi3,
> +    spi4, spi5, spi6, sysclk, trace, uarta, uartb, uartc, uartd, ulpi,
> +    usb, vgp1, vgp2, vgp3, vgp4, vgp5, vgp6, vi, vi_alt1, vi_alt3
> +
>    drive groups:

There is a list of valid pin/group names in the document, and that list
is divided into two sub-lists, for mux and drive groups. You inserted
the list of function names between the two sub-lists rather than after
the top-level list. Hence, I moved your additions to the correct place,
and also removed 2 characters of indent, since it's a top-level list,
not a sub-list of pin groups.

> diff --git a/Documentation/devicetree/bindings/pinctrl/nvidia,tegra20-pinmux.txt b/Documentation/devicetree/bindings/pinctrl/nvidia,tegra20-pinmux.txt

> @@ -82,6 +82,7 @@ Valid values for pin and group names are:
>      spdo, spia, spib, spic, spid, spie, spif, spig, spih, uaa, uab, uac, uad,
>      uca, ucb, uda.
>  
> +
>    tristate groups:

I undid that change.
