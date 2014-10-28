Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbaJ1Oer (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 10:34:47 -0400
Received: from gloria.sntech.de ([95.129.55.99]:35631 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511AbaJ1Oeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 10:34:46 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Joerg Roedel <joro@8bytes.org>, Grant Grundler <grundler@chromium.org>,
        =?ISO-8859-1?Q?St=E9phane?= Marchesin <marcheu@chromium.org>,
        Simon Xue <xxm@rock-chips.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 3/3] ARM: dts: rk3288: add VOP iommu nodes
Date: Tue, 28 Oct 2014 15:37:52 +0100
Message-ID: <6644033.fY7Wj4BQVl@diego>
User-Agent: KMail/4.12.4 (Linux/3.13-1-amd64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <1414413448-15819-4-git-send-email-djkurtz@chromium.org>
References: <1414413448-15819-1-git-send-email-djkurtz@chromium.org> <1414413448-15819-4-git-send-email-djkurtz@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 27. Oktober 2014, 20:37:28 schrieb Daniel Kurtz:
> Add device nodes for the VOP iommus.
> Device nodes for other iommus will be added in later patches.
> 
> The iommu nodes use the #iommu-cells property as described in:
>   Documentation/devicetree/bindings/iommu/iommu.txt
> 
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> Signed-off-by: Simon Xue <xxm@rock-chips.com>

Looks fine and I'll pick this patch up, once Joerg is statisfied with the iommu 
driver (patches 1 and 2).


Heiko

> ---
>  arch/arm/boot/dts/rk3288.dtsi | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
> index 5950b0a..df1170c 100644
> --- a/arch/arm/boot/dts/rk3288.dtsi
> +++ b/arch/arm/boot/dts/rk3288.dtsi
> @@ -271,6 +271,24 @@
>  		status = "disabled";
>  	};
> 
> +	vopb_mmu: iommu@ff930300 {
> +		compatible = "rockchip,iommu";
> +		reg = <0xff930300 0x100>;
> +		interrupts = <GIC_SPI 15 IRQ_TYPE_LEVEL_HIGH>;
> +		interrupt-names = "vopb_mmu";
> +		#iommu-cells = <0>;
> +		status = "disabled";
> +	};
> +
> +	vopl_mmu: iommu@ff940300 {
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

