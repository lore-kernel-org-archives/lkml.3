Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbaHTLpK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 07:45:10 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59041 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752650AbaHTLoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:44:12 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 099/104] Input: i8042 - add Acer Aspire 5710 to nomux blacklist
Date: Wed, 20 Aug 2014 13:44:02 +0200
Message-Id: <3557b0c34f56378815e425dedf927b467756f821.1408535000.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
References: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
References: <cover.1408535000.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 8c947e20cb1f442c704852b2ca24b81981b09493 upstream.

Acer Aspire needs to be added to nomux blacklist, otherwise the touchpad
misbehaves rather randomly.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/input/serio/i8042-x86ia64io.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index 0ec9abbe31fe..0522c619acda 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -402,6 +402,13 @@ static const struct dmi_system_id __initconst i8042_dmi_nomux_table[] = {
 		},
 	},
 	{
+		/* Acer Aspire 5710 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5710"),
+		},
+	},
+	{
 		/* Gericom Bellagio */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Gericom"),
-- 
2.0.4

