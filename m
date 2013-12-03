Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443Ab3LCOMI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:12:08 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:42322 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630Ab3LCOMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:12:03 -0500
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] MFD: ab8500: use irqdomain to map interrupts
Date: Tue,  3 Dec 2013 15:11:54 +0100
Message-Id: <1386079914-23807-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All subdrivers use the irqdomain to demux AB8500 IRQs but here
in the hierarchical path we find a leftover instance using the
hard-coded IRQ base. Convert it to use irqdomain with a
oneliner.

Cc: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/ab8500-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index b6c2cdc76091..7134a4060881 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -491,7 +491,7 @@ static int ab8500_handle_hierarchical_line(struct ab8500 *ab8500,
 		if (line == AB8540_INT_GPIO43F || line == AB8540_INT_GPIO44F)
 			line += 1;
 
-		handle_nested_irq(ab8500->irq_base + line);
+		handle_nested_irq(irq_create_mapping(ab8500->domain, line));
 	}
 
 	return 0;
-- 
1.8.3.1

