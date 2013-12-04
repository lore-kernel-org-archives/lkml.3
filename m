Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068Ab3LDSeP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 13:34:15 -0500
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:37662 "EHLO
	denmail01.apm.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755980Ab3LDSeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 13:34:09 -0500
From: Feng Kan <fkan@apm.com>
To: patches@apm.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Feng Kan <fkan@apm.com>
Subject: [PATCH 4/4] arm64: removed using of the mask attribute in the dts for reset bit.
Date: Wed,  4 Dec 2013 10:33:50 -0800
Message-Id: <1386182030-26713-1-git-send-email-fkan@apm.com>
X-Mailer: git-send-email 1.7.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the use of the mask attribute from original reboot driver. The use
of the mask attribute provided unneeded complexity and security risk. Also
fix minor compilation warning.

Signed-off-by: Feng Kan <fkan@apm.com>
---
 drivers/power/reset/xgene-reboot.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/power/reset/xgene-reboot.c b/drivers/power/reset/xgene-reboot.c
index ecd55f8..683238c 100644
--- a/drivers/power/reset/xgene-reboot.c
+++ b/drivers/power/reset/xgene-reboot.c
@@ -40,7 +40,7 @@ struct xgene_reboot_context {
 
 static struct xgene_reboot_context *xgene_restart_ctx;
 
-static void xgene_restart(char str, const char *cmd)
+static void xgene_restart(enum reboot_mode reboot_mode, const char *cmd)
 {
 	struct xgene_reboot_context *ctx = xgene_restart_ctx;
 	unsigned long timeout;
@@ -73,8 +73,7 @@ static int xgene_reboot_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	if (of_property_read_u32(pdev->dev.of_node, "mask", &ctx->mask))
-		ctx->mask = 0xFFFFFFFF;
+	ctx->mask = 0x1;
 
 	ctx->pdev = pdev;
 	arm_pm_restart = xgene_restart;
-- 
1.7.6.1

