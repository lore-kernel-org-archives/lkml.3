Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932517AbbAHWhx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 17:37:53 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35628 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755663AbbAHWhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 17:37:51 -0500
From: Colin King <colin.king@canonical.com>
To: Ian Munsie <imunsie@au1.ibm.com>, Michael Neuling <mikey@neuling.org>,
        linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] cxl: remove redundant increment of hwirq
Date: Thu,  8 Jan 2015 22:36:47 +0000
Message-Id: <1420756607-23459-1-git-send-email-colin.king@canonical.com>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

hwirq has not been initialized, however it is being incremented
and also not being referenced in a loop.  This error was detected with
cppcheck:

[drivers/misc/cxl/irq.c:439]: (error) Uninitialized variable: hwirq

Commit 80fa93fce37d ("cxl: Name interrupts in /proc/interrupt") 
introduced this error.

This is a simple fix that removes the redundant increment.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/misc/cxl/irq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/cxl/irq.c b/drivers/misc/cxl/irq.c
index c294925..68ab608 100644
--- a/drivers/misc/cxl/irq.c
+++ b/drivers/misc/cxl/irq.c
@@ -436,7 +436,7 @@ int afu_register_irqs(struct cxl_context *ctx, u32 count)
 	 */
 	INIT_LIST_HEAD(&ctx->irq_names);
 	for (r = 1; r < CXL_IRQ_RANGES; r++) {
-		for (i = 0; i < ctx->irqs.range[r]; hwirq++, i++) {
+		for (i = 0; i < ctx->irqs.range[r]; i++) {
 			irq_name = kmalloc(sizeof(struct cxl_irq_name),
 					   GFP_KERNEL);
 			if (!irq_name)
-- 
2.1.4

