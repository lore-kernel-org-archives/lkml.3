Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935589Ab3DISj6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 14:39:58 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:35125 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935514Ab3DISjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 14:39:55 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 3/8] dmaengine: ste_dma40: Actually write the runtime configuration to registers
Date: Tue,  9 Apr 2013 19:39:38 +0100
Message-Id: <1365532783-27425-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1365532783-27425-1-git-send-email-lee.jones@linaro.org>
References: <1365532783-27425-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Someone has spent a fair amount of effort writing a runtime configuration
changing algorithm for DMA clients. However, the config appears to never
actually make it to hardware. In order for the configuration to take hold
we need to issue a d40_config_write(), as this is the routine which writes
it into the hardware's registers.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/dma/ste_dma40.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 3b83dee..2a0a9d4 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -2831,6 +2831,9 @@ static int d40_set_runtime_config(struct dma_chan *chan,
 	/* These settings will take precedence later */
 	d40c->runtime_addr = config_addr;
 	d40c->runtime_direction = config->direction;
+
+	d40_config_write(d40c);
+
 	dev_dbg(d40c->base->dev,
 		"configured channel %s for %s, data width %d/%d, "
 		"maxburst %d/%d elements, LE, no flow control\n",
-- 
1.7.10.4

