Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757926Ab3BEWMQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:12:16 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48186 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757729Ab3BEWMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:12:06 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Corentin Chary <corentincj@iksaif.net>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Colin Ian King <colin.king@canonical.com>,
        Steve Langasek <steve.langasek@canonical.com>,
        Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 70/93] samsung-laptop: Disable on EFI hardware
Date: Tue,  5 Feb 2013 20:06:59 -0200
Message-Id: <1360102042-10732-71-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
References: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Fleming <matt.fleming@intel.com>

commit e0094244e41c4d0c7ad69920681972fc45d8ce34 upstream.

It has been reported that running this driver on some Samsung laptops
with EFI can cause those machines to become bricked as detailed in the
following report,

	https://bugs.launchpad.net/ubuntu-cdimage/+bug/1040557

There have also been reports of this driver causing Machine Check
Exceptions on recent EFI-enabled Samsung laptops,

	https://bugzilla.kernel.org/show_bug.cgi?id=47121

So disable it if booting from EFI since this driver relies on
grovelling around in the BIOS memory map which isn't going to work.

Cc: Corentin Chary <corentincj@iksaif.net>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Colin Ian King <colin.king@canonical.com>
Cc: Steve Langasek <steve.langasek@canonical.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
[ herton: adjust context ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/platform/x86/samsung-laptop.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/platform/x86/samsung-laptop.c b/drivers/platform/x86/samsung-laptop.c
index 1afbe5e..de9f432 100644
--- a/drivers/platform/x86/samsung-laptop.c
+++ b/drivers/platform/x86/samsung-laptop.c
@@ -26,6 +26,7 @@
 #include <linux/seq_file.h>
 #include <linux/debugfs.h>
 #include <linux/ctype.h>
+#include <linux/efi.h>
 #if (defined CONFIG_ACPI_VIDEO || defined CONFIG_ACPI_VIDEO_MODULE)
 #include <acpi/video.h>
 #endif
@@ -1527,6 +1528,9 @@ static int __init samsung_init(void)
 	struct samsung_laptop *samsung;
 	int ret;
 
+	if (efi_enabled(EFI_BOOT))
+		return -ENODEV;
+
 	quirks = &samsung_unknown;
 	if (!force && !dmi_check_system(samsung_dmi_table))
 		return -ENODEV;
-- 
1.7.9.5

