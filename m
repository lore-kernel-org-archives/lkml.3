Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932335AbaGVWWj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:22:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44332 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756898AbaGVWWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:22:34 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Edward Lin <yidi.lin@canonical.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 003/116] ACPI / video: Add Dell Inspiron 5737 to the blacklist
Date: Tue, 22 Jul 2014 15:20:14 -0700
Message-Id: <1406067727-19683-4-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406067727-19683-1-git-send-email-kamal@canonical.com>
References: <1406067727-19683-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward Lin <yidi.lin@canonical.com>

commit 08a56226d84706d402372d891550e130ef5df9f0 upstream.

With win8 capabiltiy, the ACPI backlight control is broken.
The system also loses backlight setting when resuming from S3.

Add this model to the the ACPI video detect blacklist to make backlight
functionality work.

Although backlight functionality works via video.use_native_backlight=1,
this approach may be safer.

Signed-off-by: Edward Lin <yidi.lin@canonical.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/acpi/video_detect.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index abcae69..c81409a 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -172,6 +172,14 @@ static struct dmi_system_id video_detect_dmi_table[] = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "UL30A"),
 		},
 	},
+	{
+	.callback = video_detect_force_vendor,
+	.ident = "Dell Inspiron 5737",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron 5737"),
+		},
+	},
 	{ },
 };
 
-- 
1.9.1

