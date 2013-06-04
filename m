Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757646Ab3FDRGS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 13:06:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48578 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758286Ab3FDRDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 13:03:09 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bastian Triller <bastian.triller@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 42/75] ACPI / video: Add "Asus UL30A" to ACPI video detect blacklist
Date: Tue,  4 Jun 2013 09:55:26 -0700
Message-Id: <1370364959-9475-43-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370364959-9475-1-git-send-email-kamal@canonical.com>
References: <1370364959-9475-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bastian Triller <bastian.triller@gmail.com>

commit c8f6d8351ba8c89d5cd4c562552ec7ec29274e31 upstream.

Like on UL30VT, the ACPI video driver can't control backlight correctly on
Asus UL30A.  Vendor driver (asus-laptop) can work.  This patch is to
add "Asus UL30A" to ACPI video detect blacklist in order to use
asus-laptop for video control on the "Asus UL30A" rather than ACPI
video driver.

Signed-off-by: Bastian Triller <bastian.triller@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/acpi/video_detect.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 4ac2593..abcae69 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -164,6 +164,14 @@ static struct dmi_system_id video_detect_dmi_table[] = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "UL30VT"),
 		},
 	},
+	{
+	.callback = video_detect_force_vendor,
+	.ident = "Asus UL30A",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK Computer Inc."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "UL30A"),
+		},
+	},
 	{ },
 };
 
-- 
1.8.1.2

