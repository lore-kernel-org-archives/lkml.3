Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965521AbbA1EmP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:42:15 -0500
Received: from mail.kernel.org ([198.145.29.136]:40521 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965039AbbA1EYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:24:01 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Darren Hart <dvhart@linux.intel.com>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 122/177] samsung-laptop: Add broken-acpi-video quirk for NC210/NC110
Date: Wed, 28 Jan 2015 12:09:40 +0800
Message-Id: <1422418236-12852-213-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 5a1426c99f9b7aa11d60c4e6b7a3211bb5321696 upstream.

The acpi-video backlight interface on the NC210 does not work, blacklist it
and use the samsung-laptop interface instead.

BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=861573
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Darren Hart <dvhart@linux.intel.com>
[lizf: Backported to 3.4: adjust context]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/platform/x86/samsung-laptop.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/platform/x86/samsung-laptop.c b/drivers/platform/x86/samsung-laptop.c
index de9f432..28c1bdb 100644
--- a/drivers/platform/x86/samsung-laptop.c
+++ b/drivers/platform/x86/samsung-laptop.c
@@ -1517,6 +1517,16 @@ static struct dmi_system_id __initdata samsung_dmi_table[] = {
 		},
 	 .driver_data = &samsung_broken_acpi_video,
 	},
+	{
+	 .callback = samsung_dmi_matched,
+	 .ident = "NC210",
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "NC210/NC110"),
+		DMI_MATCH(DMI_BOARD_NAME, "NC210/NC110"),
+		},
+	 .driver_data = &samsung_broken_acpi_video,
+	},
 	{ },
 };
 MODULE_DEVICE_TABLE(dmi, samsung_dmi_table);
-- 
1.9.1

