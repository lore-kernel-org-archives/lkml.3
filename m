Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832AbaFWIzb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:55:31 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55499 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752490AbaFWIc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:28 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Emil Goode <emilgoode@gmail.com>,
        Shawn Guo <shawn.guo@freescale.com>, Olof Johansson <olof@lixom.net>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 028/111] ARM: imx: fix error handling in ipu device registration
Date: Mon, 23 Jun 2014 10:31:03 +0200
Message-Id: <93a5cb6cf809599758d596e16b659f5944ee9652.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emil Goode <emilgoode@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit d1d70e5dc2cfa9047bb935c41ba808ebb8135696 upstream.

If we fail to allocate struct platform_device pdev we
dereference it after the goto label err.

This bug was found using coccinelle.

Fixes: afa77ef (ARM: mx3: dynamically allocate "ipu-core" devices)
Signed-off-by: Emil Goode <emilgoode@gmail.com>
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Shawn Guo <shawn.guo@freescale.com>
Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/arm/mach-imx/devices/platform-ipu-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-imx/devices/platform-ipu-core.c b/arch/arm/mach-imx/devices/platform-ipu-core.c
index fc4dd7cedc11..6bd7c3f37ac0 100644
--- a/arch/arm/mach-imx/devices/platform-ipu-core.c
+++ b/arch/arm/mach-imx/devices/platform-ipu-core.c
@@ -77,7 +77,7 @@ struct platform_device *__init imx_alloc_mx3_camera(
 
 	pdev = platform_device_alloc("mx3-camera", 0);
 	if (!pdev)
-		goto err;
+		return ERR_PTR(-ENOMEM);
 
 	pdev->dev.dma_mask = kmalloc(sizeof(*pdev->dev.dma_mask), GFP_KERNEL);
 	if (!pdev->dev.dma_mask)
-- 
2.0.0

