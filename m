Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820Ab3GDOpz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 10:45:55 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:61989 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756748Ab3GDOpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 10:45:53 -0400
From: Jonas Jensen <jonas.jensen@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, arm@kernel.org, arnd@arndb.de,
        olof@lixom.net, Jonas Jensen <jonas.jensen@gmail.com>
Subject: [PATCH v3 4/4] ARM: reinsert ARCH_MULTI_V4 Kconfig option
Date: Thu,  4 Jul 2013 16:45:42 +0200
Message-Id: <1372949142-8260-1-git-send-email-jonas.jensen@gmail.com>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CPU_FA526 is thumbless and adding under e.g. ARCH_MULTI_V4T instead means inclusion of CPU_ARM920T
which in turn selects CPU_ABRT_EV4T, CPU_CACHE_V4WT, CPU_COPY_V4WB, CPU_TLB_V4WBI, which in turn can
mean trouble when the kernel eventually tries to exec init:

[    2.580000] Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000004
[    2.580000]
[    2.580000] CPU: 0 PID: 1 Comm: init Not tainted 3.10.0-next-20130703+ #3
[    2.580000] [<c000cc64>] (unwind_backtrace+0x0/0xf0) from [<c000b524>] (show_stack+0x10/0x14)
[    2.580000] [<c000b524>] (show_stack+0x10/0x14) from [<c021d6dc>] (panic+0x90/0x1e0)
[    2.580000] [<c021d6dc>] (panic+0x90/0x1e0) from [<c0019664>] (do_exit+0x724/0x834)
[    2.580000] [<c0019664>] (do_exit+0x724/0x834) from [<c00197d8>] (do_group_exit+0x3c/0xb0)
[    2.580000] [<c00197d8>] (do_group_exit+0x3c/0xb0) from [<c0024c34>] (get_signal_to_deliver+0x2ec/0x598)
[    2.580000] [<c0024c34>] (get_signal_to_deliver+0x2ec/0x598) from [<c021d2a8>] (do_signal+0x9c/0x3cc)
[    2.580000] [<c021d2a8>] (do_signal+0x9c/0x3cc) from [<c000b110>] (do_work_pending+0xc4/0xe0)
[    2.580000] [<c000b110>] (do_work_pending+0xc4/0xe0) from [<c0009334>] (work_pending+0xc/0x20)

Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
---
 arch/arm/Kconfig | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index d84161c..87e93ab 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -878,6 +878,11 @@ menu "Multiple platform selection"
 
 comment "CPU Core family selection"
 
+config ARCH_MULTI_V4
+	bool "ARMv4 based platforms (FA526, StrongARM)"
+	depends on !ARCH_MULTI_V6_V7
+	select ARCH_MULTI_V4_V5
+
 config ARCH_MULTI_V4T
 	bool "ARMv4T based platforms (ARM720T, ARM920T, ...)"
 	depends on !ARCH_MULTI_V6_V7
-- 
1.8.2.1

