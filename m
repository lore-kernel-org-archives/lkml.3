Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142Ab3AXHIb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 02:08:31 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:14117
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751076Ab3AXHI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 02:08:26 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1ee6h1de0h1202h1e76h1d1ah1d2ah1082kzzz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h1354h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1155h)
From: Huang Shijie <b32955@freescale.com>
To: <dwmw2@infradead.org>
CC: <artem.bityutskiy@linux.intel.com>, <computersforpeace@gmail.com>,
        <shmulik.ladkani@gmail.com>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Huang Shijie <b32955@freescale.com>
Subject: [PATCH v2 0/3] mtd: use the full-id as the keyword.
Date: Thu, 24 Jan 2013 14:11:38 +0800
Message-ID: <1359007901-26464-1-git-send-email-b32955@freescale.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I ever submitted a patch to use the full-id as the keyword for some
unparsable nand chips. This is the second tries.

As time goes on, we begin to meet the situation that we can not get enough
information from some nand chips's id data. Take some Toshiba's nand chips
for example. I have 4 Toshiba's nand chips in my hand:
	TC58NVG2S0F, TC58NVG3S0F, TC58NVG5D2, TC58NVG6D2

When we read these chips' datasheets, we will get the geometry of these chips:
	TC58NVG2S0F : 4096 + 224
	TC58NVG3S0F : 4096 + 232
	TC58NVG5D2  : 8192 + 640
	TC58NVG6D2  : 8192 + 640

But we can not parse out the correct oob size for these chips from the id data.
So it is time to add some new fields to the nand_flash_dev{}, and update the
detection mechanisms.

Huang Shijie (3):
  mtd: add new fields to nand_flash_dev{}
  mtd: add a new table for the unparsable nand chips
  mtd: add the new detection method for the unparsable nand chips

 drivers/mtd/devices/doc2000.c     |    2 +-
 drivers/mtd/devices/doc2001.c     |    2 +-
 drivers/mtd/devices/doc2001plus.c |    2 +-
 drivers/mtd/nand/nand_base.c      |   35 ++++++-
 drivers/mtd/nand/nand_ids.c       |  198 +++++++++++++++++++++----------------
 drivers/mtd/nand/nandsim.c        |    2 +-
 drivers/mtd/nand/pxa3xx_nand.c    |    2 +-
 drivers/mtd/nand/sm_common.c      |   61 ++++++------
 include/linux/mtd/nand.h          |   11 ++-
 9 files changed, 188 insertions(+), 127 deletions(-)


