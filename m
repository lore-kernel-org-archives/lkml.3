Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759096Ab3D3HLc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 03:11:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:54630 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758599Ab3D3HL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 03:11:27 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-sh@vger.kernel.org
Cc: Magnus Damm <magnus.damm@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Vinod Koul <vinod.koul@intel.com>, Tony Lindgren <tony@atomide.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: [PATCH/RFC 0/4] dmaengine: add DT support for DMA multiplexers
Date: Tue, 30 Apr 2013 09:11:19 +0200
Message-Id: <1367305883-2997-1-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
X-Provags-ID: V02:K0:muUWkjFuQxiWSVp0aOpKGN3xz6xeCrZJxaUPh/dQw6Y
 1cDYMrs+QQM/SkmeghDrk94JGp+RIEZUWuVYd3lC0ccj7k3I0H
 Wqv3InFNN9w2lF+29ADZ2Gcy0TIn6yHb6GVwnLzcz6089NW1ru
 fFoAQgZZWBT4A89XisDKvicJyjw7qiISx0iFRkDGAryv9WcQ51
 +hrwWFcKph62zg/Le6mOIVLVbl0UG7zTtoJoQxPp6D4C4Uf6SE
 A3F8JYNqgFNxoJHMPwrZoGAu+G4vo9y5WC9RzPbhYaQfGWxJ5e
 YXsoH82yBMKw7a41RAR0DoTYwdgXNp6eRPdTT/BW2tBJRhFohA
 re3r9pkBELCxfW1JJmD+M38kR8lftRf/E/KajtGvUXu444b+JJ
 ccc4+brRWQA3w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously an issue has been discussed, arising on sh-/r-mobile ARM-based 
systems. There we typically have multiple DMA controller instances with 
exactly equal or very similar capabilities. Each of them can serve the same 
slaves, using the same slave identifiers (request line IDs). With the 
present DMA DT implementation _each_ such DMA slave would have to reference 
_each_ of those DMA controllers in its DMA bindings, e.g.

	mmc0: mmc@10000000 {
		...
		dmas = <&dma0 0x10
			&dma1 0x10
			&dma2 0x10
			&dma3 0x10
			&dma0 0x11
			&dma1 0x11
			&dma2 0x11
			&dma3 0x11>;
		dma-names = "tx", "tx", "tx", "tx",
			"rx", "rx", "rx", "rx";
	};

Which certainly isn't pretty. To avoid such redundancy it has been proposed 
to implement a DMA multiplexer DT node. That way slaves would just 
reference the multiplexer and one of DMA controller instances in it would 
be picked up automatically to provide DMA channels to slaves. Patches 1-3 
in this series propose such an implementation. Patch 4 is just a minor 
clean up, can be applied independently.

Cc: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>

Guennadi Liakhovetski (4):
  OF: add a new phandle parsing function for grouped nodes
  dmaengine: add support for DMA multiplexer DT nodes
  ARM: shmobile: move r8a7740 DMA controller DT node under a "dma-mux"
    node
  OF: modify function stubs to match proper function declarations.

 Documentation/devicetree/bindings/dma/dma.txt      |   44 ++++++++++++++++++++
 .../boot/dts/r8a7740-armadillo800eva-reference.dts |   12 +++---
 arch/arm/boot/dts/r8a7740.dtsi                     |   43 +++++++++++--------
 drivers/dma/of-dma.c                               |   39 +++++++++++++----
 drivers/of/base.c                                  |   28 +++++++++++-
 include/linux/of.h                                 |   20 ++++++++-
 6 files changed, 147 insertions(+), 39 deletions(-)

-- 
1.7.2.5

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
