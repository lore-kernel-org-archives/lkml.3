Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668Ab3AUUlE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 15:41:04 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:41247 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752319Ab3AUUlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 15:41:01 -0500
From: Matt Fleming <matt@console-pimps.org>
To: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
Cc: Tim Gardner <rtg.canonical@gmail.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Olof Johansson <olof@lixom.net>,
        Tony Luck <tony.luck@intel.com>,
        Steve Langasek <steve.langasek@canonical.com>,
        Colin Ian King <colin.king@canonical.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Corentin Chary <corentincj@iksaif.net>,
        platform-driver-x86@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 2/2] samsung-laptop: Disable on EFI hardware
Date: Mon, 21 Jan 2013 20:40:38 +0000
Message-Id: <1358800838-10459-3-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1358800838-10459-1-git-send-email-matt@console-pimps.org>
References: <1358800838-10459-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

It has been reported that running this driver on some Samsung laptops
with EFI can cause those machines to become bricked as detailed in the
following report,

	https://bugs.launchpad.net/ubuntu-cdimage/+bug/1040557

There have also been reports of this driver causing Machine Check
Exceptions on recent EFI-enabled Samsung laptops,

	https://bugzilla.kernel.org/show_bug.cgi?id=47121

So disable it if booting from EFI since this driver relies on
grovelling around in the BIOS memory map which isn't going to work.

Acked-by: H. Peter Anvin <hpa@zytor.com>
Cc: Corentin Chary <corentincj@iksaif.net>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Colin Ian King <colin.king@canonical.com>
Cc: Steve Langasek <steve.langasek@canonical.com>
Cc: platform-driver-x86@vger.kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 drivers/platform/x86/samsung-laptop.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/platform/x86/samsung-laptop.c b/drivers/platform/x86/samsung-laptop.c
index dd90d15..a94c0ee 100644
--- a/drivers/platform/x86/samsung-laptop.c
+++ b/drivers/platform/x86/samsung-laptop.c
@@ -1534,6 +1534,9 @@ static int __init samsung_init(void)
 	struct samsung_laptop *samsung;
 	int ret;
 
+	if (efi_enabled(EFI_BOOT))
+		return -ENODEV;
+
 	quirks = &samsung_unknown;
 	if (!force && !dmi_check_system(samsung_dmi_table))
 		return -ENODEV;
-- 
1.7.11.7

