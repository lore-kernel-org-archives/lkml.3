Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933319AbaFSPNT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 11:13:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51220 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932357AbaFSPNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 11:13:17 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: lee.jones@linaro.org
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mfd: arizona: Add comment to explain non-devm regulator_get
Date: Thu, 19 Jun 2014 16:04:23 +0100
Message-Id: <1403190263-32737-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To avoid someone attempting to change this regulator_get back into a
devm_regulator_get put a comment in explaining that devres can't be used
here as the regulator will be destroyed before devres calls
regulator_put.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-core.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index 27936fe..b4f22e7 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -683,6 +683,12 @@ int arizona_dev_init(struct arizona *arizona)
 		goto err_early;
 	}
 
+	/**
+	 * Don't use devres here because the only device we have to get
+	 * against is the MFD device and DCVDD will likely be supplied by
+	 * one of its children. Meaning that the regulator will be
+	 * destroyed by the time devres calls regulator put.
+	 */
 	arizona->dcvdd = regulator_get(arizona->dev, "DCVDD");
 	if (IS_ERR(arizona->dcvdd)) {
 		ret = PTR_ERR(arizona->dcvdd);
-- 
1.7.2.5

