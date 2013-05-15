Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758687Ab3EOJC4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 05:02:56 -0400
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:10824
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757928Ab3EOJCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 05:02:53 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 6
X-BigFish: VS6(z3121kzzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6h1082kzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
From: Huang Shijie <b32955@freescale.com>
To: <dwmw2@infradead.org>
CC: <dedekind1@gmail.com>, <computersforpeace@gmail.com>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Huang Shijie <b32955@freescale.com>
Subject: [PATCH v2 4/4] mtd: gpmi: update the ecc step size for mtd_info{}
Date: Wed, 15 May 2013 16:46:46 +0800
Message-ID: <1368607606-4344-5-git-send-email-b32955@freescale.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1368607606-4344-1-git-send-email-b32955@freescale.com>
References: <1368607606-4344-1-git-send-email-b32955@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

update the ecc step size when we have already get the right value.

Signed-off-by: Huang Shijie <b32955@freescale.com>
---
 drivers/mtd/nand/gpmi-nand/gpmi-nand.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/nand/gpmi-nand/gpmi-nand.c b/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
index 53180da..bc598e6 100644
--- a/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
+++ b/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
@@ -1598,6 +1598,7 @@ static int gpmi_pre_bbt_scan(struct gpmi_nand_data  *this)
 	/* Adjust the ECC strength according to the chip. */
 	this->nand.ecc.strength = this->bch_geometry.ecc_strength;
 	this->mtd.ecc_strength = this->bch_geometry.ecc_strength;
+	this->mtd.ecc_step = this->bch_geometry.ecc_chunk_size;
 	this->mtd.bitflip_threshold = this->bch_geometry.ecc_strength;
 
 	/* NAND boot init, depends on the gpmi_set_geometry(). */
-- 
1.7.1


