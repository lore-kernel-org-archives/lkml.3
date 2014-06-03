Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932411AbaFCLkw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 07:40:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43353 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932320AbaFCLkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:40:42 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Brian Norris <computersforpeace@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 032/138] mtd: nuc900_nand: NULL dereference in nuc900_nand_enable()
Date: Tue,  3 Jun 2014 12:37:58 +0100
Message-Id: <1401795584-22664-33-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
References: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit c69dbbf3335a21aae74376d7e5db50a486d52439 upstream.

Instead of writing to "nand->reg + REG_FMICSR" we write to "REG_FMICSR"
which is NULL and not a valid register.

Fixes: 8bff82cbc308 ('mtd: add nand support for w90p910 (v2)')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/mtd/nand/nuc900_nand.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/nuc900_nand.c b/drivers/mtd/nand/nuc900_nand.c
index cd6be2ed53a8..14203f3bb0cd 100644
--- a/drivers/mtd/nand/nuc900_nand.c
+++ b/drivers/mtd/nand/nuc900_nand.c
@@ -225,7 +225,7 @@ static void nuc900_nand_enable(struct nuc900_nand *nand)
 	val = __raw_readl(nand->reg + REG_FMICSR);
 
 	if (!(val & NAND_EN))
-		__raw_writel(val | NAND_EN, REG_FMICSR);
+		__raw_writel(val | NAND_EN, nand->reg + REG_FMICSR);
 
 	val = __raw_readl(nand->reg + REG_SMCSR);
 
-- 
1.9.1

