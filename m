Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756459Ab3HZKcZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 06:32:25 -0400
Received: from intranet.asianux.com ([58.214.24.6]:1686 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab3HZKcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 06:32:24 -0400
X-Spam-Score: -101.0
Message-ID: <521B2E75.1040802@asianux.com>
Date: Mon, 26 Aug 2013 18:31:17 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Yoshinori Sato <ysato@users.sourceforge.jp>,
        Geert Uytterhoeven <geert@linux-m68k.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] h8300/kernel/setup.c: add "linux/initrd.h" to pass compiling
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Need add "linux/initrd.h" to pass compiling.

The related error (allmodconfig for h8300):

  arch/h8300/kernel/setup.c: In function 'setup_arch':
  arch/h8300/kernel/setup.c:103:3: error: 'initrd_start' undeclared (first use in this function)
     initrd_start = memory_start;
     ^
  arch/h8300/kernel/setup.c:103:3: note: each undeclared identifier is reported only once for each function it appears in
  arch/h8300/kernel/setup.c:104:3: error: 'initrd_end' undeclared (first use in this function)
     initrd_end = memory_start += be32_to_cpu(((unsigned long *) (memory_start))[2]);
     ^

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/h8300/kernel/setup.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/h8300/kernel/setup.c b/arch/h8300/kernel/setup.c
index d0b1607..684e734 100644
--- a/arch/h8300/kernel/setup.c
+++ b/arch/h8300/kernel/setup.c
@@ -47,6 +47,9 @@
 #include <asm/regs267x.h>
 #endif
 
+#if defined(CONFIG_BLK_DEV_INITRD)
+#include <linux/initrd.h>
+#endif
 #define STUBSIZE 0xc000
 
 unsigned long rom_length;
-- 
1.7.7.6
