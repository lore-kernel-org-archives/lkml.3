Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176Ab3A2JGz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 04:06:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51619 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843Ab3A2JGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 04:06:51 -0500
Date: Tue, 29 Jan 2013 01:06:11 -0800
From: tip-bot for David Woodhouse <dwmw2@infradead.org>
Message-ID: <tip-83a57a4de1a222c351667ef9a0fedaac1295e85b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        dwmw2@infradead.org, tglx@linutronix.de, hpa@linux.intel.com,
        David.Woodhouse@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org, tglx@linutronix.de, hpa@linux.intel.com,
        David.Woodhouse@intel.com
In-Reply-To: <1355966180.18919.102.camel@shinybook.infradead.org>
References: <1355966180.18919.102.camel@shinybook.infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86: Enable ARCH_USE_BUILTIN_BSWAP
Git-Commit-ID: 83a57a4de1a222c351667ef9a0fedaac1295e85b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 29 Jan 2013 01:06:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  83a57a4de1a222c351667ef9a0fedaac1295e85b
Gitweb:     http://git.kernel.org/tip/83a57a4de1a222c351667ef9a0fedaac1295e85b
Author:     David Woodhouse <dwmw2@infradead.org>
AuthorDate: Thu, 20 Dec 2012 01:16:20 +0000
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 28 Jan 2013 08:48:57 -0800

x86: Enable ARCH_USE_BUILTIN_BSWAP

With -mmovbe enabled (implicit with -march=atom), this allows the
compiler to use the movbe instruction. This doesn't have a significant
effect on code size (unlike on PowerPC), because the movbe instruction
actually takes as many bytes to encode as a simple mov and a bswap. But
for Atom in particular I believe it should give a performance win over
the mov+bswap alternative. That was kind of why movbe was invented in
the first place, after all...

I've done basic functionality testing with IPv6 and Legacy IP, but no
performance testing. The EFI firmware on my test box unfortunately no
longer starts up.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Link: http://lkml.kernel.org/r/1355966180.18919.102.camel@shinybook.infradead.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 79795af..3e941aa 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -114,6 +114,7 @@ config X86
 	select MODULES_USE_ELF_RELA if X86_64
 	select CLONE_BACKWARDS if X86_32
 	select GENERIC_SIGALTSTACK
+	select ARCH_USE_BUILTIN_BSWAP
 
 config INSTRUCTION_DECODER
 	def_bool y
