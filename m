Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822AbbA0OKV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 09:10:21 -0500
Received: from down.free-electrons.com ([37.187.137.238]:43699 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752056AbbA0OKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 09:10:19 -0500
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com, ezequiel.garcia@free-electrons.com,
        dwmw2@infradead.org, computersforpeace@gmail.com
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/9] ARM: berlin: add nand support
Date: Tue, 27 Jan 2015 15:10:07 +0100
Message-Id: <1422367816-4257-1-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 2.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This series introduces the support for the Marvell Berlin nand
controller. It is based on top of v3.19-rc6 and was tested on the
Marvell Berlin BG2Q DMP board.

The support is added into the existing pxa3xx nand controller. Some
additions were done in order to get this controller working:
- Support for a non mandatory ECC clock has been added.
- The Berlin nand controller needs to poll the status register.
- Sequences of commands are quite different in order to perform read and
  write operations.

Changes were done in order to avoid impacting other controllers using
this driver, but I'd like people actually using the pxa3xx nand driver
to test theses patches to ensure no harm was done. A specific Berlin
nand cmd function has been added to deal with most of the Berlin
specific code.

Because of a bug in the Berlin clock driver, this series requires the
fix provided by Jisheng Zhang, which is already in v3.19-rc6
(b71e8ecd57c8aae5b1815782c47b74ffe3efc09a).

Thanks!

Antoine


Antoine Tenart (9):
  mtd: pxa3xx_nand: initialiaze pxa3xx_flash_ids to 0
  mtd: pxa3xx_nand: add a non mandatory ECC clock
  mtd: pxa3xx_nand: set NDCR_PG_PER_BLK if page per block is 128
  mtd: pxa3xx_nand: add a default chunk size
  mtd: pxa3xx_nand: add support for the Marvell Berlin nand controller
  Documentation: bindings: add the Berlin nand controller compatible
  mtd: nand: let Marvell Berlin SoCs select the pxa3xx driver
  ARM: berlin: add BG2Q node for the nand
  ARM: berlin: enable flash on the BG2Q DMP

 .../devicetree/bindings/mtd/pxa3xx-nand.txt        |   1 +
 arch/arm/boot/dts/berlin2q-marvell-dmp.dts         |  10 +
 arch/arm/boot/dts/berlin2q.dtsi                    |  21 ++
 drivers/mtd/nand/Kconfig                           |   2 +-
 drivers/mtd/nand/pxa3xx_nand.c                     | 321 ++++++++++++++++++---
 5 files changed, 320 insertions(+), 35 deletions(-)

-- 
2.2.2

