Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966497AbaFQVuE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:50:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54270 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965344AbaFQVt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:49:58 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Emil Goode <emilgoode@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Olof Johansson <olof@lixom.net>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 173/212] ARM: imx: fix error handling in ipu device registration
Date: Tue, 17 Jun 2014 14:44:27 -0700
Message-Id: <1403041506-13646-174-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emil Goode <emilgoode@gmail.com>

commit d1d70e5dc2cfa9047bb935c41ba808ebb8135696 upstream.

If we fail to allocate struct platform_device pdev we
dereference it after the goto label err.

This bug was found using coccinelle.

Fixes: afa77ef (ARM: mx3: dynamically allocate "ipu-core" devices)
Signed-off-by: Emil Goode <emilgoode@gmail.com>
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Shawn Guo <shawn.guo@freescale.com>
Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/mach-imx/devices/platform-ipu-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-imx/devices/platform-ipu-core.c b/arch/arm/mach-imx/devices/platform-ipu-core.c
index fc4dd7c..6bd7c3f 100644
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
1.9.1

