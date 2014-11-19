Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385AbaKSSHq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 13:07:46 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:59997 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755911AbaKSSHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 13:07:43 -0500
Date: Wed, 19 Nov 2014 18:07:25 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Yingjoe Chen <yingjoe.chen@mediatek.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Pawel Moll <Pawel.Moll@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "hc.yen@mediatek.com" <hc.yen@mediatek.com>,
        "srv_heupstream@mediatek.com" <srv_heupstream@mediatek.com>,
        "yh.chen@mediatek.com" <yh.chen@mediatek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Yijing Wang <wangyijing@huawei.com>, Rob Herring <robh+dt@kernel.org>,
        "nathan.chung@mediatek.com" <nathan.chung@mediatek.com>,
        "yingjoe.chen@gmail.com" <yingjoe.chen@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "eddie.huang@mediatek.com" <eddie.huang@mediatek.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v7 4/4] dt-bindings: add bindings for mediatek sysirq
Message-ID: <20141119180724.GE12851@leverpostej>
References: <1416406451-4578-1-git-send-email-yingjoe.chen@mediatek.com>
 <1416406451-4578-5-git-send-email-yingjoe.chen@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416406451-4578-5-git-send-email-yingjoe.chen@mediatek.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 02:14:11PM +0000, Yingjoe Chen wrote:
> Add binding documentation for Mediatek SoC SYSIRQ.
> 
> Signed-off-by: Yingjoe Chen <yingjoe.chen@mediatek.com>
> ---
>  .../bindings/arm/mediatek/mediatek,sysirq.txt      | 26 ++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,sysirq.txt
> 
> diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,sysirq.txt b/Documentation/devicetree/bindings/arm/mediatek/mediatek,sysirq.txt
> new file mode 100644
> index 0000000..8669536
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,sysirq.txt
> @@ -0,0 +1,26 @@
> +Mediatek 65xx/81xx sysirq
> +
> +Mediatek SOCs sysirq support controllable irq inverter for each GIC SPI
> +interrupt.
> +
> +Required properties:
> +- compatible: should be one of:
> +	"mediatek,mt8135-sysirq"
> +	"mediatek,mt8127-sysirq"
> +	"mediatek,mt6589-sysirq"
> +	"mediatek,mt6582-sysirq"
> +	"mediatek,mt6577-sysirq"
> +- interrupt-controller : Identifies the node as an interrupt controller
> +- #interrupt-cells : Must use the same cells/format as parent controller.
> +- interrupt-parent: phandle of irq domain parent for sysirq.

I'm concerned that this sounds very general while the binding assumes
the GICv2 interrupt-specifier format. Either the driver needs to become
more general, or this needs to be tightened up.

It's also odd to say "irq domain parent", as that's purely a Linux
construct and has nothing to do with the HW.

Thanks,
Mark.

> +- reg: Physical base address of the intpol registers and length of memory
> +  mapped region.
> +
> +Example:
> +	sysirq: interrupt-controller@10200100 {
> +		compatible = "mediatek,mt6589-sysirq", "mediatek,mt6577-sysirq";
> +		interrupt-controller;
> +		#interrupt-cells = <3>;
> +		interrupt-parent = <&gic>;
> +		reg = <0 0x10200100 0 0x1c>;
> +	};
> -- 
> 1.8.1.1.dirty
> 
> 
