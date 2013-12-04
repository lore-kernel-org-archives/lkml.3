Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703Ab3LDMRs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 07:17:48 -0500
Received: from 7of9.schinagl.nl ([88.159.158.68]:60941 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754765Ab3LDMRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 07:17:44 -0500
From: oliver@schinagl.nl
To: tj@kernel.org, grant.likely@linaro.org, ob.herring@calxeda.com,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, dev@linux-sunxi.org
Cc: maxime.ripard@free-electrons.com, ijc@hellion.org.uk, hdegoede@redhat.com,
        oliver+list@schinagl.nl, Olliver Schinagl <oliver@schinagl.nl>
Subject: [PATCH 0/3] AHCI: sunxi: Add sunxi AHCI driver
Date: Wed,  4 Dec 2013 13:10:52 +0100
Message-Id: <1386159055-10264-1-git-send-email-oliver@schinagl.nl>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Olliver Schinagl <oliver@schinagl.nl>

This patch series adds Allwinner sunxi support to platform_ahci.
There are a few quirks here however that will need discussing.

Allwinner added something to setup the DMA engine prior to enabling DMA in
libahci.c. I'm not familiar at all with the AHCI spec and not sure what
the proper way to implement this would have been. Don't other platforms
optionally require the same thing?

Also the way ahci_platform works seems a little hack-ish, it seems like
something along the lines of ahci_platform_register(ahci-data) would be more
appropriate, but not sure yet on those details (I am just a beginner).

Furthermore this driver should, in theory, work on the A10 but on my
cubieboard 1 it does not work yet (just hangs somewhere in libahci or after,
but not the DMA call that was altered). I've also tested it the cubietruck,
cubieboard 2 and olinuxino and it worked fine there.

Thanks,

Oliver

Oliver Schinagl (3):
  RFC: AHCI: libahci is missing DMA
  ARM: sunxi: Add an ahci-platform compatible AHCI driver for the    
    Allwinner SUNXi series of SoCs
  ARM: sunxi: dts: Add ahci support to a few A10 and A20 boards

 .../devicetree/bindings/ata/ahci-sunxi.txt         |  24 ++
 arch/arm/boot/dts/sun4i-a10-cubieboard.dts         |  26 ++
 arch/arm/boot/dts/sun4i-a10.dtsi                   |   9 +
 arch/arm/boot/dts/sun7i-a20-cubieboard2.dts        |  26 ++
 arch/arm/boot/dts/sun7i-a20-cubietruck.dts         |  26 ++
 arch/arm/boot/dts/sun7i-a20-olinuxino-micro.dts    |  26 ++
 arch/arm/boot/dts/sun7i-a20.dtsi                   |   9 +
 drivers/ata/Kconfig                                |   9 +
 drivers/ata/Makefile                               |   1 +
 drivers/ata/ahci.h                                 |   6 +
 drivers/ata/ahci_platform.c                        |  12 +
 drivers/ata/ahci_sunxi.c                           | 305 +++++++++++++++++++++
 drivers/ata/libahci.c                              |   8 +
 13 files changed, 487 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/ata/ahci-sunxi.txt
 create mode 100644 drivers/ata/ahci_sunxi.c

-- 
1.8.3.2

