Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933945AbaJ1HYV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 03:24:21 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:4913 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756908AbaJ1HYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 03:24:18 -0400
From: Yao Dongdong <yaodongdong@huawei.com>
To: <edubezval@gmail.com>, <rui.zhang@intel.com>
CC: <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lizefan@huawei.com>
Subject: [PATCH 2/2 resend] Thermal:Remove usless if(!result) before return tz
Date: Tue, 28 Oct 2014 07:40:25 +0000
Message-ID: <1414482025-4482-2-git-send-email-yaodongdong@huawei.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1414482025-4482-1-git-send-email-yaodongdong@huawei.com>
References: <1414482025-4482-1-git-send-email-yaodongdong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.189]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

result is always zero when comes here.

Signed-off-by: Yao Dongdong <yaodongdong@huawei.com>
Acked-by: Eduardo Valentin <edubezval@gmail.com>
---
 drivers/thermal/thermal_core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index d358605..a438c95 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -1575,8 +1575,7 @@ struct thermal_zone_device *thermal_zone_device_register(const char *type,
 
 	thermal_zone_device_update(tz);
 
-	if (!result)
-		return tz;
+	return tz;
 
 unregister:
 	release_idr(&thermal_tz_idr, &thermal_idr_lock, tz->id);
-- 
1.8.3.4

