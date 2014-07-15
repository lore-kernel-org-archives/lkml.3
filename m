Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758710AbaGOLBK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 07:01:10 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:40704 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758039AbaGOLBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 07:01:08 -0400
From: Zhou Wang <wangzhou.bry@gmail.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Pekon Gupta <pekon@ti.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Alexander Shiyan <shc_work@mail.ru>,
        Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        Joern Engel <joern@logfs.org>, Randy Dunlap <rdunlap@infradead.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: wangzhou1@hisilicon.com, caizhiyong@huawei.com,
        Zhou Wang <wangzhou.bry@gmail.com>
Subject: [PATCH v1 0/3] mtd: hisilicon: add a new driver for NAND controller of hisilicon hip04 Soc
Date: Tue, 15 Jul 2014 18:58:23 +0800
Message-Id: <1405421906-660-1-git-send-email-wangzhou.bry@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series patches add the support for NAND controller of hisilicon
hip04 Soc. These patches are base on branch integration-hilt-working-v3.14 
in linaro landing-team git repository[1].

The NAND controller IP was developed by hisilicon and need a new driver
to support. The driver is usable and I tested it on hisilicon hip04-d01
board.

Changes in v1:
- Remove callback functions out of struct hinfc_host, and call them directly
  in relative functions.
- Change hinfc_read and hinfc_write from macros to inline functions.
- Instead of putting pointers, embed struct nand_chip and struct mtd_info in
  struct hinfc_host directly.
- rewrite some unclear lines in device tree binding document, correct some
  code style error.

[1] ssh://git@git.linaro.org/landing-teams/working/hisilicon/kernel.git


Zhou Wang (3):
  mtd: hisilicon: add device tree node for nand controller
  mtd: hisilicon: add a new nand controller driver for hisilicon hip04 Soc
  mtd: hisilicon: add device tree binding documentation

 .../devicetree/bindings/mtd/hisi-nand.txt          |   40 +
 arch/arm/boot/dts/hip04.dtsi                       |   31 +
 drivers/mtd/nand/Kconfig                           |    5 +
 drivers/mtd/nand/Makefile                          |    1 +
 drivers/mtd/nand/hisi_nand.c                       |  836 ++++++++++++++++++++
 5 files changed, 913 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mtd/hisi-nand.txt
 create mode 100644 drivers/mtd/nand/hisi_nand.c

-- 
1.7.9.5

