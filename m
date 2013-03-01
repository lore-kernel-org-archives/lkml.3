Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098Ab3CAUIC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 15:08:02 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51652 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454Ab3CATp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:45:59 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Renninger <trenn@suse.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [ 75/77] ACPI: Overriding ACPI tables via initrd only works with an initrd and on X86
Date: Fri,  1 Mar 2013 11:45:00 -0800
Message-Id: <20130301194359.904299458@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130301194351.913471337@linuxfoundation.org>
References: <20130301194351.913471337@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Renninger <trenn@suse.de>

commit 565d956a7e191e95d81f515196951715f2616e6b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

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


