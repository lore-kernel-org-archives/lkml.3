Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757021Ab3KZOV4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 09:21:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58312 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756949Ab3KZOVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 09:21:48 -0500
Date: Tue, 26 Nov 2013 06:21:16 -0800
From: tip-bot for Ralf Baechle <tipbot@zytor.com>
Message-ID: <tip-7972e966b032939afe63d8db22975240879dfd2a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        jbaron@akamai.com, skuribay@pobox.com, ralf@linux-mips.org,
        akpm@linux-foundation.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        jbaron@akamai.com, skuribay@pobox.com, akpm@linux-foundation.org,
        ralf@linux-mips.org, tglx@linutronix.de
In-Reply-To: <d19dc75fca343ec5d9ada75a1400f57330021976.1385418410.git.jbaron@akamai.com>
References: <d19dc75fca343ec5d9ada75a1400f57330021976.1385418410.git.jbaron@akamai.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/debug] MIPS: Remove panic_timeout settings
Git-Commit-ID: 7972e966b032939afe63d8db22975240879dfd2a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 26 Nov 2013 06:21:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7972e966b032939afe63d8db22975240879dfd2a
Gitweb:     http://git.kernel.org/tip/7972e966b032939afe63d8db22975240879dfd2a
Author:     Ralf Baechle <ralf@linux-mips.org>
AuthorDate: Mon, 25 Nov 2013 23:23:07 +0000
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 26 Nov 2013 12:12:27 +0100

MIPS: Remove panic_timeout settings

Now that we have a CONFIG_PANIC_TIMEOUT=x setting, remove the
mips settings. The default is 0, which means don't reboot on
panic.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Acked-by: Shinya Kuribayashi <skuribay@pobox.com>
Signed-off-by: Jason Baron <jbaron@akamai.com>
Cc: benh@kernel.crashing.org
Cc: paulus@samba.org
Cc: mpe@ellerman.id.au
Cc: felipe.contreras@gmail.com
Cc: linux-mips@linux-mips.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/d19dc75fca343ec5d9ada75a1400f57330021976.1385418410.git.jbaron@akamai.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
