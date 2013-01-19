Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751398Ab3ASNGw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 08:06:52 -0500
Received: from mail-ea0-f180.google.com ([209.85.215.180]:42086 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862Ab3ASNGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 08:06:51 -0500
From: Cong Ding <dinggnu@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Cc: Cong Ding <dinggnu@gmail.com>
Subject: [PATCH] of: dma.c: fix memory leakage
Date: Sat, 19 Jan 2013 14:06:44 +0100
Message-Id: <1358600805-20193-1-git-send-email-dinggnu@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The memory allocated to ofdma might be a leakage when error occurs.

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 drivers/of/dma.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/of/dma.c b/drivers/of/dma.c
index 59631b2..583e50e3 100644
--- a/drivers/of/dma.c
+++ b/drivers/of/dma.c
@@ -107,6 +107,7 @@ int of_dma_controller_register(struct device_node *np,
 	if (!nbcells) {
 		pr_err("%s: #dma-cells property is missing or invalid\n",
 		       __func__);
+		kfree(ofdma);
 		return -EINVAL;
 	}
 
-- 
1.7.10.4

