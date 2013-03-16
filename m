Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665Ab3CPMCq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 08:02:46 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:39007 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755044Ab3CPMCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 08:02:45 -0400
From: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
To: devel@driverdev.osuosl.org
Cc: s.hauer@pengutronix.de, linux-kernel@vger.kernel.org,
        Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
Subject: [PATCH] imx_drm: ipu_v3: fix invalid free of devm_* allocated data
Date: Sat, 16 Mar 2013 14:02:36 +0200
Message-Id: <1363435356-2237-1-git-send-email-silviupopescu1990@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The objects allocated by devm_* APIs are managed by devres and are freed
when the device is detached. There is no need to use kfree() explicitly.

Signed-off-by: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
---
 drivers/staging/imx-drm/ipu-v3/ipu-dp.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-dp.c b/drivers/staging/imx-drm/ipu-v3/ipu-dp.c
index 26aecaf..113b046 100644
--- a/drivers/staging/imx-drm/ipu-v3/ipu-dp.c
+++ b/drivers/staging/imx-drm/ipu-v3/ipu-dp.c
@@ -316,7 +316,6 @@ int ipu_dp_init(struct ipu_soc *ipu, struct device *dev, unsigned long base)
 
 	priv->base = devm_ioremap(dev, base, PAGE_SIZE);
 	if (!priv->base) {
-		kfree(priv);
 		return -ENOMEM;
 	}
 
-- 
1.7.9.5

