Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714AbaIOPVE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 11:21:04 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:58300 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049AbaIOPVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 11:21:02 -0400
From: Matt Fleming <matt@console-pimps.org>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>,
        Ulf Winkelvos <ulf@winkelvos.de>,
        =?UTF-8?q?Andre=20M=C3=BCller?= <andre.muller@web.de>
Subject: [PATCH] x86/efi: Delete misleading efi_printk() error message
Date: Mon, 15 Sep 2014 16:20:54 +0100
Message-Id: <1410794454-17961-1-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.9.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

A number of people are reporting seeing the "setup_efi_pci() failed!"
error message in what used to be a quiet boot,

  https://bugzilla.kernel.org/show_bug.cgi?id=81891

The message isn't all that helpful because setup_efi_pci() can return a
non-success error code for a variety of reasons, not all of them fatal.

Drop the efi_printk() now that we have more fine-grained, and more
specific, error messages throughout the *setup_efi_pci*() code paths.

Reported-by: Darren Hart <dvhart@linux.intel.com>
Reported-by: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Ulf Winkelvos <ulf@winkelvos.de>
Cc: Andre Müller <andre.muller@web.de>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---

This patch is based on top of Andre's ("x86/efi: Adding efi_printks on
memory allocationa and pci.reads") sitting on the 'next' branch.

 arch/x86/boot/compressed/eboot.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index ed8e06c59a4c..87398f9434f3 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -1394,10 +1394,7 @@ struct boot_params *efi_main(struct efi_config *c,
 
 	setup_graphics(boot_params);
 
-	status = setup_efi_pci(boot_params);
-	if (status != EFI_SUCCESS) {
-		efi_printk(sys_table, "setup_efi_pci() failed!\n");
-	}
+	setup_efi_pci(boot_params);
 
 	status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
 				sizeof(*gdt), (void **)&gdt);
-- 
1.9.3

