Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674AbaKRORL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:17:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57041 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932251AbaKROK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:10:26 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Darren Hart <dvhart@linux.intel.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 197/206] acer-wmi: Add acpi_backlight=video quirk for the Acer KAV80
Date: Tue, 18 Nov 2014 15:09:12 +0100
Message-Id: <ff631b1c39bf6ff7307eb43e40bcd8ee03e2450c.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 183fd8fcd7f8afb7ac5ec68f83194872f9fecc84 upstream.

The acpi-video backlight interface on the Acer KAV80 is broken, and worse
it causes the entire machine to slow down significantly after a suspend/resume.

Blacklist it, and use the acer-wmi backlight interface instead. Note that
the KAV80 is somewhat unique in that it is the only Acer model where we
fall back to acer-wmi after blacklisting, rather then using the native
(e.g. intel) backlight driver. This is done because there is no native
backlight interface on this model.

BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1128309
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Darren Hart <dvhart@linux.intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/platform/x86/acer-wmi.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index c9076bdaf2c1..59a8d325a697 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -572,6 +572,17 @@ static const struct dmi_system_id video_vendor_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5750"),
 		},
 	},
+	{
+		/*
+		 * Note no video_set_backlight_video_vendor, we must use the
+		 * acer interface, as there is no native backlight interface.
+		 */
+		.ident = "Acer KAV80",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "KAV80"),
+		},
+	},
 	{}
 };
 
-- 
2.1.3

