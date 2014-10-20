Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172AbaJTIzV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 04:55:21 -0400
Received: from down.free-electrons.com ([37.187.137.238]:47859 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753001AbaJTIzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 04:55:14 -0400
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org, Huang Shijie <shijie8@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mike Voytovich <mvoytovich@paypal.com>, Roy Lee <roylee@paypal.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v4 0/4] mtd: nand: gpmi: add proper raw access support
Date: Mon, 20 Oct 2014 10:46:13 +0200
Message-Id: <1413794777-32220-1-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This series provides an implementation for raw accesses taking care of
hidding the specific layout used by the GPMI controller.

I also updated the nand_ecc_ctrl struct documentation to clearly state that
specific layouts should be hidden when accessing the NAND chip in raw mode.

Best Regards,

Boris

Changes since v3:
 - add comments to the gpmi_move_bits function
 - extend raw read/write documentation
 - move last part of the raw_page_read function into a conditional block

Changes since v2:
 - fixed a bug in gpmi_move_bits
 - add a raw_buffer field to be used when using raw access methods
   (experienced memory corruptions when directly using page_buffer_virt
   buffer)
 - add raw OOB access functions


Boris Brezillon (4):
  mtd: nand: provide detailed description for raw read/write page
    methods
  mtd: nand: gpmi: add gpmi_move_bits function
  mtd: nand: gpmi: add proper raw access support
  mtd: nand: gpmi: add raw oob access functions

 drivers/mtd/nand/gpmi-nand/gpmi-lib.c  | 129 +++++++++++++++++++++++++++++
 drivers/mtd/nand/gpmi-nand/gpmi-nand.c | 146 +++++++++++++++++++++++++++++++++
 drivers/mtd/nand/gpmi-nand/gpmi-nand.h |   6 ++
 include/linux/mtd/nand.h               |  17 +++-
 4 files changed, 296 insertions(+), 2 deletions(-)

-- 
1.9.1

