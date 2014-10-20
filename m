Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073AbaJTI2N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 04:28:13 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:45676 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022AbaJTI2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 04:28:10 -0400
Message-ID: <5444C78F.10404@huawei.com>
Date: Mon, 20 Oct 2014 16:27:59 +0800
From: Yao Dongdong <yaodongdong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Zhang Rui <rui.zhang@intel.com>, Eduardo Valentin <edubezval@gmail.com>
CC: <linux-pm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        <yaodongdong@huawei.com>
Subject: [PATCH 2/2] Thermal:Remove usless if(!result) before return tz
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.110.51.36]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

result is always zero when comes here.

Signed-off-by:yaodongdong@huawei.com

---
 drivers/thermal/thermal_core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index 5b7d466..19cac8e 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -1568,8 +1568,7 @@ struct thermal_zone_device *thermal_zone_device_register(const char *type,

    thermal_zone_device_update(tz);

-   if (!result)
-       return tz;
+   return tz;

 unregister:
    release_idr(&thermal_tz_idr, &thermal_idr_lock, tz->id);
--
1.8.0.1


