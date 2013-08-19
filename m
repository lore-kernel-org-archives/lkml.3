Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751347Ab3HSUBK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 16:01:10 -0400
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:11883 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117Ab3HSUBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 16:01:05 -0400
From: Linn Crosetto <linn@hp.com>
To: matt.fleming@intel.com, hpa@zytor.com, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, yinghai@kernel.org,
        penberg@kernel.org, jacob.shin@amd.com, linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Linn Crosetto <linn@hp.com>
Subject: [RFC PATCH 2/4] efi: Add memory_setup function efi_memory_setup()
Date: Mon, 19 Aug 2013 14:00:17 -0600
Message-Id: <1376942419-5684-3-git-send-email-linn@hp.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1376942419-5684-1-git-send-email-linn@hp.com>
References: <1376942419-5684-1-git-send-email-linn@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding efi_memory_setup() to be used to override the default
memory_setup function when the EFI memory map should be used instead of
a BIOS provided e820 map.

Signed-off-by: Linn Crosetto <linn@hp.com>
---
 arch/x86/platform/efi/efi.c | 8 ++++++++
 include/linux/efi.h         | 1 +
 2 files changed, 9 insertions(+)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 32da922..c2a660c 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -711,6 +711,14 @@ static int __init efi_runtime_init(void)
 	return 0;
 }
 
+char * __init efi_memory_setup(void)
+{
+	char *who = "EFI";
+	efi_memmap_init();
+	do_add_efi_memmap();
+	return who;
+}
+
 void __init efi_init(void)
 {
 	efi_char16_t *c16;
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 5f8f176..977bbc7 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -567,6 +567,7 @@ efi_guid_unparse(efi_guid_t *guid, char *out)
         return out;
 }
 
+extern char *efi_memory_setup(void);
 extern void efi_init (void);
 extern void *efi_get_pal_addr (void);
 extern void efi_map_pal_code (void);
-- 
1.7.11.3

