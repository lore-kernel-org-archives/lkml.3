Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960Ab3FXJ2o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 05:28:44 -0400
Received: from intranet.asianux.com ([58.214.24.6]:37364 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab3FXJ2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 05:28:42 -0400
X-Spam-Score: -100.9
Message-ID: <51C81115.4070803@asianux.com>
Date: Mon, 24 Jun 2013 17:27:49 +0800
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
Subject: [PATCH v2] arch: arm64: kernel: add '#ifdef CONFIG_COMPAT' for aarch32_break_handler()
References: <51C53C06.7050205@asianux.com>
In-Reply-To: <51C53C06.7050205@asianux.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If 'COMPAT' not defined, aarch32_break_handler() cannot pass compiling,
and it can work independent with 'COMPAT', so remove dummy definition.

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
 arch/arm64/include/asm/debug-monitors.h |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/debug-monitors.h b/arch/arm64/include/asm/debug-monitors.h
index ef8235c..a2232d0 100644
--- a/arch/arm64/include/asm/debug-monitors.h
+++ b/arch/arm64/include/asm/debug-monitors.h
@@ -83,14 +83,7 @@ static inline int reinstall_suspended_bps(struct pt_regs *regs)
 }
 #endif
 
-#ifdef CONFIG_COMPAT
 int aarch32_break_handler(struct pt_regs *regs);
-#else
-static int aarch32_break_handler(struct pt_regs *regs)
-{
-	return -EFAULT;
-}
-#endif
 
 #endif	/* __ASSEMBLY */
 #endif	/* __KERNEL__ */
-- 
1.7.7.6
