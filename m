Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048Ab3GBLNl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 07:13:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36299 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244Ab3GBLIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 07:08:30 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Randy Dunlap <rdunlap@infradead.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 30/50] x86: fix build error and kconfig for ia32_emulation and binfmt
Date: Tue,  2 Jul 2013 12:07:18 +0100
Message-Id: <1372763258-20664-31-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372763258-20664-1-git-send-email-luis.henriques@canonical.com>
References: <1372763258-20664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Randy Dunlap <rdunlap@infradead.org>

commit d1603990ea626668c78527376d9ec084d634202d upstream.

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
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index b2b22a6..eebd0d9 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2150,6 +2150,7 @@ source "fs/Kconfig.binfmt"
 config IA32_EMULATION
 	bool "IA32 Emulation"
 	depends on X86_64
+	select BINFMT_ELF
 	select COMPAT_BINFMT_ELF
 	---help---
 	  Include code to run legacy 32-bit programs under a
-- 
1.8.1.2

