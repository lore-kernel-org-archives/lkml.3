Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527Ab3JNBCc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 21:02:32 -0400
Received: from tango.0pointer.de ([85.214.72.216]:41162 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755400Ab3JNBCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 21:02:31 -0400
X-Greylist: delayed 442 seconds by postgrey-1.27 at vger.kernel.org; Sun, 13 Oct 2013 21:02:30 EDT
Date: Mon, 14 Oct 2013 02:55:05 +0200
From: Lennart Poettering <lennart@poettering.net>
To: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] acpi/video: Add Lenovo IdeaPad Yoga 13 to acpi video
 detect blacklist
Message-ID: <20131014005505.GA30503@tango.0pointer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On the Yoga 13 the backlight control doesn't work via ACPI. (And doesn't
work either with the low-level platform driver ideapad_laptop; but
works correctly via the intel video driver).  This patch hence adds the
Yoga 13 to the ACPI video detect blacklist, to make sure the broken ACPI
backlight device is never exposed to userspace.

Note that this appears unrelated to the Windows 8 backlight issues tracked
here:

https://bugzilla.kernel.org/show_bug.cgi?id=51231
https://bugzilla.kernel.org/show_bug.cgi?id=60682

The Yoga's ACPI backlight controls work neither with nor without
acpi_osi="!Windows 2012" on the kernel command line. It appears that
backlight control via the EC simply is not available at all, regardless
whether done via ACPI or via the vendor driver.

Signed-off-by: Lennart Poettering <lennart@poettering.net>
---
 drivers/acpi/video_detect.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 940edbf..a88e8f7 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -168,6 +168,14 @@ static struct dmi_system_id video_detect_dmi_table[] = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "UL30A"),
 		},
 	},
+	{
+	.callback = video_detect_force_vendor,
+	.ident = "Lenovo Yoga 13",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+		DMI_MATCH(DMI_PRODUCT_VERSION, "Lenovo IdeaPad Yoga 13"),
+		},
+	},
 	{ },
 };
 
-- 
1.8.3.1

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
