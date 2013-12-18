Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420Ab3LRVOB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:14:01 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36527 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634Ab3LRVN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:13:59 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Brian Norris <computersforpeace@gmail.com>
Subject: [PATCH 3.12 046/118] Partially revert "mtd: nand: pxa3xx: Introduce marvell,armada370-nand compatible string"
Date: Wed, 18 Dec 2013 13:11:23 -0800
Message-Id: <20131218211220.776260544@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211219.461663463@linuxfoundation.org>
References: <20131218211219.461663463@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>

commit 9c59ac616137fb62f6cb3f1219201b09cbcf30be upstream.

This partially reverts c0f3b8643a6fa2461d70760ec49d21d2b031d611.

The "armada370-nand" compatible support is not complete, and it was mistake
to add it. Revert it and postpone the support until the infrastructure is
in place.

Signed-off-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Acked-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/nand/pxa3xx_nand.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/mtd/nand/pxa3xx_nand.c
+++ b/drivers/mtd/nand/pxa3xx_nand.c
@@ -1241,10 +1241,6 @@ static struct of_device_id pxa3xx_nand_d
 		.compatible = "marvell,pxa3xx-nand",
 		.data       = (void *)PXA3XX_NAND_VARIANT_PXA,
 	},
-	{
-		.compatible = "marvell,armada370-nand",
-		.data       = (void *)PXA3XX_NAND_VARIANT_ARMADA370,
-	},
 	{}
 };
 MODULE_DEVICE_TABLE(of, pxa3xx_nand_dt_ids);


