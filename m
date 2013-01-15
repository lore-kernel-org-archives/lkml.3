Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780Ab3AOM4r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 07:56:47 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:59276 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756725Ab3AOM4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 07:56:44 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, sameo@linux.intel.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 10/26] mfd: ab8500-debugfs: Wake-up device on debugfs IRQ
Date: Tue, 15 Jan 2013 12:55:50 +0000
Message-Id: <1358254566-12419-11-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358254566-12419-1-git-send-email-lee.jones@linaro.org>
References: <1358254566-12419-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure the device wakes up if the debugfs IRQ fires if we're
in suspend mode.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/ab8500-debugfs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/ab8500-debugfs.c b/drivers/mfd/ab8500-debugfs.c
index 71df8e4..b3ddc23 100644
--- a/drivers/mfd/ab8500-debugfs.c
+++ b/drivers/mfd/ab8500-debugfs.c
@@ -616,7 +616,8 @@ static ssize_t ab8500_subscribe_write(struct file *file,
 	}
 
 	err = request_threaded_irq(user_val, NULL, ab8500_debug_handler,
-				   0, "ab8500-debug", &dev->kobj);
+				   IRQF_SHARED | IRQF_NO_SUSPEND,
+				   "ab8500-debug", &dev->kobj);
 	if (err < 0) {
 		printk(KERN_ERR "request_threaded_irq failed %d, %lu\n",
                        err, user_val);
-- 
1.7.9.5

