Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121Ab3HUWkv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 18:40:51 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:58095 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab3HUWku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 18:40:50 -0400
Message-ID: <521541EE.4010303@wwwdotorg.org>
Date: Wed, 21 Aug 2013 16:40:46 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: hongbo.zhang@freescale.com
CC: vinod.koul@intel.com, djbw@fb.com, leoli@freescale.com,
        scottwood@freescale.com, linuxppc-dev@lists.ozlabs.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 2/3] DMA: Freescale: Add new 8-channel DMA engine device
 tree nodes
References: <1375094944-3343-1-git-send-email-hongbo.zhang@freescale.com> <1375094944-3343-3-git-send-email-hongbo.zhang@freescale.com>
In-Reply-To: <1375094944-3343-3-git-send-email-hongbo.zhang@freescale.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2013 04:49 AM, hongbo.zhang@freescale.com wrote:
> Freescale QorIQ T4 and B4 introduce new 8-channel DMA engines, this patch adds
> the device tree nodes for them.

> diff --git a/Documentation/devicetree/bindings/powerpc/fsl/dma.txt b/Documentation/devicetree/bindings/powerpc/fsl/dma.txt

> +** Freescale Elo3 DMA Controller
> +   This is EloPlus controller with 8 channels, used in Freescale Txxx and Bxxx
> +   series chips, such as t1040, t4240, b4860.
> +
> +Required properties:
> +
> +- compatible        : must include "fsl,elo3-dma"

This should probably list all the SoC-specific compatible values too.

> +- ranges            : describes the mapping between the address space of the
> +                      DMA channels and the address space of the DMA controller

Oh, so looking at the example, this is simply about being able to write
the reg value in the child nodes more easily without having to write out
the full based address of the controller in each child node.

I don't think the binding document should require this; all the binding
document should care about is that the child nodes have a valid reg
value. Whether that reg value is <0x100100 0x80> without a ranges in the
top-level DMA nor or whether that reg value is <0x0 0x80> with a ranges
value in the top-level DMA node isn't something that the binding should
specify. Either way will work equally without affecting a driver for the
DMA controller; the parsing of reg with/without a ranges property is
more of a core part of DT than anything to do with this binding.

> +- DMA channel nodes:
> +        - compatible        : must include "fsl,eloplus-dma-channel"

Why do the channel nodes even need a compatible value? Presumably the
driver for the top-level DMA node will scan these dma-channel nodes to
extract the information it needs and will simply assume that all these
nodes are DMA channel nodes rather than something else? I suppose this
doesn't hurt, it just seems unnecessary unless you foresee other child
nodes types existing in the future and hence a need to differentiate
different types of nodes.

> +        - reg               : <registers mapping for channel>
> +        - interrupts        : <interrupt mapping for DMA channel IRQ>

s/interrupts/specifier/

> +Example:
> +dma@100300 {
> +	#address-cells = <1>;
> +	#size-cells = <1>;

Those weren't mentioned in the required properties list above. Perhaps
they're considered such a core part of DT functionality that it's not
necessary, yet some other binding documents do include these properties
in the list of required properties.
