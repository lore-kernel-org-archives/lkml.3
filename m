Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638Ab3FZLwB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 07:52:01 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:45723 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab3FZLv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 07:51:58 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kgene.kim@samsung.com, tglx@linutronix.de, t.figa@samsung.com,
        arnd@arndb.de, sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 2/2] irqchip: exynos-combiner: Staticize combiner_init
Date: Wed, 26 Jun 2013 17:06:37 +0530
Message-Id: <1372246597-32323-2-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1372246597-32323-1-git-send-email-sachin.kamat@linaro.org>
References: <1372246597-32323-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

combiner_init() is referenced only in this file. Make it
static.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/irqchip/exynos-combiner.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/irqchip/exynos-combiner.c b/drivers/irqchip/exynos-combiner.c
index a9d2b2f..4c68265 100644
--- a/drivers/irqchip/exynos-combiner.c
+++ b/drivers/irqchip/exynos-combiner.c
@@ -204,10 +204,10 @@ static unsigned int combiner_lookup_irq(int group)
 	return 0;
 }
 
-void __init combiner_init(void __iomem *combiner_base,
-			  struct device_node *np,
-			  unsigned int max_nr,
-			  int irq_base)
+static void __init combiner_init(void __iomem *combiner_base,
+				 struct device_node *np,
+				 unsigned int max_nr,
+				 int irq_base)
 {
 	int i, irq;
 	unsigned int nr_irq;
-- 
1.7.9.5

