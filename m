Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757148Ab3AOM6G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 07:58:06 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:44409 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756823Ab3AOM5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 07:57:07 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, sameo@linux.intel.com,
        Ashok G <ashok.g@stericsson.com>, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 24/26] mfd: ab8500-debugfs: sizeof() mismatch bugfix
Date: Tue, 15 Jan 2013 12:56:04 +0000
Message-Id: <1358254566-12419-25-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358254566-12419-1-git-send-email-lee.jones@linaro.org>
References: <1358254566-12419-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ashok G <ashok.g@stericsson.com>

Simple pointer error fix to obtain the expected sizeof() result.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Ashok G <ashok.g@stericsson.com>
Reviewed-by: Mattias WALLIN <mattias.wallin@stericsson.com>
---
 drivers/mfd/ab8500-debugfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/ab8500-debugfs.c b/drivers/mfd/ab8500-debugfs.c
index 8e405af..4147984 100644
--- a/drivers/mfd/ab8500-debugfs.c
+++ b/drivers/mfd/ab8500-debugfs.c
@@ -1565,7 +1565,7 @@ static int __devinit ab8500_debug_probe(struct platform_device *plf)
 	ab8500 = dev_get_drvdata(plf->dev.parent);
 	num_irqs = ab8500->mask_size;
 
-	irq_count = kzalloc(sizeof(irq_count)*num_irqs, GFP_KERNEL);
+	irq_count = kzalloc(sizeof(*irq_count)*num_irqs, GFP_KERNEL);
 	if (!irq_count)
 		return -ENOMEM;
 
-- 
1.7.9.5

