Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932326Ab3FRMCV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 08:02:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56044 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932221Ab3FRLo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 07:44:28 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ash Willis <ashwillis@programmer.net>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 35/93] ACPI / video: ignore BIOS initial backlight value for HP Pavilion g6
Date: Tue, 18 Jun 2013 12:42:43 +0100
Message-Id: <1371555821-12820-36-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
References: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ash Willis <ashwillis.kernel@gmail.com>

commit 780a6ec640a3fed671fc2c40e4dd30c03eca3ac3 upstream.

This patch addresses kernel bug 56661. BIOS reports an incorrect
backlight value, causing the driver to switch off the backlight
completely during startup. This patch ignores the incorrect value from
BIOS.

References: https://bugzilla.kernel.org/show_bug.cgi?id=56661
Signed-off-by: Ash Willis <ashwillis@programmer.net>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/acpi/video.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index a4d9f5d..403283d 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -457,6 +457,14 @@ static struct dmi_system_id video_dmi_table[] __initdata = {
 	},
 	{
 	 .callback = video_ignore_initial_backlight,
+	 .ident = "HP Pavilion g6 Notebook PC",
+	 .matches = {
+		 DMI_MATCH(DMI_BOARD_VENDOR, "Hewlett-Packard"),
+		 DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion g6 Notebook PC"),
+		},
+	},
+	{
+	 .callback = video_ignore_initial_backlight,
 	 .ident = "HP 1000 Notebook PC",
 	 .matches = {
 		DMI_MATCH(DMI_BOARD_VENDOR, "Hewlett-Packard"),
-- 
1.8.1.2

