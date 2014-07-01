Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867AbaGACOc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 22:14:32 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:41614 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbaGACOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 22:14:31 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: jkosina@suse.cz
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] hid-appleir: Fix kernel panic due to null pointer
Date: Mon, 30 Jun 2014 22:14:25 -0400
Message-Id: <1404180865-3681-1-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes a null pointer in appleir_input_configured due to reading
into wrong size array. Changed the variable to input_dev->keycodemax.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 drivers/hid/hid-appleir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-appleir.c b/drivers/hid/hid-appleir.c
index 0e6a42d..cc02df4 100644
--- a/drivers/hid/hid-appleir.c
+++ b/drivers/hid/hid-appleir.c
@@ -272,7 +272,7 @@ static void appleir_input_configured(struct hid_device *hid,
 	input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_REP);
 
 	memcpy(appleir->keymap, appleir_key_table, sizeof(appleir->keymap));
-	for (i = 0; i < ARRAY_SIZE(appleir_key_table); i++)
+	for (i = 0; i < appleir->keymap; i++)
 		set_bit(appleir->keymap[i], input_dev->keybit);
 	clear_bit(KEY_RESERVED, input_dev->keybit);
 }
-- 
1.9.1

