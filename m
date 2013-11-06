Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932361Ab3KFKTy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 05:19:54 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:34337 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756415Ab3KFKQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 05:16:51 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>,
        Vinod Koul <vinod.koul@intel.com>
Subject: [PATCH 02/13] dma: ste_dma40: Parse flags property for new 'high priority channel' request
Date: Wed,  6 Nov 2013 10:16:14 +0000
Message-Id: <1383732985-18928-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383732985-18928-1-git-send-email-lee.jones@linaro.org>
References: <1383732985-18928-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is used for MSP (audio) devices which is about to be fully DT:ed.

Cc: Vinod Koul <vinod.koul@intel.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/dma/ste_dma40.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index b8c031b..00a2de9 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -2409,6 +2409,7 @@ static void d40_set_prio_realtime(struct d40_chan *d40c)
 #define D40_DT_FLAGS_DIR(flags)        ((flags >> 1) & 0x1)
 #define D40_DT_FLAGS_BIG_ENDIAN(flags) ((flags >> 2) & 0x1)
 #define D40_DT_FLAGS_FIXED_CHAN(flags) ((flags >> 3) & 0x1)
+#define D40_DT_FLAGS_HIGH_PRIO(flags)  ((flags >> 4) & 0x1)
 
 static struct dma_chan *d40_xlate(struct of_phandle_args *dma_spec,
 				  struct of_dma *ofdma)
@@ -2446,6 +2447,9 @@ static struct dma_chan *d40_xlate(struct of_phandle_args *dma_spec,
 		cfg.use_fixed_channel = true;
 	}
 
+	if (D40_DT_FLAGS_HIGH_PRIO(flags))
+		cfg.high_priority = true;
+
 	return dma_request_channel(cap, stedma40_filter, &cfg);
 }
 
-- 
1.8.1.2

