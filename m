Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757465AbaJIVIh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:08:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59235 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757432AbaJIVIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:08:32 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 090/163] Input: i8042 - add Fujitsu U574 to no_timeout dmi table
Date: Thu,  9 Oct 2014 14:01:55 -0700
Message-Id: <1412888588-26755-91-git-send-email-kamal@canonical.com>
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

commit cc18a69c92d0972bc2fc5a047ee3be1e8398171b upstream.

https://bugzilla.kernel.org/show_bug.cgi?id=69731

Reported-by: Jason Robinson <mail@jasonrobinson.me>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/input/serio/i8042-x86ia64io.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index 0ec9abb..dc37b32 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -601,6 +601,14 @@ static const struct dmi_system_id __initconst i8042_dmi_notimeout_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion dv4 Notebook PC"),
 		},
 	},
+	{
+		/* Fujitsu U574 laptop */
+		/* https://bugzilla.kernel.org/show_bug.cgi?id=69731 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "LIFEBOOK U574"),
+		},
+	},
 	{ }
 };
 
-- 
1.9.1

