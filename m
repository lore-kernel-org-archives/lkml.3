Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852Ab3FQRd5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 13:33:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50525 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985Ab3FQRdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:33:42 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Hung <alex.hung@canonical.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 38/84] ACPI / video: ignore BIOS initial backlight value for HP m4
Date: Mon, 17 Jun 2013 10:30:42 -0700
Message-Id: <1371490288-23167-39-git-send-email-kamal@canonical.com>
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

commit fedbe9bc6fd3e14b1ffbb3dac407777ac4a3650c upstream.

On HP m4 lapops, BIOS reports minimum backlight on boot and
causes backlight to dim completely. This ignores the initial backlight
values and set to max brightness.

References: https://bugs.launchpad.net/bugs/1184501
Signed-off-by: Alex Hung <alex.hung@canonical.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/acpi/video.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index a6e1a4d..afc2a8d 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -463,6 +463,14 @@ static struct dmi_system_id video_dmi_table[] __initdata = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "HP 1000 Notebook PC"),
 		},
 	},
+	{
+	 .callback = video_ignore_initial_backlight,
+	 .ident = "HP Pavilion m4",
+	 .matches = {
+		DMI_MATCH(DMI_BOARD_VENDOR, "Hewlett-Packard"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion m4 Notebook PC"),
+		},
+	},
 	{}
 };
 
-- 
1.8.1.2

