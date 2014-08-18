Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828AbaHRR0f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 13:26:35 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54355 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751563AbaHRR0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 13:26:32 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-sunxi@googlegroups.com, "Dmitriy B." <rzk333@gmail.com>,
        Yassin Jaffer <yassinjaffer@gmail.com>, Jonas Meyer <quitte@gmail.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v4 0/2] mtd: nand: add sunxi NAND flash controller support
Date: Mon, 18 Aug 2014 19:26:26 +0200
Message-Id: <1408382788-32153-1-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch series adds support for the sunxi NAND Flash Controller (NFC)
block.

These two patches only add support for the basic NAND stuff:
 - NAND controller operations
 - SW and HW ECC handling (with both syndrome and normal ECC scheme)

If you want support for advanced features you can find it on my github
repo [1]:
 - HW randomization support
 - per partition ECC/Randomizer to handle bootloader partitions

DMA transfers are not supported yet, but I have reworked the OOB layout
when using the HW ECC scheme to match the one used when accessing the NAND
with DMA transfers (the available OOB bytes are placed at the end of the
OOB area).

This patch series depends on this other one [2] which adds support for ONFI
timing mode retrieval on non-ONFI NANDs.

Best Regards,

Boris

[1]https://github.com/bbrezillon/linux-sunxi/tree/sunxi-nand-v4
[2]https://lkml.org/lkml/2014/7/28/156

Changes since v3:
 - removed nand core code modifications from the patch series (submitted
   separately)
 - added documentation to the code
 - forced timeout (a default timeout is used when none is provided by the
   caller) on controller operations
 - fixed coding style issues
 - removed unneeded irq field from the sunxi_nfc struct
 - fixed several memory leaks
 - reworked the NFC reset code (to avoid potential garbage config from the
   bootloader)
 - made use of ECC_EXCEPTION flag to prevent erased page from generating
   ECC errors
 - changed the OOB layout for HW ECC scheme

Changes since v2:
 - merge HW ECC implementation in base implementation patch
 - fix timing config when interfacing with an ONFI compatible chip

Changes since v1:
 - add HW ECC support
 - rework NAND timings retrieval (use ONFI timing mode instead of raw timings)
 - add nand-ecc-level property to specify NAND ECC requirements from DT

Boris BREZILLON (2):
  mtd: nand: add sunxi NAND flash controller support
  mtd: nand: add sunxi NFC dt bindings doc

 .../devicetree/bindings/mtd/sunxi-nand.txt         |   45 +
 drivers/mtd/nand/Kconfig                           |    6 +
 drivers/mtd/nand/Makefile                          |    1 +
 drivers/mtd/nand/sunxi_nand.c                      | 1362 ++++++++++++++++++++
 4 files changed, 1414 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mtd/sunxi-nand.txt
 create mode 100644 drivers/mtd/nand/sunxi_nand.c

-- 
1.9.1

