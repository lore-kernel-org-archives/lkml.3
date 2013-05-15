Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758218Ab3EOI4u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 04:56:50 -0400
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:21988
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758168Ab3EOI4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 04:56:48 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 6
X-BigFish: VS6(z3121kzzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6h1082kzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
From: Huang Shijie <b32955@freescale.com>
To: <dwmw2@infradead.org>
CC: <dedekind1@gmail.com>, <computersforpeace@gmail.com>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Huang Shijie <b32955@freescale.com>
Subject: [PATCH v5 08/11] mtd: add ECC info for nand_flash_dev{}
Date: Wed, 15 May 2013 16:40:31 +0800
Message-ID: <1368607232-2210-9-git-send-email-b32955@freescale.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1368607232-2210-1-git-send-email-b32955@freescale.com>
References: <1368607232-2210-1-git-send-email-b32955@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an instance of an anonymous struct to store the ECC infor for full id
nand chips.
	@ecc.strength: ECC correctability from the datasheet.
	@ecc.step: ECC size required by the @ecc.strength,

Also add the necessary macros to make the code simple and clean.

Signed-off-by: Huang Shijie <b32955@freescale.com>
---
 include/linux/mtd/nand.h |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/include/linux/mtd/nand.h b/include/linux/mtd/nand.h
index c503850..718d2c5 100644
--- a/include/linux/mtd/nand.h
+++ b/include/linux/mtd/nand.h
@@ -625,6 +625,11 @@ struct nand_chip {
 	{ .name = (nm), {{ .dev_id = (devid) }}, .chipsize = (chipsz), \
 	  .options = (opts) }
 
+#define NAND_ECC_INFO(_strength, _step)	\
+			{ .strength = (_strength), .step = (_step) }
+#define NAND_ECC_STRENGTH(type)		((type)->ecc.strength)
+#define NAND_ECC_STEP(type)		((type)->ecc.step)
+
 /**
  * struct nand_flash_dev - NAND Flash Device ID Structure
  * @name: a human-readable name of the NAND chip
@@ -642,6 +647,12 @@ struct nand_chip {
  * @options: stores various chip bit options
  * @id_len: The valid length of the @id.
  * @oobsize: OOB size
+ * @ecc.strength: The ECC correctability from the datasheet, same as the
+ *                @ecc_strength in nand_chip{}.
+ * @ecc.step: The ECC step required by the @ecc.strength, same as the
+ *            @ecc_size in nand_chip{}, also from the datasheet.
+ *            For example, the "4bit ECC for each 512Byte" can be set with
+ *            NAND_ECC_INFO(4, 512).
  */
 struct nand_flash_dev {
 	char *name;
@@ -658,6 +669,10 @@ struct nand_flash_dev {
 	unsigned int options;
 	uint16_t id_len;
 	uint16_t oobsize;
+	struct {
+		uint16_t strength;
+		uint16_t step;
+	} ecc;
 };
 
 /**
-- 
1.7.1


