Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252AbaBMQkZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 11:40:25 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:46401 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbaBMQkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 11:40:24 -0500
From: Semen Protsenko <semen.protsenko@linaro.org>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Pawel Moll <pawel.moll@arm.com>
Subject: [PATCH] mfd: vexpress-sysreg: initialize "site" variable
Date: Thu, 13 Feb 2014 18:39:54 +0200
Message-Id: <1392309594-28229-1-git-send-email-semen.protsenko@linaro.org>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"site" variable should be initialized with 0 so that
when "site" property doesn't exist in DTB it can be handled correctly.

"0" value means board site number is motherboard (see
Documentation/devicetree/bindings/arm/vexpress.txt for details).

Signed-off-by: Semen Protsenko <semen.protsenko@linaro.org>
---
 drivers/mfd/vexpress-sysreg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/vexpress-sysreg.c b/drivers/mfd/vexpress-sysreg.c
index 981bef4..35281e8 100644
--- a/drivers/mfd/vexpress-sysreg.c
+++ b/drivers/mfd/vexpress-sysreg.c
@@ -168,7 +168,7 @@ static void *vexpress_sysreg_config_func_get(struct device *dev,
 		struct device_node *node)
 {
 	struct vexpress_sysreg_config_func *config_func;
-	u32 site;
+	u32 site = 0;
 	u32 position = 0;
 	u32 dcc = 0;
 	u32 func_device[2];
-- 
1.8.5.3

