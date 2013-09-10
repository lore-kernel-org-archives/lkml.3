Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460Ab3IJLNz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 07:13:55 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:37882 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab3IJLNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 07:13:53 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, sameo@linux.intel.com, sachin.kamat@linaro.org,
        Jin Park <jinyoungp@nvidia.com>
Subject: [PATCH 1/1] mfd: aat2870: Fix sparse error
Date: Tue, 10 Sep 2013 16:25:50 +0530
Message-Id: <1378810550-5450-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the following error:
drivers/mfd/aat2870-core.c:296:20: error:
incompatible types in comparison expression (different type sizes)

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Jin Park <jinyoungp@nvidia.com>
---
 drivers/mfd/aat2870-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/aat2870-core.c b/drivers/mfd/aat2870-core.c
index 6f68472..14d9542 100644
--- a/drivers/mfd/aat2870-core.c
+++ b/drivers/mfd/aat2870-core.c
@@ -293,7 +293,7 @@ static ssize_t aat2870_reg_write_file(struct file *file,
 	unsigned long addr, val;
 	int ret;
 
-	buf_size = min(count, (sizeof(buf)-1));
+	buf_size = min(count, (size_t)(sizeof(buf)-1));
 	if (copy_from_user(buf, user_buf, buf_size)) {
 		dev_err(aat2870->dev, "Failed to copy from user\n");
 		return -EFAULT;
-- 
1.7.9.5

