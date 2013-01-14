Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253Ab3ANIO2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 03:14:28 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:19458 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755841Ab3ANIO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 03:14:27 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1ee6h1de0h1202h1e76h1d1ah1d2ah1082kzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h1354h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1155h)
From: Huang Shijie <b32955@freescale.com>
To: <dwmw2@infradead.org>
CC: <dedekind1@gmail.com>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Huang Shijie <b32955@freescale.com>
Subject: [PATCH] mtd: gpmi: dump the BCH registers
Date: Mon, 14 Jan 2013 15:19:29 +0800
Message-ID: <1358147969-31878-1-git-send-email-b32955@freescale.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dump the BCH registers in gpmi_dump_info().

Signed-off-by: Huang Shijie <b32955@freescale.com>
---
 drivers/mtd/nand/gpmi-nand/bch-regs.h |    2 ++
 drivers/mtd/nand/gpmi-nand/gpmi-lib.c |    5 +++++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/nand/gpmi-nand/bch-regs.h b/drivers/mtd/nand/gpmi-nand/bch-regs.h
index a092451..d67bca5 100644
--- a/drivers/mtd/nand/gpmi-nand/bch-regs.h
+++ b/drivers/mtd/nand/gpmi-nand/bch-regs.h
@@ -103,4 +103,6 @@
 		? (((v) >> 2) & MX6Q_BM_BCH_FLASH0LAYOUT1_DATAN_SIZE)	\
 		: ((v) & BM_BCH_FLASH0LAYOUT1_DATAN_SIZE)		\
 	)
+
+#define HW_BCH_VERSION				0x00000160
 #endif
diff --git a/drivers/mtd/nand/gpmi-nand/gpmi-lib.c b/drivers/mtd/nand/gpmi-nand/gpmi-lib.c
index d84699c..01cc570 100644
--- a/drivers/mtd/nand/gpmi-nand/gpmi-lib.c
+++ b/drivers/mtd/nand/gpmi-nand/gpmi-lib.c
@@ -208,6 +208,11 @@ void gpmi_dump_info(struct gpmi_nand_data *this)
 	}
 
 	/* start to print out the BCH info */
+	pr_err("Show BCH registers :\n");
+	for (i = 0; i <= HW_BCH_VERSION / 0x10 + 1; i++) {
+		reg = readl(r->bch_regs + i * 0x10);
+		pr_err("offset 0x%.3x : 0x%.8x\n", i * 0x10, reg);
+	}
 	pr_err("BCH Geometry :\n");
 	pr_err("GF length              : %u\n", geo->gf_len);
 	pr_err("ECC Strength           : %u\n", geo->ecc_strength);
-- 
1.7.0.4


