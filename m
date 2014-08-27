Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933625AbaH0Mmi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 08:42:38 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:34010 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933257AbaH0Mmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 08:42:37 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, computersforpeace@gmail.com,
        pekon@pek-sem.com, linux-mtd@lists.infradead.org
Subject: [PATCH v3 0/9] mtd: nand: Support for new DT NAND driver
Date: Wed, 27 Aug 2014 13:42:15 +0100
Message-Id: <1409143344-22458-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Brian,
 
I believe all of your queries have either been answered or addressed
and I am hoping this will be the last submission. :)
 
This is v3 of the squashed submission.  v1 had a small typo which
prevented the BBT code from being truly configurable and v2 had some
build issues due to a silly 'post testing' fixup mistake.  This has now
been rectified.

Also:

  Builds	Pass
  Smatch	Pass
  Sparse	Pass
  Bisectability	Pass
  NAND Test	Pass
  MTD Tests	Pass (accept OOB test which is not applicable with
      		      this controller.  I will rectify this in the
		      near future though, as it _can be_ useful for
		      debugging/testing.)

Kind regards,
Lee

Lee Jones (9):
  ARM: multi-v7: Enable ST BCH NAND
  ARM: sti: Add two new clock definitions for use with ST's NAND
    controllers
  ARM: sti: Add BCH (NAND Flash) Controller support for STiH41x (Orly)
    SoCs
  ARM: sti: Enable BCH NAND for STiH416 B2020-RevE
  mtd: nand: stm_nand_bch: provide Device Tree documentation
  mtd: nand: stm_nand_bch: add shared register defines for ST's NAND
    Controller drivers
  mtd: nand: stm_nand_bch: adding BBT header
  mtd: nand: stm_nand_bch: add support for ST's BCH NAND controller
  mtd: nand: stm_nand_bch: provide ST's implementation of Back Block
    Table

 Documentation/devicetree/bindings/mtd/stm-nand.txt |   74 +
 arch/arm/boot/dts/stih416-b2020e.dts               |    8 +
 arch/arm/boot/dts/stih41x-b2020.dtsi               |   38 +
 arch/arm/configs/multi_v7_defconfig                |    2 +
 drivers/mtd/nand/Kconfig                           |   15 +
 drivers/mtd/nand/Makefile                          |    2 +
 drivers/mtd/nand/stm_nand_bbt.c                    |  601 ++++++++
 drivers/mtd/nand/stm_nand_bch.c                    | 1616 ++++++++++++++++++++
 drivers/mtd/nand/stm_nand_dt.c                     |  110 ++
 drivers/mtd/nand/stm_nand_dt.h                     |   24 +
 drivers/mtd/nand/stm_nand_regs.h                   |  304 ++++
 include/dt-bindings/clock/stih416-clks.h           |    2 +
 include/linux/mtd/stm_nand.h                       |  147 ++
 include/linux/mtd/stm_nand_bbt.h                   |   17 +
 14 files changed, 2960 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mtd/stm-nand.txt
 create mode 100644 drivers/mtd/nand/stm_nand_bbt.c
 create mode 100644 drivers/mtd/nand/stm_nand_bch.c
 create mode 100644 drivers/mtd/nand/stm_nand_dt.c
 create mode 100644 drivers/mtd/nand/stm_nand_dt.h
 create mode 100644 drivers/mtd/nand/stm_nand_regs.h
 create mode 100644 include/linux/mtd/stm_nand.h
 create mode 100644 include/linux/mtd/stm_nand_bbt.h

-- 
1.9.1

