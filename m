Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751598AbaEARda (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 13:33:30 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:35257 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbaEARd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 13:33:29 -0400
Message-ID: <53628566.1070602@wwwdotorg.org>
Date: Thu, 01 May 2014 11:33:26 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>
CC: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Thierry Reding <treding@nvidia.com>
Subject: Re: [PATCH] ARM: tegra: add Tegra Note 7 device tree
References: <1398928217-32629-1-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1398928217-32629-1-git-send-email-acourbot@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2014 01:10 AM, Alexandre Courbot wrote:
> Tegra Note 7 is a consumer tablet embedding a Tegra 4 SoC with 1GB RAM
> and a 720p panel.
> 
> The following features are enabled by this device tree: UART, eMMC, USB
> (needs external power), PMIC, backlight, DSI panel, keys.
> 
> SD card, HDMI, charger, self-powered USB, audio, wifi, bluetooth are not
> yet supported but might be by future patches (likely in that order).

> diff --git a/arch/arm/boot/dts/tegra114-tn7.dts b/arch/arm/boot/dts/tegra114-tn7.dts

> +	chosen {
> +		/* TN7's bootloader's arguments need to be overridden */
> +		bootargs = "console=ttyS0,115200n8 console=tty1 gpt cma=128M fbcon=rotate:2";

Do we still need the cma argument at all now? The default is now 64M in
tegra_defconfig, and 128M seems quite large.

> +	host1x@50000000 {
> +		hdmi@54280000 {
> +			status = "okay";
> +
> +			hdmi-supply = <&vdd_5v0_hdmi>;
> +			vdd-supply = <&vdd_3v3_hdmi>;
> +			pll-supply = <&vdd_1v05_pll>;
> +
> +			nvidia,ddc-i2c-bus = <&hdmi_ddc>;
> +			nvidia,hpd-gpio =
> +				<&gpio TEGRA_GPIO(N, 7) GPIO_ACTIVE_HIGH>;
> +		};

If HDMI doesn't work yet (per commit description), should we leave it
out of the DT for now?

> +	serial@70006300 {
> +		status = "okay";
> +	};

Is there actually an accessible UART on the board? I guess this is for
people lucky enough to have internal boards with the debug connector. If
so, this is probably fine.
