Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157AbaJ1Odl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 10:33:41 -0400
Received: from gloria.sntech.de ([95.129.55.99]:35593 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752001AbaJ1Odj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 10:33:39 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Joerg Roedel <joro@8bytes.org>, Grant Grundler <grundler@chromium.org>,
        =?ISO-8859-1?Q?St=E9phane?= Marchesin <marcheu@chromium.org>,
        Simon Xue <xxm@rock-chips.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Doug Anderson <dianders@chromium.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 2/3] dt-bindings: iommu: Add documentation for rockchip iommu
Date: Tue, 28 Oct 2014 15:36:21 +0100
Message-ID: <1857030.bPXkUHlXFx@diego>
User-Agent: KMail/4.12.4 (Linux/3.13-1-amd64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <1414413448-15819-3-git-send-email-djkurtz@chromium.org>
References: <1414413448-15819-1-git-send-email-djkurtz@chromium.org> <1414413448-15819-3-git-send-email-djkurtz@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 27. Oktober 2014, 20:37:27 schrieb Daniel Kurtz:
> Add binding documentation for Rockchip IOMMU.
> 
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> Signed-off-by: Simon Xue <xxm@rock-chips.com>

Reviewed-by: Heiko Stuebner <heiko@sntech.de>

> ---
>  .../devicetree/bindings/iommu/rockchip,iommu.txt   | 26
> ++++++++++++++++++++++ 1 file changed, 26 insertions(+)
>  create mode 100644
> Documentation/devicetree/bindings/iommu/rockchip,iommu.txt
> 
> diff --git a/Documentation/devicetree/bindings/iommu/rockchip,iommu.txt
> b/Documentation/devicetree/bindings/iommu/rockchip,iommu.txt new file mode
> 100644
> index 0000000..9a55ac3
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/iommu/rockchip,iommu.txt
> @@ -0,0 +1,26 @@
> +Rockchip IOMMU
> +==============
> +
> +A Rockchip DRM iommu translates io virtual addresses to physical addresses
> for +its master device.  Each slave device is bound to a single master
> device, and +shares its clocks, power domain and irq.
> +
> +Required properties:
> +- compatible      : Should be "rockchip,iommu"
> +- reg             : Address space for the configuration registers
> +- interrupts      : Interrupt specifier for the IOMMU instance
> +- interrupt-names : Interrupt name for the IOMMU instance
> +- #iommu-cells    : Should be <0>.  This indicates the iommu is a
> +                    "single-master" device, and needs no additional
> information +                    to associate with its master device.  See:
> +                    Documentation/devicetree/bindings/iommu/iommu.txt
> +
> +Example:
> +
> +	vopl_mmu: iommu@ff940300 {
> +		compatible = "rockchip,iommu";
> +		reg = <0xff940300 0x100>;
> +		interrupts = <GIC_SPI 16 IRQ_TYPE_LEVEL_HIGH>;
> +		interrupt-names = "vopl_mmu";
> +		#iommu-cells = <0>;
> +	};

