Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816AbaJ1Tse (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 15:48:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59243 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbaJ1Ts1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 15:48:27 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Input: i8042 - add mux quirk for HP EliteBook 8470p
Date: Tue, 28 Oct 2014 19:48:24 +0000
Message-Id: <1414525704-8409-1-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This laptop requires active multiplexing to be enabled in order to be able
to separate the PS/2 mouse and the touchpad.

Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/input/serio/i8042-x86ia64io.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index a0bcbb64d06d..34b95e4268eb 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -220,6 +220,13 @@ static const struct dmi_system_id __initconst i8042_dmi_mux_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "CF-18"),
 		},
 	},
+	{
+		/* HP EliteBook 8470p */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP EliteBook 8470p"),
+		},
+	},
 	{ }
 };
 
-- 
2.1.0

