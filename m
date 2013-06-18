Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932271Ab3FRMCr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 08:02:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56039 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932227Ab3FRLo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 07:44:26 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Hung <alex.hung@canonical.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 34/93] ACPI / video: ignore BIOS initial backlight value for HP m4
Date: Tue, 18 Jun 2013 12:42:42 +0100
Message-Id: <1371555821-12820-35-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
References: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@canonical.com>

commit fedbe9bc6fd3e14b1ffbb3dac407777ac4a3650c upstream.

On HP m4 lapops, BIOS reports minimum backlight on boot and
causes backlight to dim completely. This ignores the initial backlight
values and set to max brightness.

References: https://bugs.launchpad.net/bugs/1184501
Signed-off-by: Alex Hung <alex.hung@canonical.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/acpi/video.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index 55c9ae7..a4d9f5d 100644
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

