Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629AbaBKVrH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 16:47:07 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:63682 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbaBKVrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 16:47:04 -0500
From: Boris BREZILLON <b.brezillon.dev@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Gupta Pekon <pekon@ti.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Boris BREZILLON <b.brezillon.dev@gmail.com>
Subject: [RFC PATCH v2 0/4] mtd: nand: add per partition ECC config
Date: Tue, 11 Feb 2014 22:46:45 +0100
Message-Id: <1392155209-14495-1-git-send-email-b.brezillon.dev@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch series is a proposal to add per partition ECC config.

It defines a new partition type called nand_part which stores a pointer to
a nand_ecc_ctrl struct.
This specific nand_ecc_ctrl struct is used in place of the base NAND chip
nand_ecc_ctrl struct when accessing NAND chip from nand_part MTD device.

If the partition does not define any ECC config, the NAND chip ECC config
is used instead.

This patch series also provides an helper function to parse DT defined NAND
partitions (ofnandpart_parse).

If you want to test it you'll have to replace calls to
mtd_device_parse_register with ofnandpart_parse within your NAND controller
driver and implement a driver specific parser function that will provide
the ECC config (see ofnandpart_data struct).

The 4th patch of this series is here as an example on how to move from MTD
partitions to NAND partitions.

Best Regards,

Boris

Changes since v1:
- almost everything :-)

Boris BREZILLON (4):
  mtd: nand: take nand_ecc_ctrl initialization out of nand_scan_tail
  mtd: nand: add support for NAND partitions
  mtd: nand: add DT NAND partition parser
  mtd: nand: add NAND partition support to the sunxi driver

 drivers/mtd/nand/Kconfig      |    4 +
 drivers/mtd/nand/Makefile     |    2 +
 drivers/mtd/nand/nand_base.c  |  763 ++++++++++++++++++++++++++++++++---------
 drivers/mtd/nand/ofnandpart.c |  104 ++++++
 drivers/mtd/nand/sunxi_nand.c |   69 +++-
 include/linux/mtd/nand.h      |   54 +++
 6 files changed, 835 insertions(+), 161 deletions(-)
 create mode 100644 drivers/mtd/nand/ofnandpart.c

-- 
1.7.9.5

