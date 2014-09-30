Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243AbaI3R7O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 13:59:14 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:60483 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805AbaI3R7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 13:59:13 -0400
From: Karthik Nayak <karthik.188@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org, gamerh2o@gmail.com, gregkh@linuxfoundation.org,
        mark.einon@gmail.com, Karthik Nayak <karthik.188@gmail.com>
Subject: [PATCH] staging: bcm: remove unnecessary else statement
Date: Tue, 30 Sep 2014 23:29:00 +0530
Message-Id: <1412099940-4118-1-git-send-email-karthik.188@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed the else statement occurring after an if statement with a
return value as per checkpatch warning.

Signed-off-by: Karthik Nayak <karthik.188@gmail.com>
---
 drivers/staging/bcm/InterfaceMisc.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/bcm/InterfaceMisc.c b/drivers/staging/bcm/InterfaceMisc.c
index e5bcfec..1f31b8f 100644
--- a/drivers/staging/bcm/InterfaceMisc.c
+++ b/drivers/staging/bcm/InterfaceMisc.c
@@ -102,12 +102,11 @@ int InterfaceWRM(struct bcm_interface_adapter *psIntfAdapter,
 				DBG_LVL_ALL, "WRM failed status :%d", retval);
 		psIntfAdapter->psAdapter->DeviceAccess = false;
 		return retval;
-	} else {
-		psIntfAdapter->psAdapter->DeviceAccess = false;
-		BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_OTHERS, WRM,
-				DBG_LVL_ALL, "WRM sent %d", retval);
-		return STATUS_SUCCESS;
 	}
+	psIntfAdapter->psAdapter->DeviceAccess = false;
+	BCM_DEBUG_PRINT(psIntfAdapter->psAdapter, DBG_TYPE_OTHERS, WRM,
+			DBG_LVL_ALL, "WRM sent %d", retval);
+	return STATUS_SUCCESS;
 }
 
 int BcmRDM(void *arg,
-- 
2.1.0

