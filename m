Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887AbaIASsp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 14:48:45 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:38710 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339AbaIASsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 14:48:43 -0400
From: Sander Nemvalts <snemvalts@gmail.com>
To: stefanr@s5r6.in-berlin.de
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Sander Nemvalts <snemvalts@gmail.com>
Subject: [PATCH] Drivers:firewire: fix style errors in core-card.c This is a patch in the core-card.c file which fixes up 2 warnings found by the checkpatch.pl tool Signed-off-by: Sander Nemvalts <snemvalts@gmail.com>
Date: Mon,  1 Sep 2014 21:48:26 +0300
Message-Id: <1409597306-22164-1-git-send-email-snemvalts@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/firewire/core-card.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/firewire/core-card.c b/drivers/firewire/core-card.c
index 57ea7f4..825b260 100644
--- a/drivers/firewire/core-card.c
+++ b/drivers/firewire/core-card.c
@@ -89,7 +89,8 @@ static size_t config_rom_length = 1 + 4 + 1 + 1;
 #define BIB_ISC			((1) << 29)
 #define BIB_CMC			((1) << 30)
 #define BIB_IRMC		((1) << 31)
-#define NODE_CAPABILITIES	0x0c0083c0 /* per IEEE 1394 clause 8.3.2.6.5.2 */
+/* per IEEE 1394 clause 8.3.2.6.5.2 */
+#define NODE_CAPABILITIES	0x0c0083c0
 
 /*
  * IEEE-1394 specifies a default SPLIT_TIMEOUT value of 800 cycles (100 ms),
@@ -132,7 +133,7 @@ static void generate_config_rom(struct fw_card *card, __be32 *config_rom)
 	j = 7 + descriptor_count;
 
 	/* Generate root directory entries for descriptors. */
-	list_for_each_entry (desc, &descriptor_list, link) {
+	list_for_each_entry(desc, &descriptor_list, link) {
 		if (desc->immediate > 0)
 			config_rom[i++] = cpu_to_be32(desc->immediate);
 		config_rom[i] = cpu_to_be32(desc->key | (j - i));
@@ -144,7 +145,7 @@ static void generate_config_rom(struct fw_card *card, __be32 *config_rom)
 	config_rom[5] = cpu_to_be32((i - 5 - 1) << 16);
 
 	/* End of root directory, now copy in descriptors. */
-	list_for_each_entry (desc, &descriptor_list, link) {
+	list_for_each_entry(desc, &descriptor_list, link) {
 		for (k = 0; k < desc->length; k++)
 			config_rom[i + k] = cpu_to_be32(desc->data[k]);
 		i += desc->length;
@@ -164,7 +165,7 @@ static void update_config_roms(void)
 {
 	struct fw_card *card;
 
-	list_for_each_entry (card, &card_list, link) {
+	list_for_each_entry(card, &card_list, link) {
 		generate_config_rom(card, tmp_config_rom);
 		card->driver->set_config_rom(card, tmp_config_rom,
 					     config_rom_length);
-- 
1.9.1

