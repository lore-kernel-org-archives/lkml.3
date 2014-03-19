Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933773AbaCSKnl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 06:43:41 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756938AbaCSKnh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 06:43:37 -0400
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: ezequiel.garcia@free-electrons.com, dwmw2@infradead.org,
        computersforpeace@gmail.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH 1/2] UBI: block: Remove __initdata from ubiblock_param_ops
Date: Wed, 19 Mar 2014 11:43:22 +0100
Message-Id: <1395225803-25037-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You cannot mark these parameters as __initdata.
Otherwise the data is gone upon module exit.

Fixes:
[  172.045465] BUG: unable to handle kernel paging request at ffffffffa001db38
[  172.046020] IP: [<ffffffff81067aa4>] destroy_params+0x24/0x50

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/block.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/ubi/block.c b/drivers/mtd/ubi/block.c
index 69a74fd..7ff473c 100644
--- a/drivers/mtd/ubi/block.c
+++ b/drivers/mtd/ubi/block.c
@@ -156,7 +156,7 @@ static int __init ubiblock_set_param(const char *val,
 	return 0;
 }
 
-static struct kernel_param_ops ubiblock_param_ops __initdata = {
+static struct kernel_param_ops ubiblock_param_ops = {
 	.set    = ubiblock_set_param,
 };
 module_param_cb(block, &ubiblock_param_ops, NULL, 0);
-- 
1.8.1.4

