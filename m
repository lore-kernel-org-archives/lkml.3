Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab3IWREo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 13:04:44 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:39294 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041Ab3IWREn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 13:04:43 -0400
Message-ID: <524074A7.7000001@wwwdotorg.org>
Date: Mon, 23 Sep 2013 11:04:39 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: hongbo.zhang@freescale.com
CC: rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        ian.campbell@citrix.com, vinod.koul@intel.com, djbw@fb.com,
        devicetree@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 2/3] DMA: Freescale: Add new 8-channel DMA engine
 device tree nodes
References: <1379499333-4745-1-git-send-email-hongbo.zhang@freescale.com> <1379499333-4745-3-git-send-email-hongbo.zhang@freescale.com>
In-Reply-To: <1379499333-4745-3-git-send-email-hongbo.zhang@freescale.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2013 04:15 AM, hongbo.zhang@freescale.com wrote:
> From: Hongbo Zhang <hongbo.zhang@freescale.com>
> 
> Freescale QorIQ T4 and B4 introduce new 8-channel DMA engines, this patch adds
> the device tree nodes for them.

> diff --git a/Documentation/devicetree/bindings/powerpc/fsl/dma.txt b/Documentation/devicetree/bindings/powerpc/fsl/dma.txt

> +Required properties:
> +
> +- compatible        : must include "fsl,elo3-dma"
> +- reg               : DMA General Status Registers, i.e. DGSR0 which contains
> +                      status for channel 1~4, and DGSR1 for channel 5~8

Is that a single entry, which is large enough to cover both registers,
or a pair of entries, one per register? Reading the text, I might assume
the former, but looking at the examples, it's the latter.

...
 +Example:
> +dma@100300 {
> +	#address-cells = <1>;
> +	#size-cells = <1>;
> +	compatible = "fsl,elo3-dma";
> +	reg = <0x100300 0x4>,
> +	      <0x100600 0x4>;

