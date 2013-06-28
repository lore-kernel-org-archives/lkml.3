Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919Ab3F1Qz6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 12:55:58 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:56565 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755895Ab3F1Qzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 12:55:55 -0400
From: Fabio Estevam <festevam@gmail.com>
To: gregkh@linuxfoundation.org
Cc: kernel@pengutronix.de, shawn.guo@linaro.org, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH v2 2/4] imx-drm: ipu-dp: Check the return value of devm_kzalloc()
Date: Fri, 28 Jun 2013 13:55:28 -0300
Message-Id: <1372438530-1819-2-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372438530-1819-1-git-send-email-festevam@gmail.com>
References: <1372438530-1819-1-git-send-email-festevam@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

devm_kzalloc() may fail, so let's check its return value.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
Changes since v1:
- None

 drivers/staging/imx-drm/ipu-v3/ipu-dp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-dp.c b/drivers/staging/imx-drm/ipu-v3/ipu-dp.c
index 113b046..0449515 100644
--- a/drivers/staging/imx-drm/ipu-v3/ipu-dp.c
+++ b/drivers/staging/imx-drm/ipu-v3/ipu-dp.c
@@ -309,6 +309,8 @@ int ipu_dp_init(struct ipu_soc *ipu, struct device *dev, unsigned long base)
 	int i;
 
 	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
 	priv->dev = dev;
 	priv->ipu = ipu;
 
-- 
1.8.1.2

