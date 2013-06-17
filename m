Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836Ab3FQRdO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 13:33:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50476 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802Ab3FQRdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:33:12 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Hung <alex.hung@canonical.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 37/84] ACPI video: ignore BIOS initial backlight value for HP 1000
Date: Mon, 17 Jun 2013 10:30:41 -0700
Message-Id: <1371490288-23167-38-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371490288-23167-1-git-send-email-kamal@canonical.com>
References: <1371490288-23167-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@canonical.com>

commit 4ef366c583d6180b1c951147869ee5a3038834f2 upstream.

On HP 1000 lapops, BIOS reports minimum backlight on boot and
causes backlight to dim completely. This ignores the initial backlight
values and set to max brightness.

References:: https://bugs.launchpad.net/bugs/1167760
Signed-off-by: Alex Hung <alex.hung@canonical.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/acpi/video.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index d7329bc..a6e1a4d 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -455,6 +455,14 @@ static struct dmi_system_id video_dmi_table[] __initdata = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion dm4 Notebook PC"),
 		},
 	},
+	{
+	 .callback = video_ignore_initial_backlight,
+	 .ident = "HP 1000 Notebook PC",
+	 .matches = {
+		DMI_MATCH(DMI_BOARD_VENDOR, "Hewlett-Packard"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "HP 1000 Notebook PC"),
+		},
+	},
 	{}
 };
 
-- 
1.8.1.2

