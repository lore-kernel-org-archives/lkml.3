Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829AbaGHTjc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:39:32 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54097 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755690AbaGHTIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:08:39 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Uwe Kleine-=?UTF-8?Q?K=C3=B6nig?=" <u.kleine-koenig@pengutronix.de>,
        "Olof Johansson" <olof@lixom.net>, "Emil Goode" <emilgoode@gmail.com>,
        "Shawn Guo" <shawn.guo@freescale.com>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.25017974@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 011/125] ARM: imx: fix error handling in ipu device
 registration
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/plat-mxc/devices/platform-ipu-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/plat-mxc/devices/platform-ipu-core.c b/arch/arm/plat-mxc/devices/platform-ipu-core.c
index fc4dd7c..6bd7c3f 100644
--- a/arch/arm/plat-mxc/devices/platform-ipu-core.c
+++ b/arch/arm/plat-mxc/devices/platform-ipu-core.c
@@ -77,7 +77,7 @@ struct platform_device *__init imx_alloc_mx3_camera(
 
 	pdev = platform_device_alloc("mx3-camera", 0);
 	if (!pdev)
-		goto err;
+		return ERR_PTR(-ENOMEM);
 
 	pdev->dev.dma_mask = kmalloc(sizeof(*pdev->dev.dma_mask), GFP_KERNEL);
 	if (!pdev->dev.dma_mask)

