Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759779Ab3BYWOF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 17:14:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34062 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758305Ab3BYWOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 17:14:00 -0500
Date: Mon, 25 Feb 2013 14:11:52 -0800
From: tip-bot for Thomas Renninger <tipbot@zytor.com>
Message-ID: <tip-565d956a7e191e95d81f515196951715f2616e6b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        trenn@suse.de, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, trenn@suse.de, hpa@linux.intel.com
In-Reply-To: <1361538742-67599-3-git-send-email-trenn@suse.de>
References: <1361538742-67599-3-git-send-email-trenn@suse.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] ACPI:
  Overriding ACPI tables via initrd only works with an initrd and on X86
Git-Commit-ID: 565d956a7e191e95d81f515196951715f2616e6b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 25 Feb 2013 14:11:58 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  565d956a7e191e95d81f515196951715f2616e6b
Gitweb:     http://git.kernel.org/tip/565d956a7e191e95d81f515196951715f2616e6b
Author:     Thomas Renninger <trenn@suse.de>
AuthorDate: Fri, 22 Feb 2013 14:12:22 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 25 Feb 2013 10:47:09 -0800

ACPI: Overriding ACPI tables via initrd only works with an initrd and on X86

Reflect this dependency in Kconfig, to prevent build failures.

Shorten the config description as suggested by Borislav Petkov.

Finding a suitable memory area to store the modified table(s) has been
taken over from arch/x86/kernel/setup.c and makes use of max_low_pfn_mapped:
memblock_find_in_range(0, max_low_pfn_mapped,...)
This one is X86 specific. It may not be hard to extend this functionality
for other ACPI aware architectures if there is need for.

For now make this feature only available for X86 to avoid build failures on
IA64, compare with:
https://bugzilla.kernel.org/show_bug.cgi?id=54091

Signed-off-by: Thomas Renninger <trenn@suse.de>
Link: http://lkml.kernel.org/r/1361538742-67599-3-git-send-email-trenn@suse.de
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 drivers/acpi/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 38c5078..f5ae996 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -268,7 +268,8 @@ config ACPI_CUSTOM_DSDT
 	default ACPI_CUSTOM_DSDT_FILE != ""
 
 config ACPI_INITRD_TABLE_OVERRIDE
-	bool "ACPI tables can be passed via uncompressed cpio in initrd"
+	bool "ACPI tables override via initrd"
+	depends on BLK_DEV_INITRD && X86
 	default n
 	help
 	  This option provides functionality to override arbitrary ACPI tables
