Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629Ab3A3ShB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 13:37:01 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52948 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755307Ab3A3Sg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 13:36:59 -0500
Date: Wed, 30 Jan 2013 10:36:37 -0800
From: tip-bot for Matt Fleming <matt.fleming@intel.com>
Message-ID: <tip-309176501502073be48627b4e6196e8f0cc2ea60@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        mjg59@srcf.ucam.org, stable@vger.kernel.org, corentincj@iksaif.net,
        matt.fleming@intel.com, steve.langasek@canonical.com,
        colin.king@canonical.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mjg59@srcf.ucam.org, stable@vger.kernel.org, matt.fleming@intel.com,
        corentincj@iksaif.net, steve.langasek@canonical.com,
        colin.king@canonical.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1358800838-10459-3-git-send-email-matt@console-pimps.org>
References: <1358800838-10459-3-git-send-email-matt@console-pimps.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] samsung-laptop: Disable on EFI hardware
Git-Commit-ID: 309176501502073be48627b4e6196e8f0cc2ea60
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 30 Jan 2013 10:36:42 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  309176501502073be48627b4e6196e8f0cc2ea60
Gitweb:     http://git.kernel.org/tip/309176501502073be48627b4e6196e8f0cc2ea60
Author:     Matt Fleming <matt.fleming@intel.com>
AuthorDate: Mon, 21 Jan 2013 20:40:38 +0000
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 30 Jan 2013 08:58:36 -0800

samsung-laptop: Disable on EFI hardware

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
Cc: <stable@vger.kernel.org>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Link: http://lkml.kernel.org/r/1358800838-10459-3-git-send-email-matt@console-pimps.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 drivers/platform/x86/samsung-laptop.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/platform/x86/samsung-laptop.c b/drivers/platform/x86/samsung-laptop.c
index 71623a2..0ffcfc4 100644
--- a/drivers/platform/x86/samsung-laptop.c
+++ b/drivers/platform/x86/samsung-laptop.c
@@ -1544,6 +1544,9 @@ static int __init samsung_init(void)
 	struct samsung_laptop *samsung;
 	int ret;
 
+	if (efi_enabled(EFI_BOOT))
+		return -ENODEV;
+
 	quirks = &samsung_unknown;
 	if (!force && !dmi_check_system(samsung_dmi_table))
 		return -ENODEV;
