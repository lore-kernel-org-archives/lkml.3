Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519AbbAGJnx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 04:43:53 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:12897 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbbAGJnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 04:43:51 -0500
From: Kaixu Xia <xiakaixu@huawei.com>
To: <mathieu.poirier@linaro.org>
CC: <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <xiakaixu@huawei.com>, <kaixu.xia@linaro.org>
Subject: [PATCH] coresight: fix return value judgement in of_coresight.c
Date: Wed, 7 Jan 2015 17:31:06 +0800
Message-ID: <1420623066-56812-1-git-send-email-xiakaixu@huawei.com>
X-Mailer: git-send-email 1.8.5.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The right return value is rdev, so we should judge it.

Signed-off-by: Kaixu Xia <xiakaixu@huawei.com>
---
 drivers/coresight/of_coresight.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/coresight/of_coresight.c b/drivers/coresight/of_coresight.c
index 5030c07..5b5f188 100644
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
1.8.5.5

