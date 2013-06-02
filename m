Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891Ab3FBM4f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 08:56:35 -0400
Received: from mail.skyhub.de ([78.46.96.112]:56313 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751420Ab3FBMz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 08:55:59 -0400
From: Borislav Petkov <bp@alien8.de>
To: Linux EFI <linux-efi@vger.kernel.org>
Cc: Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Jiri Kosina <jkosina@suse.cz>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 3/4] x86, efi: Add an efi= kernel command line parameter
Date: Sun,  2 Jun 2013 14:56:09 +0200
Message-Id: <1370177770-26661-4-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.3.rc1.25.g423ecb0
In-Reply-To: <1370177770-26661-1-git-send-email-bp@alien8.de>
References: <1370177770-26661-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

.. for passing miscellaneous options from the kernel command line.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/platform/efi/efi.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 82089d8b1954..aea4337f7023 100644
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
@@ -1167,3 +1172,14 @@ efi_status_t efi_query_variable_store(u32 attributes, unsigned long size)
 	return EFI_SUCCESS;
 }
 EXPORT_SYMBOL_GPL(efi_query_variable_store);
+
+static int __init parse_efi_cmdline(char *str)
+{
+	if (*str == '=')
+		str++;
+	if (!strncmp(str, "1:1_map", 7))
+		efi_config |= EFI_CFG_MAP11;
+
+	return 0;
+}
+early_param("efi", parse_efi_cmdline);
-- 
1.8.3.rc1.25.g423ecb0

