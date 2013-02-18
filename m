Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605Ab3BRTJW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 14:09:22 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:36137 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754170Ab3BRTJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 14:09:21 -0500
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 1/2] base: memory: fix soft/hard_offline_page permissions
Date: Mon, 18 Feb 2013 21:09:03 +0200
Message-ID: <1361214544-14403-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

those two sysfs files don't have a 'show' method,
so they shouldn't have a read permission. Thanks
to Greg Kroah-Hartman for actually looking into
the source code and figuring out we had a real bug
with these two files.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/base/memory.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 987604d..83d0b17 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -494,8 +494,8 @@ store_hard_offline_page(struct device *dev,
 	return ret ? ret : count;
 }
 
-static DEVICE_ATTR(soft_offline_page, 0644, NULL, store_soft_offline_page);
-static DEVICE_ATTR(hard_offline_page, 0644, NULL, store_hard_offline_page);
+static DEVICE_ATTR(soft_offline_page, S_IWUSR, NULL, store_soft_offline_page);
+static DEVICE_ATTR(hard_offline_page, S_IWUSR, NULL, store_hard_offline_page);
 
 static __init int memory_fail_init(void)
 {
-- 
1.8.1.rc1.5.g7e0651a

