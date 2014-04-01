Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbaDAQ2F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 12:28:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44631 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974AbaDAQPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 12:15:46 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 81/86] Input: synaptics - add manual min/max quirk for ThinkPad X240
Date: Tue,  1 Apr 2014 09:08:34 -0700
Message-Id: <1396368519-12728-82-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396368519-12728-1-git-send-email-kamal@canonical.com>
References: <1396368519-12728-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.21 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 8a0435d958fb36d93b8df610124a0e91e5675c82 upstream.

This extends Benjamin Tissoires manual min/max quirk table with support for
the ThinkPad X240.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/input/mouse/synaptics.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index 43146cd..1f683f8 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -1481,6 +1481,14 @@ static const struct dmi_system_id min_max_dmi_table[] __initconst = {
 		.driver_data = (int []){1024, 5052, 2258, 4832},
 	},
 	{
+		/* Lenovo ThinkPad X240 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad X240"),
+		},
+		.driver_data = (int []){1232, 5710, 1156, 4696},
+	},
+	{
 		/* Lenovo ThinkPad T440s */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-- 
1.8.3.2

