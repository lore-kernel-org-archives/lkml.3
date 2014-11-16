Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461AbaKPOpr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 09:45:47 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:53212 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183AbaKPOpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 09:45:46 -0500
From: Antonio Borneo <borneo.antonio@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Jean-Baptiste Maneyrol <jmaneyrol@invensense.com>,
        Antonio Borneo <borneo.antonio@gmail.com>
Subject: [PATCH] HID: i2c-hid: print the correct data in dbg msg
Date: Sun, 16 Nov 2014 22:45:43 +0800
Message-Id: <1416149143-25703-1-git-send-email-borneo.antonio@gmail.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean-Baptiste Maneyrol <jmaneyrol@invensense.com>

From: Jean-Baptiste Maneyrol <jmaneyrol@invensense.com>

Report is received in "buffer"; fix the following i2c_hid_dbg()
to dump data from the correct pointer.

Signed-off-by: Jean-Baptiste Maneyrol <jmaneyrol@invensense.com>
[Antonio Borneo: cleanup and rebase to v3.17]
Signed-off-by: Antonio Borneo <borneo.antonio@gmail.com>
---
 drivers/hid/i2c-hid/i2c-hid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
index 747d544..933bf10 100644
--- a/drivers/hid/i2c-hid/i2c-hid.c
+++ b/drivers/hid/i2c-hid/i2c-hid.c
@@ -437,7 +437,7 @@ static void i2c_hid_init_report(struct hid_report *report, u8 *buffer,
 			report->id, buffer, size))
 		return;
 
-	i2c_hid_dbg(ihid, "report (len=%d): %*ph\n", size, size, ihid->inbuf);
+	i2c_hid_dbg(ihid, "report (len=%d): %*ph\n", size, size, buffer);
 
 	ret_size = buffer[0] | (buffer[1] << 8);
 
-- 
2.1.3

