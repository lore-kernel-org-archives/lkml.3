Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933703AbaCSKnj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 06:43:39 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1661 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933498AbaCSKni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 06:43:38 -0400
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: ezequiel.garcia@free-electrons.com, dwmw2@infradead.org,
        computersforpeace@gmail.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH 2/2] UBI: block: Implement kernel_param_ops->get()
Date: Wed, 19 Mar 2014 11:43:23 +0100
Message-Id: <1395225803-25037-2-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1395225803-25037-1-git-send-email-richard@nod.at>
References: <1395225803-25037-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ->get() function is not optional.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/block.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mtd/ubi/block.c b/drivers/mtd/ubi/block.c
index 7ff473c..9ef7df7 100644
--- a/drivers/mtd/ubi/block.c
+++ b/drivers/mtd/ubi/block.c
@@ -158,6 +158,7 @@ static int __init ubiblock_set_param(const char *val,
 
 static struct kernel_param_ops ubiblock_param_ops = {
 	.set    = ubiblock_set_param,
+	.get	= param_get_charp,
 };
 module_param_cb(block, &ubiblock_param_ops, NULL, 0);
 MODULE_PARM_DESC(block, "Attach block devices to UBI volumes. Parameter format: block=<path|dev,num|dev,name>.\n"
-- 
1.8.1.4

