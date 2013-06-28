Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934Ab3F1Q4D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 12:56:03 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:48249 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755895Ab3F1Q4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 12:56:00 -0400
From: Fabio Estevam <festevam@gmail.com>
To: gregkh@linuxfoundation.org
Cc: kernel@pengutronix.de, shawn.guo@linaro.org, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH v2 4/4] imx-drm: ipu-dp: Introduce IPUV3_NUM_FLOWS
Date: Fri, 28 Jun 2013 13:55:30 -0300
Message-Id: <1372438530-1819-4-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372438530-1819-1-git-send-email-festevam@gmail.com>
References: <1372438530-1819-1-git-send-email-festevam@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

IPUv3 has a total of 3 flows (one synchronous flow and 2 asynchronous flows).

Let's add a definition for such number in order to let the code easier to
understand.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
Changes since v1:
- Merged patches 4 and 5 from previous series
- Fix the comparison logic in 'if ((flow >> 1) >= IPUV3_NUM_FLOWS)'
---
 drivers/staging/imx-drm/ipu-v3/ipu-dp.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-dp.c b/drivers/staging/imx-drm/ipu-v3/ipu-dp.c
index 6e0e9f1..231afd6 100644
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
@@ -280,7 +282,7 @@ struct ipu_dp *ipu_dp_get(struct ipu_soc *ipu, unsigned int flow)
 	struct ipu_dp_priv *priv = ipu->dp_priv;
 	struct ipu_dp *dp;
 
-	if (flow > 5)
+	if ((flow >> 1) >= IPUV3_NUM_FLOWS)
 		return ERR_PTR(-EINVAL);
 
 	if (flow & 1)
@@ -322,7 +324,7 @@ int ipu_dp_init(struct ipu_soc *ipu, struct device *dev, unsigned long base)
 
 	mutex_init(&priv->mutex);
 
-	for (i = 0; i < 3; i++) {
+	for (i = 0; i < IPUV3_NUM_FLOWS; i++) {
 		priv->flow[i].foreground.foreground = 1;
 		priv->flow[i].base = priv->base + ipu_dp_flow_base[i];
 		priv->flow[i].priv = priv;
-- 
1.8.1.2

