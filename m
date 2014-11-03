Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867AbaKCJlZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 04:41:25 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40083 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbaKCJlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 04:41:23 -0500
Message-ID: <1415007669.3060.6.camel@pengutronix.de>
Subject: Re: [PATCH v2 3/3] ARM: dts: mt8135: Add Reset Controller for
 MediaTek SoC
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Flora Fu <flora.fu@mediatek.com>
Cc: Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>, arm@kernel.org,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        srv_heupstream@mediatek.com, Sascha Hauer <kernel@pengutronix.de>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>
Date: Mon, 03 Nov 2014 10:41:09 +0100
In-Reply-To: <1415005371-4323-4-git-send-email-flora.fu@mediatek.com>
References: <1415005371-4323-1-git-send-email-flora.fu@mediatek.com>
	 <1415005371-4323-4-git-send-email-flora.fu@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.6-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 03.11.2014, 17:02 +0800 schrieb Flora Fu:
> Add reset controller to MT8135 board dts.
> 
> Signed-off-by: Flora Fu <flora.fu@mediatek.com>
> ---
>  arch/arm/boot/dts/mt8135.dtsi | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/mt8135.dtsi b/arch/arm/boot/dts/mt8135.dtsi
> index 90a56ad..259a2b5 100644
> --- a/arch/arm/boot/dts/mt8135.dtsi
> +++ b/arch/arm/boot/dts/mt8135.dtsi
> @@ -102,6 +102,32 @@
>  			clock-names = "system-clk", "rtc-clk";
>  		};
>  
> +		infracfg: syscon@10001000 {
> +			#address-cells = <1>;
> +			#size-cells = <0>;

Same as with patch 2, please use #size-cells = <1>.

> +			compatible = "mediatek,mt8135-infracfg", "syscon";
> +			reg = <0 0x10001000 0 0x1000>;
> +
> +			infrarst: reset-controller@30 {
> +				#reset-cells = <1>;
> +				compatible = "mediatek,mt8135-infracfg-reset", "mediatek,reset";
> +				reg = <0x30 0x8>;
> +			};
> +		};
> +
> +		pericfg: syscon@10003000 {
> +			#address-cells = <1>;
> +			#size-cells = <0>;

And here. Other than that,
Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

> +			compatible = "mediatek,mt8135-pericfg", "syscon";
> +			reg = <0 0x10003000 0 0x1000>;
> +
> +			perirst: reset-controller@00 {
> +				#reset-cells = <1>;
> +				compatible = "mediatek,mt8135-pericfg-reset", "mediatek,reset";
> +				reg = <0x00 0x8>;
> +			};
> +		};
> +
>  		gic: interrupt-controller@10211000 {
>  			compatible = "arm,cortex-a15-gic";
>  			interrupt-controller;

regards
Philipp

