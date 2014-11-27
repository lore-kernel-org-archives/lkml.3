Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994AbaK0IsV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 03:48:21 -0500
Received: from mail.kernel.org ([198.145.19.201]:42007 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754979AbaK0IsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:48:16 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 46/91] Input: i8042 - add nomux quirk for Avatar AVIU-145A6
Date: Thu, 27 Nov 2014 16:42:29 +0800
Message-Id: <1417077794-9299-46-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417077368-9217-1-git-send-email-lizf@kernel.org>
References: <1417077368-9217-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit d2682118f4bb3ceb835f91c1a694407a31bb7378 upstream.

The sys_vendor / product_name are somewhat generic unfortunately, so this
may lead to some false positives. But nomux usually does no harm, where as
not having it clearly is causing problems on the Avatar AVIU-145A6.

https://bugzilla.kernel.org/show_bug.cgi?id=77391

Reported-by: Hugo P <saurosii@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/input/serio/i8042-x86ia64io.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index dc37b32..1291673 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -458,6 +458,13 @@ static const struct dmi_system_id __initconst i8042_dmi_nomux_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion dv4 Notebook PC"),
 		},
 	},
+	{
+		/* Avatar AVIU-145A6 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Intel"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "IC4I"),
+		},
+	},
 	{ }
 };
 
-- 
1.9.1

