Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540AbaEULWZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 07:22:25 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44864 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbaEULWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 07:22:21 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <computersforpeace@gmail.com>
CC: <pekon@ti.com>, <ezequiel.garcia@free-electrons.com>,
        <robertcnelson@gmail.com>, <jg1.han@samsung.com>,
        <dwmw2@infradead.org>, <javier@dowhile0.org>, <nsekhar@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-mtd@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [RFC PATCH 08/16] mtd: nand: omap: Fix build warning
Date: Wed, 21 May 2014 14:20:56 +0300
Message-ID: <1400671264-10702-9-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1400671264-10702-1-git-send-email-rogerq@ti.com>
References: <1400671264-10702-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following warning when CONFIG_MTD_NAND_OMAP_BCH is disabled.
warning: ‘erased_sector_bitflips’ defined but not used [-Wunused-function]

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/mtd/nand/omap2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
index 1ff49b8..1b800bc 100644
--- a/drivers/mtd/nand/omap2.c
+++ b/drivers/mtd/nand/omap2.c
@@ -1237,6 +1237,7 @@ static int __maybe_unused omap_calculate_ecc_bch(struct mtd_info *mtd,
 	return 0;
 }
 
+#ifdef CONFIG_MTD_NAND_OMAP_BCH
 /**
  * erased_sector_bitflips - count bit flips
  * @data:	data sector buffer
@@ -1276,7 +1277,6 @@ static int erased_sector_bitflips(u_char *data, u_char *oob,
 	return flip_bits;
 }
 
-#ifdef CONFIG_MTD_NAND_OMAP_BCH
 /**
  * omap_elm_correct_data - corrects page data area in case error reported
  * @mtd:	MTD device structure
-- 
1.8.3.2

