Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393Ab3G3S64 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 14:58:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56520 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756625Ab3G3Spd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 14:45:33 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lan Tianyu <tianyu.lan@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 34/75] ACPI / video: ignore BIOS initial backlight value for Fujitsu E753
Date: Tue, 30 Jul 2013 11:44:38 -0700
Message-Id: <1375209919-1768-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1375197464-27962-1-git-send-email-kamal@canonical.com>
References: <1375197464-27962-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lan Tianyu <tianyu.lan@intel.com>

commit 9657a565a476d517451c10b0bcc106e300785aff upstream.

The BIOS of FUjitsu E753 reports an incorrect initial backlight value
for WIN8 compatible OS, causing backlight to be dark during startup.
This change causes the incorrect initial value from BIOS to be ignored.

References: https://bugzilla.kernel.org/show_bug.cgi?id=60161
Reported-and-tested-by: Jan Hinnerk Stosch <janhinnerk.stosch@gmail.com>
Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/acpi/video.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index 545246f..5006c47 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -449,6 +449,14 @@ static struct dmi_system_id video_dmi_table[] __initdata = {
 	},
 	{
 	 .callback = video_ignore_initial_backlight,
+	 .ident = "Fujitsu E753",
+	 .matches = {
+		DMI_MATCH(DMI_BOARD_VENDOR, "FUJITSU"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "LIFEBOOK E753"),
+		},
+	},
+	{
+	 .callback = video_ignore_initial_backlight,
 	 .ident = "HP Pavilion dm4",
 	 .matches = {
 		DMI_MATCH(DMI_BOARD_VENDOR, "Hewlett-Packard"),
-- 
1.8.1.2

