Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173AbaAFNkP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 08:40:15 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:42063 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbaAFNkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 08:40:13 -0500
From: Christopher Covington <cov@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christopher Covington <cov@codeaurora.org>
Subject: [PATCH] ARM: Make pgtbl macro more robust
Date: Mon,  6 Jan 2014 08:39:53 -0500
Message-Id: <1389015593-31716-1-git-send-email-cov@codeaurora.org>
X-Mailer: git-send-email 1.8.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pgtbl macro couldn't handle the specific
(TEXT_OFFSET - PG_DIR_SIZE) value that the combination of
MSM platforms and LPAE created:

head.S:163: Error: invalid constant (203000) after fixup

Regardless of whether this combination of configuration options
will work on currently support platforms at run time, make it
at least assemble properly.

Signed-off-by: Christopher Covington <cov@codeaurora.org>
---
 arch/arm/kernel/head.S | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
index 9cf6063..af30cac 100644
--- a/arch/arm/kernel/head.S
+++ b/arch/arm/kernel/head.S
@@ -52,7 +52,8 @@
 	.equ	swapper_pg_dir, KERNEL_RAM_VADDR - PG_DIR_SIZE
 
 	.macro	pgtbl, rd, phys
-	add	\rd, \phys, #TEXT_OFFSET - PG_DIR_SIZE
+	add	\rd, \phys, #TEXT_OFFSET
+	sub	\rd, \rd, #PG_DIR_SIZE
 	.endm
 
 /*
-- 
Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by the Linux Foundation.

