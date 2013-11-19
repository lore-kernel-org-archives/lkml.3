Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165Ab3KSLIN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 06:08:13 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:55669 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107Ab3KSLIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 06:08:09 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 02/10] dma: ste_dma40: Parse flags property for new 'high priority channel' request
Date: Tue, 19 Nov 2013 11:07:41 +0000
Message-Id: <1384859269-19801-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1384859269-19801-1-git-send-email-lee.jones@linaro.org>
References: <1384859269-19801-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is used for MSP (audio) devices which is about to be fully DT:ed.

Acked-by: Vinod Koul <vinod.koul@intel.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
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

