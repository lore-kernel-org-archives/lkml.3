Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762895Ab3ECGfI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 02:35:08 -0400
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:38649
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760198Ab3ECGfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 02:35:06 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 6
X-BigFish: VS6(z3121kzzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1082kzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
From: Huang Shijie <b32955@freescale.com>
To: <dwmw2@infradead.org>
CC: <dedekind1@gmail.com>, <computersforpeace@gmail.com>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Huang Shijie <b32955@freescale.com>
Subject: [PATCH 1/4] mtd: add a new field to mtd_info{}
Date: Fri, 3 May 2013 14:21:41 +0800
Message-ID: <1367562104-8955-2-git-send-email-b32955@freescale.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1367562104-8955-1-git-send-email-b32955@freescale.com>
References: <1367562104-8955-1-git-send-email-b32955@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to implement the NAND boot for some Freescale's chips, such as
imx23/imx28/imx50/imx6, we use a tool (called kobs-ng) to burn the uboot
and some metadata to nand chip. And the ROM code will use the metadata to
configrate the BCH, and to find the uboot.

The ECC information(ecc step size, ecc strength) which is used to configrate
the BCH is part of the metadata. The kobs-ng can gets the ecc strength from
the sys node /sys/*/ecc_strength now. But it can not gets the ecc step size.

This patch adds a new field to store the ecc step size in mtd_info{}, and
it makes preparation for the next patches.

Signed-off-by: Huang Shijie <b32955@freescale.com>
---
 include/linux/mtd/mtd.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/mtd/mtd.h b/include/linux/mtd/mtd.h
index 183a304..b93035f 100644
--- a/include/linux/mtd/mtd.h
+++ b/include/linux/mtd/mtd.h
@@ -173,6 +173,9 @@ struct mtd_info {
 	/* ECC layout structure pointer - read only! */
 	struct nand_ecclayout *ecclayout;
 
+	/* the ecc step size. */
+	unsigned int ecc_size;
+
 	/* max number of correctible bit errors per ecc step */
 	unsigned int ecc_strength;
 
-- 
1.7.1


