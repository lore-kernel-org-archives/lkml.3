Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030321Ab3FTS3w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 14:29:52 -0400
Received: from mga14.intel.com ([143.182.124.37]:59661 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030277Ab3FTS3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 14:29:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,906,1363158000"; 
   d="scan'208";a="257884884"
From: "Luck, Tony" <tony.luck@intel.com>
Date: Thu, 20 Jun 2013 11:15:39 -0700
Subject: [PATCH] [IA64] sim: Add casts to avoid assignment warnings
In-reply-to: <1371491416-11037-2-git-send-email-bp@alien8.de>
To: Borislav Petkov <bp@amd64.org>
Cc: Matt Fleming <matt.fleming@intel.com>, linux-kernel@vger.kernel.org
Message-Id: <084100@agluck-desk.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pointers in the efi_runtime_services_t structure now have type
"void *" (formerly they were "unsigned long"). So we now see a
bunch of warnings like this:

arch/ia64/hp/sim/boot/fw-emu.c:293: warning: assignment makes pointer from integer without a cast

Add (void *) casts to the 10 affected lines to make the build quiet again.

Signed-off-by: Tony Luck <tony.luck@intel.com>

---

Boris, Matt - Can you add this patch to the same tree that

   commit 43ab0476a648053e5998bf081f47f215375a4502 [linux-next id]
   efi: Convert runtime services function ptrs

is in so that it will follow along behind it.  Thanks.

 arch/ia64/hp/sim/boot/fw-emu.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/ia64/hp/sim/boot/fw-emu.c b/arch/ia64/hp/sim/boot/fw-emu.c
index 271f412..87bf9ad 100644
--- a/arch/ia64/hp/sim/boot/fw-emu.c
+++ b/arch/ia64/hp/sim/boot/fw-emu.c
@@ -290,16 +290,16 @@ sys_fw_init (const char *args, int arglen)
 	efi_runtime->hdr.signature = EFI_RUNTIME_SERVICES_SIGNATURE;
 	efi_runtime->hdr.revision = EFI_RUNTIME_SERVICES_REVISION;
 	efi_runtime->hdr.headersize = sizeof(efi_runtime->hdr);
-	efi_runtime->get_time = __pa(&fw_efi_get_time);
-	efi_runtime->set_time = __pa(&efi_unimplemented);
-	efi_runtime->get_wakeup_time = __pa(&efi_unimplemented);
-	efi_runtime->set_wakeup_time = __pa(&efi_unimplemented);
-	efi_runtime->set_virtual_address_map = __pa(&efi_unimplemented);
-	efi_runtime->get_variable = __pa(&efi_unimplemented);
-	efi_runtime->get_next_variable = __pa(&efi_unimplemented);
-	efi_runtime->set_variable = __pa(&efi_unimplemented);
-	efi_runtime->get_next_high_mono_count = __pa(&efi_unimplemented);
-	efi_runtime->reset_system = __pa(&efi_reset_system);
+	efi_runtime->get_time = (void *)__pa(&fw_efi_get_time);
+	efi_runtime->set_time = (void *)__pa(&efi_unimplemented);
+	efi_runtime->get_wakeup_time = (void *)__pa(&efi_unimplemented);
+	efi_runtime->set_wakeup_time = (void *)__pa(&efi_unimplemented);
+	efi_runtime->set_virtual_address_map = (void *)__pa(&efi_unimplemented);
+	efi_runtime->get_variable = (void *)__pa(&efi_unimplemented);
+	efi_runtime->get_next_variable = (void *)__pa(&efi_unimplemented);
+	efi_runtime->set_variable = (void *)__pa(&efi_unimplemented);
+	efi_runtime->get_next_high_mono_count = (void *)__pa(&efi_unimplemented);
+	efi_runtime->reset_system = (void *)__pa(&efi_reset_system);
 
 	efi_tables->guid = SAL_SYSTEM_TABLE_GUID;
 	efi_tables->table = __pa(sal_systab);
-- 
1.8.1.4

