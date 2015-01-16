Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415AbbAPK4U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 05:56:20 -0500
Received: from www.osadl.org ([62.245.132.105]:48656 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753844AbbAPK4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 05:56:19 -0500
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Lucas Stach <l.stach@pengutronix.de>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Antoine Schweitzer-Chaput <antoine@schweitzer-chaput.fr>,
        linux-kernel@vger.kernel.org, Nicholas Mc Guire <der.herr@hofr.at>
Subject: [PATCH] gpu: ipu-v3: wait_for_completion_timeout does not return negativ status
Date: Fri, 16 Jan 2015 11:48:02 +0100
Message-Id: <1421405282-8951-1-git-send-email-der.herr@hofr.at>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---

Patch is against 3.19.0-rc3 -next-20150109

This patch was compiletested with imx_v6_v7_defconfig + 
CONFIG_RESET_CONTROLLER=y, CONFIG_IMX_IPUV3_CORE=m

 drivers/gpu/ipu-v3/ipu-dc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/ipu-v3/ipu-dc.c b/drivers/gpu/ipu-v3/ipu-dc.c
index 2326c75..0ffa659 100644
--- a/drivers/gpu/ipu-v3/ipu-dc.c
+++ b/drivers/gpu/ipu-v3/ipu-dc.c
@@ -282,7 +282,7 @@ void ipu_dc_disable_channel(struct ipu_dc *dc)
 	enable_irq(irq);
 	ret = wait_for_completion_timeout(&priv->comp, msecs_to_jiffies(50));
 	disable_irq(irq);
-	if (ret <= 0) {
+	if (ret == 0) {
 		dev_warn(priv->dev, "DC stop timeout after 50 ms\n");
 
 		val = readl(dc->base + DC_WR_CH_CONF);
-- 
1.7.10.4

