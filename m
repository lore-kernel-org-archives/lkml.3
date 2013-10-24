Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928Ab3JXHWY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 03:22:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:62083 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753738Ab3JXHWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 03:22:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="397726441"
From: Lan Tianyu <tianyu.lan@intel.com>
To: mingo@kernel.org, hpa@zytor.com, x86@kernel.org, holt@sgi.com,
        davej@fedoraproject.org, lenb@kernel.org, rjw@rjwysocki.net,
        awilliam@redhat.com
Cc: Lan Tianyu <tianyu.lan@intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] x86/reboot: Correct pr_info log message in the set_bios/pci/kbd_reboot()
Date: Thu, 24 Oct 2013 15:11:33 +0800
Message-Id: <1382598693-29334-1-git-send-email-tianyu.lan@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit c767a54ba broke log message in the set_bios/pci/kbd_reboot. Put
reboot method string and quirk entry's ident string in the wrong order.
This patch is to fix it.

Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
---
 arch/x86/kernel/reboot.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 083ade7..c93280d 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -61,7 +61,7 @@ static int __init set_bios_reboot(const struct dmi_system_id *d)
 	if (reboot_type != BOOT_BIOS) {
 		reboot_type = BOOT_BIOS;
 		pr_info("%s series board detected. Selecting %s-method for reboots.\n",
-			"BIOS", d->ident);
+			d->ident, "BIOS");
 	}
 	return 0;
 }
@@ -117,7 +117,7 @@ static int __init set_pci_reboot(const struct dmi_system_id *d)
 	if (reboot_type != BOOT_CF9) {
 		reboot_type = BOOT_CF9;
 		pr_info("%s series board detected. Selecting %s-method for reboots.\n",
-			"PCI", d->ident);
+			d->ident, "PCI");
 	}
 	return 0;
 }
@@ -127,7 +127,7 @@ static int __init set_kbd_reboot(const struct dmi_system_id *d)
 	if (reboot_type != BOOT_KBD) {
 		reboot_type = BOOT_KBD;
 		pr_info("%s series board detected. Selecting %s-method for reboot.\n",
-			"KBD", d->ident);
+			d->ident, "KBD");
 	}
 	return 0;
 }
-- 
1.8.4.rc0.1.g8f6a3e5.dirty

