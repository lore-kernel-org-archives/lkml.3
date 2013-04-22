Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324Ab3DVH7G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 03:59:06 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:21973 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755307Ab3DVH7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 03:59:03 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 6
X-BigFish: VS6(z3121kzzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1082kzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
From: Huang Shijie <b32955@freescale.com>
To: <dwmw2@infradead.org>
CC: <dedekind1@gmail.com>, <computersforpeace@gmail.com>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Huang Shijie <b32955@freescale.com>
Subject: [PATCH v2 5/8] mtd: add a new field for ecc info in the nand_flash_dev{}
Date: Mon, 22 Apr 2013 15:47:55 +0800
Message-ID: <1366616878-29481-6-git-send-email-b32955@freescale.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1366616878-29481-1-git-send-email-b32955@freescale.com>
References: <1366616878-29481-1-git-send-email-b32955@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the @ecc_info in the nand_flash_dev{}.
The lower 16 bits are used to store the ECC bits, while the upper 16 bits
are used to store the ECC data chunk size.

Signed-off-by: Huang Shijie <b32955@freescale.com>
---
 include/linux/mtd/nand.h |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/include/linux/mtd/nand.h b/include/linux/mtd/nand.h
index 122322c..8238e00 100644
--- a/include/linux/mtd/nand.h
+++ b/include/linux/mtd/nand.h
@@ -623,6 +623,10 @@ struct nand_chip {
 	{ .name = (nm), {{ .dev_id = (devid) }}, .chipsize = (chipsz), \
 	  .options = (opts) }
 
+#define NAND_ECC_INFO(strength, size)	(((strength) << 16) | (size))
+#define NAND_ECC_STRENGTH(x)		(((x) >> 16) & 0xffff)
+#define NAND_ECC_SIZE(x)		((x) & 0xffff)
+
 /**
  * struct nand_flash_dev - NAND Flash Device ID Structure
  * @name: a human-readable name of the NAND chip
@@ -640,6 +644,11 @@ struct nand_chip {
  * @options: stores various chip bit options
  * @id_len: The valid length of the @id.
  * @oobsize: OOB size
+ * @ecc_info: The ECC information.
+ *            lower 16 bits: store the ECC bits.
+ *            upper 16 bits: store the ECC data chunk size.
+ *            For example, the "4bit ECC for each 512Byte" can be set with
+ *            NAND_ECC_INFO(4, 512) macro.
  */
 struct nand_flash_dev {
 	char *name;
@@ -656,6 +665,7 @@ struct nand_flash_dev {
 	unsigned int options;
 	uint16_t id_len;
 	uint16_t oobsize;
+	uint32_t ecc_info;
 };
 
 /**
-- 
1.7.1


