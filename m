Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932646Ab3CGKw0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 05:52:26 -0500
Received: from [213.199.154.208] ([213.199.154.208]:43747 "EHLO
	am1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932607Ab3CGKwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 05:52:23 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 6
X-BigFish: VS6(z3121kzzz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ah1082kzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
From: Huang Shijie <b32955@freescale.com>
To: <dwmw2@infradead.org>
CC: <artem.bityutskiy@linux.intel.com>, <computersforpeace@gmail.com>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Huang Shijie <b32955@freescale.com>
Subject: [PATCH V4 1/3] mtd: add new fields to nand_flash_dev{}
Date: Thu, 7 Mar 2013 18:49:22 +0800
Message-ID: <1362653364-29993-2-git-send-email-b32955@freescale.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1362653364-29993-1-git-send-email-b32955@freescale.com>
References: <1362653364-29993-1-git-send-email-b32955@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

This patch adds some new fields to the nand_flash_dev{}:
  @id_len: the valid length of the id data. See the comments in
           nand_id_has_period()
  @oobsize: the oob size.

Signed-off-by: Huang Shijie <b32955@freescale.com>
---
 include/linux/mtd/nand.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/mtd/nand.h b/include/linux/mtd/nand.h
index 591eeeb..f0a9d93 100644
--- a/include/linux/mtd/nand.h
+++ b/include/linux/mtd/nand.h
@@ -578,6 +578,8 @@ struct nand_chip {
  * @erasesize: eraseblock size in bytes (determined from the extended ID if 0)
  * @chipsize: total chip size in MiB
  * @options: stores various chip bit options
+ * @id_len: The valid length of the @id.
+ * @oobsize: OOB size
  */
 struct nand_flash_dev {
 	char *name;
@@ -592,6 +594,8 @@ struct nand_flash_dev {
 	unsigned long chipsize;
 	unsigned long erasesize;
 	unsigned long options;
+	unsigned long id_len;
+	unsigned long oobsize;
 };
 
 /**
-- 
1.7.1


