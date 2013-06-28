Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab3F1Dc2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 23:32:28 -0400
Received: from mail-yh0-f54.google.com ([209.85.213.54]:47454 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135Ab3F1Dc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 23:32:26 -0400
From: Fabio Estevam <festevam@gmail.com>
To: gregkh@linuxfoundation.org
Cc: shawn.guo@linaro.org, kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH 4/5] imx-drm: ipu-dp: Introduce IPUV3_NUM_FLOWS
Date: Fri, 28 Jun 2013 00:32:04 -0300
Message-Id: <1372390325-7566-4-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372390325-7566-1-git-send-email-festevam@gmail.com>
References: <1372390325-7566-1-git-send-email-festevam@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

IPUv3 has a total of 3 flows (one synchronous flow and 2 asynchronous flows).

Let's add a definition for such number in order to let the code easier to
understand.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/staging/imx-drm/ipu-v3/ipu-dp.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-dp.c b/drivers/staging/imx-drm/ipu-v3/ipu-dp.c
index 6e0e9f1..3bdff6af 100644
--- a/drivers/staging/imx-drm/ipu-v3/ipu-dp.c
+++ b/drivers/staging/imx-drm/ipu-v3/ipu-dp.c
@@ -46,6 +46,8 @@
 #define DP_COM_CONF_CSC_DEF_BG		(2 << 8)
 #define DP_COM_CONF_CSC_DEF_BOTH	(1 << 8)
 
+#define IPUV3_NUM_FLOWS		3
+
 struct ipu_dp_priv;
 
 struct ipu_dp {
@@ -67,7 +69,7 @@ struct ipu_dp_priv {
 	struct ipu_soc *ipu;
 	struct device *dev;
 	void __iomem *base;
-	struct ipu_flow flow[3];
+	struct ipu_flow flow[IPUV3_NUM_FLOWS];
 	struct mutex mutex;
 	int use_count;
 };
@@ -322,7 +324,7 @@ int ipu_dp_init(struct ipu_soc *ipu, struct device *dev, unsigned long base)
 
 	mutex_init(&priv->mutex);
 
-	for (i = 0; i < 3; i++) {
+	for (i = 0; i < IPUV3_NUM_FLOWS; i++) {
 		priv->flow[i].foreground.foreground = 1;
 		priv->flow[i].base = priv->base + ipu_dp_flow_base[i];
 		priv->flow[i].priv = priv;
-- 
1.8.1.2

