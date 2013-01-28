Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911Ab3A1FzR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 00:55:17 -0500
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:17501
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751751Ab3A1FzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 00:55:14 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1ee6h1de0h1202h1e76h1d1ah1d2ah1082kzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h1354h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1155h)
From: Huang Shijie <b32955@freescale.com>
To: <dwmw2@infradead.org>
CC: <dedekind1@gmail.com>, <computersforpeace@gmail.com>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH V3 0/3] mtd: use the full-id as the keyword
Date: Mon, 28 Jan 2013 12:57:16 +0800
Message-ID: <1359349039-11510-1-git-send-email-b32955@freescale.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huang Shijie <b32955@freescale.com>

I ever submitted a patch to use the full-id as the keyword for
some unparsable nand chips. This is the second tries.

As time goes on, we begin to meet the situation that we can not
get enough information from some nand chips's id data.
Take some Toshiba's nand chips for example.
I have 4 Toshiba's nand chips in my hand:
	TC58NVG2S0F, TC58NVG3S0F, TC58NVG5D2, TC58NVG6D2

When we read these chips' datasheets, we will get the geometry of these chips:
	TC58NVG2S0F : 4096 + 224
	TC58NVG3S0F : 4096 + 232
	TC58NVG5D2  : 8192 + 640
	TC58NVG6D2  : 8192 + 640

But we can not parse out the correct oob size for these chips from the id data.
So it is time to add some new fields to the nand_flash_dev{},
and update the detection mechanisms.

v2 --> v3:
	[1] remove the duplicated header.
	[2] remove the field "ecc_len" in nand_flash_dev{}.
	[3] fix some coding style warnings.
	[4] add more comments

Huang Shijie (3):
  mtd: add new fields to nand_flash_dev{}
  mtd: add a new table for the unparsable nand chips
  mtd: add the new detection method for the unparsable nand chips

 drivers/mtd/devices/doc2000.c     |    2 +-
 drivers/mtd/devices/doc2001.c     |    2 +-
 drivers/mtd/devices/doc2001plus.c |    2 +-
 drivers/mtd/nand/nand_base.c      |   35 ++++++-
 drivers/mtd/nand/nand_ids.c       |  217 +++++++++++++++++++++----------------
 drivers/mtd/nand/nandsim.c        |    2 +-
 drivers/mtd/nand/pxa3xx_nand.c    |    2 +-
 drivers/mtd/nand/sm_common.c      |   61 +++++------
 include/linux/mtd/nand.h          |    9 ++-
 9 files changed, 201 insertions(+), 131 deletions(-)


