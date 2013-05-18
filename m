Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801Ab3ERJuk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 May 2013 05:50:40 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:39383 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140Ab3ERJui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 May 2013 05:50:38 -0400
X-AuditID: cbfee691-b7fef6d000002d62-c1-51974eec4122
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        Amit Dinel Kachhap <amit.kachhap@linaro.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH 1/3] Thermal: core: Ask .get_trip_temp() to register thermal
 zone device.
Date: Sat, 18 May 2013 18:50:26 +0900
Message-id: <1368870627-1143-1-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsWyRsSkSPeN3/RAg7Y+LYslD6YwWqzZ/5PJ
	ovPsE2aLy7vmsFl87j3CaHG7cQWbxZOHfWwO7B6L97xk8rhzbQ+bR9+WVYwex29sZ/L4vEku
	gDWKyyYlNSezLLVI3y6BK2PxqoWMBb0cFWv+CjYwvmPrYuTkkBAwkZiy6AMrhC0mceHeerC4
	kMBSRokju7hgaubdbmHqYuQCii9ilPjx9heU08Ik8f7pRxaQKjYBHYn/+26yg9giAjISU6/s
	ZwUpYhb4xCgx6eAOJpCEsEC0xJVFJ4FWcHCwCKhKrLoQBhLmFXCXeNJ+lxkkLCGgIDFnkg1I
	q4RAM7vE+ilnmEFqWAQEJL5NPsQCUSMrsekAM8RxkhIHV9xgmcAouICRYRWjaGpBckFxUnqR
	qV5xYm5xaV66XnJ+7iZGYMie/vds4g7G+wesDzEmA42byCwlmpwPDPm8knhDYzMjC1MTU2Mj
	c0sz0oSVxHnVW6wDhQTSE0tSs1NTC1KL4otKc1KLDzEycXBKNTC6B63q0D7Q/mTJ3F9/rZm7
	rKdHTFh4MG6+enxeT/5t5uZ2izsbtv+sa/0m2+q8nkuufZ/29PCJuxq267w5H9d3k6t5b8He
	/2aV6e9582Sz5VwOON364BPir3zGdIfEV90HvTOL2Qq8VD4+23C0MEwgXeWo/oaeZq8Py8os
	jpyU031dnZKZ5KDEUpyRaKjFXFScCAD2LsrabwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsVy+t9jAd03ftMDDb4sVLJY8mAKo8Wa/T+Z
	LDrPPmG2uLxrDpvF594jjBa3G1ewWTx52MfmwO6xeM9LJo871/awefRtWcXocfzGdiaPz5vk
	AlijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4Du
	UFIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jBmLF61kLGgl6NizV/BBsZ3
	bF2MnBwSAiYS8263MEHYYhIX7q0HinNxCAksYpT48fYXE4TTwiTx/ulHFpAqNgEdif/7brKD
	2CICMhJTr+xnBSliFvjEKDHp4A6wUcIC0RJXFp0EGsXBwSKgKrHqQhhImFfAXeJJ+11mkLCE
	gILEnEk2Exi5FzAyrGIUTS1ILihOSs810itOzC0uzUvXS87P3cQIjoln0jsYVzVYHGIU4GBU
	4uGd4TwtUIg1say4MvcQowQHs5II7/NioBBvSmJlVWpRfnxRaU5q8SHGZKDdE5mlRJPzgfGa
	VxJvaGxiZmRpZG5oYWRsTpqwkjjvwVbrQCGB9MSS1OzU1ILUIpgtTBycUg2MtbtvW2212l9g
	HXHMJ0e7/9dizTDJtEkr6lyiTvHObPrF+HrzHQ/1orNccfe5pf8/95UKrHlY9KzziKpF/prn
	OS8CDh6QmxMb5sa+ueODaK1EXhXXA66F85YZSZVe/9zaPZ1rlk7iPf6m2ssdVvyM77kPnD+2
	tbRCou37zz+TN+ZOs/5q7imhxFKckWioxVxUnAgAG0Umgs0CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a requirement needing .get_trip_temp() callback
function for registering thermal zone device. This function is
used when thermal zone is updated and essential where thermal core
handles thermal trip based only polling way not hw interrupt.

Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
---
 drivers/thermal/thermal_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index d755440..f753f48 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -1624,7 +1624,7 @@ struct thermal_zone_device *thermal_zone_device_register(const char *type,
 	if (!ops || !ops->get_temp)
 		return ERR_PTR(-EINVAL);
 
-	if (trips > 0 && !ops->get_trip_type)
+	if (trips > 0 && (!ops->get_trip_type || !ops->get_trip_temp))
 		return ERR_PTR(-EINVAL);
 
 	tz = kzalloc(sizeof(struct thermal_zone_device), GFP_KERNEL);
-- 
1.7.9.5

