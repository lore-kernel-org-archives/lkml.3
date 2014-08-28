Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282AbaH1NOz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 09:14:55 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:38572 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206AbaH1NOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 09:14:48 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 11/11] mfd: sm501: Avoid implicit sign extension
Date: Thu, 28 Aug 2014 14:14:17 +0100
Message-Id: <1409231657-18294-11-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409231657-18294-1-git-send-email-lee.jones@linaro.org>
References: <1409231657-18294-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suspicious implicit sign extension where 'reg' (unsigned char) is
promoted in reg << clksrc to int, then sign-extended to unsigned
long. If reg << clksrc is greater than 0x7FFFFFFF, the upper bits
of the result will all be 1.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/sm501.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/sm501.c b/drivers/mfd/sm501.c
index 81e6d09..1f9233b 100644
--- a/drivers/mfd/sm501.c
+++ b/drivers/mfd/sm501.c
@@ -514,9 +514,9 @@ unsigned long sm501_set_clock(struct device *dev,
 	unsigned long mode = smc501_readl(sm->regs + SM501_POWER_MODE_CONTROL);
 	unsigned long gate = smc501_readl(sm->regs + SM501_CURRENT_GATE);
 	unsigned long clock = smc501_readl(sm->regs + SM501_CURRENT_CLOCK);
-	unsigned char reg;
 	unsigned int pll_reg = 0;
 	unsigned long sm501_freq; /* the actual frequency achieved */
+	u64 reg;
 
 	struct sm501_clock to;
 
-- 
1.9.1

