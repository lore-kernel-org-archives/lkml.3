Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761144AbaEMK2x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:28:53 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:33415 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933393AbaEMKLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:11:13 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Brian Norris <computersforpeace@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 168/182] mtd: nuc900_nand: NULL dereference in nuc900_nand_enable()
Date: Tue, 13 May 2014 11:28:40 +0200
Message-Id: <d7df72087bbca8a4f6c4843f6d73e44a9ace7454.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit c69dbbf3335a21aae74376d7e5db50a486d52439 upstream.

Instead of writing to "nand->reg + REG_FMICSR" we write to "REG_FMICSR"
which is NULL and not a valid register.

Fixes: 8bff82cbc308 ('mtd: add nand support for w90p910 (v2)')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/mtd/nand/nuc900_nand.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/nuc900_nand.c b/drivers/mtd/nand/nuc900_nand.c
index 52115151e4a7..2e1d16bf9818 100644
--- a/drivers/mtd/nand/nuc900_nand.c
+++ b/drivers/mtd/nand/nuc900_nand.c
@@ -225,7 +225,7 @@ static void nuc900_nand_enable(struct nuc900_nand *nand)
 	val = __raw_readl(nand->reg + REG_FMICSR);
 
 	if (!(val & NAND_EN))
-		__raw_writel(val | NAND_EN, REG_FMICSR);
+		__raw_writel(val | NAND_EN, nand->reg + REG_FMICSR);
 
 	val = __raw_readl(nand->reg + REG_SMCSR);
 
-- 
1.9.3

