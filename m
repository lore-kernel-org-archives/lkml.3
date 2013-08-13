Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932386Ab3HMQKK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:10:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15503 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758616Ab3HMP62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 11:58:28 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=5bD80Y2IUgkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=by0Kqf2THfEA:10 a=JfrnYn6hAAAA:8 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=3Rfx1nUSh_UA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130813155825.091860321@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 13 Aug 2013 11:57:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [09/88] x86: fix build error and kconfig for ia32_emulation and binfmt
References: <20130813155654.069291373@goodmis.org>
Content-Disposition: inline; filename=0009-x86-fix-build-error-and-kconfig-for-ia32_emulation-a.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.7-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit d1603990ea626668c78527376d9ec084d634202d ]

Fix kconfig warning and build errors on x86_64 by selecting BINFMT_ELF
when COMPAT_BINFMT_ELF is being selected.

warning: (IA32_EMULATION) selects COMPAT_BINFMT_ELF which has unmet direct dependencies (COMPAT && BINFMT_ELF)

fs/built-in.o: In function `elf_core_dump':
compat_binfmt_elf.c:(.text+0x3e093): undefined reference to `elf_core_extra_phdrs'
compat_binfmt_elf.c:(.text+0x3ebcd): undefined reference to `elf_core_extra_data_size'
compat_binfmt_elf.c:(.text+0x3eddd): undefined reference to `elf_core_write_extra_phdrs'
compat_binfmt_elf.c:(.text+0x3f004): undefined reference to `elf_core_write_extra_data'

[ hpa: This was sent to me for -next but it is a low risk build fix ]

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Link: http://lkml.kernel.org/r/51C0B614.5000708@infradead.org
Cc: <stable@vger.kernel.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 50a1d1f..3ccdf39 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2156,6 +2156,7 @@ source "fs/Kconfig.binfmt"
 config IA32_EMULATION
 	bool "IA32 Emulation"
 	depends on X86_64
+	select BINFMT_ELF
 	select COMPAT_BINFMT_ELF
 	---help---
 	  Include code to run legacy 32-bit programs under a
-- 
1.7.10.4


