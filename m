Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760282Ab3D3LQx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 07:16:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:19043 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760208Ab3D3LQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 07:16:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,580,1363158000"; 
   d="scan'208";a="326487544"
Date: Tue, 30 Apr 2013 16:13:54 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: Re: [PATCH/RFC 0/4] dmaengine: add DT support for DMA multiplexers
Message-ID: <20130430104354.GF1960@intel.com>
References: <1367305883-2997-1-git-send-email-g.liakhovetski@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367305883-2997-1-git-send-email-g.liakhovetski@gmx.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 30, 2013 at 09:11:19AM +0200, Guennadi Liakhovetski wrote:
> Previously an issue has been discussed, arising on sh-/r-mobile ARM-based 
> systems. There we typically have multiple DMA controller instances with 
> exactly equal or very similar capabilities. Each of them can serve the same 
> slaves, using the same slave identifiers (request line IDs). With the 
> present DMA DT implementation _each_ such DMA slave would have to reference 
> _each_ of those DMA controllers in its DMA bindings, e.g.
But why... if that is the case then we havent define DT-bindings clearly enough

And we havent merged that yet, so why not fix that in first set itself

--
~Vinod
> 
> 	mmc0: mmc@10000000 {
> 		...
> 		dmas = <&dma0 0x10
> 			&dma1 0x10
> 			&dma2 0x10
> 			&dma3 0x10
> 			&dma0 0x11
> 			&dma1 0x11
> 			&dma2 0x11
> 			&dma3 0x11>;
> 		dma-names = "tx", "tx", "tx", "tx",
> 			"rx", "rx", "rx", "rx";
> 	};
> 
> Which certainly isn't pretty. To avoid such redundancy it has been proposed 
> to implement a DMA multiplexer DT node. That way slaves would just 
> reference the multiplexer and one of DMA controller instances in it would 
> be picked up automatically to provide DMA channels to slaves. Patches 1-3 
> in this series propose such an implementation. Patch 4 is just a minor 
> clean up, can be applied independently.
> 
> Cc: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
> 
> Guennadi Liakhovetski (4):
>   OF: add a new phandle parsing function for grouped nodes
>   dmaengine: add support for DMA multiplexer DT nodes
>   ARM: shmobile: move r8a7740 DMA controller DT node under a "dma-mux"
>     node
>   OF: modify function stubs to match proper function declarations.
> 
>  Documentation/devicetree/bindings/dma/dma.txt      |   44 ++++++++++++++++++++
>  .../boot/dts/r8a7740-armadillo800eva-reference.dts |   12 +++---
>  arch/arm/boot/dts/r8a7740.dtsi                     |   43 +++++++++++--------
>  drivers/dma/of-dma.c                               |   39 +++++++++++++----
>  drivers/of/base.c                                  |   28 +++++++++++-
>  include/linux/of.h                                 |   20 ++++++++-
>  6 files changed, 147 insertions(+), 39 deletions(-)
> 
> -- 
> 1.7.2.5
> 
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
