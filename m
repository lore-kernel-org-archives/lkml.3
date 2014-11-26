Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391AbaKZRks (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 12:40:48 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:38527 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924AbaKZRkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 12:40:24 -0500
From: Leif Lindholm <leif.lindholm@linaro.org>
To: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: mark.rutland@arm.com, grant.likely@linaro.org, robh+dt@kernel.org,
        plagnioj@jcrosoft.com, ijc@debian.org, andrew@lunn.ch,
        s.hauer@pengutronix.de
Subject: [PATCH v2 1/2] of: add optional options parameter to of_find_node_by_path()
Date: Wed, 26 Nov 2014 17:40:39 +0000
Message-Id: <1417023640-23464-2-git-send-email-leif.lindholm@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417023640-23464-1-git-send-email-leif.lindholm@linaro.org>
References: <1417023640-23464-1-git-send-email-leif.lindholm@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update of_find_node_by_path():
1) Ignore any part of the path beyond and including the ':' separator.
2) Set the new provided pointer argument to the beginning of the string
   following the ':' separator.

Coccinelle fixup using:

@@
expression E1;
@@

- of_find_node_by_path(E1)
+ of_find_node_by_path(E1, NULL)

drivers/of/resolver.c manually updated, since spatch fails to parse
it correctly.

Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
---
 arch/arm/kernel/devtree.c                       |    2 +-
 arch/arm/mach-bcm/kona_smp.c                    |    2 +-
 arch/arm/mach-imx/clk.c                         |    2 +-
 arch/arm/mach-imx/cpu.c                         |    2 +-
 arch/arm/mach-integrator/integrator_ap.c        |    4 +-
 arch/arm/mach-mxs/mach-mxs.c                    |    2 +-
 arch/arm/mach-nomadik/cpu-8815.c                |    2 +-
 arch/arm/mach-shmobile/timer.c                  |    2 +-
 arch/arm/mach-u300/core.c                       |    2 +-
 arch/arm64/kernel/topology.c                    |    2 +-
 arch/microblaze/kernel/reset.c                  |    2 +-
 arch/powerpc/include/asm/kvm_para.h             |    2 +-
 arch/powerpc/kernel/btext.c                     |    2 +-
 arch/powerpc/kernel/ibmebus.c                   |    4 +-
 arch/powerpc/kernel/legacy_serial.c             |    4 +-
 arch/powerpc/kernel/machine_kexec.c             |    2 +-
 arch/powerpc/kernel/machine_kexec_64.c          |    2 +-
 arch/powerpc/kernel/pci_32.c                    |    4 +-
 arch/powerpc/kernel/proc_powerpc.c              |    2 +-
 arch/powerpc/kernel/rtas.c                      |    2 +-
 arch/powerpc/kernel/rtas_pci.c                  |    2 +-
 arch/powerpc/kernel/setup-common.c              |    6 +-
 arch/powerpc/kernel/setup_64.c                  |    2 +-
 arch/powerpc/mm/numa.c                          |   15 +++--
 arch/powerpc/platforms/52xx/efika.c             |    4 +-
 arch/powerpc/platforms/85xx/xes_mpc85xx.c       |    2 +-
 arch/powerpc/platforms/8xx/mpc885ads_setup.c    |    4 +-
 arch/powerpc/platforms/cell/celleb_setup.c      |    2 +-
 arch/powerpc/platforms/cell/qpace_setup.c       |    2 +-
 arch/powerpc/platforms/cell/ras.c               |    2 +-
 arch/powerpc/platforms/cell/setup.c             |    4 +-
 arch/powerpc/platforms/cell/spufs/inode.c       |    2 +-
 arch/powerpc/platforms/chrp/pci.c               |    4 +-
 arch/powerpc/platforms/chrp/setup.c             |   12 ++--
 arch/powerpc/platforms/embedded6xx/ls_uart.c    |    2 +-
 arch/powerpc/platforms/maple/pci.c              |    2 +-
 arch/powerpc/platforms/maple/setup.c            |    2 +-
 arch/powerpc/platforms/pasemi/pci.c             |    2 +-
 arch/powerpc/platforms/pasemi/setup.c           |    2 +-
 arch/powerpc/platforms/powermac/feature.c       |    6 +-
 arch/powerpc/platforms/powermac/pci.c           |    2 +-
 arch/powerpc/platforms/powermac/setup.c         |    7 ++-
 arch/powerpc/platforms/powermac/smp.c           |    4 +-
 arch/powerpc/platforms/powermac/udbg_scc.c      |    2 +-
 arch/powerpc/platforms/powernv/opal-async.c     |    2 +-
 arch/powerpc/platforms/powernv/opal-sysparam.c  |    2 +-
 arch/powerpc/platforms/powernv/opal.c           |    4 +-
 arch/powerpc/platforms/powernv/setup.c          |    2 +-
 arch/powerpc/platforms/ps3/os-area.c            |    4 +-
 arch/powerpc/platforms/pseries/dlpar.c          |    8 +--
 arch/powerpc/platforms/pseries/hotplug-memory.c |    6 +-
 arch/powerpc/platforms/pseries/io_event_irq.c   |    2 +-
 arch/powerpc/platforms/pseries/lparcfg.c        |    6 +-
 arch/powerpc/platforms/pseries/pseries_energy.c |    4 +-
 arch/powerpc/platforms/pseries/ras.c            |    4 +-
 arch/powerpc/platforms/pseries/reconfig.c       |    6 +-
 arch/powerpc/platforms/pseries/setup.c          |    4 +-
 arch/powerpc/sysdev/mpic_msgr.c                 |    2 +-
 arch/powerpc/sysdev/mv64x60_dev.c               |    2 +-
 arch/powerpc/sysdev/mv64x60_udbg.c              |    2 +-
 arch/sparc/kernel/chmc.c                        |    2 +-
 arch/sparc/kernel/irq_64.c                      |    2 +-
 arch/sparc/kernel/leon_kernel.c                 |    2 +-
 arch/sparc/kernel/leon_smp.c                    |    2 +-
 arch/sparc/kernel/of_device_32.c                |    2 +-
 arch/sparc/kernel/of_device_64.c                |    2 +-
 arch/sparc/kernel/prom_32.c                     |    2 +-
 arch/sparc/kernel/time_64.c                     |    2 +-
 arch/x86/platform/olpc/olpc.c                   |    2 +-
 drivers/ata/pata_macio.c                        |    2 +-
 drivers/cpufreq/pmac64-cpufreq.c                |    5 +-
 drivers/cpufreq/powernv-cpufreq.c               |    2 +-
 drivers/cpuidle/cpuidle-big_little.c            |    2 +-
 drivers/cpuidle/cpuidle-powernv.c               |    2 +-
 drivers/edac/cpc925_edac.c                      |    2 +-
 drivers/hwmon/ibmpowernv.c                      |    4 +-
 drivers/ide/pmac.c                              |    2 +-
 drivers/input/misc/sparcspkr.c                  |    2 +-
 drivers/input/serio/i8042-sparcio.h             |    4 +-
 drivers/irqchip/irq-atmel-aic-common.c          |    2 +-
 drivers/macintosh/therm_pm72.c                  |    4 +-
 drivers/macintosh/via-pmu-led.c                 |    2 +-
 drivers/macintosh/windfarm_mpu.h                |    2 +-
 drivers/macintosh/windfarm_pm72.c               |    2 +-
 drivers/mtd/nand/mpc5121_nfc.c                  |    2 +-
 drivers/net/ethernet/amd/sunlance.c             |    2 +-
 drivers/of/base.c                               |   31 +++++++---
 drivers/of/platform.c                           |    4 +-
 drivers/of/resolver.c                           |    4 +-
 drivers/of/selftest.c                           |   73 ++++++++++++++---------
 drivers/sbus/char/display7seg.c                 |    2 +-
 drivers/sbus/char/envctrl.c                     |    2 +-
 drivers/sbus/char/openprom.c                    |   10 ++--
 drivers/scsi/ibmvscsi/ibmvfc.c                  |    2 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c                |    2 +-
 drivers/soc/tegra/common.c                      |    2 +-
 drivers/tty/hvc/hvc_opal.c                      |    4 +-
 drivers/tty/serial/nwpserial.c                  |    2 +-
 drivers/tty/serial/suncore.c                    |    2 +-
 drivers/tty/serial/sunsu.c                      |    6 +-
 drivers/tty/sysrq.c                             |    2 +-
 drivers/video/fbdev/aty/radeon_monitor.c        |    2 +-
 drivers/virt/fsl_hypervisor.c                   |    2 +-
 drivers/watchdog/cpwd.c                         |    2 +-
 fs/openpromfs/inode.c                           |    2 +-
 include/linux/of.h                              |    5 +-
 sound/soc/fsl/fsl_ssi.c                         |    2 +-
 107 files changed, 232 insertions(+), 194 deletions(-)

diff --git a/arch/arm/kernel/devtree.c b/arch/arm/kernel/devtree.c
index 11c54de..9cbcea6 100644
--- a/arch/arm/kernel/devtree.c
+++ b/arch/arm/kernel/devtree.c
@@ -81,7 +81,7 @@ void __init arm_dt_init_cpu_maps(void)
 
 	u32 tmp_map[NR_CPUS] = { [0 ... NR_CPUS-1] = MPIDR_INVALID };
 	bool bootcpu_valid = false;
-	cpus = of_find_node_by_path("/cpus");
+	cpus = of_find_node_by_path("/cpus", NULL);
 
 	if (!cpus)
 		return;
diff --git a/arch/arm/mach-bcm/kona_smp.c b/arch/arm/mach-bcm/kona_smp.c
index 66a0465..f363b17 100644
--- a/arch/arm/mach-bcm/kona_smp.c
+++ b/arch/arm/mach-bcm/kona_smp.c
@@ -89,7 +89,7 @@ static void __init bcm_smp_prepare_cpus(unsigned int max_cpus)
 	 * and has an "enable-method" property that selects the SMP
 	 * operations defined herein.
 	 */
-	node = of_find_node_by_path("/cpus");
+	node = of_find_node_by_path("/cpus", NULL);
 	BUG_ON(!node);
 
 	/*
diff --git a/arch/arm/mach-imx/clk.c b/arch/arm/mach-imx/clk.c
index df12b53..b29926b 100644
--- a/arch/arm/mach-imx/clk.c
+++ b/arch/arm/mach-imx/clk.c
@@ -27,7 +27,7 @@ static struct clk * __init imx_obtain_fixed_clock_from_dt(const char *name)
 	if (!path)
 		return ERR_PTR(-ENOMEM);
 
-	phandle.np = of_find_node_by_path(path);
+	phandle.np = of_find_node_by_path(path, NULL);
 	kfree(path);
 
 	if (phandle.np) {
diff --git a/arch/arm/mach-imx/cpu.c b/arch/arm/mach-imx/cpu.c
index df42c14..72ac87a 100644
--- a/arch/arm/mach-imx/cpu.c
+++ b/arch/arm/mach-imx/cpu.c
@@ -87,7 +87,7 @@ struct device * __init imx_soc_device_init(void)
 
 	soc_dev_attr->family = "Freescale i.MX";
 
-	root = of_find_node_by_path("/");
+	root = of_find_node_by_path("/", NULL);
 	ret = of_property_read_string(root, "model", &soc_dev_attr->machine);
 	of_node_put(root);
 	if (ret)
diff --git a/arch/arm/mach-integrator/integrator_ap.c b/arch/arm/mach-integrator/integrator_ap.c
index 8ca290b..5013b96 100644
--- a/arch/arm/mach-integrator/integrator_ap.c
+++ b/arch/arm/mach-integrator/integrator_ap.c
@@ -407,7 +407,7 @@ static void __init ap_of_timer_init(void)
 				"arm,timer-primary", &path);
 	if (WARN_ON(err))
 		return;
-	node = of_find_node_by_path(path);
+	node = of_find_node_by_path(path, NULL);
 	base = of_iomap(node, 0);
 	if (WARN_ON(!base))
 		return;
@@ -424,7 +424,7 @@ static void __init ap_of_timer_init(void)
 				"arm,timer-secondary", &path);
 	if (WARN_ON(err))
 		return;
-	node = of_find_node_by_path(path);
+	node = of_find_node_by_path(path, NULL);
 	base = of_iomap(node, 0);
 	if (WARN_ON(!base))
 		return;
diff --git a/arch/arm/mach-mxs/mach-mxs.c b/arch/arm/mach-mxs/mach-mxs.c
index 2e7cec8..2014599 100644
--- a/arch/arm/mach-mxs/mach-mxs.c
+++ b/arch/arm/mach-mxs/mach-mxs.c
@@ -465,7 +465,7 @@ static void __init mxs_machine_init(void)
 	if (!soc_dev_attr)
 		return;
 
-	root = of_find_node_by_path("/");
+	root = of_find_node_by_path("/", NULL);
 	ret = of_property_read_string(root, "model", &soc_dev_attr->machine);
 	if (ret)
 		return;
diff --git a/arch/arm/mach-nomadik/cpu-8815.c b/arch/arm/mach-nomadik/cpu-8815.c
index 9116ca4..ffb74ef 100644
--- a/arch/arm/mach-nomadik/cpu-8815.c
+++ b/arch/arm/mach-nomadik/cpu-8815.c
@@ -118,7 +118,7 @@ static int __init cpu8815_mmcsd_init(void)
 	struct device_node *cdbias;
 	int gpio, err;
 
-	cdbias = of_find_node_by_path("/usb-s8815/mmcsd-gpio");
+	cdbias = of_find_node_by_path("/usb-s8815/mmcsd-gpio", NULL);
 	if (!cdbias) {
 		pr_info("could not find MMC/SD card detect bias node\n");
 		return 0;
diff --git a/arch/arm/mach-shmobile/timer.c b/arch/arm/mach-shmobile/timer.c
index 87c6be1..e044946 100644
--- a/arch/arm/mach-shmobile/timer.c
+++ b/arch/arm/mach-shmobile/timer.c
@@ -47,7 +47,7 @@ void __init shmobile_init_delay(void)
 	bool is_a15 = false;
 	u32 max_freq = 0;
 
-	cpus = of_find_node_by_path("/cpus");
+	cpus = of_find_node_by_path("/cpus", NULL);
 	if (!cpus)
 		return;
 
diff --git a/arch/arm/mach-u300/core.c b/arch/arm/mach-u300/core.c
index 35670b1..2f180ce 100644
--- a/arch/arm/mach-u300/core.c
+++ b/arch/arm/mach-u300/core.c
@@ -351,7 +351,7 @@ static void __init u300_init_irq_dt(void)
 	struct device_node *syscon;
 	struct clk *clk;
 
-	syscon = of_find_node_by_path("/syscon@c0011000");
+	syscon = of_find_node_by_path("/syscon@c0011000", NULL);
 	if (!syscon) {
 		pr_crit("could not find syscon node\n");
 		return;
diff --git a/arch/arm64/kernel/topology.c b/arch/arm64/kernel/topology.c
index b6ee26b..53a5d07 100644
--- a/arch/arm64/kernel/topology.c
+++ b/arch/arm64/kernel/topology.c
@@ -167,7 +167,7 @@ static int __init parse_dt_topology(void)
 	int ret = 0;
 	int cpu;
 
-	cn = of_find_node_by_path("/cpus");
+	cn = of_find_node_by_path("/cpus", NULL);
 	if (!cn) {
 		pr_err("No CPU information found in DT\n");
 		return 0;
diff --git a/arch/microblaze/kernel/reset.c b/arch/microblaze/kernel/reset.c
index fbe58c6..7b10434 100644
--- a/arch/microblaze/kernel/reset.c
+++ b/arch/microblaze/kernel/reset.c
@@ -22,7 +22,7 @@ static unsigned int reset_val;
 void of_platform_reset_gpio_probe(void)
 {
 	int ret;
-	handle = of_get_named_gpio(of_find_node_by_path("/"),
+	handle = of_get_named_gpio(of_find_node_by_path("/", NULL),
 				   "hard-reset-gpios", 0);
 
 	if (!gpio_is_valid(handle)) {
diff --git a/arch/powerpc/include/asm/kvm_para.h b/arch/powerpc/include/asm/kvm_para.h
index 336a91a..f2830c1 100644
--- a/arch/powerpc/include/asm/kvm_para.h
+++ b/arch/powerpc/include/asm/kvm_para.h
@@ -29,7 +29,7 @@ static inline int kvm_para_available(void)
 {
 	struct device_node *hyper_node;
 
-	hyper_node = of_find_node_by_path("/hypervisor");
+	hyper_node = of_find_node_by_path("/hypervisor", NULL);
 	if (!hyper_node)
 		return 0;
 
diff --git a/arch/powerpc/kernel/btext.c b/arch/powerpc/kernel/btext.c
index 41c011c..6a350c8 100644
--- a/arch/powerpc/kernel/btext.c
+++ b/arch/powerpc/kernel/btext.c
@@ -237,7 +237,7 @@ int __init btext_find_display(int allow_nonstdout)
 
 	name = of_get_property(of_chosen, "linux,stdout-path", NULL);
 	if (name != NULL) {
-		np = of_find_node_by_path(name);
+		np = of_find_node_by_path(name, NULL);
 		if (np != NULL) {
 			if (strcmp(np->type, "display") != 0) {
 				printk("boot stdout isn't a display !\n");
diff --git a/arch/powerpc/kernel/ibmebus.c b/arch/powerpc/kernel/ibmebus.c
index ac86c53..d85d71d 100644
--- a/arch/powerpc/kernel/ibmebus.c
+++ b/arch/powerpc/kernel/ibmebus.c
@@ -182,7 +182,7 @@ static int ibmebus_create_devices(const struct of_device_id *matches)
 	struct device_node *root, *child;
 	int ret = 0;
 
-	root = of_find_node_by_path("/");
+	root = of_find_node_by_path("/", NULL);
 
 	for_each_child_of_node(root, child) {
 		if (!of_match_node(matches, child))
@@ -277,7 +277,7 @@ static ssize_t ibmebus_store_probe(struct bus_type *bus,
 		goto out;
 	}
 
-	if ((dn = of_find_node_by_path(path))) {
+	if ((dn = of_find_node_by_path(path, NULL))) {
 		rc = ibmebus_create_device(dn);
 		of_node_put(dn);
 	} else {
diff --git a/arch/powerpc/kernel/legacy_serial.c b/arch/powerpc/kernel/legacy_serial.c
index 7b750c4..5f86fb2 100644
--- a/arch/powerpc/kernel/legacy_serial.c
+++ b/arch/powerpc/kernel/legacy_serial.c
@@ -371,7 +371,7 @@ void __init find_legacy_serial_ports(void)
 	/* Now find out if one of these is out firmware console */
 	path = of_get_property(of_chosen, "linux,stdout-path", NULL);
 	if (path != NULL) {
-		stdout = of_find_node_by_path(path);
+		stdout = of_find_node_by_path(path, NULL);
 		if (stdout)
 			DBG("stdout is %s\n", stdout->full_name);
 	} else {
@@ -597,7 +597,7 @@ static int __init check_legacy_serial_console(void)
 		DBG(" no linux,stdout-path !\n");
 		return -ENODEV;
 	}
-	prom_stdout = of_find_node_by_path(name);
+	prom_stdout = of_find_node_by_path(name, NULL);
 	if (!prom_stdout) {
 		DBG(" can't find stdout package %s !\n", name);
 		return -ENODEV;
diff --git a/arch/powerpc/kernel/machine_kexec.c b/arch/powerpc/kernel/machine_kexec.c
index 015ae55..53b3e96 100644
--- a/arch/powerpc/kernel/machine_kexec.c
+++ b/arch/powerpc/kernel/machine_kexec.c
@@ -260,7 +260,7 @@ static int __init kexec_setup(void)
 	struct device_node *node;
 	struct property *prop;
 
-	node = of_find_node_by_path("/chosen");
+	node = of_find_node_by_path("/chosen", NULL);
 	if (!node)
 		return -ENOENT;
 
diff --git a/arch/powerpc/kernel/machine_kexec_64.c b/arch/powerpc/kernel/machine_kexec_64.c
index 879b3aa..c67fc02 100644
--- a/arch/powerpc/kernel/machine_kexec_64.c
+++ b/arch/powerpc/kernel/machine_kexec_64.c
@@ -392,7 +392,7 @@ static int __init export_htab_values(void)
 	if (!htab_address)
 		return -ENODEV;
 
-	node = of_find_node_by_path("/chosen");
+	node = of_find_node_by_path("/chosen", NULL);
 	if (!node)
 		return -ENODEV;
 
diff --git a/arch/powerpc/kernel/pci_32.c b/arch/powerpc/kernel/pci_32.c
index 432459c..609adbb 100644
--- a/arch/powerpc/kernel/pci_32.c
+++ b/arch/powerpc/kernel/pci_32.c
@@ -132,7 +132,7 @@ pcibios_make_OF_bus_map(void)
 			continue;
 		make_one_node_map(node, hose->first_busno);
 	}
-	dn = of_find_node_by_path("/");
+	dn = of_find_node_by_path("/", NULL);
 	map_prop = of_find_property(dn, "pci-OF-bus-map", NULL);
 	if (map_prop) {
 		BUG_ON(pci_bus_count > map_prop->length);
@@ -202,7 +202,7 @@ pci_create_OF_bus_map(void)
 	of_prop = (struct property*) alloc_bootmem(sizeof(struct property) + 256);
 	if (!of_prop)
 		return;
-	dn = of_find_node_by_path("/");
+	dn = of_find_node_by_path("/", NULL);
 	if (dn) {
 		memset(of_prop, -1, sizeof(struct property) + 256);
 		of_prop->name = "pci-OF-bus-map";
diff --git a/arch/powerpc/kernel/proc_powerpc.c b/arch/powerpc/kernel/proc_powerpc.c
index c30612a..ed88000 100644
--- a/arch/powerpc/kernel/proc_powerpc.c
+++ b/arch/powerpc/kernel/proc_powerpc.c
@@ -92,7 +92,7 @@ static int __init proc_ppc64_create(void)
 		pr_err("Failed to create link /proc/ppc64 -> /proc/powerpc\n");
 #endif
 
-	if (!of_find_node_by_path("/rtas"))
+	if (!of_find_node_by_path("/rtas", NULL))
 		return 0;
 
 	if (!proc_mkdir("rtas", root))
diff --git a/arch/powerpc/kernel/rtas.c b/arch/powerpc/kernel/rtas.c
index 8b4c857..3723477 100644
--- a/arch/powerpc/kernel/rtas.c
+++ b/arch/powerpc/kernel/rtas.c
@@ -218,7 +218,7 @@ void rtas_progress(char *s, unsigned short hex)
 
 	if (display_width == 0) {
 		display_width = 0x10;
-		if ((root = of_find_node_by_path("/rtas"))) {
+		if ((root = of_find_node_by_path("/rtas", NULL))) {
 			if ((p = of_get_property(root,
 					"ibm,display-line-length", NULL)))
 				display_width = be32_to_cpu(*p);
diff --git a/arch/powerpc/kernel/rtas_pci.c b/arch/powerpc/kernel/rtas_pci.c
index 7c55b86..3101891 100644
--- a/arch/powerpc/kernel/rtas_pci.c
+++ b/arch/powerpc/kernel/rtas_pci.c
@@ -283,7 +283,7 @@ void __init find_and_init_phbs(void)
 {
 	struct device_node *node;
 	struct pci_controller *phb;
-	struct device_node *root = of_find_node_by_path("/");
+	struct device_node *root = of_find_node_by_path("/", NULL);
 
 	for_each_child_of_node(root, node) {
 		if (node->type == NULL || (strcmp(node->type, "pci") != 0 &&
diff --git a/arch/powerpc/kernel/setup-common.c b/arch/powerpc/kernel/setup-common.c
index 1362cd6..443808c 100644
--- a/arch/powerpc/kernel/setup-common.c
+++ b/arch/powerpc/kernel/setup-common.c
@@ -192,7 +192,7 @@ static void show_cpuinfo_summary(struct seq_file *m)
 	seq_printf(m, "timebase\t: %lu\n", ppc_tb_freq);
 	if (ppc_md.name)
 		seq_printf(m, "platform\t: %s\n", ppc_md.name);
-	root = of_find_node_by_path("/");
+	root = of_find_node_by_path("/", NULL);
 	if (root)
 		model = of_get_property(root, "model", NULL);
 	if (model)
@@ -501,7 +501,7 @@ void __init smp_setup_cpu_maps(void)
 	 * could possibly be added to this partition.
 	 */
 	if (machine_is(pseries) && firmware_has_feature(FW_FEATURE_LPAR) &&
-	    (dn = of_find_node_by_path("/rtas"))) {
+	    (dn = of_find_node_by_path("/rtas", NULL))) {
 		int num_addr_cell, num_size_cell, maxcpus;
 		const __be32 *ireg;
 
@@ -706,7 +706,7 @@ static int __init check_cache_coherency(void)
 	const void *prop;
 	int devtree_coherency;
 
-	np = of_find_node_by_path("/");
+	np = of_find_node_by_path("/", NULL);
 	prop = of_get_property(np, "coherency-off", NULL);
 	of_node_put(np);
 
diff --git a/arch/powerpc/kernel/setup_64.c b/arch/powerpc/kernel/setup_64.c
index 4f3cfe1..2b1d227 100644
--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -158,7 +158,7 @@ static void check_smt_enabled(void)
 					min(threads_per_core, smt);
 		}
 	} else {
-		dn = of_find_node_by_path("/options");
+		dn = of_find_node_by_path("/options", NULL);
 		if (dn) {
 			smt_option = of_get_property(dn, "ibm,smt-enabled",
 						     NULL);
diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
index b9d1dfd..edcea78 100644
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -319,11 +319,11 @@ static int __init find_min_common_depth(void)
 	struct device_node *root;
 
 	if (firmware_has_feature(FW_FEATURE_OPAL))
-		root = of_find_node_by_path("/ibm,opal");
+		root = of_find_node_by_path("/ibm,opal", NULL);
 	else
-		root = of_find_node_by_path("/rtas");
+		root = of_find_node_by_path("/rtas", NULL);
 	if (!root)
-		root = of_find_node_by_path("/");
+		root = of_find_node_by_path("/", NULL);
 
 	/*
 	 * This property is a set of 32-bit integers, each representing
@@ -827,7 +827,8 @@ new_range:
 	 * ibm,dynamic-memory property in the
 	 * ibm,dynamic-reconfiguration-memory node.
 	 */
-	memory = of_find_node_by_path("/ibm,dynamic-reconfiguration-memory");
+	memory = of_find_node_by_path("/ibm,dynamic-reconfiguration-memory",
+				      NULL);
 	if (memory)
 		parse_drconf_memory(memory);
 
@@ -1276,7 +1277,8 @@ int hot_add_scn_to_nid(unsigned long scn_addr)
 	if (!numa_enabled || (min_common_depth < 0))
 		return first_online_node;
 
-	memory = of_find_node_by_path("/ibm,dynamic-reconfiguration-memory");
+	memory = of_find_node_by_path("/ibm,dynamic-reconfiguration-memory",
+				      NULL);
 	if (memory) {
 		nid = hot_add_drconf_scn_to_nid(memory, scn_addr);
 		of_node_put(memory);
@@ -1308,7 +1310,8 @@ static u64 hot_add_drconf_memory_max(void)
         u64 lmb_size = 0;
 	const __be32 *dm = NULL;
 
-        memory = of_find_node_by_path("/ibm,dynamic-reconfiguration-memory");
+        memory = of_find_node_by_path("/ibm,dynamic-reconfiguration-memory",
+                                      NULL);
         if (memory) {
                 drconf_cell_cnt = of_get_drconf_memory(memory, &dm);
                 lmb_size = of_get_lmb_size(memory);
diff --git a/arch/powerpc/platforms/52xx/efika.c b/arch/powerpc/platforms/52xx/efika.c
index 3feffde..549e049 100644
--- a/arch/powerpc/platforms/52xx/efika.c
+++ b/arch/powerpc/platforms/52xx/efika.c
@@ -75,7 +75,7 @@ static void __init efika_pcisetup(void)
 	struct device_node *root;
 	struct device_node *pcictrl;
 
-	root = of_find_node_by_path("/");
+	root = of_find_node_by_path("/", NULL);
 	if (root == NULL) {
 		printk(KERN_WARNING EFIKA_PLATFORM_NAME
 		       ": Unable to find the root node\n");
@@ -148,7 +148,7 @@ static void efika_show_cpuinfo(struct seq_file *m)
 	const char *codegendescription;
 	const char *codegenvendor;
 
-	root = of_find_node_by_path("/");
+	root = of_find_node_by_path("/", NULL);
 	if (!root)
 		return;
 
diff --git a/arch/powerpc/platforms/85xx/xes_mpc85xx.c b/arch/powerpc/platforms/85xx/xes_mpc85xx.c
index 1a9c108..0b0ee19 100644
--- a/arch/powerpc/platforms/85xx/xes_mpc85xx.c
+++ b/arch/powerpc/platforms/85xx/xes_mpc85xx.c
@@ -119,7 +119,7 @@ static void __init xes_mpc85xx_setup_arch(void)
 	struct device_node *root;
 	const char *model = "Unknown";
 
-	root = of_find_node_by_path("/");
+	root = of_find_node_by_path("/", NULL);
 	if (root == NULL)
 		return;
 
diff --git a/arch/powerpc/platforms/8xx/mpc885ads_setup.c b/arch/powerpc/platforms/8xx/mpc885ads_setup.c
index 4d62bf9..55e7974 100644
--- a/arch/powerpc/platforms/8xx/mpc885ads_setup.c
+++ b/arch/powerpc/platforms/8xx/mpc885ads_setup.c
@@ -176,9 +176,9 @@ static void __init mpc885ads_setup_arch(void)
 
 	setbits32(&bcsr[1], BCSR1_ETHEN);
 
-	np = of_find_node_by_path("/soc@ff000000/cpm@9c0/serial@a80");
+	np = of_find_node_by_path("/soc@ff000000/cpm@9c0/serial@a80", NULL);
 #else
-	np = of_find_node_by_path("/soc@ff000000/cpm@9c0/ethernet@a40");
+	np = of_find_node_by_path("/soc@ff000000/cpm@9c0/ethernet@a40", NULL);
 #endif
 
 	/* The SCC3 enet registers overlap the SMC1 registers, so
diff --git a/arch/powerpc/platforms/cell/celleb_setup.c b/arch/powerpc/platforms/cell/celleb_setup.c
index 34e8ce2..655b2dc 100644
--- a/arch/powerpc/platforms/cell/celleb_setup.c
+++ b/arch/powerpc/platforms/cell/celleb_setup.c
@@ -71,7 +71,7 @@ static void celleb_show_cpuinfo(struct seq_file *m)
 	struct device_node *root;
 	const char *model = "";
 
-	root = of_find_node_by_path("/");
+	root = of_find_node_by_path("/", NULL);
 	if (root)
 		model = of_get_property(root, "model", NULL);
 	/* using "CHRP" is to trick anaconda into installing FCx into Celleb */
diff --git a/arch/powerpc/platforms/cell/qpace_setup.c b/arch/powerpc/platforms/cell/qpace_setup.c
index 6e3409d..1ad8ac6 100644
--- a/arch/powerpc/platforms/cell/qpace_setup.c
+++ b/arch/powerpc/platforms/cell/qpace_setup.c
@@ -49,7 +49,7 @@ static void qpace_show_cpuinfo(struct seq_file *m)
 	struct device_node *root;
 	const char *model = "";
 
-	root = of_find_node_by_path("/");
+	root = of_find_node_by_path("/", NULL);
 	if (root)
 		model = of_get_property(root, "model", NULL);
 	seq_printf(m, "machine\t\t: CHRP %s\n", model);
diff --git a/arch/powerpc/platforms/cell/ras.c b/arch/powerpc/platforms/cell/ras.c
index e865d74..429f3547 100644
--- a/arch/powerpc/platforms/cell/ras.c
+++ b/arch/powerpc/platforms/cell/ras.c
@@ -169,7 +169,7 @@ static int __init cbe_ptcal_enable(void)
 	struct device_node *np;
 	int order, found_mic = 0;
 
-	np = of_find_node_by_path("/rtas");
+	np = of_find_node_by_path("/rtas", NULL);
 	if (!np)
 		return -ENODEV;
 
diff --git a/arch/powerpc/platforms/cell/setup.c b/arch/powerpc/platforms/cell/setup.c
index 6ae25fb..379a903 100644
--- a/arch/powerpc/platforms/cell/setup.c
+++ b/arch/powerpc/platforms/cell/setup.c
@@ -69,7 +69,7 @@ static void cell_show_cpuinfo(struct seq_file *m)
 	struct device_node *root;
 	const char *model = "";
 
-	root = of_find_node_by_path("/");
+	root = of_find_node_by_path("/", NULL);
 	if (root)
 		model = of_get_property(root, "model", NULL);
 	seq_printf(m, "machine\t\t: CHRP %s\n", model);
@@ -154,7 +154,7 @@ static const struct of_device_id cell_bus_ids[] __initconst = {
 
 static int __init cell_publish_devices(void)
 {
-	struct device_node *root = of_find_node_by_path("/");
+	struct device_node *root = of_find_node_by_path("/", NULL);
 	struct device_node *np;
 	int node;
 
diff --git a/arch/powerpc/platforms/cell/spufs/inode.c b/arch/powerpc/platforms/cell/spufs/inode.c
index 87ba7cf..f3fe01d 100644
--- a/arch/powerpc/platforms/cell/spufs/inode.c
+++ b/arch/powerpc/platforms/cell/spufs/inode.c
@@ -659,7 +659,7 @@ spufs_init_isolated_loader(void)
 	const char *loader;
 	int size;
 
-	dn = of_find_node_by_path("/spu-isolation");
+	dn = of_find_node_by_path("/spu-isolation", NULL);
 	if (!dn)
 		return;
 
diff --git a/arch/powerpc/platforms/chrp/pci.c b/arch/powerpc/platforms/chrp/pci.c
index 1b87e19..8fa3192 100644
--- a/arch/powerpc/platforms/chrp/pci.c
+++ b/arch/powerpc/platforms/chrp/pci.c
@@ -188,7 +188,7 @@ setup_python(struct pci_controller *hose, struct device_node *dev)
 /* Marvell Discovery II based Pegasos 2 */
 static void __init setup_peg2(struct pci_controller *hose, struct device_node *dev)
 {
-	struct device_node *root = of_find_node_by_path("/");
+	struct device_node *root = of_find_node_by_path("/", NULL);
 	struct device_node *rtas;
 
 	rtas = of_find_node_by_name (root, "rtas");
@@ -213,7 +213,7 @@ chrp_find_bridges(void)
 	const unsigned int *dma;
 	const char *model, *machine;
 	int is_longtrail = 0, is_mot = 0, is_pegasos = 0;
-	struct device_node *root = of_find_node_by_path("/");
+	struct device_node *root = of_find_node_by_path("/", NULL);
 	struct resource r;
 	/*
 	 * The PCI host bridge nodes on some machines don't have
diff --git a/arch/powerpc/platforms/chrp/setup.c b/arch/powerpc/platforms/chrp/setup.c
index 5b77b19..f820d61 100644
--- a/arch/powerpc/platforms/chrp/setup.c
+++ b/arch/powerpc/platforms/chrp/setup.c
@@ -100,7 +100,7 @@ void chrp_show_cpuinfo(struct seq_file *m)
 	struct device_node *root;
 	const char *model = "";
 
-	root = of_find_node_by_path("/");
+	root = of_find_node_by_path("/", NULL);
 	if (root)
 		model = of_get_property(root, "model", NULL);
 	seq_printf(m, "machine\t\t: CHRP %s\n", model);
@@ -196,7 +196,7 @@ static void __init sio_init(void)
 	struct device_node *root;
 	const char *model;
 
-	root = of_find_node_by_path("/");
+	root = of_find_node_by_path("/", NULL);
 	if (!root)
 		return;
 
@@ -263,7 +263,7 @@ static void chrp_init_early(void)
 	/* find the boot console from /chosen/stdout */
 	if (!of_chosen)
 		return;
-	node = of_find_node_by_path("/");
+	node = of_find_node_by_path("/", NULL);
 	if (!node)
 		return;
 	property = of_get_property(node, "model", NULL);
@@ -276,7 +276,7 @@ static void chrp_init_early(void)
 	if (!property)
 		goto out_put;
 	of_node_put(node);
-	node = of_find_node_by_path(property);
+	node = of_find_node_by_path(property, NULL);
 	if (!node)
 		return;
 	property = of_get_property(node, "device_type", NULL);
@@ -300,7 +300,7 @@ out_put:
 
 void __init chrp_setup_arch(void)
 {
-	struct device_node *root = of_find_node_by_path("/");
+	struct device_node *root = of_find_node_by_path("/", NULL);
 	const char *machine = NULL;
 
 	/* init to some ~sane value until calibrate_delay() runs */
@@ -390,7 +390,7 @@ static void __init chrp_find_openpic(void)
 	np = of_find_node_by_type(NULL, "open-pic");
 	if (np == NULL)
 		return;
-	root = of_find_node_by_path("/");
+	root = of_find_node_by_path("/", NULL);
 	if (root) {
 		opprop = of_get_property(root, "platform-open-pic", &oplen);
 		na = of_n_addr_cells(root);
diff --git a/arch/powerpc/platforms/embedded6xx/ls_uart.c b/arch/powerpc/platforms/embedded6xx/ls_uart.c
index 9d891bd..51d5373 100644
--- a/arch/powerpc/platforms/embedded6xx/ls_uart.c
+++ b/arch/powerpc/platforms/embedded6xx/ls_uart.c
@@ -117,7 +117,7 @@ static int __init ls_uarts_init(void)
 	phys_addr_t phys_addr;
 	int len;
 
-	avr = of_find_node_by_path("/soc10x/serial@80004500");
+	avr = of_find_node_by_path("/soc10x/serial@80004500", NULL);
 	if (!avr)
 		return -EINVAL;
 
diff --git a/arch/powerpc/platforms/maple/pci.c b/arch/powerpc/platforms/maple/pci.c
index f7136aa..2c60cc4 100644
--- a/arch/powerpc/platforms/maple/pci.c
+++ b/arch/powerpc/platforms/maple/pci.c
@@ -578,7 +578,7 @@ void __init maple_pci_init(void)
 	 * and actually added last as it's resource management relies
 	 * on the AGP resources to have been setup first
 	 */
-	root = of_find_node_by_path("/");
+	root = of_find_node_by_path("/", NULL);
 	if (root == NULL) {
 		printk(KERN_CRIT "maple_find_bridges: can't find root of device tree\n");
 		return;
diff --git a/arch/powerpc/platforms/maple/setup.c b/arch/powerpc/platforms/maple/setup.c
index cb1b0b3..6306997 100644
--- a/arch/powerpc/platforms/maple/setup.c
+++ b/arch/powerpc/platforms/maple/setup.c
@@ -244,7 +244,7 @@ static void __init maple_init_IRQ(void)
 	}
 
 	/* Find address list in /platform-open-pic */
-	root = of_find_node_by_path("/");
+	root = of_find_node_by_path("/", NULL);
 	naddr = of_n_addr_cells(root);
 	opprop = of_get_property(root, "platform-open-pic", &opplen);
 	if (opprop != 0) {
diff --git a/arch/powerpc/platforms/pasemi/pci.c b/arch/powerpc/platforms/pasemi/pci.c
index aa86271..39eb8a5 100644
--- a/arch/powerpc/platforms/pasemi/pci.c
+++ b/arch/powerpc/platforms/pasemi/pci.c
@@ -214,7 +214,7 @@ void __init pas_pci_init(void)
 {
 	struct device_node *np, *root;
 
-	root = of_find_node_by_path("/");
+	root = of_find_node_by_path("/", NULL);
 	if (!root) {
 		printk(KERN_CRIT "pas_pci_init: can't find root "
 			"of device tree\n");
diff --git a/arch/powerpc/platforms/pasemi/setup.c b/arch/powerpc/platforms/pasemi/setup.c
index d71b2c7..f8bfc42 100644
--- a/arch/powerpc/platforms/pasemi/setup.c
+++ b/arch/powerpc/platforms/pasemi/setup.c
@@ -213,7 +213,7 @@ static __init void pas_init_IRQ(void)
 	}
 
 	/* Find address list in /platform-open-pic */
-	root = of_find_node_by_path("/");
+	root = of_find_node_by_path("/", NULL);
 	naddr = of_n_addr_cells(root);
 	opprop = of_get_property(root, "platform-open-pic", &opplen);
 	if (!opprop) {
diff --git a/arch/powerpc/platforms/powermac/feature.c b/arch/powerpc/platforms/powermac/feature.c
index 4882bfd..cdcdf05 100644
--- a/arch/powerpc/platforms/powermac/feature.c
+++ b/arch/powerpc/platforms/powermac/feature.c
@@ -1059,7 +1059,7 @@ core99_reset_cpu(struct device_node *node, long param, long value)
 	if (macio->type != macio_keylargo)
 		return -ENODEV;
 
-	cpus = of_find_node_by_path("/cpus");
+	cpus = of_find_node_by_path("/cpus", NULL);
 	if (cpus == NULL)
 		return -ENODEV;
 	for (np = cpus->child; np != NULL; np = np->sibling) {
@@ -1510,7 +1510,7 @@ static long g5_reset_cpu(struct device_node *node, long param, long value)
 	if (macio->type != macio_keylargo2 && macio->type != macio_shasta)
 		return -ENODEV;
 
-	cpus = of_find_node_by_path("/cpus");
+	cpus = of_find_node_by_path("/cpus", NULL);
 	if (cpus == NULL)
 		return -ENODEV;
 	for (np = cpus->child; np != NULL; np = np->sibling) {
@@ -2516,7 +2516,7 @@ found:
 	 * that all Apple OF revs did it properly, I do it the paranoid way.
 	 */
 	while (uninorth_base && uninorth_rev > 3) {
-		struct device_node *cpus = of_find_node_by_path("/cpus");
+		struct device_node *cpus = of_find_node_by_path("/cpus", NULL);
 		struct device_node *np;
 
 		if (!cpus || !cpus->child) {
diff --git a/arch/powerpc/platforms/powermac/pci.c b/arch/powerpc/platforms/powermac/pci.c
index 7e868cc..012100f 100644
--- a/arch/powerpc/platforms/powermac/pci.c
+++ b/arch/powerpc/platforms/powermac/pci.c
@@ -1014,7 +1014,7 @@ void __init pmac_pci_init(void)
 
 	pci_set_flags(PCI_CAN_SKIP_ISA_ALIGN);
 
-	root = of_find_node_by_path("/");
+	root = of_find_node_by_path("/", NULL);
 	if (root == NULL) {
 		printk(KERN_CRIT "pmac_pci_init: can't find root "
 		       "of device tree\n");
diff --git a/arch/powerpc/platforms/powermac/setup.c b/arch/powerpc/platforms/powermac/setup.c
index b127a29..5d98010 100644
--- a/arch/powerpc/platforms/powermac/setup.c
+++ b/arch/powerpc/platforms/powermac/setup.c
@@ -121,7 +121,7 @@ static void pmac_show_cpuinfo(struct seq_file *m)
 
 	/* find motherboard type */
 	seq_printf(m, "machine\t\t: ");
-	np = of_find_node_by_path("/");
+	np = of_find_node_by_path("/", NULL);
 	if (np != NULL) {
 		pp = of_get_property(np, "model", NULL);
 		if (pp != NULL)
@@ -510,7 +510,8 @@ static int __init pmac_declare_of_platform_devices(void)
 	np = of_find_node_by_type(NULL, "fcu");
 	if (np == NULL) {
 		/* Some machines have strangely broken device-tree */
-		np = of_find_node_by_path("/u3@0,f8000000/i2c@f8001000/fan@15e");
+		np = of_find_node_by_path("/u3@0,f8000000/i2c@f8001000/fan@15e",
+					  NULL);
 	}
 	if (np) {
 		of_platform_device_create(np, "temperature", NULL);
@@ -559,7 +560,7 @@ static int __init check_pmac_serial_console(void)
 		pr_debug(" no linux,stdout-path !\n");
 		return -ENODEV;
 	}
-	prom_stdout = of_find_node_by_path(name);
+	prom_stdout = of_find_node_by_path(name, NULL);
 	if (!prom_stdout) {
 		pr_debug(" can't find stdout package %s !\n", name);
 		return -ENODEV;
diff --git a/arch/powerpc/platforms/powermac/smp.c b/arch/powerpc/platforms/powermac/smp.c
index af094ae..00ed6a0 100644
--- a/arch/powerpc/platforms/powermac/smp.c
+++ b/arch/powerpc/platforms/powermac/smp.c
@@ -637,7 +637,7 @@ static void smp_core99_pfunc_tb_freeze(int freeze)
 	struct device_node *cpus;
 	struct pmf_args args;
 
-	cpus = of_find_node_by_path("/cpus");
+	cpus = of_find_node_by_path("/cpus", NULL);
 	BUG_ON(cpus == NULL);
 	args.count = 1;
 	args.u[0].v = !freeze;
@@ -713,7 +713,7 @@ static void __init smp_core99_setup(int ncpus)
 	/* pfunc based HW sync on recent G5s */
 	if (pmac_tb_freeze == NULL) {
 		struct device_node *cpus =
-			of_find_node_by_path("/cpus");
+			of_find_node_by_path("/cpus", NULL);
 		if (cpus &&
 		    of_get_property(cpus, "platform-cpu-timebase", NULL)) {
 			pmac_tb_freeze = smp_core99_pfunc_tb_freeze;
diff --git a/arch/powerpc/platforms/powermac/udbg_scc.c b/arch/powerpc/platforms/powermac/udbg_scc.c
index d83135a9..f4140c3 100644
--- a/arch/powerpc/platforms/powermac/udbg_scc.c
+++ b/arch/powerpc/platforms/powermac/udbg_scc.c
@@ -83,7 +83,7 @@ void udbg_scc_init(int force_scc)
 		goto bail;
 	path = of_get_property(of_chosen, "linux,stdout-path", NULL);
 	if (path != NULL)
-		stdout = of_find_node_by_path(path);
+		stdout = of_find_node_by_path(path, NULL);
 	for (ch = NULL; (ch = of_get_next_child(escc, ch)) != NULL;) {
 		if (ch == stdout)
 			ch_def = of_node_get(ch);
diff --git a/arch/powerpc/platforms/powernv/opal-async.c b/arch/powerpc/platforms/powernv/opal-async.c
index e462ab9..07c10f8 100644
--- a/arch/powerpc/platforms/powernv/opal-async.c
+++ b/arch/powerpc/platforms/powernv/opal-async.c
@@ -154,7 +154,7 @@ static int __init opal_async_comp_init(void)
 	const __be32 *async;
 	int err;
 
-	opal_node = of_find_node_by_path("/ibm,opal");
+	opal_node = of_find_node_by_path("/ibm,opal", NULL);
 	if (!opal_node) {
 		pr_err("%s: Opal node not found\n", __func__);
 		err = -ENOENT;
diff --git a/arch/powerpc/platforms/powernv/opal-sysparam.c b/arch/powerpc/platforms/powernv/opal-sysparam.c
index 9d1acf2..2a4d596 100644
--- a/arch/powerpc/platforms/powernv/opal-sysparam.c
+++ b/arch/powerpc/platforms/powernv/opal-sysparam.c
@@ -176,7 +176,7 @@ void __init opal_sys_param_init(void)
 		goto out_kobj_put;
 	}
 
-	sysparam = of_find_node_by_path("/ibm,opal/sysparams");
+	sysparam = of_find_node_by_path("/ibm,opal/sysparams", NULL);
 	if (!sysparam) {
 		pr_err("SYSPARAM: Opal sysparam node not found\n");
 		goto out_param_buf;
diff --git a/arch/powerpc/platforms/powernv/opal.c b/arch/powerpc/platforms/powernv/opal.c
index d019b08..300b70c 100644
--- a/arch/powerpc/platforms/powernv/opal.c
+++ b/arch/powerpc/platforms/powernv/opal.c
@@ -650,7 +650,7 @@ static int __init opal_init(void)
 	const __be32 *irqs;
 	int rc, i, irqlen;
 
-	opal_node = of_find_node_by_path("/ibm,opal");
+	opal_node = of_find_node_by_path("/ibm,opal", NULL);
 	if (!opal_node) {
 		pr_warn("opal: Node not found\n");
 		return -ENODEV;
@@ -658,7 +658,7 @@ static int __init opal_init(void)
 
 	/* Register OPAL consoles if any ports */
 	if (firmware_has_feature(FW_FEATURE_OPALv2))
-		consoles = of_find_node_by_path("/ibm,opal/consoles");
+		consoles = of_find_node_by_path("/ibm,opal/consoles", NULL);
 	else
 		consoles = of_node_get(opal_node);
 	if (consoles) {
diff --git a/arch/powerpc/platforms/powernv/setup.c b/arch/powerpc/platforms/powernv/setup.c
index 3f9546d..f78868a 100644
--- a/arch/powerpc/platforms/powernv/setup.c
+++ b/arch/powerpc/platforms/powernv/setup.c
@@ -87,7 +87,7 @@ static void pnv_show_cpuinfo(struct seq_file *m)
 	struct device_node *root;
 	const char *model = "";
 
-	root = of_find_node_by_path("/");
+	root = of_find_node_by_path("/", NULL);
 	if (root)
 		model = of_get_property(root, "model", NULL);
 	seq_printf(m, "machine\t\t: PowerNV %s\n", model);
diff --git a/arch/powerpc/platforms/ps3/os-area.c b/arch/powerpc/platforms/ps3/os-area.c
index 0978713..f0c4695 100644
--- a/arch/powerpc/platforms/ps3/os-area.c
+++ b/arch/powerpc/platforms/ps3/os-area.c
@@ -694,7 +694,7 @@ static void os_area_queue_work_handler(struct work_struct *work)
 
 	pr_debug(" -> %s:%d\n", __func__, __LINE__);
 
-	node = of_find_node_by_path("/");
+	node = of_find_node_by_path("/", NULL);
 	if (node) {
 		os_area_set_property(node, &property_rtc_diff);
 		of_node_put(node);
@@ -792,7 +792,7 @@ void __init ps3_os_area_init(void)
 
 	pr_debug(" -> %s:%d\n", __func__, __LINE__);
 
-	node = of_find_node_by_path("/");
+	node = of_find_node_by_path("/", NULL);
 
 	if (!saved_params.valid && node) {
 		/* Second stage kernels should have a dt entry. */
diff --git a/arch/powerpc/platforms/pseries/dlpar.c b/arch/powerpc/platforms/pseries/dlpar.c
index c22bb1b..888b7bb 100644
--- a/arch/powerpc/platforms/pseries/dlpar.c
+++ b/arch/powerpc/platforms/pseries/dlpar.c
@@ -249,7 +249,7 @@ static struct device_node *derive_parent(const char *path)
 
 	last_slash = strrchr(path, '/');
 	if (last_slash == path) {
-		parent = of_find_node_by_path("/");
+		parent = of_find_node_by_path("/", NULL);
 	} else {
 		char *parent_path;
 		int parent_path_len = last_slash - path + 1;
@@ -258,7 +258,7 @@ static struct device_node *derive_parent(const char *path)
 			return NULL;
 
 		strlcpy(parent_path, path, parent_path_len);
-		parent = of_find_node_by_path(parent_path);
+		parent = of_find_node_by_path(parent_path, NULL);
 		kfree(parent_path);
 	}
 
@@ -410,7 +410,7 @@ static ssize_t dlpar_cpu_probe(const char *buf, size_t count)
 	if (rc)
 		return -EINVAL;
 
-	parent = of_find_node_by_path("/cpus");
+	parent = of_find_node_by_path("/cpus", NULL);
 	if (!parent)
 		return -ENODEV;
 
@@ -502,7 +502,7 @@ static ssize_t dlpar_cpu_release(const char *buf, size_t count)
 	u32 drc_index;
 	int rc;
 
-	dn = of_find_node_by_path(buf);
+	dn = of_find_node_by_path(buf, NULL);
 	if (!dn)
 		return -EINVAL;
 
diff --git a/arch/powerpc/platforms/pseries/hotplug-memory.c b/arch/powerpc/platforms/pseries/hotplug-memory.c
index 3c4c0dc..3acb8d1 100644
--- a/arch/powerpc/platforms/pseries/hotplug-memory.c
+++ b/arch/powerpc/platforms/pseries/hotplug-memory.c
@@ -28,7 +28,7 @@ unsigned long pseries_memory_block_size(void)
 	unsigned int memblock_size = MIN_MEMORY_BLOCK_SIZE;
 	struct resource r;
 
-	np = of_find_node_by_path("/ibm,dynamic-reconfiguration-memory");
+	np = of_find_node_by_path("/ibm,dynamic-reconfiguration-memory", NULL);
 	if (np) {
 		const __be64 *size;
 
@@ -40,7 +40,7 @@ unsigned long pseries_memory_block_size(void)
 		/* This fallback really only applies to pseries */
 		unsigned int memzero_size = 0;
 
-		np = of_find_node_by_path("/memory@0");
+		np = of_find_node_by_path("/memory@0", NULL);
 		if (np) {
 			if (!of_address_to_resource(np, 0, &r))
 				memzero_size = resource_size(&r);
@@ -54,7 +54,7 @@ unsigned long pseries_memory_block_size(void)
 			char buf[64];
 
 			sprintf(buf, "/memory@%x", memzero_size);
-			np = of_find_node_by_path(buf);
+			np = of_find_node_by_path(buf, NULL);
 			if (np) {
 				if (!of_address_to_resource(np, 0, &r))
 					memblock_size = resource_size(&r);
diff --git a/arch/powerpc/platforms/pseries/io_event_irq.c b/arch/powerpc/platforms/pseries/io_event_irq.c
index 0240c4f..dd165a6 100644
--- a/arch/powerpc/platforms/pseries/io_event_irq.c
+++ b/arch/powerpc/platforms/pseries/io_event_irq.c
@@ -151,7 +151,7 @@ static int __init ioei_init(void)
 	if (ioei_check_exception_token == RTAS_UNKNOWN_SERVICE)
 		return -ENODEV;
 
-	np = of_find_node_by_path("/event-sources/ibm,io-events");
+	np = of_find_node_by_path("/event-sources/ibm,io-events", NULL);
 	if (np) {
 		request_event_sources_irqs(np, ioei_interrupt, "IO_EVENT");
 		pr_info("IBM I/O event interrupts enabled\n");
diff --git a/arch/powerpc/platforms/pseries/lparcfg.c b/arch/powerpc/platforms/pseries/lparcfg.c
index c9fecf0..79fda79 100644
--- a/arch/powerpc/platforms/pseries/lparcfg.c
+++ b/arch/powerpc/platforms/pseries/lparcfg.c
@@ -196,7 +196,7 @@ static void parse_ppp_data(struct seq_file *m)
 	 * valid if the ibm,partition-performance-parameters-level
 	 * property is >= 1.
 	 */
-	root = of_find_node_by_path("/");
+	root = of_find_node_by_path("/", NULL);
 	if (root) {
 		perf_level = of_get_property(root,
 				"ibm,partition-performance-parameters-level",
@@ -437,7 +437,7 @@ static int pseries_lparcfg_data(struct seq_file *m, void *v)
 	struct device_node *rtas_node;
 	const __be32 *lrdrp = NULL;
 
-	rtas_node = of_find_node_by_path("/rtas");
+	rtas_node = of_find_node_by_path("/rtas", NULL);
 	if (rtas_node)
 		lrdrp = of_get_property(rtas_node, "ibm,lrdr-capacity", NULL);
 
@@ -659,7 +659,7 @@ static int lparcfg_data(struct seq_file *m, void *v)
 
 	seq_printf(m, "%s %s\n", MODULE_NAME, MODULE_VERS);
 
-	rootdn = of_find_node_by_path("/");
+	rootdn = of_find_node_by_path("/", NULL);
 	if (rootdn) {
 		tmp = of_get_property(rootdn, "model", NULL);
 		if (tmp)
diff --git a/arch/powerpc/platforms/pseries/pseries_energy.c b/arch/powerpc/platforms/pseries/pseries_energy.c
index 9276779..1e859f6 100644
--- a/arch/powerpc/platforms/pseries/pseries_energy.c
+++ b/arch/powerpc/platforms/pseries/pseries_energy.c
@@ -43,7 +43,7 @@ static u32 cpu_to_drc_index(int cpu)
 	int rc = 1;
 	u32 ret = 0;
 
-	dn = of_find_node_by_path("/cpus");
+	dn = of_find_node_by_path("/cpus", NULL);
 	if (dn == NULL)
 		goto err;
 	indexes = of_get_property(dn, "ibm,drc-indexes", NULL);
@@ -75,7 +75,7 @@ static int drc_index_to_cpu(u32 drc_index)
 	int i, cpu = 0;
 	int rc = 1;
 
-	dn = of_find_node_by_path("/cpus");
+	dn = of_find_node_by_path("/cpus", NULL);
 	if (dn == NULL)
 		goto err;
 	indexes = of_get_property(dn, "ibm,drc-indexes", NULL);
diff --git a/arch/powerpc/platforms/pseries/ras.c b/arch/powerpc/platforms/pseries/ras.c
index 5a4d0fc..87d590b 100644
--- a/arch/powerpc/platforms/pseries/ras.c
+++ b/arch/powerpc/platforms/pseries/ras.c
@@ -55,7 +55,7 @@ static int __init init_ras_IRQ(void)
 	ras_check_exception_token = rtas_token("check-exception");
 
 	/* Internal Errors */
-	np = of_find_node_by_path("/event-sources/internal-errors");
+	np = of_find_node_by_path("/event-sources/internal-errors", NULL);
 	if (np != NULL) {
 		request_event_sources_irqs(np, ras_error_interrupt,
 					   "RAS_ERROR");
@@ -63,7 +63,7 @@ static int __init init_ras_IRQ(void)
 	}
 
 	/* EPOW Events */
-	np = of_find_node_by_path("/event-sources/epow-events");
+	np = of_find_node_by_path("/event-sources/epow-events", NULL);
 	if (np != NULL) {
 		request_event_sources_irqs(np, ras_epow_interrupt, "RAS_EPOW");
 		of_node_put(np);
diff --git a/arch/powerpc/platforms/pseries/reconfig.c b/arch/powerpc/platforms/pseries/reconfig.c
index 0f31952..5eec4ef 100644
--- a/arch/powerpc/platforms/pseries/reconfig.c
+++ b/arch/powerpc/platforms/pseries/reconfig.c
@@ -46,7 +46,7 @@ static struct device_node *derive_parent(const char *path)
 			return ERR_PTR(-ENOMEM);
 		strlcpy(parent_path, path, parent_path_len);
 	}
-	parent = of_find_node_by_path(parent_path);
+	parent = of_find_node_by_path(parent_path, NULL);
 	if (!parent)
 		return ERR_PTR(-EINVAL);
 	if (strcmp(parent_path, "/"))
@@ -242,7 +242,7 @@ static int do_add_node(char *buf, size_t bufsize)
 	*buf = '\0';
 	buf++;
 
-	if ((np = of_find_node_by_path(path))) {
+	if ((np = of_find_node_by_path(path, NULL))) {
 		of_node_put(np);
 		return -EINVAL;
 	}
@@ -277,7 +277,7 @@ static int do_remove_node(char *buf)
 	struct device_node *node;
 	int rv = -ENODEV;
 
-	if ((node = of_find_node_by_path(buf)))
+	if ((node = of_find_node_by_path(buf, NULL)))
 		rv = pSeries_reconfig_remove_node(node);
 
 	of_node_put(node);
diff --git a/arch/powerpc/platforms/pseries/setup.c b/arch/powerpc/platforms/pseries/setup.c
index 125c589..71e75a3 100644
--- a/arch/powerpc/platforms/pseries/setup.c
+++ b/arch/powerpc/platforms/pseries/setup.c
@@ -83,7 +83,7 @@ static void pSeries_show_cpuinfo(struct seq_file *m)
 	struct device_node *root;
 	const char *model = "";
 
-	root = of_find_node_by_path("/");
+	root = of_find_node_by_path("/", NULL);
 	if (root)
 		model = of_get_property(root, "model", NULL);
 	seq_printf(m, "machine\t\t: CHRP %s\n", model);
@@ -179,7 +179,7 @@ static void __init pseries_mpic_init_IRQ(void)
 	int naddr, n, i, opplen;
 	struct mpic *mpic;
 
-	np = of_find_node_by_path("/");
+	np = of_find_node_by_path("/", NULL);
 	naddr = of_n_addr_cells(np);
 	opprop = of_get_property(np, "platform-open-pic", &opplen);
 	if (opprop != NULL) {
diff --git a/arch/powerpc/sysdev/mpic_msgr.c b/arch/powerpc/sysdev/mpic_msgr.c
index 7bdf3cc..ca692e3 100644
--- a/arch/powerpc/sysdev/mpic_msgr.c
+++ b/arch/powerpc/sysdev/mpic_msgr.c
@@ -151,7 +151,7 @@ static int mpic_msgr_block_number(struct device_node *node)
 
 		snprintf(buf, sizeof(buf), "mpic-msgr-block%d", index);
 		prop = of_find_property(aliases, buf, NULL);
-		if (node == of_find_node_by_path(prop->value))
+		if (node == of_find_node_by_path(prop->value, NULL))
 			break;
 	}
 
diff --git a/arch/powerpc/sysdev/mv64x60_dev.c b/arch/powerpc/sysdev/mv64x60_dev.c
index 026bbc3..69717c8 100644
--- a/arch/powerpc/sysdev/mv64x60_dev.c
+++ b/arch/powerpc/sysdev/mv64x60_dev.c
@@ -516,7 +516,7 @@ static int __init mv64x60_add_mpsc_console(void)
 	if (prop == NULL)
 		goto not_mpsc;
 
-	np = of_find_node_by_path(prop);
+	np = of_find_node_by_path(prop, NULL);
 	if (!np)
 		goto not_mpsc;
 
diff --git a/arch/powerpc/sysdev/mv64x60_udbg.c b/arch/powerpc/sysdev/mv64x60_udbg.c
index 3b8734b..0aab2e6b 100644
--- a/arch/powerpc/sysdev/mv64x60_udbg.c
+++ b/arch/powerpc/sysdev/mv64x60_udbg.c
@@ -81,7 +81,7 @@ static void mv64x60_udbg_init(void)
 	if (!path)
 		return;
 
-	stdout = of_find_node_by_path(path);
+	stdout = of_find_node_by_path(path, NULL);
 	if (!stdout)
 		return;
 
diff --git a/arch/sparc/kernel/chmc.c b/arch/sparc/kernel/chmc.c
index dbb210d..81de6e4 100644
--- a/arch/sparc/kernel/chmc.c
+++ b/arch/sparc/kernel/chmc.c
@@ -402,7 +402,7 @@ static int jbusmc_probe(struct platform_device *op)
 	const void *ml;
 
 	err = -ENODEV;
-	mem_node = of_find_node_by_path("/memory");
+	mem_node = of_find_node_by_path("/memory", NULL);
 	if (!mem_node) {
 		printk(KERN_ERR PFX "Cannot find /memory node.\n");
 		goto out;
diff --git a/arch/sparc/kernel/irq_64.c b/arch/sparc/kernel/irq_64.c
index 4033c23..daf86b9 100644
--- a/arch/sparc/kernel/irq_64.c
+++ b/arch/sparc/kernel/irq_64.c
@@ -907,7 +907,7 @@ static void map_prom_timers(void)
 	const unsigned int *addr;
 
 	/* PROM timer node hangs out in the top level of device siblings... */
-	dp = of_find_node_by_path("/");
+	dp = of_find_node_by_path("/", NULL);
 	dp = dp->child;
 	while (dp) {
 		if (!strcmp(dp->name, "counter-timer"))
diff --git a/arch/sparc/kernel/leon_kernel.c b/arch/sparc/kernel/leon_kernel.c
index 9bbb8f2..d39a8db 100644
--- a/arch/sparc/kernel/leon_kernel.c
+++ b/arch/sparc/kernel/leon_kernel.c
@@ -326,7 +326,7 @@ void __init leon_init_timers(void)
 	master_l10_counter = (u32 __iomem *)&dummy_master_l10_counter;
 	dummy_master_l10_counter = 0;
 
-	rootnp = of_find_node_by_path("/ambapp0");
+	rootnp = of_find_node_by_path("/ambapp0", NULL);
 	if (!rootnp)
 		goto bad;
 
diff --git a/arch/sparc/kernel/leon_smp.c b/arch/sparc/kernel/leon_smp.c
index ea2bad3..3305338 100644
--- a/arch/sparc/kernel/leon_smp.c
+++ b/arch/sparc/kernel/leon_smp.c
@@ -280,7 +280,7 @@ static void __init leon_ipi_init(void)
 	unsigned long flags;
 
 	/* Find IPI IRQ or stick with default value */
-	rootnp = of_find_node_by_path("/ambapp0");
+	rootnp = of_find_node_by_path("/ambapp0", NULL);
 	if (rootnp) {
 		pp = of_find_property(rootnp, "ipi_num", &len);
 		if (pp && (*(int *)pp->value))
diff --git a/arch/sparc/kernel/of_device_32.c b/arch/sparc/kernel/of_device_32.c
index 185aa96..859216e 100644
--- a/arch/sparc/kernel/of_device_32.c
+++ b/arch/sparc/kernel/of_device_32.c
@@ -404,7 +404,7 @@ static void __init scan_tree(struct device_node *dp, struct device *parent)
 
 static int __init scan_of_devices(void)
 {
-	struct device_node *root = of_find_node_by_path("/");
+	struct device_node *root = of_find_node_by_path("/", NULL);
 	struct platform_device *parent;
 
 	parent = scan_one_device(root, NULL);
diff --git a/arch/sparc/kernel/of_device_64.c b/arch/sparc/kernel/of_device_64.c
index 7bbdc26..2abbb43 100644
--- a/arch/sparc/kernel/of_device_64.c
+++ b/arch/sparc/kernel/of_device_64.c
@@ -699,7 +699,7 @@ static void __init scan_tree(struct device_node *dp, struct device *parent)
 
 static int __init scan_of_devices(void)
 {
-	struct device_node *root = of_find_node_by_path("/");
+	struct device_node *root = of_find_node_by_path("/", NULL);
 	struct platform_device *parent;
 
 	parent = scan_one_device(root, NULL);
diff --git a/arch/sparc/kernel/prom_32.c b/arch/sparc/kernel/prom_32.c
index b51cbb9..f7e037c 100644
--- a/arch/sparc/kernel/prom_32.c
+++ b/arch/sparc/kernel/prom_32.c
@@ -307,7 +307,7 @@ void __init of_console_init(void)
 		} else {
 			const char *path;
 
-			dp = of_find_node_by_path("/");
+			dp = of_find_node_by_path("/", NULL);
 			path = of_get_property(dp, "stdout-path", NULL);
 			if (!path) {
 				prom_printf("No stdout-path in root node.\n");
diff --git a/arch/sparc/kernel/time_64.c b/arch/sparc/kernel/time_64.c
index 59da0c3..efbde9e 100644
--- a/arch/sparc/kernel/time_64.c
+++ b/arch/sparc/kernel/time_64.c
@@ -605,7 +605,7 @@ static unsigned long sparc64_init_timers(void)
 	struct device_node *dp;
 	unsigned long freq;
 
-	dp = of_find_node_by_path("/");
+	dp = of_find_node_by_path("/", NULL);
 	if (tlb_type == spitfire) {
 		unsigned long ver, manuf, impl;
 
diff --git a/arch/x86/platform/olpc/olpc.c b/arch/x86/platform/olpc/olpc.c
index 2737608..735cd23 100644
--- a/arch/x86/platform/olpc/olpc.c
+++ b/arch/x86/platform/olpc/olpc.c
@@ -286,7 +286,7 @@ static u32 __init get_board_revision(struct device_node *root)
 
 static bool __init platform_detect(void)
 {
-	struct device_node *root = of_find_node_by_path("/");
+	struct device_node *root = of_find_node_by_path("/", NULL);
 	bool success;
 
 	if (!root)
diff --git a/drivers/ata/pata_macio.c b/drivers/ata/pata_macio.c
index a02f76f..d514062 100644
--- a/drivers/ata/pata_macio.c
+++ b/drivers/ata/pata_macio.c
@@ -480,7 +480,7 @@ static int pata_macio_cable_detect(struct ata_port *ap)
 	    priv->kind == controller_sh_ata6) {
 		const char* cable = of_get_property(priv->node, "cable-type",
 						    NULL);
-		struct device_node *root = of_find_node_by_path("/");
+		struct device_node *root = of_find_node_by_path("/", NULL);
 		const char *model = of_get_property(root, "model", NULL);
 
 		if (cable && !strncmp(cable, "80-", 3)) {
diff --git a/drivers/cpufreq/pmac64-cpufreq.c b/drivers/cpufreq/pmac64-cpufreq.c
index 4ff8687..03b0674 100644
--- a/drivers/cpufreq/pmac64-cpufreq.c
+++ b/drivers/cpufreq/pmac64-cpufreq.c
@@ -401,7 +401,7 @@ static int __init g5_neo2_cpufreq_init(struct device_node *cpunode)
 	} else if (use_volts_vdnap) {
 		struct device_node *root;
 
-		root = of_find_node_by_path("/");
+		root = of_find_node_by_path("/", NULL);
 		if (root == NULL) {
 			printk(KERN_ERR "cpufreq: Can't find root of "
 			       "device tree\n");
@@ -489,7 +489,8 @@ static int __init g5_pm72_cpufreq_init(struct device_node *cpunode)
 	    " RackMac3,1...\n");
 
 	/* Lookup the cpuid eeprom node */
-        cpuid = of_find_node_by_path("/u3@0,f8000000/i2c@f8001000/cpuid@a0");
+        cpuid = of_find_node_by_path("/u3@0,f8000000/i2c@f8001000/cpuid@a0",
+				     NULL);
 	if (cpuid != NULL)
 		eeprom = of_get_property(cpuid, "cpuid", NULL);
 	if (eeprom == NULL) {
diff --git a/drivers/cpufreq/powernv-cpufreq.c b/drivers/cpufreq/powernv-cpufreq.c
index 2dfd4fd..e5f2d9d 100644
--- a/drivers/cpufreq/powernv-cpufreq.c
+++ b/drivers/cpufreq/powernv-cpufreq.c
@@ -64,7 +64,7 @@ static int init_powernv_pstates(void)
 	const __be32 *pstate_ids, *pstate_freqs;
 	u32 len_ids, len_freqs;
 
-	power_mgt = of_find_node_by_path("/ibm,opal/power-mgt");
+	power_mgt = of_find_node_by_path("/ibm,opal/power-mgt", NULL);
 	if (!power_mgt) {
 		pr_warn("power-mgt node not found\n");
 		return -ENODEV;
diff --git a/drivers/cpuidle/cpuidle-big_little.c b/drivers/cpuidle/cpuidle-big_little.c
index fbc00a1..f489686 100644
--- a/drivers/cpuidle/cpuidle-big_little.c
+++ b/drivers/cpuidle/cpuidle-big_little.c
@@ -174,7 +174,7 @@ static const struct of_device_id compatible_machine_match[] = {
 static int __init bl_idle_init(void)
 {
 	int ret;
-	struct device_node *root = of_find_node_by_path("/");
+	struct device_node *root = of_find_node_by_path("/", NULL);
 
 	if (!root)
 		return -ENODEV;
diff --git a/drivers/cpuidle/cpuidle-powernv.c b/drivers/cpuidle/cpuidle-powernv.c
index 7d3a349..741c3e1 100644
--- a/drivers/cpuidle/cpuidle-powernv.c
+++ b/drivers/cpuidle/cpuidle-powernv.c
@@ -169,7 +169,7 @@ static int powernv_add_idle_states(void)
 
 	/* Currently we have snooze statically defined */
 
-	power_mgt = of_find_node_by_path("/ibm,opal/power-mgt");
+	power_mgt = of_find_node_by_path("/ibm,opal/power-mgt", NULL);
 	if (!power_mgt) {
 		pr_warn("opal: PowerMgmt Node not found\n");
 		return nr_idle_states;
diff --git a/drivers/edac/cpc925_edac.c b/drivers/edac/cpc925_edac.c
index 682288c..8d66b7c 100644
--- a/drivers/edac/cpc925_edac.c
+++ b/drivers/edac/cpc925_edac.c
@@ -604,7 +604,7 @@ static u32 cpc925_cpu_mask_disabled(void)
 
 	mask = APIMASK_ADI0 | APIMASK_ADI1;
 
-	cpus = of_find_node_by_path("/cpus");
+	cpus = of_find_node_by_path("/cpus", NULL);
 	if (cpus == NULL) {
 		cpc925_printk(KERN_DEBUG, "No /cpus node !\n");
 		return 0;
diff --git a/drivers/hwmon/ibmpowernv.c b/drivers/hwmon/ibmpowernv.c
index 6a30eee..fa5325b 100644
--- a/drivers/hwmon/ibmpowernv.c
+++ b/drivers/hwmon/ibmpowernv.c
@@ -179,7 +179,7 @@ static int __init populate_attr_groups(struct platform_device *pdev)
 	struct device_node *opal, *np;
 	enum sensors type;
 
-	opal = of_find_node_by_path("/ibm,opal/sensors");
+	opal = of_find_node_by_path("/ibm,opal/sensors", NULL);
 	if (!opal) {
 		dev_dbg(&pdev->dev, "Opal node 'sensors' not found\n");
 		return -ENODEV;
@@ -232,7 +232,7 @@ static int __init create_device_attrs(struct platform_device *pdev)
 	u32 count = 0;
 	int err = 0;
 
-	opal = of_find_node_by_path("/ibm,opal/sensors");
+	opal = of_find_node_by_path("/ibm,opal/sensors", NULL);
 	sdata = devm_kzalloc(&pdev->dev, pdata->sensors_count * sizeof(*sdata),
 			     GFP_KERNEL);
 	if (!sdata) {
diff --git a/drivers/ide/pmac.c b/drivers/ide/pmac.c
index 2db803c..dc6d033 100644
--- a/drivers/ide/pmac.c
+++ b/drivers/ide/pmac.c
@@ -917,7 +917,7 @@ static u8 pmac_ide_cable_detect(ide_hwif_t *hwif)
 	pmac_ide_hwif_t *pmif = dev_get_drvdata(hwif->gendev.parent);
 	struct device_node *np = pmif->node;
 	const char *cable = of_get_property(np, "cable-type", NULL);
-	struct device_node *root = of_find_node_by_path("/");
+	struct device_node *root = of_find_node_by_path("/", NULL);
 	const char *model = of_get_property(root, "model", NULL);
 
 	/* Get cable type from device-tree. */
diff --git a/drivers/input/misc/sparcspkr.c b/drivers/input/misc/sparcspkr.c
index 179ff1c..72564f8 100644
--- a/drivers/input/misc/sparcspkr.c
+++ b/drivers/input/misc/sparcspkr.c
@@ -197,7 +197,7 @@ static int bbc_beep_probe(struct platform_device *op)
 	state->event = bbc_spkr_event;
 	spin_lock_init(&state->lock);
 
-	dp = of_find_node_by_path("/");
+	dp = of_find_node_by_path("/", NULL);
 	err = -ENODEV;
 	if (!dp)
 		goto out_free;
diff --git a/drivers/input/serio/i8042-sparcio.h b/drivers/input/serio/i8042-sparcio.h
index 93cb791..53c69a6 100644
--- a/drivers/input/serio/i8042-sparcio.h
+++ b/drivers/input/serio/i8042-sparcio.h
@@ -108,7 +108,7 @@ static struct platform_driver sparc_i8042_driver = {
 
 static int __init i8042_platform_init(void)
 {
-	struct device_node *root = of_find_node_by_path("/");
+	struct device_node *root = of_find_node_by_path("/", NULL);
 
 	if (!strcmp(root->name, "SUNW,JavaStation-1")) {
 		/* Hardcoded values for MrCoffee.  */
@@ -138,7 +138,7 @@ static int __init i8042_platform_init(void)
 
 static inline void i8042_platform_exit(void)
 {
-	struct device_node *root = of_find_node_by_path("/");
+	struct device_node *root = of_find_node_by_path("/", NULL);
 
 	if (strcmp(root->name, "SUNW,JavaStation-1"))
 		platform_driver_unregister(&sparc_i8042_driver);
diff --git a/drivers/irqchip/irq-atmel-aic-common.c b/drivers/irqchip/irq-atmel-aic-common.c
index 6ae3cdee..768e402 100644
--- a/drivers/irqchip/irq-atmel-aic-common.c
+++ b/drivers/irqchip/irq-atmel-aic-common.c
@@ -169,7 +169,7 @@ void __init aic_common_rtc_irq_fixup(struct device_node *root)
 
 void __init aic_common_irq_fixup(const struct of_device_id *matches)
 {
-	struct device_node *root = of_find_node_by_path("/");
+	struct device_node *root = of_find_node_by_path("/", NULL);
 	const struct of_device_id *match;
 
 	if (!root)
diff --git a/drivers/macintosh/therm_pm72.c b/drivers/macintosh/therm_pm72.c
index 97cfc5a..67a9e78 100644
--- a/drivers/macintosh/therm_pm72.c
+++ b/drivers/macintosh/therm_pm72.c
@@ -644,7 +644,7 @@ static int read_eeprom(int cpu, struct mpu_data *out)
 	 * will work for these machines
 	 */
 	sprintf(nodename, "/u3@0,f8000000/i2c@f8001000/cpuid@a%d", cpu ? 2 : 0);
-	np = of_find_node_by_path(nodename);
+	np = of_find_node_by_path(nodename, NULL);
 	if (np == NULL) {
 		printk(KERN_ERR "therm_pm72: Failed to retrieve cpuid node from device-tree\n");
 		return -ENODEV;
@@ -1331,7 +1331,7 @@ static int init_backside_state(struct backside_pid_state *state)
 	 * There are different PID params for machines with U3 and machines
 	 * with U3H, pick the right ones now
 	 */
-	u3 = of_find_node_by_path("/u3@0,f8000000");
+	u3 = of_find_node_by_path("/u3@0,f8000000", NULL);
 	if (u3 != NULL) {
 		const u32 *vers = of_get_property(u3, "device-rev", NULL);
 		if (vers)
diff --git a/drivers/macintosh/via-pmu-led.c b/drivers/macintosh/via-pmu-led.c
index 19c3718..630ba0a 100644
--- a/drivers/macintosh/via-pmu-led.c
+++ b/drivers/macintosh/via-pmu-led.c
@@ -88,7 +88,7 @@ static int __init via_pmu_led_init(void)
 	if (pmu_get_model() != PMU_KEYLARGO_BASED)
 		return -ENODEV;
 
-	dt = of_find_node_by_path("/");
+	dt = of_find_node_by_path("/", NULL);
 	if (dt == NULL)
 		return -ENODEV;
 	model = of_get_property(dt, "model", NULL);
diff --git a/drivers/macintosh/windfarm_mpu.h b/drivers/macintosh/windfarm_mpu.h
index 046edc8..ca3170e 100644
--- a/drivers/macintosh/windfarm_mpu.h
+++ b/drivers/macintosh/windfarm_mpu.h
@@ -85,7 +85,7 @@ static inline const struct mpu_data *wf_get_mpu(int cpu)
 	 * will work for these machines
 	 */
 	sprintf(nodename, "/u3@0,f8000000/i2c@f8001000/cpuid@a%d", cpu ? 2 : 0);
-	np = of_find_node_by_path(nodename);
+	np = of_find_node_by_path(nodename, NULL);
 	if (!np)
 		return NULL;
 	data = of_get_property(np, "cpuid", &len);	
diff --git a/drivers/macintosh/windfarm_pm72.c b/drivers/macintosh/windfarm_pm72.c
index 2f506b9..a2327ff 100644
--- a/drivers/macintosh/windfarm_pm72.c
+++ b/drivers/macintosh/windfarm_pm72.c
@@ -509,7 +509,7 @@ static void backside_setup_pid(void)
 	struct device_node *u3;
 	int u3h = 1; /* conservative by default */
 
-	u3 = of_find_node_by_path("/u3@0,f8000000");
+	u3 = of_find_node_by_path("/u3@0,f8000000", NULL);
 	if (u3 != NULL) {
 		const u32 *vers = of_get_property(u3, "device-rev", NULL);
 		if (vers)
diff --git a/drivers/mtd/nand/mpc5121_nfc.c b/drivers/mtd/nand/mpc5121_nfc.c
index e78841a..bc39644 100644
--- a/drivers/mtd/nand/mpc5121_nfc.c
+++ b/drivers/mtd/nand/mpc5121_nfc.c
@@ -714,7 +714,7 @@ static int mpc5121_nfc_probe(struct platform_device *op)
 	chip->ecc.mode = NAND_ECC_SOFT;
 
 	/* Support external chip-select logic on ADS5121 board */
-	rootnode = of_find_node_by_path("/");
+	rootnode = of_find_node_by_path("/", NULL);
 	if (of_device_is_compatible(rootnode, "fsl,mpc5121ads")) {
 		retval = ads5121_chipselect_init(mtd);
 		if (retval) {
diff --git a/drivers/net/ethernet/amd/sunlance.c b/drivers/net/ethernet/amd/sunlance.c
index 5e4273b..2f7c799 100644
--- a/drivers/net/ethernet/amd/sunlance.c
+++ b/drivers/net/ethernet/amd/sunlance.c
@@ -1413,7 +1413,7 @@ static int sparc_lance_probe_one(struct platform_device *op,
 			printk(KERN_INFO "SunLance: using "
 			       "auto-carrier-detection.\n");
 
-			nd = of_find_node_by_path("/options");
+			nd = of_find_node_by_path("/options", NULL);
 			if (!nd)
 				goto no_link_test;
 
diff --git a/drivers/of/base.c b/drivers/of/base.c
index 3823edf..3e764bd 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -493,7 +493,7 @@ int of_machine_is_compatible(const char *compat)
 	struct device_node *root;
 	int rc = 0;
 
-	root = of_find_node_by_path("/");
+	root = of_find_node_by_path("/", NULL);
 	if (root) {
 		rc = of_device_is_compatible(root, compat);
 		of_node_put(root);
@@ -699,10 +699,15 @@ static struct device_node *__of_find_node_by_path(struct device_node *parent,
 {
 	struct device_node *child;
 	int len = strchrnul(path, '/') - path;
+	int term;
 
 	if (!len)
 		return NULL;
 
+	term = strchrnul(path, ':') - path;
+	if (term < len)
+		len = term;
+
 	__for_each_child_of_node(parent, child) {
 		const char *name = strrchr(child->full_name, '/');
 		if (WARN(!name, "malformed device_node %s\n", child->full_name))
@@ -720,6 +725,9 @@ static struct device_node *__of_find_node_by_path(struct device_node *parent,
  *	       start with '/', the name of a property of the /aliases
  *	       node (an alias).  In the case of an alias, the node
  *	       matching the alias' value will be returned.
+ *	@opts: Address of a pointer into which to store the start of
+ *	       an options string appended to the end of the path with
+ *	       a ':' separator.
  *
  *	Valid paths:
  *		/foo/bar	Full path
@@ -729,19 +737,24 @@ static struct device_node *__of_find_node_by_path(struct device_node *parent,
  *	Returns a node pointer with refcount incremented, use
  *	of_node_put() on it when done.
  */
-struct device_node *of_find_node_by_path(const char *path)
+struct device_node *of_find_node_by_path(const char *path, char **opts)
 {
 	struct device_node *np = NULL;
 	struct property *pp;
 	unsigned long flags;
+	char *separator;
 
 	if (strcmp(path, "/") == 0)
 		return of_node_get(of_allnodes);
 
+	separator = strchr(path, ':');
+	if (separator && opts)
+		*opts = separator + 1;
+
 	/* The path could begin with an alias */
 	if (*path != '/') {
 		char *p = strchrnul(path, '/');
-		int len = p - path;
+		int len = separator ? separator - path : p - path;
 
 		/* of_aliases must not be NULL */
 		if (!of_aliases)
@@ -749,7 +762,7 @@ struct device_node *of_find_node_by_path(const char *path)
 
 		for_each_property_of_node(of_aliases, pp) {
 			if (strlen(pp->name) == len && !strncmp(pp->name, path, len)) {
-				np = of_find_node_by_path(pp->value);
+				np = of_find_node_by_path(pp->value, NULL);
 				break;
 			}
 		}
@@ -1818,10 +1831,10 @@ void of_alias_scan(void * (*dt_alloc)(u64 size, u64 align))
 {
 	struct property *pp;
 
-	of_aliases = of_find_node_by_path("/aliases");
-	of_chosen = of_find_node_by_path("/chosen");
+	of_aliases = of_find_node_by_path("/aliases", NULL);
+	of_chosen = of_find_node_by_path("/chosen", NULL);
 	if (of_chosen == NULL)
-		of_chosen = of_find_node_by_path("/chosen@0");
+		of_chosen = of_find_node_by_path("/chosen@0", NULL);
 
 	if (of_chosen) {
 		/* linux,stdout-path and /aliases/stdout are for legacy compatibility */
@@ -1831,7 +1844,7 @@ void of_alias_scan(void * (*dt_alloc)(u64 size, u64 align))
 		if (IS_ENABLED(CONFIG_PPC) && !name)
 			name = of_get_property(of_aliases, "stdout", NULL);
 		if (name)
-			of_stdout = of_find_node_by_path(name);
+			of_stdout = of_find_node_by_path(name, NULL);
 	}
 
 	if (!of_aliases)
@@ -1850,7 +1863,7 @@ void of_alias_scan(void * (*dt_alloc)(u64 size, u64 align))
 		    !strcmp(pp->name, "linux,phandle"))
 			continue;
 
-		np = of_find_node_by_path(pp->value);
+		np = of_find_node_by_path(pp->value, NULL);
 		if (!np)
 			continue;
 
diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index 3b64d0b..546c583 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -441,7 +441,7 @@ int of_platform_bus_probe(struct device_node *root,
 	struct device_node *child;
 	int rc = 0;
 
-	root = root ? of_node_get(root) : of_find_node_by_path("/");
+	root = root ? of_node_get(root) : of_find_node_by_path("/", NULL);
 	if (!root)
 		return -EINVAL;
 
@@ -491,7 +491,7 @@ int of_platform_populate(struct device_node *root,
 	struct device_node *child;
 	int rc = 0;
 
-	root = root ? of_node_get(root) : of_find_node_by_path("/");
+	root = root ? of_node_get(root) : of_find_node_by_path("/", NULL);
 	if (!root)
 		return -EINVAL;
 
diff --git a/drivers/of/resolver.c b/drivers/of/resolver.c
index aed7959..1f6bb8d 100644
--- a/drivers/of/resolver.c
+++ b/drivers/of/resolver.c
@@ -264,7 +264,7 @@ int of_resolve_phandles(struct device_node *resolve)
 	resolve_fix = NULL;
 
 	/* this may fail (if no fixups are required) */
-	root_sym = of_find_node_by_path("/__symbols__");
+	root_sym = of_find_node_by_path("/__symbols__", NULL);
 
 	/* locate the symbols & fixups nodes on resolve */
 	for_each_child_of_node(resolve, child) {
@@ -308,7 +308,7 @@ int of_resolve_phandles(struct device_node *resolve)
 			goto out;
 		}
 
-		refnode = of_find_node_by_path(refpath);
+		refnode = of_find_node_by_path(refpath, NULL);
 		if (!refnode) {
 			pr_err("%s: Could not find node by path '%s'\n",
 					__func__, refpath);
diff --git a/drivers/of/selftest.c b/drivers/of/selftest.c
index e2d79af..988126d 100644
--- a/drivers/of/selftest.c
+++ b/drivers/of/selftest.c
@@ -43,46 +43,57 @@ static bool selftest_live_tree;
 static void __init of_selftest_find_node_by_name(void)
 {
 	struct device_node *np;
+	char *options;
 
-	np = of_find_node_by_path("/testcase-data");
+	np = of_find_node_by_path("/testcase-data", NULL);
 	selftest(np && !strcmp("/testcase-data", np->full_name),
 		"find /testcase-data failed\n");
 	of_node_put(np);
 
 	/* Test if trailing '/' works */
-	np = of_find_node_by_path("/testcase-data/");
+	np = of_find_node_by_path("/testcase-data/", NULL);
 	selftest(!np, "trailing '/' on /testcase-data/ should fail\n");
 
-	np = of_find_node_by_path("/testcase-data/phandle-tests/consumer-a");
+	np = of_find_node_by_path("/testcase-data/phandle-tests/consumer-a",
+				  NULL);
 	selftest(np && !strcmp("/testcase-data/phandle-tests/consumer-a", np->full_name),
 		"find /testcase-data/phandle-tests/consumer-a failed\n");
 	of_node_put(np);
 
-	np = of_find_node_by_path("testcase-alias");
+	np = of_find_node_by_path("testcase-alias", NULL);
 	selftest(np && !strcmp("/testcase-data", np->full_name),
 		"find testcase-alias failed\n");
 	of_node_put(np);
 
 	/* Test if trailing '/' works on aliases */
-	np = of_find_node_by_path("testcase-alias/");
+	np = of_find_node_by_path("testcase-alias/", NULL);
 	selftest(!np, "trailing '/' on testcase-alias/ should fail\n");
 
-	np = of_find_node_by_path("testcase-alias/phandle-tests/consumer-a");
+	np = of_find_node_by_path("testcase-alias/phandle-tests/consumer-a",
+				  NULL);
 	selftest(np && !strcmp("/testcase-data/phandle-tests/consumer-a", np->full_name),
 		"find testcase-alias/phandle-tests/consumer-a failed\n");
 	of_node_put(np);
 
-	np = of_find_node_by_path("/testcase-data/missing-path");
+	np = of_find_node_by_path("/testcase-data/missing-path", NULL);
 	selftest(!np, "non-existent path returned node %s\n", np->full_name);
 	of_node_put(np);
 
-	np = of_find_node_by_path("missing-alias");
+	np = of_find_node_by_path("missing-alias", NULL);
 	selftest(!np, "non-existent alias returned node %s\n", np->full_name);
 	of_node_put(np);
 
-	np = of_find_node_by_path("testcase-alias/missing-path");
+	np = of_find_node_by_path("testcase-alias/missing-path", NULL);
 	selftest(!np, "non-existent alias with relative path returned node %s\n", np->full_name);
 	of_node_put(np);
+
+	np = of_find_node_by_path("/testcase-data:testoption", &options);
+	selftest(!np || strcmp("testoption", options), "option path test failed\n");
+	of_node_put(np);
+
+	np = of_find_node_by_path("testcase-alias:testaliasoption", &options);
+	selftest(!np || strcmp("testaliasoption", options), "option alias path test failed\n");
+	of_node_put(np);
 }
 
 static void __init of_selftest_dynamic(void)
@@ -90,7 +101,7 @@ static void __init of_selftest_dynamic(void)
 	struct device_node *np;
 	struct property *prop;
 
-	np = of_find_node_by_path("/testcase-data");
+	np = of_find_node_by_path("/testcase-data", NULL);
 	if (!np) {
 		pr_err("missing testcase data\n");
 		return;
@@ -243,7 +254,8 @@ static void __init of_selftest_parse_phandle_with_args(void)
 	struct of_phandle_args args;
 	int i, rc;
 
-	np = of_find_node_by_path("/testcase-data/phandle-tests/consumer-a");
+	np = of_find_node_by_path("/testcase-data/phandle-tests/consumer-a",
+				  NULL);
 	if (!np) {
 		pr_err("missing testcase data\n");
 		return;
@@ -345,7 +357,8 @@ static void __init of_selftest_property_string(void)
 	struct device_node *np;
 	int rc;
 
-	np = of_find_node_by_path("/testcase-data/phandle-tests/consumer-a");
+	np = of_find_node_by_path("/testcase-data/phandle-tests/consumer-a",
+				  NULL);
 	if (!np) {
 		pr_err("No testcase data in device tree\n");
 		return;
@@ -461,7 +474,8 @@ static void __init of_selftest_changeset(void)
 	selftest(n2, "testcase setup failure\n");
 	n21 = __of_node_alloc("/testcase-data/changeset/n2/n21", GFP_KERNEL);
 	selftest(n21, "testcase setup failure %p\n", n21);
-	nremove = of_find_node_by_path("/testcase-data/changeset/node-remove");
+	nremove = of_find_node_by_path("/testcase-data/changeset/node-remove",
+				       NULL);
 	selftest(nremove, "testcase setup failure\n");
 	ppadd = __of_prop_dup(&padd, GFP_KERNEL);
 	selftest(ppadd, "testcase setup failure\n");
@@ -501,7 +515,8 @@ static void __init of_selftest_parse_interrupts(void)
 	struct of_phandle_args args;
 	int i, rc;
 
-	np = of_find_node_by_path("/testcase-data/interrupts/interrupts0");
+	np = of_find_node_by_path("/testcase-data/interrupts/interrupts0",
+				  NULL);
 	if (!np) {
 		pr_err("missing testcase data\n");
 		return;
@@ -521,7 +536,8 @@ static void __init of_selftest_parse_interrupts(void)
 	}
 	of_node_put(np);
 
-	np = of_find_node_by_path("/testcase-data/interrupts/interrupts1");
+	np = of_find_node_by_path("/testcase-data/interrupts/interrupts1",
+				  NULL);
 	if (!np) {
 		pr_err("missing testcase data\n");
 		return;
@@ -573,7 +589,8 @@ static void __init of_selftest_parse_interrupts_extended(void)
 	struct of_phandle_args args;
 	int i, rc;
 
-	np = of_find_node_by_path("/testcase-data/interrupts/interrupts-extended0");
+	np = of_find_node_by_path("/testcase-data/interrupts/interrupts-extended0",
+				  NULL);
 	if (!np) {
 		pr_err("missing testcase data\n");
 		return;
@@ -678,7 +695,7 @@ static void __init of_selftest_match_node(void)
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(match_node_tests); i++) {
-		np = of_find_node_by_path(match_node_tests[i].path);
+		np = of_find_node_by_path(match_node_tests[i].path, NULL);
 		if (!np) {
 			selftest(0, "missing testcase node %s\n",
 				match_node_tests[i].path);
@@ -712,11 +729,11 @@ static void __init of_selftest_platform_populate(void)
 		{}
 	};
 
-	np = of_find_node_by_path("/testcase-data");
+	np = of_find_node_by_path("/testcase-data", NULL);
 	of_platform_populate(np, of_default_bus_match_table, NULL, NULL);
 
 	/* Test that a missing irq domain returns -EPROBE_DEFER */
-	np = of_find_node_by_path("/testcase-data/testcase-device1");
+	np = of_find_node_by_path("/testcase-data/testcase-device1", NULL);
 	pdev = of_find_device_by_node(np);
 	selftest(pdev, "device 1 creation failed\n");
 
@@ -724,13 +741,13 @@ static void __init of_selftest_platform_populate(void)
 	selftest(irq == -EPROBE_DEFER, "device deferred probe failed - %d\n", irq);
 
 	/* Test that a parsing failure does not return -EPROBE_DEFER */
-	np = of_find_node_by_path("/testcase-data/testcase-device2");
+	np = of_find_node_by_path("/testcase-data/testcase-device2", NULL);
 	pdev = of_find_device_by_node(np);
 	selftest(pdev, "device 2 creation failed\n");
 	irq = platform_get_irq(pdev, 0);
 	selftest(irq < 0 && irq != -EPROBE_DEFER, "device parsing error failed - %d\n", irq);
 
-	np = of_find_node_by_path("/testcase-data/platform-tests");
+	np = of_find_node_by_path("/testcase-data/platform-tests", NULL);
 	if (!np) {
 		pr_err("No testcase data in device tree\n");
 		return;
@@ -792,7 +809,7 @@ static int attach_node_and_children(struct device_node *np)
 
 	while (np) {
 		next = np->allnext;
-		dup = of_find_node_by_path(np->full_name);
+		dup = of_find_node_by_path(np->full_name, NULL);
 		if (dup)
 			update_node_properties(np, dup);
 		else {
@@ -853,8 +870,8 @@ static int __init selftest_data_add(void)
 
 		for_each_of_allnodes(np)
 			__of_attach_node_sysfs(np);
-		of_aliases = of_find_node_by_path("/aliases");
-		of_chosen = of_find_node_by_path("/chosen");
+		of_aliases = of_find_node_by_path("/aliases", NULL);
+		of_chosen = of_find_node_by_path("/chosen", NULL);
 		return 0;
 	}
 
@@ -898,7 +915,8 @@ static void selftest_data_remove(void)
 
 	while (last_node_index-- > 0) {
 		if (nodes[last_node_index]) {
-			np = of_find_node_by_path(nodes[last_node_index]->full_name);
+			np = of_find_node_by_path(nodes[last_node_index]->full_name,
+						  NULL);
 			if (np == nodes[last_node_index]) {
 				if (of_aliases == np) {
 					of_node_put(of_aliases);
@@ -925,9 +943,10 @@ static int __init of_selftest(void)
 	if (res)
 		return res;
 	if (!of_aliases)
-		of_aliases = of_find_node_by_path("/aliases");
+		of_aliases = of_find_node_by_path("/aliases", NULL);
 
-	np = of_find_node_by_path("/testcase-data/phandle-tests/consumer-a");
+	np = of_find_node_by_path("/testcase-data/phandle-tests/consumer-a",
+				  NULL);
 	if (!np) {
 		pr_info("No testcase data in device tree; not running tests\n");
 		return 0;
diff --git a/drivers/sbus/char/display7seg.c b/drivers/sbus/char/display7seg.c
index 2b0ce7c..815e7e0 100644
--- a/drivers/sbus/char/display7seg.c
+++ b/drivers/sbus/char/display7seg.c
@@ -200,7 +200,7 @@ static int d7s_probe(struct platform_device *op)
 	 * device, and reset default when detached
 	 */
 	regs = readb(p->regs);
-	opts = of_find_node_by_path("/options");
+	opts = of_find_node_by_path("/options", NULL);
 	if (opts &&
 	    of_get_property(opts, "d7s-flipped?", NULL))
 		p->flipped = true;
diff --git a/drivers/sbus/char/envctrl.c b/drivers/sbus/char/envctrl.c
index af15a2f..4a5f3e0 100644
--- a/drivers/sbus/char/envctrl.c
+++ b/drivers/sbus/char/envctrl.c
@@ -905,7 +905,7 @@ static void envctrl_init_i2c_child(struct device_node *dp,
 		struct device_node *root_node;
 		int len;
 
-		root_node = of_find_node_by_path("/");
+		root_node = of_find_node_by_path("/", NULL);
 		if (!strcmp(root_node->name, "SUNW,UltraSPARC-IIi-cEngine")) {
 			for (len = 0; len < PCF8584_MAX_CHANNELS; ++len) {
 				pchild->mon_type[len] = ENVCTRL_NOMON;
diff --git a/drivers/sbus/char/openprom.c b/drivers/sbus/char/openprom.c
index 5843288..0c077ae 100644
--- a/drivers/sbus/char/openprom.c
+++ b/drivers/sbus/char/openprom.c
@@ -228,7 +228,7 @@ static int opromnext(void __user *argp, unsigned int cmd, struct device_node *dp
 		if (cmd != OPROMNEXT)
 			return -EINVAL;
 
-		dp = of_find_node_by_path("/");
+		dp = of_find_node_by_path("/", NULL);
 	}
 
 	ph = 0;
@@ -271,7 +271,7 @@ static int oprompath2node(void __user *argp, struct device_node *dp, struct open
 {
 	phandle ph = 0;
 
-	dp = of_find_node_by_path(op->oprom_array);
+	dp = of_find_node_by_path(op->oprom_array, NULL);
 	if (dp)
 		ph = dp->phandle;
 	data->current_node = dp;
@@ -532,7 +532,7 @@ static int opiocgetnext(unsigned int cmd, void __user *argp)
 	if (nd == 0) {
 		if (cmd != OPIOCGETNEXT)
 			return -EINVAL;
-		dp = of_find_node_by_path("/");
+		dp = of_find_node_by_path("/", NULL);
 	} else {
 		dp = of_find_node_by_phandle(nd);
 		nd = 0;
@@ -698,7 +698,7 @@ static int openprom_open(struct inode * inode, struct file * file)
 		return -ENOMEM;
 
 	mutex_lock(&openprom_mutex);
-	data->current_node = of_find_node_by_path("/");
+	data->current_node = of_find_node_by_path("/", NULL);
 	data->lastnode = data->current_node;
 	file->private_data = (void *) data;
 	mutex_unlock(&openprom_mutex);
@@ -736,7 +736,7 @@ static int __init openprom_init(void)
 	if (err)
 		return err;
 
-	dp = of_find_node_by_path("/");
+	dp = of_find_node_by_path("/", NULL);
 	dp = dp->child;
 	while (dp) {
 		if (!strcmp(dp->name, "options"))
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 598c42c..39c3430 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -1143,7 +1143,7 @@ static void ibmvfc_gather_partition_info(struct ibmvfc_host *vhost)
 	const char *name;
 	const unsigned int *num;
 
-	rootdn = of_find_node_by_path("/");
+	rootdn = of_find_node_by_path("/", NULL);
 	if (!rootdn)
 		return;
 
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 7b23f21..f72aa1f 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -254,7 +254,7 @@ static void gather_partition_info(void)
 	const __be32 *p_number_ptr;
 
 	/* Retrieve information about this partition */
-	rootdn = of_find_node_by_path("/");
+	rootdn = of_find_node_by_path("/", NULL);
 	if (!rootdn) {
 		return;
 	}
diff --git a/drivers/soc/tegra/common.c b/drivers/soc/tegra/common.c
index a71cb74..c80ccf1 100644
--- a/drivers/soc/tegra/common.c
+++ b/drivers/soc/tegra/common.c
@@ -22,7 +22,7 @@ bool soc_is_tegra(void)
 {
 	struct device_node *root;
 
-	root = of_find_node_by_path("/");
+	root = of_find_node_by_path("/", NULL);
 	if (!root)
 		return false;
 
diff --git a/drivers/tty/hvc/hvc_opal.c b/drivers/tty/hvc/hvc_opal.c
index a2cc5f8..2a46ce6 100644
--- a/drivers/tty/hvc/hvc_opal.c
+++ b/drivers/tty/hvc/hvc_opal.c
@@ -354,11 +354,11 @@ void __init hvc_opal_init_early(void)
 		/* Current OPAL takeover doesn't provide the stdout
 		 * path, so we hard wire it
 		 */
-		opal = of_find_node_by_path("/ibm,opal/consoles");
+		opal = of_find_node_by_path("/ibm,opal/consoles", NULL);
 		if (opal)
 			pr_devel("hvc_opal: Found consoles in new location\n");
 		if (!opal) {
-			opal = of_find_node_by_path("/ibm,opal");
+			opal = of_find_node_by_path("/ibm,opal", NULL);
 			if (opal)
 				pr_devel("hvc_opal: "
 					 "Found consoles in old location\n");
diff --git a/drivers/tty/serial/nwpserial.c b/drivers/tty/serial/nwpserial.c
index 5da7622..392153e 100644
--- a/drivers/tty/serial/nwpserial.c
+++ b/drivers/tty/serial/nwpserial.c
@@ -452,7 +452,7 @@ static int __init nwpserial_console_init(void)
 	if (name == NULL)
 		return -1;
 
-	dn = of_find_node_by_path(name);
+	dn = of_find_node_by_path(name, NULL);
 	if (!dn)
 		return -1;
 
diff --git a/drivers/tty/serial/suncore.c b/drivers/tty/serial/suncore.c
index 6e4ac8d..46a05a4 100644
--- a/drivers/tty/serial/suncore.c
+++ b/drivers/tty/serial/suncore.c
@@ -108,7 +108,7 @@ void sunserial_console_termios(struct console *con, struct device_node *uart_dp)
 
 		mode_prop[3] = c;
 
-		dp = of_find_node_by_path("/options");
+		dp = of_find_node_by_path("/options", NULL);
 		mode = of_get_property(dp, mode_prop, NULL);
 		if (!mode)
 			mode = "9600,8,n,1,-";
diff --git a/drivers/tty/serial/sunsu.c b/drivers/tty/serial/sunsu.c
index 5326ae1..610df7b 100644
--- a/drivers/tty/serial/sunsu.c
+++ b/drivers/tty/serial/sunsu.c
@@ -1379,18 +1379,18 @@ static inline struct console *SUNSU_CONSOLE(void)
 
 static enum su_type su_get_type(struct device_node *dp)
 {
-	struct device_node *ap = of_find_node_by_path("/aliases");
+	struct device_node *ap = of_find_node_by_path("/aliases", NULL);
 
 	if (ap) {
 		const char *keyb = of_get_property(ap, "keyboard", NULL);
 		const char *ms = of_get_property(ap, "mouse", NULL);
 
 		if (keyb) {
-			if (dp == of_find_node_by_path(keyb))
+			if (dp == of_find_node_by_path(keyb, NULL))
 				return SU_PORT_KBD;
 		}
 		if (ms) {
-			if (dp == of_find_node_by_path(ms))
+			if (dp == of_find_node_by_path(ms, NULL))
 				return SU_PORT_MS;
 		}
 	}
diff --git a/drivers/tty/sysrq.c b/drivers/tty/sysrq.c
index 42bad18..515ca21 100644
--- a/drivers/tty/sysrq.c
+++ b/drivers/tty/sysrq.c
@@ -692,7 +692,7 @@ static void sysrq_of_get_keyreset_config(void)
 	struct property *prop;
 	const __be32 *p;
 
-	np = of_find_node_by_path("/chosen/linux,sysrq-reset-seq");
+	np = of_find_node_by_path("/chosen/linux,sysrq-reset-seq", NULL);
 	if (!np) {
 		pr_debug("No sysrq node found");
 		return;
diff --git a/drivers/video/fbdev/aty/radeon_monitor.c b/drivers/video/fbdev/aty/radeon_monitor.c
index bc078d5..1750360 100644
--- a/drivers/video/fbdev/aty/radeon_monitor.c
+++ b/drivers/video/fbdev/aty/radeon_monitor.c
@@ -737,7 +737,7 @@ static int is_powerblade(const char *model)
 	const char* cp;
 	int len, l, rc = 0;
 
-	root = of_find_node_by_path("/");
+	root = of_find_node_by_path("/", NULL);
 	if (root && model) {
 		l = strlen(model);
 		cp = of_get_property(root, "model", &len);
diff --git a/drivers/virt/fsl_hypervisor.c b/drivers/virt/fsl_hypervisor.c
index 32c8fc5..f7cea32 100644
--- a/drivers/virt/fsl_hypervisor.c
+++ b/drivers/virt/fsl_hypervisor.c
@@ -797,7 +797,7 @@ static int has_fsl_hypervisor(void)
 	struct device_node *node;
 	int ret;
 
-	node = of_find_node_by_path("/hypervisor");
+	node = of_find_node_by_path("/hypervisor", NULL);
 	if (!node)
 		return 0;
 
diff --git a/drivers/watchdog/cpwd.c b/drivers/watchdog/cpwd.c
index e55ed70..f880848 100644
--- a/drivers/watchdog/cpwd.c
+++ b/drivers/watchdog/cpwd.c
@@ -556,7 +556,7 @@ static int cpwd_probe(struct platform_device *op)
 		goto out_free;
 	}
 
-	options = of_find_node_by_path("/options");
+	options = of_find_node_by_path("/options", NULL);
 	err = -ENODEV;
 	if (!options) {
 		pr_err("Unable to find /options node\n");
diff --git a/fs/openpromfs/inode.c b/fs/openpromfs/inode.c
index 15e4500..bbc15a2 100644
--- a/fs/openpromfs/inode.c
+++ b/fs/openpromfs/inode.c
@@ -400,7 +400,7 @@ static int openprom_fill_super(struct super_block *s, void *data, int silent)
 
 	oi = OP_I(root_inode);
 	oi->type = op_inode_node;
-	oi->u.node = of_find_node_by_path("/");
+	oi->u.node = of_find_node_by_path("/", NULL);
 
 	s->s_root = d_make_root(root_inode);
 	if (!s->s_root)
diff --git a/include/linux/of.h b/include/linux/of.h
index 29f0adc..3adb4a4 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -228,7 +228,7 @@ extern struct device_node *of_find_matching_node_and_match(
 	const struct of_device_id *matches,
 	const struct of_device_id **match);
 
-extern struct device_node *of_find_node_by_path(const char *path);
+extern struct device_node *of_find_node_by_path(const char *path, char **opts);
 extern struct device_node *of_find_node_by_phandle(phandle handle);
 extern struct device_node *of_get_parent(const struct device_node *node);
 extern struct device_node *of_get_next_parent(struct device_node *node);
@@ -380,7 +380,8 @@ static inline struct device_node *of_find_matching_node_and_match(
 	return NULL;
 }
 
-static inline struct device_node *of_find_node_by_path(const char *path)
+static inline struct device_node *of_find_node_by_path(const char *path,
+	char **opts)
 {
 	return NULL;
 }
diff --git a/sound/soc/fsl/fsl_ssi.c b/sound/soc/fsl/fsl_ssi.c
index e695517..0056963 100644
--- a/sound/soc/fsl/fsl_ssi.c
+++ b/sound/soc/fsl/fsl_ssi.c
@@ -1427,7 +1427,7 @@ static int fsl_ssi_probe(struct platform_device *pdev)
 	 * device tree.  We also pass the address of the CPU DAI driver
 	 * structure.
 	 */
-	sprop = of_get_property(of_find_node_by_path("/"), "compatible", NULL);
+	sprop = of_get_property(of_find_node_by_path("/", NULL), "compatible", NULL);
 	/* Sometimes the compatible name has a "fsl," prefix, so we strip it. */
 	p = strrchr(sprop, ',');
 	if (p)
-- 
1.7.10.4

