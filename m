Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799Ab3FQRdL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 13:33:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50467 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786Ab3FQRdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:33:09 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Gustavo Maciel Dias Vieira <gustavo@sagui.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 36/84] ACPI video: ignore BIOS backlight value for HP dm4
Date: Mon, 17 Jun 2013 10:30:40 -0700
Message-Id: <1371490288-23167-37-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371490288-23167-1-git-send-email-kamal@canonical.com>
References: <1371490288-23167-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gustavo Maciel Dias Vieira <gustavo@sagui.org>

commit 771d09b3c4c45d4d534a83a68e6331b97fd82e15 upstream.

On a HP Pavilion dm4 laptop the BIOS sets minimum backlight on boot,
completely dimming the screen. Ignore this initial value for this
machine.

Signed-off-by: Gustavo Maciel Dias Vieira <gustavo@sagui.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/acpi/video.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index ac9a69c..d7329bc 100644
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

