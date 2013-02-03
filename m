Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935Ab3BCO6K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 09:58:10 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34521 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754857Ab3BCO5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:57:54 -0500
Message-Id: <20130203144653.425801193@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:48:30 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Matt Fleming <matt.fleming@intel.com>,
        Corentin Chary <corentincj@iksaif.net>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Colin Ian King <colin.king@canonical.com>,
        Steve Langasek <steve.langasek@canonical.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [ 106/128] samsung-laptop: Disable on EFI hardware
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/platform/x86/samsung-laptop.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/platform/x86/samsung-laptop.c
+++ b/drivers/platform/x86/samsung-laptop.c
@@ -22,6 +22,7 @@
 #include <linux/platform_device.h>
 #include <linux/rfkill.h>
 #include <linux/acpi.h>
+#include <linux/efi.h>
 
 /*
  * This driver is needed because a number of Samsung laptops do not hook
@@ -603,6 +604,9 @@ static int __init samsung_init(void)
 	int loca;
 	int retval;
 
+	if (efi_enabled(EFI_BOOT))
+		return -ENODEV;
+
 	mutex_init(&sabi_mutex);
 	handle_backlight = true;
 


