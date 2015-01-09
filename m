Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758388AbbAIX5w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 18:57:52 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:34333 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758290AbbAIX5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 18:57:47 -0500
From: mathieu.poirier@linaro.org
To: gregkh@linuxfoundation.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mathieu.poirier@linaro.org
Subject: [PATCH 11/11] coresight: fixing validity check on remote device
Date: Fri,  9 Jan 2015 16:57:22 -0700
Message-Id: <1420847842-31769-12-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1420847842-31769-1-git-send-email-mathieu.poirier@linaro.org>
References: <1420847842-31769-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kaixu Xia <xiakaixu@huawei.com>

A validity check should be made on the remote device, i.e rdev,
rather than the current device.

Signed-off-by: Kaixu Xia <xiakaixu@huawei.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/coresight/of_coresight.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/coresight/of_coresight.c b/drivers/coresight/of_coresight.c
index 89ebbe29ac97..9a5ff56f34d9 100644
--- a/drivers/coresight/of_coresight.c
+++ b/drivers/coresight/of_coresight.c
@@ -174,7 +174,7 @@ struct coresight_platform_data *of_get_coresight_platform_data(
 				continue;
 
 			rdev = of_coresight_get_endpoint_device(rparent);
-			if (!dev)
+			if (!rdev)
 				continue;
 
 			pdata->child_names[i] = dev_name(rdev);
-- 
1.9.1

