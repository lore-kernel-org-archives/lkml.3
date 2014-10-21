Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635AbaJUEO6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 00:14:58 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:33960 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598AbaJUEOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 00:14:49 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Ralf Baechle <ralf@linux-mips.org>,
        "Maciej W. Rozycki" <macro@linux-mips.org>, linux-mips@linux-mips.org
Subject: [PATCH v2 40/47] mips: Register with kernel poweroff handler
Date: Mon, 20 Oct 2014 21:12:56 -0700
Message-Id: <1413864783-3271-41-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413864783-3271-1-git-send-email-linux@roeck-us.net>
References: <1413864783-3271-1-git-send-email-linux@roeck-us.net>
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A02020A.5445DDB9.0049,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 228
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register with kernel poweroff handler instead of setting pm_power_off
directly.

If there is an indication that there can be more than one poweroff handler,
use register_power_off_handler, otherwise use register_power_off_handler_simple
to register the poweroff handler.

If the poweroff handler only resets or stops the system, select the fallback
priority to indicate that the poweroff handler is one of last resort.
If the poweroff handler powers off the system, select the default priority,
unless the poweroff handler installation code suggests that there can be
more than one poweroff handler and the new handler is only installed
conditionally. In this case, install the handler with low priority.

Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Maciej W. Rozycki <macro@linux-mips.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
- Use defines to specify poweroff handler priorities

 arch/mips/alchemy/board-gpr.c          |  3 ++-
 arch/mips/alchemy/board-mtx1.c         |  3 ++-
 arch/mips/alchemy/board-xxs1500.c      |  3 ++-
 arch/mips/alchemy/devboards/platform.c | 17 +++++++++++++++--
 arch/mips/ar7/setup.c                  |  3 ++-
 arch/mips/ath79/setup.c                |  3 ++-
 arch/mips/bcm47xx/setup.c              |  3 ++-
 arch/mips/bcm63xx/setup.c              |  3 ++-
 arch/mips/cobalt/setup.c               |  3 ++-
 arch/mips/dec/setup.c                  |  3 ++-
 arch/mips/emma/markeins/setup.c        |  3 ++-
 arch/mips/jz4740/reset.c               |  3 ++-
 arch/mips/lantiq/falcon/reset.c        |  3 ++-
 arch/mips/lantiq/xway/reset.c          |  3 ++-
 arch/mips/lasat/reset.c                |  3 ++-
 arch/mips/loongson/common/reset.c      |  3 ++-
 arch/mips/loongson1/common/reset.c     |  3 ++-
 arch/mips/mti-malta/malta-reset.c      |  3 ++-
 arch/mips/mti-sead3/sead3-reset.c      |  3 ++-
 arch/mips/netlogic/xlp/setup.c         |  3 ++-
 arch/mips/netlogic/xlr/setup.c         |  3 ++-
 arch/mips/pmcs-msp71xx/msp_setup.c     |  3 ++-
 arch/mips/pnx833x/common/setup.c       |  3 ++-
 arch/mips/ralink/reset.c               |  3 ++-
 arch/mips/rb532/setup.c                |  3 ++-
 arch/mips/sgi-ip22/ip22-reset.c        |  3 ++-
 arch/mips/sgi-ip27/ip27-reset.c        |  3 ++-
 arch/mips/sgi-ip32/ip32-reset.c        |  3 ++-
 arch/mips/sibyte/common/cfe.c          |  3 ++-
 arch/mips/sni/setup.c                  |  3 ++-
 arch/mips/txx9/generic/setup.c         |  3 ++-
 arch/mips/vr41xx/common/pmu.c          |  3 ++-
 32 files changed, 77 insertions(+), 33 deletions(-)

diff --git a/arch/mips/alchemy/board-gpr.c b/arch/mips/alchemy/board-gpr.c
index acf9a2a..3e06384 100644
--- a/arch/mips/alchemy/board-gpr.c
+++ b/arch/mips/alchemy/board-gpr.c
@@ -89,7 +89,8 @@ void __init board_setup(void)
 {
 	printk(KERN_INFO "Trapeze ITS GPR board\n");
 
-	pm_power_off = gpr_power_off;
+	register_power_off_handler_simple(gpr_power_off,
+					  POWEROFF_PRIORITY_FALLBACK);
 	_machine_halt = gpr_power_off;
 	_machine_restart = gpr_reset;
 
diff --git a/arch/mips/alchemy/board-mtx1.c b/arch/mips/alchemy/board-mtx1.c
index 1e3b102..4fd3cee 100644
--- a/arch/mips/alchemy/board-mtx1.c
+++ b/arch/mips/alchemy/board-mtx1.c
@@ -98,7 +98,8 @@ void __init board_setup(void)
 	alchemy_gpio_direction_output(211, 1);	/* green on */
 	alchemy_gpio_direction_output(212, 0);	/* red off */
 
-	pm_power_off = mtx1_power_off;
+	register_power_off_handler_simple(mtx1_power_off,
+					  POWEROFF_PRIORITY_FALLBACK);
 	_machine_halt = mtx1_power_off;
 	_machine_restart = mtx1_reset;
 
diff --git a/arch/mips/alchemy/board-xxs1500.c b/arch/mips/alchemy/board-xxs1500.c
index 0fc53e0..92d6d28 100644
--- a/arch/mips/alchemy/board-xxs1500.c
+++ b/arch/mips/alchemy/board-xxs1500.c
@@ -79,7 +79,8 @@ void __init board_setup(void)
 {
 	u32 pin_func;
 
-	pm_power_off = xxs1500_power_off;
+	register_power_off_handler_simple(xxs1500_power_off,
+					  POWEROFF_PRIORITY_FALLBACK);
 	_machine_halt = xxs1500_power_off;
 	_machine_restart = xxs1500_reset;
 
diff --git a/arch/mips/alchemy/devboards/platform.c b/arch/mips/alchemy/devboards/platform.c
index be139a0..1e1722a 100644
--- a/arch/mips/alchemy/devboards/platform.c
+++ b/arch/mips/alchemy/devboards/platform.c
@@ -6,6 +6,7 @@
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/map.h>
 #include <linux/mtd/physmap.h>
+#include <linux/notifier.h>
 #include <linux/slab.h>
 #include <linux/platform_device.h>
 #include <linux/pm.h>
@@ -64,10 +65,22 @@ static void db1x_reset(char *c)
 	bcsr_write(BCSR_SYSTEM, 0);
 }
 
+static int db1x_power_off_notify(struct notifier_block *this,
+				 unsigned long unused1, void *unused2)
+{
+	db1x_power_off();
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block db1x_poweroff_nb = {
+	.notifier_call = db1x_power_off_notify,
+	.priority = POWEROFF_PRIORITY_LOW,
+};
+
 static int __init db1x_late_setup(void)
 {
-	if (!pm_power_off)
-		pm_power_off = db1x_power_off;
+	if (register_power_off_handler(&db1x_poweroff_nb))
+		pr_warn("dbx1: Failed to register poweroff handler\n");
 	if (!_machine_halt)
 		_machine_halt = db1x_power_off;
 	if (!_machine_restart)
diff --git a/arch/mips/ar7/setup.c b/arch/mips/ar7/setup.c
index 820b7a3..c312e03 100644
--- a/arch/mips/ar7/setup.c
+++ b/arch/mips/ar7/setup.c
@@ -91,7 +91,8 @@ void __init plat_mem_setup(void)
 
 	_machine_restart = ar7_machine_restart;
 	_machine_halt = ar7_machine_halt;
-	pm_power_off = ar7_machine_power_off;
+	register_power_off_handler_simple(ar7_machine_power_off,
+					  POWEROFF_PRIORITY_DEFAULT);
 
 	io_base = (unsigned long)ioremap(AR7_REGS_BASE, 0x10000);
 	if (!io_base)
diff --git a/arch/mips/ath79/setup.c b/arch/mips/ath79/setup.c
index 64807a4..ea53c84 100644
--- a/arch/mips/ath79/setup.c
+++ b/arch/mips/ath79/setup.c
@@ -203,7 +203,8 @@ void __init plat_mem_setup(void)
 
 	_machine_restart = ath79_restart;
 	_machine_halt = ath79_halt;
-	pm_power_off = ath79_halt;
+	register_power_off_handler_simple(ath79_halt,
+					  POWEROFF_PRIORITY_FALLBACK);
 }
 
 void __init plat_time_init(void)
diff --git a/arch/mips/bcm47xx/setup.c b/arch/mips/bcm47xx/setup.c
index c00585d..47318aa 100644
--- a/arch/mips/bcm47xx/setup.c
+++ b/arch/mips/bcm47xx/setup.c
@@ -246,7 +246,8 @@ void __init plat_mem_setup(void)
 
 	_machine_restart = bcm47xx_machine_restart;
 	_machine_halt = bcm47xx_machine_halt;
-	pm_power_off = bcm47xx_machine_halt;
+	register_power_off_handler_simple(bcm47xx_machine_halt,
+					  POWEROFF_PRIORITY_FALLBACK);
 	bcm47xx_board_detect();
 	mips_set_machine_name(bcm47xx_board_get_name());
 }
diff --git a/arch/mips/bcm63xx/setup.c b/arch/mips/bcm63xx/setup.c
index 6660c7d..8fcbb517 100644
--- a/arch/mips/bcm63xx/setup.c
+++ b/arch/mips/bcm63xx/setup.c
@@ -149,7 +149,8 @@ void __init plat_mem_setup(void)
 
 	_machine_halt = bcm63xx_machine_halt;
 	_machine_restart = __bcm63xx_machine_reboot;
-	pm_power_off = bcm63xx_machine_halt;
+	register_power_off_handler_simple(bcm63xx_machine_halt,
+					  POWEROFF_PRIORITY_FALLBACK);
 
 	set_io_port_base(0);
 	ioport_resource.start = 0;
diff --git a/arch/mips/cobalt/setup.c b/arch/mips/cobalt/setup.c
index 9a8c2fe..82d1606 100644
--- a/arch/mips/cobalt/setup.c
+++ b/arch/mips/cobalt/setup.c
@@ -78,7 +78,8 @@ void __init plat_mem_setup(void)
 
 	_machine_restart = cobalt_machine_restart;
 	_machine_halt = cobalt_machine_halt;
-	pm_power_off = cobalt_machine_halt;
+	register_power_off_handler_simple(cobalt_machine_halt,
+					  POWEROFF_PRIORITY_FALLBACK);
 
 	set_io_port_base(CKSEG1ADDR(GT_DEF_PCI0_IO_BASE));
 
diff --git a/arch/mips/dec/setup.c b/arch/mips/dec/setup.c
index 41bbffd..ec648b2 100644
--- a/arch/mips/dec/setup.c
+++ b/arch/mips/dec/setup.c
@@ -158,7 +158,8 @@ void __init plat_mem_setup(void)
 
 	_machine_restart = dec_machine_restart;
 	_machine_halt = dec_machine_halt;
-	pm_power_off = dec_machine_power_off;
+	register_power_off_handler_simple(dec_machine_power_off,
+					  POWEROFF_PRIORITY_DEFAULT);
 
 	ioport_resource.start = ~0UL;
 	ioport_resource.end = 0UL;
diff --git a/arch/mips/emma/markeins/setup.c b/arch/mips/emma/markeins/setup.c
index 9100122..0242e9a 100644
--- a/arch/mips/emma/markeins/setup.c
+++ b/arch/mips/emma/markeins/setup.c
@@ -103,7 +103,8 @@ void __init plat_mem_setup(void)
 
 	_machine_restart = markeins_machine_restart;
 	_machine_halt = markeins_machine_halt;
-	pm_power_off = markeins_machine_power_off;
+	register_power_off_handler_simple(markeins_machine_power_off,
+					  POWEROFF_PRIORITY_FALLBACK);
 
 	/* setup resource limits */
 	ioport_resource.start = EMMA2RH_PCI_IO_BASE;
diff --git a/arch/mips/jz4740/reset.c b/arch/mips/jz4740/reset.c
index b6c6343..0beaef5 100644
--- a/arch/mips/jz4740/reset.c
+++ b/arch/mips/jz4740/reset.c
@@ -114,5 +114,6 @@ void jz4740_reset_init(void)
 {
 	_machine_restart = jz4740_restart;
 	_machine_halt = jz4740_halt;
-	pm_power_off = jz4740_power_off;
+	register_power_off_handler_simple(jz4740_power_off,
+					  POWEROFF_PRIORITY_DEFAULT);
 }
diff --git a/arch/mips/lantiq/falcon/reset.c b/arch/mips/lantiq/falcon/reset.c
index 5682482..feefca1 100644
--- a/arch/mips/lantiq/falcon/reset.c
+++ b/arch/mips/lantiq/falcon/reset.c
@@ -83,7 +83,8 @@ static int __init mips_reboot_setup(void)
 {
 	_machine_restart = machine_restart;
 	_machine_halt = machine_halt;
-	pm_power_off = machine_power_off;
+	register_power_off_handler_simple(machine_power_off,
+					  POWEROFF_PRIORITY_FALLBACK);
 	return 0;
 }
 
diff --git a/arch/mips/lantiq/xway/reset.c b/arch/mips/lantiq/xway/reset.c
index 1fa0f17..6c7072f 100644
--- a/arch/mips/lantiq/xway/reset.c
+++ b/arch/mips/lantiq/xway/reset.c
@@ -157,7 +157,8 @@ static int __init mips_reboot_setup(void)
 
 	_machine_restart = ltq_machine_restart;
 	_machine_halt = ltq_machine_halt;
-	pm_power_off = ltq_machine_power_off;
+	register_power_off_handler_simple(ltq_machine_power_off,
+					  POWEROFF_PRIORITY_FALLBACK);
 
 	return 0;
 }
diff --git a/arch/mips/lasat/reset.c b/arch/mips/lasat/reset.c
index e21f0b9..29708c2 100644
--- a/arch/mips/lasat/reset.c
+++ b/arch/mips/lasat/reset.c
@@ -56,5 +56,6 @@ void lasat_reboot_setup(void)
 {
 	_machine_restart = lasat_machine_restart;
 	_machine_halt = lasat_machine_halt;
-	pm_power_off = lasat_machine_halt;
+	register_power_off_handler_simple(lasat_machine_halt,
+					  POWEROFF_PRIORITY_FALLBACK);
 }
diff --git a/arch/mips/loongson/common/reset.c b/arch/mips/loongson/common/reset.c
index a60715e..6ad7056 100644
--- a/arch/mips/loongson/common/reset.c
+++ b/arch/mips/loongson/common/reset.c
@@ -84,7 +84,8 @@ static int __init mips_reboot_setup(void)
 {
 	_machine_restart = loongson_restart;
 	_machine_halt = loongson_halt;
-	pm_power_off = loongson_poweroff;
+	register_power_off_handler_simple(loongson_poweroff,
+					  POWEROFF_PRIORITY_DEFAULT);
 
 	return 0;
 }
diff --git a/arch/mips/loongson1/common/reset.c b/arch/mips/loongson1/common/reset.c
index 547f34b..b0ed702 100644
--- a/arch/mips/loongson1/common/reset.c
+++ b/arch/mips/loongson1/common/reset.c
@@ -38,7 +38,8 @@ static int __init ls1x_reboot_setup(void)
 {
 	_machine_restart = ls1x_restart;
 	_machine_halt = ls1x_halt;
-	pm_power_off = ls1x_power_off;
+	register_power_off_handler_simple(ls1x_power_off,
+					  POWEROFF_PRIORITY_FALLBACK);
 
 	return 0;
 }
diff --git a/arch/mips/mti-malta/malta-reset.c b/arch/mips/mti-malta/malta-reset.c
index 2fd2cc2..d883c7e 100644
--- a/arch/mips/mti-malta/malta-reset.c
+++ b/arch/mips/mti-malta/malta-reset.c
@@ -40,7 +40,8 @@ static int __init mips_reboot_setup(void)
 {
 	_machine_restart = mips_machine_restart;
 	_machine_halt = mips_machine_halt;
-	pm_power_off = mips_machine_power_off;
+	register_power_off_handler_simple(mips_machine_power_off,
+					  POWEROFF_PRIORITY_DEFAULT);
 
 	return 0;
 }
diff --git a/arch/mips/mti-sead3/sead3-reset.c b/arch/mips/mti-sead3/sead3-reset.c
index e6fb244..7cb433d 100644
--- a/arch/mips/mti-sead3/sead3-reset.c
+++ b/arch/mips/mti-sead3/sead3-reset.c
@@ -33,7 +33,8 @@ static int __init mips_reboot_setup(void)
 {
 	_machine_restart = mips_machine_restart;
 	_machine_halt = mips_machine_halt;
-	pm_power_off = mips_machine_halt;
+	register_power_off_handler_simple(mips_machine_halt,
+					  POWEROFF_PRIORITY_FALLBACK);
 
 	return 0;
 }
diff --git a/arch/mips/netlogic/xlp/setup.c b/arch/mips/netlogic/xlp/setup.c
index 4fdd9fd..5a324c5 100644
--- a/arch/mips/netlogic/xlp/setup.c
+++ b/arch/mips/netlogic/xlp/setup.c
@@ -106,7 +106,8 @@ void __init plat_mem_setup(void)
 #endif
 	_machine_restart = (void (*)(char *))nlm_linux_exit;
 	_machine_halt	= nlm_linux_exit;
-	pm_power_off	= nlm_linux_exit;
+	register_power_off_handler_simple(nlm_linux_exit,
+					  POWEROFF_PRIORITY_FALLBACK);
 
 	/* memory and bootargs from DT */
 	xlp_early_init_devtree();
diff --git a/arch/mips/netlogic/xlr/setup.c b/arch/mips/netlogic/xlr/setup.c
index d118b9a..a20d210 100644
--- a/arch/mips/netlogic/xlr/setup.c
+++ b/arch/mips/netlogic/xlr/setup.c
@@ -75,7 +75,8 @@ void __init plat_mem_setup(void)
 {
 	_machine_restart = (void (*)(char *))nlm_linux_exit;
 	_machine_halt	= nlm_linux_exit;
-	pm_power_off	= nlm_linux_exit;
+	register_power_off_handler_simple(nlm_linux_exit,
+					  POWEROFF_PRIORITY_FALLBACK);
 }
 
 const char *get_system_type(void)
diff --git a/arch/mips/pmcs-msp71xx/msp_setup.c b/arch/mips/pmcs-msp71xx/msp_setup.c
index 4f925e0..1a3c91d 100644
--- a/arch/mips/pmcs-msp71xx/msp_setup.c
+++ b/arch/mips/pmcs-msp71xx/msp_setup.c
@@ -144,7 +144,8 @@ void __init plat_mem_setup(void)
 {
 	_machine_restart = msp_restart;
 	_machine_halt = msp_halt;
-	pm_power_off = msp_power_off;
+	register_power_off_handler_simple(msp_power_off,
+					  POWEROFF_PRIORITY_FALLBACK);
 }
 
 void __init prom_init(void)
diff --git a/arch/mips/pnx833x/common/setup.c b/arch/mips/pnx833x/common/setup.c
index 99b4d94..c690a5c 100644
--- a/arch/mips/pnx833x/common/setup.c
+++ b/arch/mips/pnx833x/common/setup.c
@@ -51,7 +51,8 @@ int __init plat_mem_setup(void)
 
 	_machine_restart = pnx833x_machine_restart;
 	_machine_halt = pnx833x_machine_halt;
-	pm_power_off = pnx833x_machine_power_off;
+	register_power_off_handler_simple(pnx833x_machine_power_off,
+					  POWEROFF_PRIORITY_DEFAULT);
 
 	/* IO/MEM resources. */
 	set_io_port_base(KSEG1);
diff --git a/arch/mips/ralink/reset.c b/arch/mips/ralink/reset.c
index 55c7ec5..6d83d82 100644
--- a/arch/mips/ralink/reset.c
+++ b/arch/mips/ralink/reset.c
@@ -98,7 +98,8 @@ static int __init mips_reboot_setup(void)
 {
 	_machine_restart = ralink_restart;
 	_machine_halt = ralink_halt;
-	pm_power_off = ralink_halt;
+	register_power_off_handler_simple(ralink_halt,
+					  POWEROFF_PRIORITY_FALLBACK);
 
 	return 0;
 }
diff --git a/arch/mips/rb532/setup.c b/arch/mips/rb532/setup.c
index d0c64e7..1e10df4 100644
--- a/arch/mips/rb532/setup.c
+++ b/arch/mips/rb532/setup.c
@@ -44,7 +44,8 @@ void __init plat_mem_setup(void)
 
 	_machine_restart = rb_machine_restart;
 	_machine_halt = rb_machine_halt;
-	pm_power_off = rb_machine_halt;
+	register_power_off_handler_simple(rb_machine_halt,
+					  POWEROFF_PRIORITY_FALLBACK);
 
 	set_io_port_base(KSEG1);
 
diff --git a/arch/mips/sgi-ip22/ip22-reset.c b/arch/mips/sgi-ip22/ip22-reset.c
index 063c2dd..6177ba2 100644
--- a/arch/mips/sgi-ip22/ip22-reset.c
+++ b/arch/mips/sgi-ip22/ip22-reset.c
@@ -188,7 +188,8 @@ static int __init reboot_setup(void)
 
 	_machine_restart = sgi_machine_restart;
 	_machine_halt = sgi_machine_halt;
-	pm_power_off = sgi_machine_power_off;
+	register_power_off_handler_simple(sgi_machine_power_off,
+					  POWEROFF_PRIORITY_DEFAULT);
 
 	res = request_irq(SGI_PANEL_IRQ, panel_int, 0, "Front Panel", NULL);
 	if (res) {
diff --git a/arch/mips/sgi-ip27/ip27-reset.c b/arch/mips/sgi-ip27/ip27-reset.c
index ac37e54..958d1e1 100644
--- a/arch/mips/sgi-ip27/ip27-reset.c
+++ b/arch/mips/sgi-ip27/ip27-reset.c
@@ -76,5 +76,6 @@ void ip27_reboot_setup(void)
 {
 	_machine_restart = ip27_machine_restart;
 	_machine_halt = ip27_machine_halt;
-	pm_power_off = ip27_machine_power_off;
+	register_power_off_handler_simple(ip27_machine_power_off,
+					  POWEROFF_PRIORITY_FALLBACK);
 }
diff --git a/arch/mips/sgi-ip32/ip32-reset.c b/arch/mips/sgi-ip32/ip32-reset.c
index 1f823da..bc10c06 100644
--- a/arch/mips/sgi-ip32/ip32-reset.c
+++ b/arch/mips/sgi-ip32/ip32-reset.c
@@ -189,7 +189,8 @@ static __init int ip32_reboot_setup(void)
 
 	_machine_restart = ip32_machine_restart;
 	_machine_halt = ip32_machine_halt;
-	pm_power_off = ip32_machine_power_off;
+	register_power_off_handler_simple(ip32_machine_power_off,
+					  POWEROFF_PRIORITY_FALLBACK);
 
 	init_timer(&blink_timer);
 	blink_timer.function = blink_timeout;
diff --git a/arch/mips/sibyte/common/cfe.c b/arch/mips/sibyte/common/cfe.c
index 588e180..d8c4fce 100644
--- a/arch/mips/sibyte/common/cfe.c
+++ b/arch/mips/sibyte/common/cfe.c
@@ -245,7 +245,8 @@ void __init prom_init(void)
 
 	_machine_restart   = cfe_linux_restart;
 	_machine_halt	   = cfe_linux_halt;
-	pm_power_off = cfe_linux_halt;
+	register_power_off_handler_simple(cfe_linux_halt,
+					  POWEROFF_PRIORITY_FALLBACK);
 
 	/*
 	 * Check if a loader was used; if NOT, the 4 arguments are
diff --git a/arch/mips/sni/setup.c b/arch/mips/sni/setup.c
index efad85c..20f95e5 100644
--- a/arch/mips/sni/setup.c
+++ b/arch/mips/sni/setup.c
@@ -225,7 +225,8 @@ void __init plat_mem_setup(void)
 	}
 
 	_machine_restart = sni_machine_restart;
-	pm_power_off = sni_machine_power_off;
+	register_power_off_handler_simple(sni_machine_power_off,
+					  POWEROFF_PRIORITY_DEFAULT);
 
 	sni_display_setup();
 	sni_console_setup();
diff --git a/arch/mips/txx9/generic/setup.c b/arch/mips/txx9/generic/setup.c
index 2791b86..beef0e5 100644
--- a/arch/mips/txx9/generic/setup.c
+++ b/arch/mips/txx9/generic/setup.c
@@ -555,7 +555,8 @@ void __init plat_mem_setup(void)
 	/* fallback restart/halt routines */
 	_machine_restart = (void (*)(char *))txx9_machine_halt;
 	_machine_halt = txx9_machine_halt;
-	pm_power_off = txx9_machine_halt;
+	register_power_off_handler_simple(txx9_machine_halt,
+					  POWEROFF_PRIORITY_FALLBACK);
 
 #ifdef CONFIG_PCI
 	pcibios_plat_setup = txx9_pcibios_setup;
diff --git a/arch/mips/vr41xx/common/pmu.c b/arch/mips/vr41xx/common/pmu.c
index d7f7558..358a267 100644
--- a/arch/mips/vr41xx/common/pmu.c
+++ b/arch/mips/vr41xx/common/pmu.c
@@ -127,7 +127,8 @@ static int __init vr41xx_pmu_init(void)
 	cpu_wait = vr41xx_cpu_wait;
 	_machine_restart = vr41xx_restart;
 	_machine_halt = vr41xx_halt;
-	pm_power_off = vr41xx_halt;
+	register_power_off_handler_simple(vr41xx_halt,
+					  POWEROFF_PRIORITY_FALLBACK);
 
 	return 0;
 }
-- 
1.9.1

