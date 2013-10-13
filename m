Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609Ab3JMOqe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 10:46:34 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:46047 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497Ab3JMOqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 10:46:33 -0400
From: "ethan.zhao" <ethan.kernel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, "ethan.zhao" <ethan.kernel@gmail.com>
Subject: [PATCH] drivers/base/core.c: output device renaming messages with dev_dbg(). 
Date: Sun, 13 Oct 2013 22:44:45 +0800
Message-Id: <1381675485-695-1-git-send-email-ethan.kernel@gmail.com>
X-Mailer: git-send-email 1.7.12.4 (Apple Git-37)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "ethan.zhao" <ethan.kernel@gmail.com>

Replace pr_debug() with dev_dbg().

Signed-off-by: ethan.zhao <ethan.kernel@gmail.com>
---
 drivers/base/core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 2d1c6ba..8c4d3dc 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1904,8 +1904,7 @@ int device_rename(struct device *dev, const char *new_name)
 	if (!dev)
 		return -EINVAL;
 
-	pr_debug("device: '%s': %s: renaming to '%s'\n", dev_name(dev),
-		 __func__, new_name);
+	dev_dbg(dev, "renaming to %s\n", new_name);
 
 	old_device_name = kstrdup(dev_name(dev), GFP_KERNEL);
 	if (!old_device_name) {
-- 
1.7.12.4 (Apple Git-37)

