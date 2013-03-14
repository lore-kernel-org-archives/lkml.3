Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934381Ab3CNDBv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 23:01:51 -0400
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:2304 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932725Ab3CNDBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 23:01:50 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ah1082kzzz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
From: Huang Shijie <b32955@freescale.com>
To: <dwmw2@infradead.org>
CC: <artem.bityutskiy@linux.intel.com>, <computersforpeace@gmail.com>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Huang Shijie <b32955@freescale.com>
Subject: [PATCH v5 0/3] mtd: use the full-id as the keyword for some nand chips
Date: Thu, 14 Mar 2013 10:59:22 +0800
Message-ID: <1363229965-13128-1-git-send-email-b32955@freescale.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

v4 --> v4:
	[1] remove the id_len field.
	[2] based on Artem "mtd: nand: use more reasonable integer types"
	[3] add more comments.

v3 --> v4:
	[1] rewrite the code based on the latest l2-mtd.
	[2] add the full-id nand in the nand_flash_lds.

v2 --> v3:
	[1] remove the duplicated header.
	[2] remove the field "ecc_len" in nand_flash_dev{}.
	[3] fix some coding style warnings.
	[4] add more comments

Huang Shijie (3):
  mtd: add a new field for nand_flash_dev{}
  mtd: add the support to parse out the full-id nand type
  mtd: add 4 Toshiba nand chips for the full-id case

 drivers/mtd/nand/nand_base.c |   36 +++++++++++++++++++++++++++++++++---
 drivers/mtd/nand/nand_ids.c  |   22 ++++++++++++++++++++++
 include/linux/mtd/nand.h     |    2 ++
 3 files changed, 57 insertions(+), 3 deletions(-)


