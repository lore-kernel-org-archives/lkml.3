Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757216Ab3GWKvE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 06:51:04 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:53450 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756665Ab3GWKuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 06:50:22 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: Magnus Damm <magnus.damm@gmail.com>, Simon Horman <horms@verge.net.au>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-sh@vger.kernel.org,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: [PATCH v4 00/15] ARM: shmobile: move DMAC configuration data in the driver
Date: Tue, 23 Jul 2013 12:49:54 +0200
Message-Id: <1374576609-27748-1-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
X-Provags-ID: V02:K0:C5q7045Db8tA3Vk4wGJNP1fCY2oNgiV5FzWLYPtnM6d
 rvsZUe7WNTMrBAJ5sqw2Ca4vfumk6TBNv8GK+9qtkJXSG9IFSb
 J8gUWfe/26ydVCbszZKPUTz1+xffcM6Bp15lRidj147Mvyj8a5
 9gvOj7oqqdSACQTbrA4OzmdbNZCSBBDZDwgb2NP7M9pli3D/cC
 yWPsEEPyWRNC8zs8wLcsz4GFHviX4a3iSdFf2NyUfJh5/yCXlQ
 0TuFvKI/F0Lgai2PvtGTRcEu69IuqdqnFFXdm0MheHYy1N6gMy
 CeiG0CSupPTMS41kKS+gx0fLx6CBUU4yK9SekX1+7kDHdZwuAO
 FXUZaoQZT7hDCJ3RcChmEDncAoHbUvRVqI5tJcqSdW+eUW7lsD
 yBF2thwD5WpcA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An updated version of an shdma driver platform driver conversion and Device
Tree support. No functional changes since v2/v3, just made some structs
const, updated documentation, removed an unused generic DT match entry,
adjusted file order in the Makefile.

Patch 9 "DMA: shdma: support referencing specific DMACs within a
multiplexer in DT" is actually an RFC. It proposes a method to support
referencing a specific DMAC ninstance within a multiplexer DT node from
slave DT nodes. As described in the documentation, the idea is to add a
"#dma-cells" property to DMAC instances, that has to be made available
for such targeted channel allocation. AFAICS, this is the only way to
support both muxed and targeted referencing without core code
modifications.

Cc: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>

Guennadi Liakhovetski (15):
  DMA: shdma: add support for DMAC configuration data, supplied via
    device ID
  DMA: shdma: add r8a7740 DMAC data to the device ID table
  DMA: shdma: add r8a73a4 DMAC data to the device ID table
  DMA: shdma: make a pointer const
  DMA: shdma: pass SoC-specific configuration to the driver via OF
    matching
  DMA: shdma: make multiplexer platform data optional
  DMA: shdma: add sh73a0 DMAC data to the device ID table
  DMA: shdma: move two macros to a header
  DMA: shdma: support referencing specific DMACs within a multiplexer
    in DT
  ARM: shmobile: r8a73a4: add a DMAC platform device and clock for it
  ARM: shmobile: r8a7740: switch DMAC controllers to using device ID
    data
  ARM: shmobile: r8a7740: add DT nodes and clock aliases for three DMAC
    instances
  ARM: shmobile: r8a73a4: add a DT node and a clock alias for the DMAC
  ARM: shmobile: sh73a0: switch DMAC controllers to using device ID
    data
  ARM: shmobile: r8a7740: add support for 2 RTDMACs

 Documentation/devicetree/bindings/dma/shdma.txt |   23 +++-
 arch/arm/boot/dts/r8a73a4.dtsi                  |   43 ++++++
 arch/arm/boot/dts/r8a7740.dtsi                  |   95 ++++++++++++
 arch/arm/mach-shmobile/clock-r8a73a4.c          |    5 +-
 arch/arm/mach-shmobile/clock-r8a7740.c          |   17 ++-
 arch/arm/mach-shmobile/clock-sh73a0.c           |    2 +-
 arch/arm/mach-shmobile/include/mach/r8a73a4.h   |    9 +
 arch/arm/mach-shmobile/setup-r8a73a4.c          |   17 ++
 arch/arm/mach-shmobile/setup-r8a7740.c          |  178 +++++++++-------------
 arch/arm/mach-shmobile/setup-sh73a0.c           |  182 +----------------------
 drivers/dma/sh/Kconfig                          |   12 ++
 drivers/dma/sh/Makefile                         |    5 +
 drivers/dma/sh/shdma-base.c                     |    3 -
 drivers/dma/sh/shdma-of.c                       |    5 -
 drivers/dma/sh/shdma-r8a73a4.c                  |   75 +++++++++
 drivers/dma/sh/shdma-r8a7740.c                  |   95 ++++++++++++
 drivers/dma/sh/shdma-sh73a0.c                   |  181 ++++++++++++++++++++++
 drivers/dma/sh/shdma.h                          |   30 ++++-
 drivers/dma/sh/{shdma.c => shdmac.c}            |  104 ++++++++++++-
 include/linux/shdma-base.h                      |    3 +
 20 files changed, 775 insertions(+), 309 deletions(-)
 create mode 100644 drivers/dma/sh/shdma-r8a73a4.c
 create mode 100644 drivers/dma/sh/shdma-r8a7740.c
 create mode 100644 drivers/dma/sh/shdma-sh73a0.c
 rename drivers/dma/sh/{shdma.c => shdmac.c} (89%)

-- 
1.7.2.5

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
