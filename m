Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916AbbADTKp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 14:10:45 -0500
Received: from khitomer.mortis.eu ([185.27.175.75]:11419 "EHLO
	khitomer.mortis.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778AbbADTK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 14:10:29 -0500
From: Giel van Schijndel <me@mortis.eu>
To: linux-kernel@vger.kernel.org
Cc: Giel van Schijndel <me@mortis.eu>, Armin Schindler <mac@melware.de>,
        Karsten Keil <isdn@linux-pingi.de>,
        netdev@vger.kernel.org (open list:ISDN SUBSYSTEM)
Subject: [PATCH] Fix NUL (\0 or \x00) specification in string
Date: Sun,  4 Jan 2015 19:05:22 +0100
Message-Id: <1420394722-20197-1-git-send-email-me@mortis.eu>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In C one can either use '\0' or '\x00' (or '\000') to add a NUL byte to
a string. '\0x00' isn't part of these and will in fact result in a
single NUL followed by "x00". This fixes that.
---
 drivers/isdn/hardware/eicon/message.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/isdn/hardware/eicon/message.c b/drivers/isdn/hardware/eicon/message.c
index a82e542..0b38060 100644
--- a/drivers/isdn/hardware/eicon/message.c
+++ b/drivers/isdn/hardware/eicon/message.c
@@ -4880,7 +4880,7 @@ static void sig_ind(PLCI *plci)
 	byte SS_Ind[] = "\x05\x02\x00\x02\x00\x00"; /* Hold_Ind struct*/
 	byte CF_Ind[] = "\x09\x02\x00\x06\x00\x00\x00\x00\x00\x00";
 	byte Interr_Err_Ind[] = "\x0a\x02\x00\x07\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00";
-	byte CONF_Ind[] = "\x09\x16\x00\x06\x00\x00\0x00\0x00\0x00\0x00";
+	byte CONF_Ind[] = "\x09\x16\x00\x06\x00\x00\x00\x00\x00\x00";
 	byte force_mt_info = false;
 	byte dir;
 	dword d;
-- 
2.1.4

