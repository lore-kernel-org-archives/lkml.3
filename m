Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751368AbaJTLp2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 07:45:28 -0400
Received: from down.free-electrons.com ([37.187.137.238]:48903 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750978AbaJTLp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 07:45:26 -0400
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-sunxi@googlegroups.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Yassin Jaffer <yassinjaffer@gmail.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v6 0/2] mtd: nand: add sunxi NAND flash controller support
Date: Mon, 20 Oct 2014 13:45:18 +0200
Message-Id: <1413805520-14947-1-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Brian,

The sunxi NAND controller driver is being submitted for almost 9 month now
and I've only had one review (from Ezequiel) during this period.

I'd really like to get this first implementation mainlined, so that I can
follow up with other MLC specific stuff (like randomizer/scrambler support)
which are required on most HW designs embedding an Allwinner SoC.

I'm aware that you have a lot of things to review, and that you do most of
it (if not all of it) on your spare time, so let know if I can help you in
any way (by reviewing other submissions for example).
Hopefully this will speed up the review of my driver :-).

This being said, here comes the usal cover letter:

This series adds support for the sunxi NAND Flash Controller (NFC)
block.

These two patches only add support for the basic NAND stuff:
 - NAND controller operations
 - SW and HW ECC handling (with both syndrome and normal ECC scheme)

If you want support for advanced features you can find it on my github
repo [1]:
 - HW randomization support
 - per partition ECC/Randomizer to handle bootloader partitions

DMA transfers are not supported yet, but I reworked the OOB layout
when using the HW ECC scheme to match the one used when accessing the NAND
through DMA (the available OOB bytes are placed at the end of the OOB area).

Best Regards,

Boris

[1]https://github.com/bbrezillon/linux-sunxi/tree/sunxi-nand-v6

Changes since v5:
 - make use of of_get_nand_ecc_step_size and of_get_nand_ecc_strength
 - add error messages

Changes since v4:
 - adapt to v2 of "mtd: nand: support ONFI timing mode retrieval for non-ONFI
   NANDs" series

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


Boris Brezillon (2):
  mtd: nand: add sunxi NAND flash controller support
  mtd: nand: add sunxi NFC dt bindings doc

 .../devicetree/bindings/mtd/sunxi-nand.txt         |   45 +
 drivers/mtd/nand/Kconfig                           |    6 +
 drivers/mtd/nand/Makefile                          |    1 +
 drivers/mtd/nand/sunxi_nand.c                      | 1400 ++++++++++++++++++++
 4 files changed, 1452 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mtd/sunxi-nand.txt
 create mode 100644 drivers/mtd/nand/sunxi_nand.c

-- 
1.9.1

