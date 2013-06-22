Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751178Ab3FVFzM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 01:55:12 -0400
Received: from intranet.asianux.com ([58.214.24.6]:36771 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775Ab3FVFzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 01:55:10 -0400
X-Spam-Score: -100.8
Message-ID: <51C53C06.7050205@asianux.com>
Date: Sat, 22 Jun 2013 13:54:14 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
CC: Tony Lindgren <tony@atomide.com>, "olof@lixom.net" <olof@lixom.net>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: [PATCH] arch: arm64: kernel: add '#ifdef CONFIG_COMPAT' for aarch32_break_handler()
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If 'COMPAT' not defined, aarch32_break_handler() cannot pass compiling,
so need add '#ifdef' for it just like the header file has done.

The related make:

  make ARCH=arm64 randconfig
  make ARCH=arm64 menuconfig
  make ARCH=arm64 V=1 EXTRA_CFLAGS=-W

The related error:

  arch/arm64/kernel/debug-monitors.c:249:5: error: redefinition of ‘aarch32_break_handler’
  In file included from arch/arm64/kernel/debug-monitors.c:29:0:
  /root/linux-next/arch/arm64/include/asm/debug-monitors.h:89:12: note: previous definition of ‘aarch32_break_handler’ was here


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/arm64/kernel/debug-monitors.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm64/kernel/debug-monitors.c b/arch/arm64/kernel/debug-monitors.c
index 08018e3..ceedcd7 100644
--- a/arch/arm64/kernel/debug-monitors.c
+++ b/arch/arm64/kernel/debug-monitors.c
@@ -246,6 +246,7 @@ static int brk_handler(unsigned long addr, unsigned int esr,
 	return 0;
 }
 
+#ifdef CONFIG_COMPAT
 int aarch32_break_handler(struct pt_regs *regs)
 {
 	siginfo_t info;
@@ -285,6 +286,7 @@ int aarch32_break_handler(struct pt_regs *regs)
 	force_sig_info(SIGTRAP, &info, current);
 	return 0;
 }
+#endif
 
 static int __init debug_traps_init(void)
 {
-- 
1.7.7.6
