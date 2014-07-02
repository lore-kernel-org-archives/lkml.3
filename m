Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640AbaGBP3q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 11:29:46 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:40769 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413AbaGBP3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 11:29:43 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, linus.walleij@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 10/12] mfd: aat2870-core: Stop using obsolte simple_strtoul()
Date: Wed,  2 Jul 2014 16:28:42 +0100
Message-Id: <1404314924-23564-11-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1404314924-23564-1-git-send-email-lee.jones@linaro.org>
References: <1404314924-23564-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Soothes checkpatch warning:

    WARNING: simple_strtoul is obsolete, use kstrtoul instead
    #306: FILE: drivers/mfd/aat2870-core.c:306:
    +	addr = simple_strtoul(start, &start, 16);

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/aat2870-core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/aat2870-core.c b/drivers/mfd/aat2870-core.c
index 14d9542..4e6e03d 100644
--- a/drivers/mfd/aat2870-core.c
+++ b/drivers/mfd/aat2870-core.c
@@ -303,7 +303,10 @@ static ssize_t aat2870_reg_write_file(struct file *file,
 	while (*start == ' ')
 		start++;
 
-	addr = simple_strtoul(start, &start, 16);
+	ret = kstrtoul(start, 16, &addr);
+	if (ret)
+		return ret;
+
 	if (addr >= AAT2870_REG_NUM) {
 		dev_err(aat2870->dev, "Invalid address, 0x%lx\n", addr);
 		return -EINVAL;
-- 
1.8.3.2

