Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751338AbaFNXeb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 19:34:31 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:48964 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861AbaFNXe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 19:34:26 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Rob Herring <robh+dt@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH] staging: imx-drm: ipu-v3: ipu-common.c:  Cleaning up return of uninitialized variable
Date: Sun, 15 Jun 2014 01:35:21 +0200
Message-Id: <1402788921-15458-2-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402788921-15458-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1402788921-15458-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before when there was an error a uninitialized variable would be returnd.
Now it returns -ENODEV

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/imx-drm/ipu-v3/ipu-common.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-common.c b/drivers/staging/imx-drm/ipu-v3/ipu-common.c
index ca85d3d..468e364 100644
--- a/drivers/staging/imx-drm/ipu-v3/ipu-common.c
+++ b/drivers/staging/imx-drm/ipu-v3/ipu-common.c
@@ -1002,7 +1002,7 @@ static int ipu_add_client_devices(struct ipu_soc *ipu)
 {
 	struct device *dev = ipu->dev;
 	unsigned i;
-	int id, ret;
+	int id;
 
 	mutex_lock(&ipu_client_id_mutex);
 	id = ipu_client_id;
@@ -1025,7 +1025,7 @@ static int ipu_add_client_devices(struct ipu_soc *ipu)
 err_register:
 	platform_device_unregister_children(to_platform_device(dev));
 
-	return ret;
+	return -ENODEV;
 }
 
 
-- 
1.7.10.4

