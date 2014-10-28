Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933976AbaJ1HYW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 03:24:22 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:4916 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756904AbaJ1HYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 03:24:18 -0400
From: Yao Dongdong <yaodongdong@huawei.com>
To: <edubezval@gmail.com>, <rui.zhang@intel.com>
CC: <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lizefan@huawei.com>
Subject: [PATCH 1/2 resend] Thermal:Fix memory leak if occur goto unregister
Date: Tue, 28 Oct 2014 07:40:24 +0000
Message-ID: <1414482025-4482-1-git-send-email-yaodongdong@huawei.com>
X-Mailer: git-send-email 1.8.3.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.189]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yao Dongdong <yaodongdong@huawei.com>
Acked-by: Eduardo Valentin <edubezval@gmail.com>
---
 drivers/thermal/thermal_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index 9bf10aa..d358605 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -1581,6 +1581,7 @@ struct thermal_zone_device *thermal_zone_device_register(const char *type,
 unregister:
 	release_idr(&thermal_tz_idr, &thermal_idr_lock, tz->id);
 	device_unregister(&tz->device);
+	kfree(tz);
 	return ERR_PTR(result);
 }
 EXPORT_SYMBOL_GPL(thermal_zone_device_register);
-- 
1.8.3.4

