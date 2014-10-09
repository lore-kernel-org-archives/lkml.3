Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932610AbaJIVJ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:09:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59371 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932588AbaJIVJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:09:23 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 091/163] Input: i8042 - add nomux quirk for Avatar AVIU-145A6
Date: Thu,  9 Oct 2014 14:01:56 -0700
Message-Id: <1412888588-26755-92-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit d2682118f4bb3ceb835f91c1a694407a31bb7378 upstream.

The sys_vendor / product_name are somewhat generic unfortunately, so this
may lead to some false positives. But nomux usually does no harm, where as
not having it clearly is causing problems on the Avatar AVIU-145A6.

https://bugzilla.kernel.org/show_bug.cgi?id=77391

Reported-by: Hugo P <saurosii@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
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

