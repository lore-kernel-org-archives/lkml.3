Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548Ab3FQRvx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 13:51:53 -0400
Received: from mail.skyhub.de ([78.46.96.112]:43978 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754371Ab3FQRu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:50:26 -0400
From: Borislav Petkov <bp@alien8.de>
To: Linux EFI <linux-efi@vger.kernel.org>
Cc: Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: [PATCH -v2 3/4] x86, efi: Add an efi= kernel command line parameter
Date: Mon, 17 Jun 2013 19:50:15 +0200
Message-Id: <1371491416-11037-4-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <1371491416-11037-1-git-send-email-bp@alien8.de>
References: <1371491416-11037-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

.. for passing miscellaneous options from the kernel command line.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/platform/efi/efi.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 82089d8b1954..5af5b97bf203 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -88,6 +88,11 @@ static u64 active_size;
 
 unsigned long x86_efi_facility;
 
+ /* 1:1 mapping of services regions */
+#define EFI_CFG_MAP11	BIT(0)
+
+static unsigned long efi_config;
+
 /*
  * Returns 1 if 'facility' is enabled, 0 otherwise.
  */
@@ -1167,3 +1172,17 @@ efi_status_t efi_query_variable_store(u32 attributes, unsigned long size)
 	return EFI_SUCCESS;
 }
 EXPORT_SYMBOL_GPL(efi_query_variable_store);
+
+static int __init parse_efi_cmdline(char *str)
+{
+	if (*str == '=')
+		str++;
+
+#ifdef CONFIG_X86_64
+	if (!strncmp(str, "1:1_map", 7))
+		efi_config |= EFI_CFG_MAP11;
+#endif
+
+	return 0;
+}
+early_param("efi", parse_efi_cmdline);
-- 
1.8.3

