Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934893AbaFTQZX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 12:25:23 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:35908 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754097AbaFTQZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 12:25:21 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: jkosina@suse.cz
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Fixes kernel panic with Null pointer in hid-appleir.c
Date: Fri, 20 Jun 2014 12:25:15 -0400
Message-Id: <1403281515-5508-1-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In for loop of function appleir_input_configured we hit
a Null pointer after the for loop due to array_size not
being correct needs to be changed to input_dev->keycodemax.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 drivers/hid/hid-appleir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-appleir.c b/drivers/hid/hid-appleir.c
index 0e6a42d..ab0a702 100644
--- a/drivers/hid/hid-appleir.c
+++ b/drivers/hid/hid-appleir.c
@@ -272,7 +272,7 @@ static void appleir_input_configured(struct hid_device *hid,
 	input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_REP);
 
 	memcpy(appleir->keymap, appleir_key_table, sizeof(appleir->keymap));
-	for (i = 0; i < ARRAY_SIZE(appleir_key_table); i++)
+	for (i = 0; i < ARRAY_SIZE(input_dev->keycodemax); i++)
 		set_bit(appleir->keymap[i], input_dev->keybit);
 	clear_bit(KEY_RESERVED, input_dev->keybit);
 }
-- 
1.9.1

