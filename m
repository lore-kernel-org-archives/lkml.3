Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933669Ab3FSAZG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 20:25:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34024 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932824Ab3FSAZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 20:25:03 -0400
Date: Tue, 18 Jun 2013 17:18:34 -0700
From: tip-bot for Randy Dunlap <tipbot@zytor.com>
Message-ID: <tip-d1603990ea626668c78527376d9ec084d634202d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rdunlap@infradead.org, stable@vger.kernel.org, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rdunlap@infradead.org, tglx@linutronix.de, stable@vger.kernel.org,
        hpa@linux.intel.com
In-Reply-To: <51C0B614.5000708@infradead.org>
References: <51C0B614.5000708@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86:
  fix build error and kconfig for ia32_emulation and binfmt
Git-Commit-ID: d1603990ea626668c78527376d9ec084d634202d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 18 Jun 2013 17:18:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d1603990ea626668c78527376d9ec084d634202d
Gitweb:     http://git.kernel.org/tip/d1603990ea626668c78527376d9ec084d634202d
Author:     Randy Dunlap <rdunlap@infradead.org>
AuthorDate: Tue, 18 Jun 2013 12:33:40 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 18 Jun 2013 16:20:32 -0500

x86: fix build error and kconfig for ia32_emulation and binfmt

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
---
 arch/x86/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 685692c..fe120da 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2265,6 +2265,7 @@ source "fs/Kconfig.binfmt"
 config IA32_EMULATION
 	bool "IA32 Emulation"
 	depends on X86_64
+	select BINFMT_ELF
 	select COMPAT_BINFMT_ELF
 	select HAVE_UID16
 	---help---
