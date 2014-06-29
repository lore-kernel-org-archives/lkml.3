Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387AbaF2Q5k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 12:57:40 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:35296 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbaF2Q5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 12:57:39 -0400
From: Manuel Lauss <manuel.lauss@gmail.com>
To: Linux-MIPS <linux-mips@linux-mips.org>
Cc: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        Manuel Lauss <manuel.lauss@gmail.com>
Subject: [RFC PATCH 0/2] MIPS: Alchemy: common clk framework integration
Date: Sun, 29 Jun 2014 18:57:33 +0200
Message-Id: <1404061055-89797-1-git-send-email-manuel.lauss@gmail.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a request for comments for the below patches.

Patch 1 is a cleanup I came up with while writing patch 2.  I'm sending
        it along because the other one depends on some things introduced
        in it to compile cleanly.

Patch 2 adds COMMON_CLK support for all configurable internal
        clock sources on alchemy socs.

Please have a look!

Thanks a lot,
        Manuel Lauss

Manuel Lauss (2):
  MIPS: Alchemy: au1000 header file cleanup
  MIPS: Alchemy: common clock framework integration

 arch/mips/Kconfig                               |    1 +
 arch/mips/alchemy/board-mtx1.c                  |    4 +-
 arch/mips/alchemy/board-xxs1500.c               |    4 +-
 arch/mips/alchemy/common/Makefile               |    2 +-
 arch/mips/alchemy/common/clock.c                | 1113 ++++++++++
 arch/mips/alchemy/common/clocks.c               |  105 -
 arch/mips/alchemy/common/dbdma.c                |   22 +-
 arch/mips/alchemy/common/dma.c                  |   15 +-
 arch/mips/alchemy/common/irq.c                  |    4 +-
 arch/mips/alchemy/common/platform.c             |   12 +-
 arch/mips/alchemy/common/power.c                |   88 +-
 arch/mips/alchemy/common/setup.c                |   21 +-
 arch/mips/alchemy/common/time.c                 |   25 +-
 arch/mips/alchemy/common/usb.c                  |   10 +
 arch/mips/alchemy/devboards/db1000.c            |   19 +-
 arch/mips/alchemy/devboards/db1200.c            |   73 +-
 arch/mips/alchemy/devboards/db1300.c            |   10 +-
 arch/mips/alchemy/devboards/db1550.c            |   25 +-
 arch/mips/alchemy/devboards/pm.c                |   39 +-
 arch/mips/include/asm/mach-au1x00/au1000.h      | 2514 ++++++++++-------------
 arch/mips/include/asm/mach-au1x00/au1000_dma.h  |   51 +-
 arch/mips/include/asm/mach-au1x00/gpio-au1000.h |   66 +-
 arch/mips/pci/pci-alchemy.c                     |   85 +-
 drivers/mmc/host/au1xmmc.c                      |  194 +-
 drivers/mtd/nand/au1550nd.c                     |   52 +-
 drivers/net/ethernet/amd/au1000_eth.c           |  155 +-
 drivers/net/irda/au1k_ir.c                      |   48 +-
 drivers/rtc/rtc-au1xxx.c                        |   18 +-
 drivers/spi/spi-au1550.c                        |   66 +-
 drivers/video/fbdev/au1100fb.c                  |   19 +-
 drivers/video/fbdev/au1200fb.c                  |   34 +-
 sound/soc/au1x/psc-ac97.c                       |  140 +-
 sound/soc/au1x/psc-i2s.c                        |  100 +-
 sound/soc/au1x/psc.h                            |   22 +-
 34 files changed, 3017 insertions(+), 2139 deletions(-)
 create mode 100644 arch/mips/alchemy/common/clock.c
 delete mode 100644 arch/mips/alchemy/common/clocks.c

-- 
2.0.0

