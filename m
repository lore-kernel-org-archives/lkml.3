Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab3H0Lfu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 07:35:50 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:39672 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753005Ab3H0Lfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 07:35:48 -0400
Date: Tue, 27 Aug 2013 12:35:34 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: "hongbo.zhang@freescale.com" <hongbo.zhang@freescale.com>
Cc: "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "djbw@fb.com" <djbw@fb.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 2/3] DMA: Freescale: Add new 8-channel DMA engine
 device tree nodes
Message-ID: <20130827113534.GI19893@e106331-lin.cambridge.arm.com>
References: <1377600123-5746-1-git-send-email-hongbo.zhang@freescale.com>
 <1377600123-5746-3-git-send-email-hongbo.zhang@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377600123-5746-3-git-send-email-hongbo.zhang@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 11:42:02AM +0100, hongbo.zhang@freescale.com wrote:
> From: Hongbo Zhang <hongbo.zhang@freescale.com>
> 
> Freescale QorIQ T4 and B4 introduce new 8-channel DMA engines, this patch adds
> the device tree nodes for them.
> 
> Signed-off-by: Hongbo Zhang <hongbo.zhang@freescale.com>
> ---
>  .../devicetree/bindings/powerpc/fsl/dma.txt        |   66 ++++++++++++++++
>  arch/powerpc/boot/dts/fsl/b4si-post.dtsi           |    4 +-
>  arch/powerpc/boot/dts/fsl/elo3-dma-0.dtsi          |   81 ++++++++++++++++++++
>  arch/powerpc/boot/dts/fsl/elo3-dma-1.dtsi          |   81 ++++++++++++++++++++
>  arch/powerpc/boot/dts/fsl/t4240si-post.dtsi        |    4 +-
>  5 files changed, 232 insertions(+), 4 deletions(-)
>  create mode 100644 arch/powerpc/boot/dts/fsl/elo3-dma-0.dtsi
>  create mode 100644 arch/powerpc/boot/dts/fsl/elo3-dma-1.dtsi
> 
> diff --git a/Documentation/devicetree/bindings/powerpc/fsl/dma.txt b/Documentation/devicetree/bindings/powerpc/fsl/dma.txt
> index ddf17af..10fd031 100644
> --- a/Documentation/devicetree/bindings/powerpc/fsl/dma.txt
> +++ b/Documentation/devicetree/bindings/powerpc/fsl/dma.txt
> @@ -126,6 +126,72 @@ Example:
>                 };
>         };
> 
> +** Freescale Elo3 DMA Controller
> +   This is EloPlus controller with 8 channels, used in Freescale Txxx and Bxxx
> +   series chips, such as t1040, t4240, b4860.
> +
> +Required properties:
> +
> +- compatible        : must include "fsl,elo3-dma"
> +- reg               : <registers specifier for DMA general status reg>
> +- ranges            : describes the mapping between the address space of the
> +                      DMA channels and the address space of the DMA controller
> +
> +- DMA channel nodes:
> +        - compatible        : must include "fsl,eloplus-dma-channel"
> +        - reg               : <registers specifier for channel>
> +        - interrupts        : <interrupt specifier for DMA channel IRQ>
> +        - interrupt-parent  : optional, if needed for interrupt mapping
> +
> +Example:
> +dma@100300 {
> +       #address-cells = <1>;
> +       #size-cells = <1>;
> +       compatible = "fsl,elo3-dma";
> +       reg = <0x100300 0x4 0x100600 0x4>;

Is that one reg entry where #size-cells=2 and #address-cells=2?

That's what the binding implies (given it only describes a single reg
entry).

if it's two entries, we should make that explicit (both in the binding
and example):

	reg = <0x100300 0x4>,
	      <0x100600 0x4>;

> +       ranges = <0x0 0x100100 0x500>;

If it is one reg entry then the example ranges property isn't big enough
to contain the parent-bus-address.

> +       dma-channel@0 {
> +               compatible = "fsl,eloplus-dma-channel";
> +               reg = <0x0 0x80>;
> +               interrupts = <28 2 0 0>;
> +       };
> +       dma-channel@80 {
> +               compatible = "fsl,eloplus-dma-channel";
> +               reg = <0x80 0x80>;
> +               interrupts = <29 2 0 0>;
> +       };
> +       dma-channel@100 {
> +               compatible = "fsl,eloplus-dma-channel";
> +               reg = <0x100 0x80>;
> +               interrupts = <30 2 0 0>;
> +       };
> +       dma-channel@180 {
> +               compatible = "fsl,eloplus-dma-channel";
> +               reg = <0x180 0x80>;
> +               interrupts = <31 2 0 0>;
> +       };
> +       dma-channel@300 {
> +               compatible = "fsl,eloplus-dma-channel";
> +               reg = <0x300 0x80>;
> +               interrupts = <76 2 0 0>;
> +       };
> +       dma-channel@380 {
> +               compatible = "fsl,eloplus-dma-channel";
> +               reg = <0x380 0x80>;
> +               interrupts = <77 2 0 0>;
> +       };
> +       dma-channel@400 {
> +               compatible = "fsl,eloplus-dma-channel";
> +               reg = <0x400 0x80>;
> +               interrupts = <78 2 0 0>;
> +       };
> +       dma-channel@480 {
> +               compatible = "fsl,eloplus-dma-channel";
> +               reg = <0x480 0x80>;
> +               interrupts = <79 2 0 0>;
> +       };
> +};
> +
>  Note on DMA channel compatible properties: The compatible property must say
>  "fsl,elo-dma-channel" or "fsl,eloplus-dma-channel" to be used by the Elo DMA
>  driver (fsldma).  Any DMA channel used by fsldma cannot be used by another
> diff --git a/arch/powerpc/boot/dts/fsl/b4si-post.dtsi b/arch/powerpc/boot/dts/fsl/b4si-post.dtsi
> index 7399154..ea53ea1 100644
> --- a/arch/powerpc/boot/dts/fsl/b4si-post.dtsi
> +++ b/arch/powerpc/boot/dts/fsl/b4si-post.dtsi
> @@ -223,13 +223,13 @@
>                 reg = <0xe2000 0x1000>;
>         };
> 
> -/include/ "qoriq-dma-0.dtsi"
> +/include/ "elo3-dma-0.dtsi"
>         dma@100300 {
>                 fsl,iommu-parent = <&pamu0>;
>                 fsl,liodn-reg = <&guts 0x580>; /* DMA1LIODNR */
>         };
> 
> -/include/ "qoriq-dma-1.dtsi"
> +/include/ "elo3-dma-1.dtsi"
>         dma@101300 {
>                 fsl,iommu-parent = <&pamu0>;
>                 fsl,liodn-reg = <&guts 0x584>; /* DMA2LIODNR */
> diff --git a/arch/powerpc/boot/dts/fsl/elo3-dma-0.dtsi b/arch/powerpc/boot/dts/fsl/elo3-dma-0.dtsi
> new file mode 100644
> index 0000000..69a3277
> --- /dev/null
> +++ b/arch/powerpc/boot/dts/fsl/elo3-dma-0.dtsi
> @@ -0,0 +1,81 @@
> +/*
> + * QorIQ DMA device tree stub [ controller @ offset 0x100000 ]

Copy-pasted?

Presumably should be "Elo3 DMA devicetree stub", or similar?

Similarly for elo3-dma-1.dtsi.

Thanks,
Mark.
