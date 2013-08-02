Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758551Ab3HBJge (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 05:36:34 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:61236 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758261Ab3HBJgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 05:36:32 -0400
Date: Fri, 2 Aug 2013 10:35:59 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Jonas Jensen <jonas.jensen@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "arm@kernel.org" <arm@kernel.org>
Subject: Re: [PATCH] Documentation: Add device tree binding file for MOXA
 ART SoCs interrupt controller
Message-ID: <20130802093559.GB2884@e106331-lin.cambridge.arm.com>
References: <1374137426-6763-1-git-send-email-jonas.jensen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374137426-6763-1-git-send-email-jonas.jensen@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 09:50:26AM +0100, Jonas Jensen wrote:
> Add binding document for MOXA ART SoCs interrupt controller.
> 
> Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
> ---
> 
> Notes:
>     The MOXA ART irqchip driver was added without accompanying devicetree document.
>     ( in next-20130716   drivers/irqchip/irq-moxart.c )

Aaargh. That should not have happened >:(

>     
>     Applies to next-20130716
> 
>  .../interrupt-controller/moxa,moxart-ic.txt        | 28 ++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/interrupt-controller/moxa,moxart-ic.txt
> 
> diff --git a/Documentation/devicetree/bindings/interrupt-controller/moxa,moxart-ic.txt b/Documentation/devicetree/bindings/interrupt-controller/moxa,moxart-ic.txt
> new file mode 100644
> index 0000000..58f1fe1
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/interrupt-controller/moxa,moxart-ic.txt
> @@ -0,0 +1,28 @@
> +* MOXA ART Interrupt Controller
> +
> +MOXA ART Interrupt Controller (moxart-ic) is used on MOXA ART SoCs
> +and supports 32 non-configurable number of interrupts
> +
> +Main node required properties:
> +
> +- compatible : "moxa,moxart-ic"
> +- interrupt-controller : Identifies the node as an interrupt controller
> +- #interrupt-cells : Specifies the number of cells needed to encode an
> +  interrupt source. The type shall be a <u32> and the value shall be 2.
> +
> +  The first cell contains the interrupt number in the range [0-31].
> +  The second cell contains the interrupt type
> +
> +- reg: physical base address and size of the intc registers map.
> +- interrupt-mask: Specifies if the interrupt is edge or level-triggered
> +  each bit represent an interrupt 0-31 where 1 signify edge

For the GIC, this gets descrbied in the interrupt sepcifier rather than
on the interrupt controller's root node. Is there a reason to do this
differently here?

Thanks,
Mark.

> +
> +Example:
> +
> +	intc: interrupt-controller@98800000 {
> +		compatible = "moxa,moxart-ic";
> +		reg = <0x98800000 0x38>;
> +		interrupt-controller;
> +		#interrupt-cells = <2>;
> +		interrupt-mask = <0x00080000>;
> +	};
> -- 
> 1.8.2.1
> 
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss
> 
