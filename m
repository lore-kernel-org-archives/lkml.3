Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591Ab3F1Dca (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 23:32:30 -0400
Received: from mail-yh0-f44.google.com ([209.85.213.44]:59225 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754543Ab3F1Dc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 23:32:28 -0400
From: Fabio Estevam <festevam@gmail.com>
To: gregkh@linuxfoundation.org
Cc: shawn.guo@linaro.org, kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH 5/5] imx-drm: ipu-dp: Adjust the maximum number of flows
Date: Fri, 28 Jun 2013 00:32:05 -0300
Message-Id: <1372390325-7566-5-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372390325-7566-1-git-send-email-festevam@gmail.com>
References: <1372390325-7566-1-git-send-email-festevam@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

Later in ipu_dp_get() the index of the flow array is calculated by:
flow >> 1

So adjust its maximum to IPUV3_NUM_FLOWS << 1.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/staging/imx-drm/ipu-v3/ipu-dp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-dp.c b/drivers/staging/imx-drm/ipu-v3/ipu-dp.c
index 3bdff6af..ae2c199 100644
--- a/drivers/staging/imx-drm/ipu-v3/ipu-dp.c
+++ b/drivers/staging/imx-drm/ipu-v3/ipu-dp.c
@@ -282,7 +282,7 @@ struct ipu_dp *ipu_dp_get(struct ipu_soc *ipu, unsigned int flow)
 	struct ipu_dp_priv *priv = ipu->dp_priv;
 	struct ipu_dp *dp;
 
-	if (flow > 5)
+	if (flow > IPUV3_NUM_FLOWS << 1)
 		return ERR_PTR(-EINVAL);
 
 	if (flow & 1)
-- 
1.8.1.2

