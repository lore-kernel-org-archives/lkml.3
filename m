Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964858AbaGOV6g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:58:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54788 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759560AbaGOViH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:38:07 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Edward Lin <yidi.lin@canonical.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 137/198] ACPI / video: Add Dell Inspiron 5737 to the blacklist
Date: Tue, 15 Jul 2014 14:30:07 -0700
Message-Id: <1405459868-15089-138-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

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
Cc: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/acpi/video_detect.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 84875fd..7245a5d 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -176,6 +176,14 @@ static struct dmi_system_id video_detect_dmi_table[] = {
 		DMI_MATCH(DMI_PRODUCT_VERSION, "Lenovo IdeaPad Yoga 13"),
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

