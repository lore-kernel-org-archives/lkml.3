Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977Ab3CVANJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 20:13:09 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:37581 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823Ab3CVANB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 20:13:01 -0400
From: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: andrew@lunn.ch, jason@lakedaemon.net,
        Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
Subject: [PATCH] drivers: cpuidle: kirkwood: fix coccicheck warnings
Date: Fri, 22 Mar 2013 02:12:55 +0200
Message-Id: <1363911175-12502-1-git-send-email-silviupopescu1990@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert all uses of devm_request_and_ioremap() to the newly introduced
devm_ioremap_resource() which provides more consistent error handling.

devm_ioremap_resource() provides its own error messages so all explicit
error messages can be removed from the failure code paths.

Signed-off-by: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
---
 drivers/cpuidle/cpuidle-kirkwood.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/cpuidle/cpuidle-kirkwood.c b/drivers/cpuidle/cpuidle-kirkwood.c
index 670aa1e..53aad73 100644
--- a/drivers/cpuidle/cpuidle-kirkwood.c
+++ b/drivers/cpuidle/cpuidle-kirkwood.c
@@ -66,9 +66,9 @@ static int kirkwood_cpuidle_probe(struct platform_device *pdev)
 	if (res == NULL)
 		return -EINVAL;
 
-	ddr_operation_base = devm_request_and_ioremap(&pdev->dev, res);
-	if (!ddr_operation_base)
-		return -EADDRNOTAVAIL;
+	ddr_operation_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(ddr_operation_base))
+		return PTR_ERR(ddr_operation_base);
 
 	device = &per_cpu(kirkwood_cpuidle_device, smp_processor_id());
 	device->state_count = KIRKWOOD_MAX_STATES;
-- 
1.7.9.5

