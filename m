Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967508AbaFTNhu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 09:37:50 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:48468 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965921AbaFTNht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 09:37:49 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH] gpu: ipu-v3: ipu-common.c:  Cleaning up return of uninitialized variable
Date: Fri, 20 Jun 2014 15:38:46 +0200
Message-Id: <1403271526-16947-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before when there was an error a uninitialized variable would be returnd.
Now it returns -ENODEV

This was found using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/gpu/ipu-v3/ipu-common.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-common.c b/drivers/gpu/ipu-v3/ipu-common.c
index 04e7b2e..d01c77d 100644
--- a/drivers/gpu/ipu-v3/ipu-common.c
+++ b/drivers/gpu/ipu-v3/ipu-common.c
@@ -1092,7 +1092,7 @@ static int ipu_add_client_devices(struct ipu_soc *ipu, unsigned long ipu_base)
 {
 	struct device *dev = ipu->dev;
 	unsigned i;
-	int id, ret;
+	int id;
 
 	mutex_lock(&ipu_client_id_mutex);
 	id = ipu_client_id;
@@ -1125,7 +1125,7 @@ static int ipu_add_client_devices(struct ipu_soc *ipu, unsigned long ipu_base)
 err_register:
 	platform_device_unregister_children(to_platform_device(dev));
 
-	return ret;
+	return -ENODEV;
 }
 
 
-- 
1.7.10.4

