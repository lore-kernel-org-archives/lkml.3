Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145AbaFBQdS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 12:33:18 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:55939 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429AbaFBQdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 12:33:16 -0400
Message-ID: <538CA749.3010106@wwwdotorg.org>
Date: Mon, 02 Jun 2014 10:33:13 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Marcel Ziswiler <marcel@ziswiler.com>, thierry.reding@gmail.com
CC: linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, stefan@agner.ch
Subject: Re: [PATCH 3/3] arm: tegra: initial support for apalis t30
References: <c5522b0efcbfc7690dcde6aaf78b9dd568f99604.1401665237.git.marcel@ziswiler.com> <b470c9c8631a6ef021d140192eb07006de3cfd93.1401665237.git.marcel@ziswiler.com>
In-Reply-To: <b470c9c8631a6ef021d140192eb07006de3cfd93.1401665237.git.marcel@ziswiler.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2014 05:37 PM, Marcel Ziswiler wrote:
> This patch adds the device tree to support Toradex Apalis T30, a
> computer on module which can be used on different carrier boards.
> 
> The module consists of a Tegra 3 SoC, two PMICs, 1 or 2 GB of DDR3L
> RAM, eMMC, an LM95245 temperature sensor chip, an i210 resp. i211
> gigabit Ethernet controller, an STMPE811 ADC/touch controller as well
> as two MCP2515 CAN controllers. Furthermore, there is an SGTL5000 audio
> codec which is not yet supported. Anything that is not self contained
> on the module is disabled by default.
> 
> The device tree for the Evaluation Board includes the modules device
> tree and enables the supported peripherals of the carrier board (the
> Evaluation Board supports almost all of them).
> 
> While at it also add the device tree binding documentation for Apalis
> T30 as well as the previously missing one for the recently added
> Colibri T30.

> diff --git a/arch/arm/boot/dts/tegra30-apalis-eval.dts b/arch/arm/boot/dts/tegra30-apalis-eval.dts

> +	/* SPI1: Apalis SPI1 */
> +	spi@7000d400 {
> +		status = "okay";
> +		spi-max-frequency = <25000000>;
> +		spidev0: spidev@1 {
> +			compatible = "spidev";
> +			reg = <1>;
> +			spi-max-frequency = <25000000>;
> +		};
> +	};

I vaguely recall people speaking out against including "spidev" devices
in DT because they don't represent actual HW, but rather a way to
request that the SPI bus be exposed to user-space, which is a pure SW
issue. Wouldn't it be better if the spidev interface worked like
I2C_CHARDEV, where fake devices weren't actually required?

