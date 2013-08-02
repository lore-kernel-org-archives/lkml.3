Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088Ab3HBOur (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 10:50:47 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:65453 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab3HBOup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 10:50:45 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-sh@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        Simon Horman <horms@verge.net.au>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: [PATCH v5 0/7] DMA: shdma: switch DT to use OF device ID tables
Date: Fri,  2 Aug 2013 16:50:35 +0200
Message-Id: <1375455042-24093-1-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
X-Provags-ID: V02:K0:/Coe8UiQs2Kz3tGi9G+xLB6TVa5OJe0TXxx41L7k3R7
 fJKlUcwTP24Poy7tMfPWrvIhT5VO6Z1TTLiukjOjkX1AZfjW7W
 0ul6qIfbyBvann/2gsLapx5QSR+cWXLUMKv/5pEATC62dqcwAP
 LrzyKtAzjBNP7MwgjB/Y1o+g3UEK+GWr74dwEtbkGhiZLgf4vr
 N3+WK/mWHyRQNilAvjoiKu1PUfmiq9qQY1KJg2DvQmiDW25Gl2
 xVCkWlN3vA3Ck9iXO5eknNpYdVnYZiDYzmvuwiRUCDu9gYKn9/
 B1Gz/2J5WNpIWvUxD29M+BKZKeHF0B9O6xC3QJY5qyGvA9LRyr
 2nZQRdIyLWIhSpwnFtwzexdkkZZhSjCTy/cx3km4XKg844P3p7
 UcwQxbUdv6Iwg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this version of shdma Device Tree support I preserved the DT 
configuration approach via OF device ID tables from v4, but now it is only 
used for the DT-mode, the C-version is left untouched. In this series I 
only include one platform: r8a73a4-based APE6EVM, if accepted, others can 
be added easily. I also took care not to include mach/*.h headers in 
driver .c files. To illustrate the use of DT DMA support for MMC DMA on 
APE6EVM a patch from a previously separate patch series "DMA for MMCIF and 
SDHI devices in DT mode"
http://thread.gmane.org/gmane.linux.ports.sh.devel/25445
is now also included in this series.

This series should be applied on top of my previous shdma patches 
"DMA: shdma: fix CHCLR register address calculation"
https://lkml.org/lkml/2013/7/2/331
"DMA: shdma: several stylistic improvements and support for new SoCs"
http://thread.gmane.org/gmane.linux.ports.sh.devel/24826
"DMA: shdma: make a pointer const"
http://marc.info/?l=linux-sh&m=137545309332395&w=2

The above dependencies also mean, that the ARM patches shall only be 
applied after the DMA patches are upstream.

Cc: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>

Guennadi Liakhovetski (7):
  DMA: shdma: switch DT mode to use configuration data from a match
    table
  DMA: shdma: remove private and unused defines from a global header
  DMA: shdma: add a header with common for ARM SoCs defines
  DMA: shdma: add r8a73a4 DMAC data to the device ID table
  ARM: shmobile: r8a73a4: add a DMAC platform device and clock for it
  ARM: shmobile: r8a73a4: add a DT node and a clock alias for the DMAC
  ARM: shmobile: ape6evm-reference: enable DMA for the MMC interface

 Documentation/devicetree/bindings/dma/shdma.txt |   61 +++++++++-------
 arch/arm/boot/dts/r8a73a4-ape6evm-reference.dts |    3 +
 arch/arm/boot/dts/r8a73a4.dtsi                  |   43 +++++++++++
 arch/arm/mach-shmobile/clock-r8a73a4.c          |    5 +-
 arch/arm/mach-shmobile/include/mach/r8a73a4.h   |    9 ++
 arch/arm/mach-shmobile/setup-r8a73a4.c          |   91 +++++++++++++++++++++++
 drivers/dma/sh/Kconfig                          |    4 +
 drivers/dma/sh/Makefile                         |    5 +
 drivers/dma/sh/shdma-arm.h                      |   51 +++++++++++++
 drivers/dma/sh/shdma-base.c                     |   15 ++--
 drivers/dma/sh/shdma-of.c                       |    3 -
 drivers/dma/sh/shdma-r8a73a4.c                  |   77 +++++++++++++++++++
 drivers/dma/sh/shdma.h                          |    8 ++
 drivers/dma/sh/{shdma.c => shdmac.c}            |   40 +++++++---
 drivers/dma/sh/sudmac.c                         |    3 +-
 include/linux/sh_dma.h                          |   21 -----
 include/linux/shdma-base.h                      |    2 +-
 17 files changed, 371 insertions(+), 70 deletions(-)
 create mode 100644 drivers/dma/sh/shdma-arm.h
 create mode 100644 drivers/dma/sh/shdma-r8a73a4.c
 rename drivers/dma/sh/{shdma.c => shdmac.c} (97%)

-- 
1.7.2.5

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
