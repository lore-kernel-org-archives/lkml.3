Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758140Ab3DXKJU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 06:09:20 -0400
Received: from mail.skyhub.de ([78.46.96.112]:39846 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752487Ab3DXKJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 06:09:19 -0400
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH] x86, efi: Fix a build warning
Date: Wed, 24 Apr 2013 12:09:14 +0200
Message-Id: <1366798154-1380-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.2.135.g7b592fa
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Fix this:

arch/x86/boot/compressed/eboot.c: In function ‘setup_efi_vars’:
arch/x86/boot/compressed/eboot.c:269:2: warning: passing argument 1 of ‘efi_call_phys’ makes pointer from integer without a cast [enabled by default]
In file included from arch/x86/boot/compressed/eboot.c:12:0:
/w/kernel/linux/arch/x86/include/asm/efi.h:8:33: note: expected ‘void *’ but argument is of type ‘long unsigned int’

after cc5a080c5d40 ("efi: Pass boot services variable info to runtime
code").

Cc: Matthew Garrett <matthew.garrett@nebula.com>
Cc: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/boot/compressed/eboot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 8615f7581820..41de115a55b7 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -266,7 +266,7 @@ static efi_status_t setup_efi_vars(struct boot_params *params)
 	while (data && data->next)
 		data = (struct setup_data *)(unsigned long)data->next;
 
-	status = efi_call_phys4(sys_table->runtime->query_variable_info,
+	status = efi_call_phys4((void *)sys_table->runtime->query_variable_info,
 				EFI_VARIABLE_NON_VOLATILE |
 				EFI_VARIABLE_BOOTSERVICE_ACCESS |
 				EFI_VARIABLE_RUNTIME_ACCESS, &store_size,
-- 
1.8.2.135.g7b592fa

