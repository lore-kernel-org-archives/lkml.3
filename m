Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272Ab3KUVBt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 16:01:49 -0500
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:38284 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754444Ab3KUVBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 16:01:41 -0500
From: Jerry Hoemann <jerry.hoemann@hp.com>
To: rob@landley.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, matt.fleming@intel.com, yinghai@kernel.org,
        akpm@linux-foundation.org, bp@suse.de, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
Cc: penberg@kernel.org, mingo.kernel.org@gmail.com, vgoyal@redhat.com,
        jerry.hoemann@hp.com
Subject: [RFC v2 1/2] efi: Early use of boot service memory
Date: Thu, 21 Nov 2013 14:01:25 -0700
Message-Id: <1385067686-73500-2-git-send-email-jerry.hoemann@hp.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1385067686-73500-1-git-send-email-jerry.hoemann@hp.com>
References: <1385067686-73500-1-git-send-email-jerry.hoemann@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add #define to allow for specifying that firmware doesn't reuse
boot service code or data after Exit Boot Service.

Signed-off-by: Jerry Hoemann <jerry.hoemann@hp.com>
---
 include/linux/efi.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/efi.h b/include/linux/efi.h
index 5f8f176..af085cf 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -568,6 +568,7 @@ efi_guid_unparse(efi_guid_t *guid, char *out)
 }
 
 extern void efi_init (void);
+extern void efi_quirks(void);
 extern void *efi_get_pal_addr (void);
 extern void efi_map_pal_code (void);
 extern void efi_memmap_walk (efi_freemem_callback_t callback, void *arg);
@@ -634,6 +635,7 @@ extern int __init efi_setup_pcdp_console(char *);
 #define EFI_RUNTIME_SERVICES	3	/* Can we use runtime services? */
 #define EFI_MEMMAP		4	/* Can we use EFI memory map? */
 #define EFI_64BIT		5	/* Is the firmware 64-bit? */
+#define EFI_QUIRK_RESERVE_BSCD	6	/* Reserve Boot Service Data/Code */
 
 #ifdef CONFIG_EFI
 # ifdef CONFIG_X86
-- 
1.7.11.3

