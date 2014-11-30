Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553AbaK3SKq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 13:10:46 -0500
Received: from down.free-electrons.com ([37.187.137.238]:47369 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752453AbaK3SKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 13:10:45 -0500
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org
Cc: Huang Shijie <shijie8@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mike Voytovich <mvoytovich@paypal.com>, Roy Lee <roylee@paypal.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v6 0/3] mtd: nand: gpmi: add proper raw access support
Date: Sun, 30 Nov 2014 19:10:27 +0100
Message-Id: <1417371030-24015-1-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This series provides an implementation for raw accesses taking care of
hidding the specific layout used by the GPMI controller.

Best Regards,

Boris

Changes since v5:
 - rename gpmi_move_bits into gpmi_copy_bits

Changes since v4:
 - fixed a few corner cases in gpmi_move_bits (tested it with:
   https://github.com/bbrezillon/gpmi-move-bits-test/blob/master/gpmi-move-bits-test.c)
 - add documentation and comments for the new gpmi functions

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


Boris Brezillon (3):
  mtd: nand: gpmi: add gpmi_copy_bits function
  mtd: nand: gpmi: add proper raw access support
  mtd: nand: gpmi: add raw oob access functions

 drivers/mtd/nand/gpmi-nand/gpmi-lib.c  | 153 +++++++++++++++++++++++++
 drivers/mtd/nand/gpmi-nand/gpmi-nand.c | 201 +++++++++++++++++++++++++++++++++
 drivers/mtd/nand/gpmi-nand/gpmi-nand.h |   6 +
 3 files changed, 360 insertions(+)

-- 
1.9.1

