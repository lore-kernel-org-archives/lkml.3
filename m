Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100AbaL2M0n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 07:26:43 -0500
Received: from mga09.intel.com ([134.134.136.24]:44091 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751200AbaL2M0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 07:26:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,659,1413270000"; 
   d="scan'208";a="654431768"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org, Andres Salomon <dilinger@queued.net>,
        Paul Fox <pgf@laptop.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1] OLPC: use %*ph specifier instead of passing direct values
Date: Mon, 29 Dec 2014 14:26:50 +0200
Message-Id: <1419856010-9528-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The %*ph specifier allows to dump small buffers in hex format. Let's use it
instead of passing direct values via stack.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/platform/olpc/olpc-ec.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/platform/olpc/olpc-ec.c b/drivers/platform/olpc/olpc-ec.c
index f911952..f99b183 100644
--- a/drivers/platform/olpc/olpc-ec.c
+++ b/drivers/platform/olpc/olpc-ec.c
@@ -192,18 +192,15 @@ static ssize_t ec_dbgfs_cmd_write(struct file *file, const char __user *buf,
 	for (i = 0; i <= ec_cmd_bytes; i++)
 		ec_cmd[i] = ec_cmd_int[i];
 
-	pr_debug("olpc-ec: debugfs cmd 0x%02x with %d args %02x %02x %02x %02x %02x, want %d returns\n",
-			ec_cmd[0], ec_cmd_bytes, ec_cmd[1], ec_cmd[2],
-			ec_cmd[3], ec_cmd[4], ec_cmd[5], ec_dbgfs_resp_bytes);
+	pr_debug("olpc-ec: debugfs cmd 0x%02x with %d args %5ph, want %d returns\n",
+			ec_cmd[0], ec_cmd_bytes, ec_cmd + 1,
+			ec_dbgfs_resp_bytes);
 
 	olpc_ec_cmd(ec_cmd[0], (ec_cmd_bytes == 0) ? NULL : &ec_cmd[1],
 			ec_cmd_bytes, ec_dbgfs_resp, ec_dbgfs_resp_bytes);
 
-	pr_debug("olpc-ec: response %02x %02x %02x %02x %02x %02x %02x %02x (%d bytes expected)\n",
-			ec_dbgfs_resp[0], ec_dbgfs_resp[1], ec_dbgfs_resp[2],
-			ec_dbgfs_resp[3], ec_dbgfs_resp[4], ec_dbgfs_resp[5],
-			ec_dbgfs_resp[6], ec_dbgfs_resp[7],
-			ec_dbgfs_resp_bytes);
+	pr_debug("olpc-ec: response %8ph (%d bytes expected)\n",
+			ec_dbgfs_resp, ec_dbgfs_resp_bytes);
 
 out:
 	mutex_unlock(&ec_dbgfs_lock);
-- 
2.1.3

