Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757319AbaFTTmz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 15:42:55 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:49950 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754354AbaFTTmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 15:42:53 -0400
From: Andreas Noever <andreas.noever@gmail.com>
To: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Cc: Andreas Noever <andreas.noever@gmail.com>
Subject: [PATCH 3/4] thunderbolt: Make enum tb_drom_entry_type unsigned
Date: Fri, 20 Jun 2014 21:42:24 +0200
Message-Id: <1403293345-20772-3-git-send-email-andreas.noever@gmail.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1403293345-20772-1-git-send-email-andreas.noever@gmail.com>
References: <1403293345-20772-1-git-send-email-andreas.noever@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Force enum tb_drom_entry_type to unsigned to fix the following error:

drivers/thunderbolt/eeprom.c:202:39: error: dubious one-bit signed bitfield

Signed-off-by: Andreas Noever <andreas.noever@gmail.com>
---
 drivers/thunderbolt/eeprom.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/thunderbolt/eeprom.c b/drivers/thunderbolt/eeprom.c
index b133f3f..71f719b 100644
--- a/drivers/thunderbolt/eeprom.c
+++ b/drivers/thunderbolt/eeprom.c
@@ -191,7 +191,8 @@ struct tb_drom_header {
 } __packed;
 
 enum tb_drom_entry_type {
-	TB_DROM_ENTRY_GENERIC,
+	/* force unsigned to prevent "one-bit signed bitfield" warning */
+	TB_DROM_ENTRY_GENERIC = 0U,
 	TB_DROM_ENTRY_PORT,
 };
 
-- 
2.0.0

