Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532Ab3KYXX4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 18:23:56 -0500
Received: from prod-mail-xrelay02.akamai.com ([72.246.2.14]:60855 "EHLO
	prod-mail-xrelay02.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753194Ab3KYXXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 18:23:08 -0500
To: mingo@kernel.org
Cc: benh@kernel.crashing.org, paulus@samba.org, ralf@linux-mips.org,
        akpm@linux-foundation.org, mpe@ellerman.id.au,
        felipe.contreras@gmail.com, skuribay@pobox.com,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Message-Id: <d19dc75fca343ec5d9ada75a1400f57330021976.1385418410.git.jbaron@akamai.com>
In-Reply-To: <cover.1385418410.git.jbaron@akamai.com>
References: <cover.1385418410.git.jbaron@akamai.com>
From: Jason Baron <jbaron@akamai.com>
Subject: [PATCH 2/3 v3] mips: remove panic_timeout settings
Date: Mon, 25 Nov 2013 23:23:07 +0000 (GMT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ralf Baechle <ralf@linux-mips.org>

Now that we have a CONFIG_PANIC_TIMEOUT=x setting, remove the mips settings. The
default is 0, which means don't reboot on panic.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Acked-by: Shinya Kuribayashi <skuribay@pobox.com>
Signed-off-by: Jason Baron <jbaron@akamai.com>
---
 arch/mips/ar7/setup.c           | 1 -
 arch/mips/emma/markeins/setup.c | 3 ---
 arch/mips/netlogic/xlp/setup.c  | 1 -
 arch/mips/netlogic/xlr/setup.c  | 1 -
 arch/mips/sibyte/swarm/setup.c  | 2 --
 5 files changed, 8 deletions(-)

diff --git a/arch/mips/ar7/setup.c b/arch/mips/ar7/setup.c
index 9a357ff..820b7a3 100644
--- a/arch/mips/ar7/setup.c
+++ b/arch/mips/ar7/setup.c
@@ -92,7 +92,6 @@ void __init plat_mem_setup(void)
 	_machine_restart = ar7_machine_restart;
 	_machine_halt = ar7_machine_halt;
 	pm_power_off = ar7_machine_power_off;
-	panic_timeout = 3;
 
 	io_base = (unsigned long)ioremap(AR7_REGS_BASE, 0x10000);
 	if (!io_base)
diff --git a/arch/mips/emma/markeins/setup.c b/arch/mips/emma/markeins/setup.c
index d710058..9100122 100644
--- a/arch/mips/emma/markeins/setup.c
+++ b/arch/mips/emma/markeins/setup.c
@@ -111,9 +111,6 @@ void __init plat_mem_setup(void)
 	iomem_resource.start = EMMA2RH_IO_BASE;
 	iomem_resource.end = EMMA2RH_ROM_BASE - 1;
 
-	/* Reboot on panic */
-	panic_timeout = 180;
-
 	markeins_sio_setup();
 }
 
diff --git a/arch/mips/netlogic/xlp/setup.c b/arch/mips/netlogic/xlp/setup.c
index 6d981bb..54e75c7 100644
--- a/arch/mips/netlogic/xlp/setup.c
+++ b/arch/mips/netlogic/xlp/setup.c
@@ -92,7 +92,6 @@ static void __init xlp_init_mem_from_bars(void)
 
 void __init plat_mem_setup(void)
 {
-	panic_timeout	= 5;
 	_machine_restart = (void (*)(char *))nlm_linux_exit;
 	_machine_halt	= nlm_linux_exit;
 	pm_power_off	= nlm_linux_exit;
diff --git a/arch/mips/netlogic/xlr/setup.c b/arch/mips/netlogic/xlr/setup.c
index 214d123..921be5f 100644
--- a/arch/mips/netlogic/xlr/setup.c
+++ b/arch/mips/netlogic/xlr/setup.c
@@ -92,7 +92,6 @@ static void nlm_linux_exit(void)
 
 void __init plat_mem_setup(void)
 {
-	panic_timeout	= 5;
 	_machine_restart = (void (*)(char *))nlm_linux_exit;
 	_machine_halt	= nlm_linux_exit;
 	pm_power_off	= nlm_linux_exit;
diff --git a/arch/mips/sibyte/swarm/setup.c b/arch/mips/sibyte/swarm/setup.c
index 41707a2..3462c83 100644
--- a/arch/mips/sibyte/swarm/setup.c
+++ b/arch/mips/sibyte/swarm/setup.c
@@ -134,8 +134,6 @@ void __init plat_mem_setup(void)
 #error invalid SiByte board configuration
 #endif
 
-	panic_timeout = 5;  /* For debug.  */
-
 	board_be_handler = swarm_be_handler;
 
 	if (xicor_probe())
-- 
1.8.2

