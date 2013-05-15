Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758243Ab3EOJDV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 05:03:21 -0400
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:56237
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757978Ab3EOJDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 05:03:18 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6h1082kzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
From: Huang Shijie <b32955@freescale.com>
To: <dwmw2@infradead.org>
CC: <dedekind1@gmail.com>, <computersforpeace@gmail.com>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Huang Shijie <b32955@freescale.com>
Subject: [PATCH v2 3/4] mtd: set the ecc step size for master/slave mtd_info
Date: Wed, 15 May 2013 16:46:45 +0800
Message-ID: <1368607606-4344-4-git-send-email-b32955@freescale.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1368607606-4344-1-git-send-email-b32955@freescale.com>
References: <1368607606-4344-1-git-send-email-b32955@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set the ecc step size for master/slave mtd_info{}.

Signed-off-by: Huang Shijie <b32955@freescale.com>
---
 drivers/mtd/mtdpart.c        |    1 +
 drivers/mtd/nand/nand_base.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/mtdpart.c b/drivers/mtd/mtdpart.c
index 3014933..63b42a6 100644
--- a/drivers/mtd/mtdpart.c
+++ b/drivers/mtd/mtdpart.c
@@ -516,6 +516,7 @@ static struct mtd_part *allocate_partition(struct mtd_info *master,
 	}
 
 	slave->mtd.ecclayout = master->ecclayout;
+	slave->mtd.ecc_step = master->ecc_step;
 	slave->mtd.ecc_strength = master->ecc_strength;
 	slave->mtd.bitflip_threshold = master->bitflip_threshold;
 
diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index 359e105..48dfab5 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -3747,6 +3747,7 @@ int nand_scan_tail(struct mtd_info *mtd)
 	/* propagate ecc info to mtd_info */
 	mtd->ecclayout = chip->ecc.layout;
 	mtd->ecc_strength = chip->ecc.strength;
+	mtd->ecc_step = chip->ecc.size;
 	/*
 	 * Initialize bitflip_threshold to its default prior scan_bbt() call.
 	 * scan_bbt() might invoke mtd_read(), thus bitflip_threshold must be
-- 
1.7.1


