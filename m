Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106Ab3CQI32 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 04:29:28 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:63351 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028Ab3CQI3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 04:29:24 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH] [SCSI]: print the msgbytes and statusbyte from scsi result
Date: Sun, 17 Mar 2013 17:29:11 +0900
Message-Id: <1363508951-3011-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Introduce msgbyte and statusbyte in the prints as part of the
result which is returned by the lower layer driver in response to
SCSI command issued, in case of any error conditions.

Purpose of adding these prints is to convey, during any I/O
error case, which condition exactly has happened in lower device and
from the prints we can directly deduce, what is the status of command
issued. This will help to quickly debug the scenario and also making
a test case to create new scenarios.

Also change the printk to more appropriate pr_* macro.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 drivers/scsi/constants.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index 76e4c03..77bb1dc 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -1445,8 +1445,10 @@ void scsi_show_result(int result)
 
 void scsi_show_result(int result)
 {
-	printk("Result: hostbyte=0x%02x driverbyte=0x%02x\n",
-	       host_byte(result), driver_byte(result));
+	pr_info("Result: hostbyte=0x%02x driverbyte=0x%02x"
+			"msgbyte=0x%02x statusbyte=0x%02x\n",
+	       host_byte(result), driver_byte(result), msg_byte(result),
+							status_byte(result));
 }
 
 #endif
-- 
1.7.9.5

