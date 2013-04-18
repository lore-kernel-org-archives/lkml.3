Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030337Ab3DRKUH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 06:20:07 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:60735 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967762Ab3DRKMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 06:12:48 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>,
        Rabin Vincent <rabin@rab.in>
Subject: [PATCH 08/32] dmaengine: ste_dma40: Optimise local MAX() macro
Date: Thu, 18 Apr 2013 11:11:50 +0100
Message-Id: <1366279934-30761-9-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current implementation of the DMA40's local MAX() macro evaluates
its arguments more times than is necessary. This patch strips it
optimises it to only evaluate what's appropriate.

Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>
Cc: Per Forlin <per.forlin@stericsson.com>
Cc: Rabin Vincent <rabin@rab.in>
Reported-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/dma/ste_dma40.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index b21a8a3..7b451b2 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -53,7 +53,7 @@
 #define D40_ALLOC_PHY		BIT(30)
 #define D40_ALLOC_LOG_FREE	BIT(0)
 
-#define MAX(a, b) (((a) < (b)) ? (b) : (a))
+#define MAX(a, b) ((a > b) ? a : b)
 
 #define D40_IS_SRC(dir)  ((dir == STEDMA40_PERIPH_TO_MEM) ? true : false)
 #define D40_IS_DST(dir) (((dir == STEDMA40_MEM_TO_PERIPH) || \
-- 
1.7.10.4

