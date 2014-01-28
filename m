Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910AbaA1Bn0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 20:43:26 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:33806 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbaA1BnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 20:43:25 -0500
From: Brandon Stewart <stewartb2@gmail.com>
To: benh@kernel.crashing.org
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] Fixed some coding style problems
Date: Mon, 27 Jan 2014 19:43:17 -0600
Message-Id: <1390873397-4470-1-git-send-email-stewartb2@gmail.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Brandon Stewart <stewartb2@gmail.com>
---
 drivers/macintosh/adb.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/macintosh/adb.c b/drivers/macintosh/adb.c
index 04a5049..53611de 100644
--- a/drivers/macintosh/adb.c
+++ b/drivers/macintosh/adb.c
@@ -38,7 +38,7 @@
 #include <linux/platform_device.h>
 #include <linux/mutex.h>
 
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #ifdef CONFIG_PPC
 #include <asm/prom.h>
 #include <asm/machdep.h>
@@ -193,8 +193,7 @@ static int adb_scan_bus(void)
 					break;
 
 				noMovement = 0;
-			}
-			else {
+			} else {
 				/*
 				 * No devices left at address i; move the
 				 * one(s) we moved to `highFree' back to i.
@@ -502,7 +501,7 @@ void
 adb_input(unsigned char *buf, int nb, int autopoll)
 {
 	int i, id;
-	static int dump_adb_input = 0;
+	static int dump_adb_input;
 	unsigned long flags;
 	
 	void (*handler)(unsigned char *, int, int);
@@ -624,8 +623,7 @@ do_adb_query(struct adb_request *req)
 {
 	int	ret = -EINVAL;
 
-	switch(req->data[1])
-	{
+	switch(req->data[1]) {
 	case ADB_QUERY_GETDEVINFO:
 		if (req->nbytes < 3)
 			break;
@@ -697,7 +695,7 @@ static ssize_t adb_read(struct file *file, char __user *buf,
 	int ret = 0;
 	struct adbdev_state *state = file->private_data;
 	struct adb_request *req;
-	DECLARE_WAITQUEUE(wait,current);
+	DECLARE_WAITQUEUE(wait, current);
 	unsigned long flags;
 
 	if (count < 2)
@@ -794,8 +792,8 @@ static ssize_t adb_write(struct file *file, const char __user *buf,
 	}
 	/* Special case for ADB_BUSRESET request, all others are sent to
 	   the controller */
-	else if ((req->data[0] == ADB_PACKET)&&(count > 1)
-		&&(req->data[1] == ADB_BUSRESET)) {
+	else if ((req->data[0] == ADB_PACKET) && (count > 1)
+		&& (req->data[1] == ADB_BUSRESET)) {
 		ret = do_adb_reset_bus();
 		up(&adb_probe_mutex);
 		atomic_dec(&state->n_pending);
-- 
1.8.5.3

