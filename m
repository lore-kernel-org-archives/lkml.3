Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240Ab3FRLo1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 07:44:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56026 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932221Ab3FRLoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 07:44:24 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Gustavo Maciel Dias Vieira <gustavo@sagui.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Alex Hung <alex.hung@canonical.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 31/93] ACPI video: ignore BIOS backlight value for HP dm4
Date: Tue, 18 Jun 2013 12:42:39 +0100
Message-Id: <1371555821-12820-32-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
References: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gustavo Maciel Dias Vieira <gustavo@sagui.org>

commit 771d09b3c4c45d4d534a83a68e6331b97fd82e15 upstream.

On a HP Pavilion dm4 laptop the BIOS sets minimum backlight on boot,
completely dimming the screen. Ignore this initial value for this
machine.

Signed-off-by: Gustavo Maciel Dias Vieira <gustavo@sagui.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Alex Hung <alex.hung@canonical.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/acpi/video.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index 3837739..f3b3027 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -447,6 +447,14 @@ static struct dmi_system_id video_dmi_table[] __initdata = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "HP Folio 13 - 2000 Notebook PC"),
 		},
 	},
+	{
+	 .callback = video_ignore_initial_backlight,
+	 .ident = "HP Pavilion dm4",
+	 .matches = {
+		DMI_MATCH(DMI_BOARD_VENDOR, "Hewlett-Packard"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion dm4 Notebook PC"),
+		},
+	},
 	{}
 };
 
-- 
1.8.1.2

