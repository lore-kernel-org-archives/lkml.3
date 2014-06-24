Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276AbaFXUbm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 16:31:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47710 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864AbaFXUbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 16:31:39 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 42/65] Input: synaptics - add min/max quirk for the ThinkPad W540
Date: Tue, 24 Jun 2014 13:30:02 -0700
Message-Id: <1403641825-12825-43-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403641825-12825-1-git-send-email-kamal@canonical.com>
References: <1403641825-12825-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.25 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 0b5fe736fe923f1f5e05413878d5990e92ffbdf5 upstream.

https://bugzilla.redhat.com/show_bug.cgi?id=1096436

Tested-and-reported-by: ajayr@bigfoot.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/input/mouse/synaptics.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index cee28f8..fd569be 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -1537,6 +1537,14 @@ static const struct dmi_system_id min_max_dmi_table[] __initconst = {
 		.driver_data = (int []){1024, 5112, 2024, 4832},
 	},
 	{
+		/* Lenovo ThinkPad W540 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad W540"),
+		},
+		.driver_data = (int []){1024, 5112, 2024, 4832},
+	},
+	{
 		/* Lenovo Yoga S1 */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-- 
1.9.1

