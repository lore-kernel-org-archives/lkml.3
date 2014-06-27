Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581AbaF0Uj4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 16:39:56 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:35559 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751406AbaF0Ujy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 16:39:54 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkYHAETVrVNXQCoO/2dsb2JhbABbgw2rbwUBAQEBAQEFAW0BmQKBDRd1hDEvEwEPViwYN4guAxUBvXUNhlAXhWSGe4ImHYQtBZhfgX6LP4IshhCCAIFEOw
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org
Subject: [PATCH 1/1] drivers/input/touchscreen/edt-ft5x06.c: remove unnecessary null test before debugfs_remove_recursive
Date: Fri, 27 Jun 2014 22:38:32 +0200
Message-Id: <1403901512-9710-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch warning:
"WARNING: debugfs_remove_recursive(NULL) is safe this check is probably not required"

Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Henrik Rydberg <rydberg@euromail.se>
Cc: linux-input@vger.kernel.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/input/touchscreen/edt-ft5x06.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/input/touchscreen/edt-ft5x06.c b/drivers/input/touchscreen/edt-ft5x06.c
index d4f3399..5a6d50c 100644
--- a/drivers/input/touchscreen/edt-ft5x06.c
+++ b/drivers/input/touchscreen/edt-ft5x06.c
@@ -733,8 +733,7 @@ edt_ft5x06_ts_prepare_debugfs(struct edt_ft5x06_ts_data *tsdata,
 static void
 edt_ft5x06_ts_teardown_debugfs(struct edt_ft5x06_ts_data *tsdata)
 {
-	if (tsdata->debug_dir)
-		debugfs_remove_recursive(tsdata->debug_dir);
+	debugfs_remove_recursive(tsdata->debug_dir);
 	kfree(tsdata->raw_buffer);
 }
 
-- 
1.8.4.5

