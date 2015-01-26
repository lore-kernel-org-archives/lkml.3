Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726AbbAZL4c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 06:56:32 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:61871 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbbAZL4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 06:56:30 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
Cc: tiwai@suse.de, perex@perex.cz, broonie@kernel.org, lgirdwood@gmail.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 2/4] dt: sound: jz4740: Add binding documentation for jz4740-i2s
Date: Mon, 26 Jan 2015 12:56:23 +0100
Message-ID: <2047908.1EOGyb8YHD@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1422267511-6649-3-git-send-email-Zubair.Kakakhel@imgtec.com>
References: <1422267511-6649-1-git-send-email-Zubair.Kakakhel@imgtec.com> <1422267511-6649-3-git-send-email-Zubair.Kakakhel@imgtec.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:sKqrN8Jj6NuDyDLe8K0b/UwgEBhIbIiXlwnYFHtUKMwiTyyQQkh
 r5xo29L9gwnf1Ap7Om3s0B2FJSxY6XD5GV12oc458y/vu39HNw2FkxepGzkSep94oO/7p0T
 clAtwK9Gs6AD2BGbSI+beHLrFZbc6KHaVt/dI290vl6eqoylDVIoNBvX4gGqOCZDvpsrEGF
 cvnLixuF67Ag420tp3Phw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 January 2015 10:18:29 Zubair Lutfullah Kakakhel wrote:
> index 0000000..0e40517
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/sound/ingenic,jz4740-i2s.txt
> @@ -0,0 +1,18 @@
> +Ingenic JZ4740 I2S controller
> +
> +Required properties:
> +- compatible : "ingenic,jz4740-i2s"
> +- reg : I2S registers location and length
> +- clocks : AIC and I2S PLL clock specifiers.
> +- clock-names: "aic" and "i2s"
> +
> +Example:
> +
> +i2s: i2s@10020000 {
> +       compatible = "ingenic,jz4740-i2s";
> +       reg = <0x10020000 0x94>;
> +
> +       clocks = <&cgu JZ4740_CLK_AIC>, <&cgu JZ4740_CLK_I2SPLL>;
> +       clock-names = "aic", "i2s";
> +
> +};
> 

I would argue that the binding should mandate "dmas" property already.
The code currently does not use it, but it will need to get changed
in order to allow the dmaengine driver for this platform to be
converted. You should require only one argument for the channel ID,
so something like

	dmas = <&dma 24>, <&dma 25>;
	dma-names = "tx", "rx";

would be enough for the binding. Unfortunately that also requires
having a device node for the dma engine, but you can cheat there
and not call of_dma_controller_register() in the first step.

	Arnd
