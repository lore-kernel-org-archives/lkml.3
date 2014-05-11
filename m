Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934238AbaEKT1e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 15:27:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48591 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934190AbaEKT13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 15:27:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Brian Norris <computersforpeace@gmail.com>
Subject: [PATCH 3.4 19/22] mtd: nuc900_nand: NULL dereference in nuc900_nand_enable()
Date: Sun, 11 May 2014 21:21:27 +0200
Message-Id: <20140511192106.404565124@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140511192103.733723493@linuxfoundation.org>
References: <20140511192103.733723493@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit c69dbbf3335a21aae74376d7e5db50a486d52439 upstream.

Instead of writing to "nand->reg + REG_FMICSR" we write to "REG_FMICSR"
which is NULL and not a valid register.

Fixes: 8bff82cbc308 ('mtd: add nand support for w90p910 (v2)')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/nand/nuc900_nand.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/nand/nuc900_nand.c
+++ b/drivers/mtd/nand/nuc900_nand.c
@@ -250,7 +250,7 @@ static void nuc900_nand_enable(struct nu
 	val = __raw_readl(nand->reg + REG_FMICSR);
 
 	if (!(val & NAND_EN))
-		__raw_writel(val | NAND_EN, REG_FMICSR);
+		__raw_writel(val | NAND_EN, nand->reg + REG_FMICSR);
 
 	val = __raw_readl(nand->reg + REG_SMCSR);
 


