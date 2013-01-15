Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903Ab3AOM4z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 07:56:55 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:38058 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756823Ab3AOM4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 07:56:51 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, sameo@linux.intel.com,
        Philippe Langlais <philippe.langlais@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Philippe Langlais <philippe.langlais@linaro.org>
Subject: [PATCH 14/26] mfd: ab8500-debugfs: Fix introduced compiler time warnings
Date: Tue, 15 Jan 2013 12:55:54 +0000
Message-Id: <1358254566-12419-15-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358254566-12419-1-git-send-email-lee.jones@linaro.org>
References: <1358254566-12419-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philippe Langlais <philippe.langlais@stericsson.com>

Some simple fixes regarding pre-processor usage.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Philippe Langlais <philippe.langlais@linaro.org>
---
 drivers/mfd/ab8500-debugfs.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/ab8500-debugfs.c b/drivers/mfd/ab8500-debugfs.c
index 78a8e0c..7698d30 100644
--- a/drivers/mfd/ab8500-debugfs.c
+++ b/drivers/mfd/ab8500-debugfs.c
@@ -776,9 +776,9 @@ static ssize_t hwreg_common_write(char *b, struct hwreg_cfg *cfg,
 	/* args are ok, update target cfg (mainly for read) */
 	*cfg = loc;
 
-#if ABB_HWREG_DEBUG
-	pr_warn("HWREG request: %s, %s, addr=0x%08X, mask=0x%X, shift=%d
-			value=0x%X\n", (write) ? "write" : "read",
+#ifdef ABB_HWREG_DEBUG
+	pr_warn("HWREG request: %s, %s, addr=0x%08X, mask=0x%X, shift=%d"
+			"value=0x%X\n", (write) ? "write" : "read",
 			REG_FMT_DEC(cfg) ? "decimal" : "hexa",
 			cfg->addr, cfg->mask, cfg->shift, val);
 #endif
-- 
1.7.9.5

