Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694Ab3HANyr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 09:54:47 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:56346 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752452Ab3HANyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 09:54:46 -0400
From: Felipe Balbi <balbi@ti.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <linux-rt-users@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH] arm: spear: platsmp: fix lock definition
Date: Thu, 1 Aug 2013 16:54:24 +0300
Message-ID: <1375365264-10135-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.8.3.4.840.g6a90778
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

raw_spin_{lock,unlock}() functions, we must
pass a raw_spinlock_t as argument.

Previous patch converting ARM boot_lock to
raw_spinlock_t missed this one spot. Fix it.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---

compile tested only, I don't have any spear boards.

But at least solves the argument error compile warnings.

 arch/arm/mach-spear/platsmp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-spear/platsmp.c b/arch/arm/mach-spear/platsmp.c
index 382eef6..ec5437d 100644
--- a/arch/arm/mach-spear/platsmp.c
+++ b/arch/arm/mach-spear/platsmp.c
@@ -20,7 +20,7 @@
 #include <mach/spear.h>
 #include "generic.h"
 
-static DEFINE_SPINLOCK(boot_lock);
+static DEFINE_RAW_SPINLOCK(boot_lock);
 
 static void __iomem *scu_base = IOMEM(VA_SCU_BASE);
 
-- 
1.8.3.4.840.g6a90778

