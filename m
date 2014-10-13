Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243AbaJMWek (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 18:34:40 -0400
Received: from gloria.sntech.de ([95.129.55.99]:45874 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751546AbaJMWei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 18:34:38 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: =?ISO-8859-1?Q?St=E9phane?= Marchesin <marcheu@chromium.org>,
        Grant Grundler <grundler@chromium.org>, Simon Xue <xxm@rock-chips.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "moderated list:ARM/Rockchip SoC..." 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 3/3] ARM: dts: rk3288: add VOP iommu nodes
Date: Tue, 14 Oct 2014 00:33:41 +0200
Message-ID: <4094180.e6s5oT6HgP@phil>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1412965848-18663-4-git-send-email-djkurtz@chromium.org>
References: <1412965848-18663-1-git-send-email-djkurtz@chromium.org> <1412965848-18663-4-git-send-email-djkurtz@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

Am Samstag, 11. Oktober 2014, 02:30:48 schrieb Daniel Kurtz:
> Add device nodes for the VOP iommus.
> Device nodes for other iommus will be added in later patches.
> 
> The iommu nodes use the #iommu-cells property as described in:
>   Documentation/devicetree/bindings/iommu/iommu.txt
> 
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> Signed-off-by: Simon Xue <xxm@rock-chips.com>
> ---
>  arch/arm/boot/dts/rk3288.dtsi | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
> index 5950b0a..cbc92fa 100644
> --- a/arch/arm/boot/dts/rk3288.dtsi
> +++ b/arch/arm/boot/dts/rk3288.dtsi
> @@ -271,6 +271,24 @@
>  		status = "disabled";
>  	};
> 
> +	vopb_mmu: iommu@0xff930300 {

please use the address without the 0x here ... iommu@ff930300


Thanks
Heiko

> +		compatible = "rockchip,iommu";
> +		reg = <0xff930300 0x100>;
> +		interrupts = <GIC_SPI 15 IRQ_TYPE_LEVEL_HIGH>;
> +		interrupt-names = "vopb_mmu";
> +		#iommu-cells = <0>;
> +		status = "disabled";
> +	};
> +
> +	vopl_mmu: iommu@0xff940300 {
> +		compatible = "rockchip,iommu";
> +		reg = <0xff940300 0x100>;
> +		interrupts = <GIC_SPI 16 IRQ_TYPE_LEVEL_HIGH>;
> +		interrupt-names = "vopl_mmu";
> +		#iommu-cells = <0>;
> +		status = "disabled";
> +	};
> +
>  	gic: interrupt-controller@ffc01000 {
>  		compatible = "arm,gic-400";
>  		interrupt-controller;

