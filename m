Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320AbaJVTOQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 15:14:16 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:38112 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754996AbaJVTN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 15:13:26 -0400
From: Frans Klaver <fransklaver@gmail.com>
To: Darren Hart <dvhart@infradead.org>
Cc: Frans Klaver <fransklaver@gmail.com>,
        Corentin Chary <corentin.chary@gmail.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/8] eeepc-laptop: replace magic numbers with defines
Date: Wed, 22 Oct 2014 21:12:41 +0200
Message-Id: <1414005163-3461-7-git-send-email-fransklaver@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1414005163-3461-1-git-send-email-fransklaver@gmail.com>
References: <1414005163-3461-1-git-send-email-fransklaver@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

eeepc_[gs]et_fan_ctrl uses some magic numbers. These numbers mean
something more than just the number. Describe them with macros instead
of comments in one of the functions.

Signed-off-by: Frans Klaver <fransklaver@gmail.com>
---
 drivers/platform/x86/eeepc-laptop.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
index 21ffe1f..f820bb3 100644
--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -999,15 +999,19 @@ static int eeepc_get_fan_rpm(void)
 	return high << 8 | low;
 }
 
+#define EEEPC_EC_FAN_CTRL_BIT	0x02
+#define EEEPC_FAN_CTRL_MANUAL	1
+#define EEEPC_FAN_CTRL_AUTO	2
+
 static int eeepc_get_fan_ctrl(void)
 {
 	u8 value = 0;
 
 	ec_read(EEEPC_EC_FAN_CTRL, &value);
-	if (value & 0x02)
-		return 1; /* manual */
+	if (value & EEEPC_EC_FAN_CTRL_BIT)
+		return EEEPC_FAN_CTRL_MANUAL;
 	else
-		return 2; /* automatic */
+		return EEEPC_FAN_CTRL_AUTO;
 }
 
 static void eeepc_set_fan_ctrl(int manual)
@@ -1015,10 +1019,10 @@ static void eeepc_set_fan_ctrl(int manual)
 	u8 value = 0;
 
 	ec_read(EEEPC_EC_FAN_CTRL, &value);
-	if (manual == 1)
-		value |= 0x02;
+	if (manual == EEEPC_FAN_CTRL_MANUAL)
+		value |= EEEPC_EC_FAN_CTRL_BIT;
 	else
-		value &= ~0x02;
+		value &= ~EEEPC_EC_FAN_CTRL_BIT;
 	ec_write(EEEPC_EC_FAN_CTRL, value);
 }
 
-- 
2.1.0

