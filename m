Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758260Ab3BLUlm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 15:41:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53862 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758147Ab3BLUli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 15:41:38 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Matt Fleming <matt.fleming@intel.com>,
        Corentin Chary <corentincj@iksaif.net>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Colin Ian King <colin.king@canonical.com>,
        Steve Langasek <steve.langasek@canonical.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [ 07/36] samsung-laptop: Disable on EFI hardware
Date: Tue, 12 Feb 2013 12:41:01 -0800
Message-Id: <20130212203858.192483647@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130212203857.305594226@linuxfoundation.org>
References: <20130212203857.305594226@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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

Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Cc: Corentin Chary <corentincj@iksaif.net>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Colin Ian King <colin.king@canonical.com>
Cc: Steve Langasek <steve.langasek@canonical.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/platform/x86/samsung-laptop.c |    4 ++++
 1 file changed, 4 insertions(+)

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


