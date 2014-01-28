Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbaA1DHn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 22:07:43 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:51976 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428AbaA1DHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 22:07:41 -0500
From: Brandon Stewart <stewartb2@gmail.com>
To: benh@kernel.crashing.org
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] Fix coding style errors
Date: Mon, 27 Jan 2014 21:07:34 -0600
Message-Id: <1390878454-4329-1-git-send-email-stewartb2@gmail.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I corrected several coding errors.

Signed-off-by: Brandon Stewart <stewartb2@gmail.com>
---
 drivers/macintosh/adb.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/macintosh/adb.c b/drivers/macintosh/adb.c
index 53611de..dd3f49a 100644
--- a/drivers/macintosh/adb.c
+++ b/drivers/macintosh/adb.c
@@ -623,7 +623,7 @@ do_adb_query(struct adb_request *req)
 {
 	int	ret = -EINVAL;
 
-	switch(req->data[1]) {
+	switch (req->data[1]) {
 	case ADB_QUERY_GETDEVINFO:
 		if (req->nbytes < 3)
 			break;
@@ -792,8 +792,9 @@ static ssize_t adb_write(struct file *file, const char __user *buf,
 	}
 	/* Special case for ADB_BUSRESET request, all others are sent to
 	   the controller */
-	else if ((req->data[0] == ADB_PACKET) && (count > 1)
-		&& (req->data[1] == ADB_BUSRESET)) {
+	else if (req->data[0] == ADB_PACKET &&
+		req->data[1] == ADB_BUSRESET &&
+		count > 1) {
 		ret = do_adb_reset_bus();
 		up(&adb_probe_mutex);
 		atomic_dec(&state->n_pending);
-- 
1.8.5.3

