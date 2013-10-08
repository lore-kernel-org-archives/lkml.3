Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707Ab3JHQrH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 12:47:07 -0400
Received: from mail.skyhub.de ([78.46.96.112]:43550 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756676Ab3JHQrE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 12:47:04 -0400
Date: Tue, 8 Oct 2013 18:47:02 +0200
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>, Dave Young <dyoung@redhat.com>,
        linux-efi@vger.kernel.org, fwts-devel@lists.ubuntu.com
Subject: [PATCH 11/12] efi: Add an efi= kernel command line parameter
Message-ID: <20131008164701.GC16793@pd.tnic>
References: <1379602494-26684-1-git-send-email-bp@alien8.de>
 <20131008164551.GB16793@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131008164551.GB16793@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

... for passing miscellaneous options and chicken bits from the command
line.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/platform/efi/efi.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 538c1e6b7b2c..16996aba5012 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -1113,3 +1113,12 @@ efi_status_t efi_query_variable_store(u32 attributes, unsigned long size)
 	return EFI_SUCCESS;
 }
 EXPORT_SYMBOL_GPL(efi_query_variable_store);
+
+static int __init parse_efi_cmdline(char *str)
+{
+	if (*str == '=')
+		str++;
+
+	return 0;
+}
+early_param("efi", parse_efi_cmdline);
-- 
1.8.4

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
