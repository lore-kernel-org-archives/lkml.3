Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843Ab3FBM4l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 08:56:41 -0400
Received: from mail.skyhub.de ([78.46.96.112]:56314 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289Ab3FBMz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 08:55:59 -0400
From: Borislav Petkov <bp@alien8.de>
To: Linux EFI <linux-efi@vger.kernel.org>
Cc: Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Jiri Kosina <jkosina@suse.cz>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 1/4] efi: Convert runtime services function ptrs
Date: Sun,  2 Jun 2013 14:56:07 +0200
Message-Id: <1370177770-26661-2-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.3.rc1.25.g423ecb0
In-Reply-To: <1370177770-26661-1-git-send-email-bp@alien8.de>
References: <1370177770-26661-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

... to void * like the boot services and lose all the void * casts. No
functionality change.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/boot/compressed/eboot.c |  2 +-
 arch/x86/include/asm/efi.h       | 28 ++++++++++++++--------------
 include/linux/efi.h              | 28 ++++++++++++++--------------
 3 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 35ee62fccf98..4060c8daf05e 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -266,7 +266,7 @@ static efi_status_t setup_efi_vars(struct boot_params *params)
 	while (data && data->next)
 		data = (struct setup_data *)(unsigned long)data->next;
 
-	status = efi_call_phys4((void *)sys_table->runtime->query_variable_info,
+	status = efi_call_phys4(sys_table->runtime->query_variable_info,
 				EFI_VARIABLE_NON_VOLATILE |
 				EFI_VARIABLE_BOOTSERVICE_ACCESS |
 				EFI_VARIABLE_RUNTIME_ACCESS, &store_size,
diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 2fb5d5884e23..5b33686b6995 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -52,40 +52,40 @@ extern u64 efi_call6(void *fp, u64 arg1, u64 arg2, u64 arg3,
 		     u64 arg4, u64 arg5, u64 arg6);
 
 #define efi_call_phys0(f)			\
-	efi_call0((void *)(f))
+	efi_call0((f))
 #define efi_call_phys1(f, a1)			\
-	efi_call1((void *)(f), (u64)(a1))
+	efi_call1((f), (u64)(a1))
 #define efi_call_phys2(f, a1, a2)			\
-	efi_call2((void *)(f), (u64)(a1), (u64)(a2))
+	efi_call2((f), (u64)(a1), (u64)(a2))
 #define efi_call_phys3(f, a1, a2, a3)				\
-	efi_call3((void *)(f), (u64)(a1), (u64)(a2), (u64)(a3))
+	efi_call3((f), (u64)(a1), (u64)(a2), (u64)(a3))
 #define efi_call_phys4(f, a1, a2, a3, a4)				\
-	efi_call4((void *)(f), (u64)(a1), (u64)(a2), (u64)(a3),		\
+	efi_call4((f), (u64)(a1), (u64)(a2), (u64)(a3),		\
 		  (u64)(a4))
 #define efi_call_phys5(f, a1, a2, a3, a4, a5)				\
-	efi_call5((void *)(f), (u64)(a1), (u64)(a2), (u64)(a3),		\
+	efi_call5((f), (u64)(a1), (u64)(a2), (u64)(a3),		\
 		  (u64)(a4), (u64)(a5))
 #define efi_call_phys6(f, a1, a2, a3, a4, a5, a6)			\
-	efi_call6((void *)(f), (u64)(a1), (u64)(a2), (u64)(a3),		\
+	efi_call6((f), (u64)(a1), (u64)(a2), (u64)(a3),		\
 		  (u64)(a4), (u64)(a5), (u64)(a6))
 
 #define efi_call_virt0(f)				\
-	efi_call0((void *)(efi.systab->runtime->f))
+	efi_call0((efi.systab->runtime->f))
 #define efi_call_virt1(f, a1)					\
-	efi_call1((void *)(efi.systab->runtime->f), (u64)(a1))
+	efi_call1((efi.systab->runtime->f), (u64)(a1))
 #define efi_call_virt2(f, a1, a2)					\
-	efi_call2((void *)(efi.systab->runtime->f), (u64)(a1), (u64)(a2))
+	efi_call2((efi.systab->runtime->f), (u64)(a1), (u64)(a2))
 #define efi_call_virt3(f, a1, a2, a3)					\
-	efi_call3((void *)(efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
+	efi_call3((efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
 		  (u64)(a3))
 #define efi_call_virt4(f, a1, a2, a3, a4)				\
-	efi_call4((void *)(efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
+	efi_call4((efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
 		  (u64)(a3), (u64)(a4))
 #define efi_call_virt5(f, a1, a2, a3, a4, a5)				\
-	efi_call5((void *)(efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
+	efi_call5((efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
 		  (u64)(a3), (u64)(a4), (u64)(a5))
 #define efi_call_virt6(f, a1, a2, a3, a4, a5, a6)			\
-	efi_call6((void *)(efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
+	efi_call6((efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
 		  (u64)(a3), (u64)(a4), (u64)(a5), (u64)(a6))
 
 extern void __iomem *efi_ioremap(unsigned long addr, unsigned long size,
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 2bc0ad78d058..21ae6b3c0359 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -287,20 +287,20 @@ typedef struct {
 
 typedef struct {
 	efi_table_hdr_t hdr;
-	unsigned long get_time;
-	unsigned long set_time;
-	unsigned long get_wakeup_time;
-	unsigned long set_wakeup_time;
-	unsigned long set_virtual_address_map;
-	unsigned long convert_pointer;
-	unsigned long get_variable;
-	unsigned long get_next_variable;
-	unsigned long set_variable;
-	unsigned long get_next_high_mono_count;
-	unsigned long reset_system;
-	unsigned long update_capsule;
-	unsigned long query_capsule_caps;
-	unsigned long query_variable_info;
+	void *get_time;
+	void *set_time;
+	void *get_wakeup_time;
+	void *set_wakeup_time;
+	void *set_virtual_address_map;
+	void *convert_pointer;
+	void *get_variable;
+	void *get_next_variable;
+	void *set_variable;
+	void *get_next_high_mono_count;
+	void *reset_system;
+	void *update_capsule;
+	void *query_capsule_caps;
+	void *query_variable_info;
 } efi_runtime_services_t;
 
 typedef efi_status_t efi_get_time_t (efi_time_t *tm, efi_time_cap_t *tc);
-- 
1.8.3.rc1.25.g423ecb0

