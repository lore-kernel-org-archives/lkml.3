Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056Ab3EWJmZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 05:42:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53235 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757887Ab3EWJmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 05:42:00 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Subject: Re: [3.5.y.z extended stable] Linux 3.5.7.13
Date: Thu, 23 May 2013 10:41:48 +0100
Message-Id: <1369302108-4302-2-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369302108-4302-1-git-send-email-luis.henriques@canonical.com>
References: <1369302108-4302-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index 4bcb440..cfc5c91 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 3
 PATCHLEVEL = 5
 SUBLEVEL = 7
-EXTRAVERSION = .12
+EXTRAVERSION = .13
 NAME = Saber-toothed Squirrel
 
 # *DOCUMENTATION*
diff --git a/arch/arm/configs/at91sam9g45_defconfig b/arch/arm/configs/at91sam9g45_defconfig
index 606d48f..8aab786 100644
--- a/arch/arm/configs/at91sam9g45_defconfig
+++ b/arch/arm/configs/at91sam9g45_defconfig
@@ -173,7 +173,6 @@ CONFIG_MMC=y
 # CONFIG_MMC_BLOCK_BOUNCE is not set
 CONFIG_SDIO_UART=m
 CONFIG_MMC_ATMELMCI=y
-CONFIG_MMC_ATMELMCI_DMA=y
 CONFIG_LEDS_ATMEL_PWM=y
 CONFIG_LEDS_GPIO=y
 CONFIG_LEDS_TRIGGER_TIMER=y
diff --git a/arch/arm/include/asm/cmpxchg.h b/arch/arm/include/asm/cmpxchg.h
index 7eb18c1..4f009c1 100644
--- a/arch/arm/include/asm/cmpxchg.h
+++ b/arch/arm/include/asm/cmpxchg.h
@@ -233,15 +233,15 @@ static inline unsigned long __cmpxchg_local(volatile void *ptr,
 	((__typeof__(*(ptr)))atomic64_cmpxchg(container_of((ptr),	\
 						atomic64_t,		\
 						counter),		\
-					      (unsigned long)(o),	\
-					      (unsigned long)(n)))
+					      (unsigned long long)(o),	\
+					      (unsigned long long)(n)))
 
 #define cmpxchg64_local(ptr, o, n)					\
 	((__typeof__(*(ptr)))local64_cmpxchg(container_of((ptr),	\
 						local64_t,		\
 						a),			\
-					     (unsigned long)(o),	\
-					     (unsigned long)(n)))
+					     (unsigned long long)(o),	\
+					     (unsigned long long)(n)))
 
 #endif	/* __LINUX_ARM_ARCH__ >= 6 */
 
diff --git a/arch/arm/include/asm/hardware/iop3xx.h b/arch/arm/include/asm/hardware/iop3xx.h
index 2ff2c75..7e2507f 100644
--- a/arch/arm/include/asm/hardware/iop3xx.h
+++ b/arch/arm/include/asm/hardware/iop3xx.h
@@ -37,7 +37,7 @@ extern int iop3xx_get_init_atu(void);
  * IOP3XX processor registers
  */
 #define IOP3XX_PERIPHERAL_PHYS_BASE	0xffffe000
-#define IOP3XX_PERIPHERAL_VIRT_BASE	0xfeffe000
+#define IOP3XX_PERIPHERAL_VIRT_BASE	0xfedfe000
 #define IOP3XX_PERIPHERAL_SIZE		0x00002000
 #define IOP3XX_PERIPHERAL_UPPER_PA (IOP3XX_PERIPHERAL_PHYS_BASE +\
 					IOP3XX_PERIPHERAL_SIZE - 1)
diff --git a/arch/arm/mach-at91/setup.c b/arch/arm/mach-at91/setup.c
index 98c07d3..7c4edff 100644
--- a/arch/arm/mach-at91/setup.c
+++ b/arch/arm/mach-at91/setup.c
@@ -332,7 +332,7 @@ static void at91_dt_rstc(void)
 
 	of_id = of_match_node(rstc_ids, np);
 	if (!of_id)
-		panic("AT91: rtsc no restart function availlable\n");
+		panic("AT91: rtsc no restart function available\n");
 
 	arm_pm_restart = of_id->data;
 
diff --git a/arch/arm/mach-exynos/include/mach/regs-pmu.h b/arch/arm/mach-exynos/include/mach/regs-pmu.h
index 43a99e6..20a43be 100644
--- a/arch/arm/mach-exynos/include/mach/regs-pmu.h
+++ b/arch/arm/mach-exynos/include/mach/regs-pmu.h
@@ -337,6 +337,7 @@
 #define EXYNOS5_FSYS_ARM_OPTION					S5P_PMUREG(0x2208)
 #define EXYNOS5_ISP_ARM_OPTION					S5P_PMUREG(0x2288)
 #define EXYNOS5_ARM_COMMON_OPTION				S5P_PMUREG(0x2408)
+#define EXYNOS5_ARM_L2_OPTION					S5P_PMUREG(0x2608)
 #define EXYNOS5_TOP_PWR_OPTION					S5P_PMUREG(0x2C48)
 #define EXYNOS5_TOP_PWR_SYSMEM_OPTION				S5P_PMUREG(0x2CC8)
 #define EXYNOS5_JPEG_MEM_OPTION					S5P_PMUREG(0x2F48)
diff --git a/arch/arm/mach-exynos/pmu.c b/arch/arm/mach-exynos/pmu.c
index 4aacb66..d054f16 100644
--- a/arch/arm/mach-exynos/pmu.c
+++ b/arch/arm/mach-exynos/pmu.c
@@ -227,6 +227,7 @@ static struct exynos_pmu_conf exynos5250_pmu_config[] = {
 	{ EXYNOS5_DIS_IRQ_ISP_ARM_CENTRAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
 	{ EXYNOS5_ARM_COMMON_SYS_PWR_REG,		{ 0x0, 0x0, 0x2} },
 	{ EXYNOS5_ARM_L2_SYS_PWR_REG,			{ 0x3, 0x3, 0x3} },
+	{ EXYNOS5_ARM_L2_OPTION,			{ 0x10, 0x10, 0x0 } },
 	{ EXYNOS5_CMU_ACLKSTOP_SYS_PWR_REG,		{ 0x1, 0x0, 0x1} },
 	{ EXYNOS5_CMU_SCLKSTOP_SYS_PWR_REG,		{ 0x1, 0x0, 0x1} },
 	{ EXYNOS5_CMU_RESET_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
@@ -352,11 +353,9 @@ static void exynos5_init_pmu(void)
 
 	/*
 	 * SKIP_DEACTIVATE_ACEACP_IN_PWDN_BITFIELD Enable
-	 * MANUAL_L2RSTDISABLE_CONTROL_BITFIELD Enable
 	 */
 	tmp = __raw_readl(EXYNOS5_ARM_COMMON_OPTION);
-	tmp |= (EXYNOS5_MANUAL_L2RSTDISABLE_CONTROL |
-		EXYNOS5_SKIP_DEACTIVATE_ACEACP_IN_PWDN);
+	tmp |= EXYNOS5_SKIP_DEACTIVATE_ACEACP_IN_PWDN;
 	__raw_writel(tmp, EXYNOS5_ARM_COMMON_OPTION);
 
 	/*
diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/mach-omap2/board-rx51-peripherals.c
index df2534d..364e36a 100644
--- a/arch/arm/mach-omap2/board-rx51-peripherals.c
+++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
@@ -67,11 +67,11 @@
 #define LIS302_IRQ1_GPIO 181
 #define LIS302_IRQ2_GPIO 180  /* Not yet in use */
 
-/* list all spi devices here */
+/* List all SPI devices here. Note that the list/probe order seems to matter! */
 enum {
 	RX51_SPI_WL1251,
-	RX51_SPI_MIPID,		/* LCD panel */
 	RX51_SPI_TSC2005,	/* Touch Controller */
+	RX51_SPI_MIPID,		/* LCD panel */
 };
 
 static struct wl12xx_platform_data wl1251_pdata;
diff --git a/arch/arm/mach-u300/include/mach/u300-regs.h b/arch/arm/mach-u300/include/mach/u300-regs.h
index 65f87c5..cacb2af 100644
--- a/arch/arm/mach-u300/include/mach/u300-regs.h
+++ b/arch/arm/mach-u300/include/mach/u300-regs.h
@@ -101,7 +101,7 @@
 
 #ifdef CONFIG_MACH_U300_BS335
 /* Fast UART1 on U335 only */
-#define U300_UART1_BASE			(U300_SLOW_PER_PHYS_BASE+0x7000)
+#define U300_UART1_BASE			(U300_FAST_PER_PHYS_BASE+0x7000)
 #endif
 
 /*
diff --git a/arch/avr32/configs/favr-32_defconfig b/arch/avr32/configs/favr-32_defconfig
index 19973b0..59e4cc9 100644
--- a/arch/avr32/configs/favr-32_defconfig
+++ b/arch/avr32/configs/favr-32_defconfig
@@ -122,7 +122,6 @@ CONFIG_USB_G_SERIAL=m
 CONFIG_USB_CDC_COMPOSITE=m
 CONFIG_MMC=y
 CONFIG_MMC_ATMELMCI=y
-CONFIG_MMC_ATMELMCI_DMA=y
 CONFIG_NEW_LEDS=y
 CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_ATMEL_PWM=m
diff --git a/arch/avr32/configs/merisc_defconfig b/arch/avr32/configs/merisc_defconfig
index 3befab9..65de443 100644
--- a/arch/avr32/configs/merisc_defconfig
+++ b/arch/avr32/configs/merisc_defconfig
@@ -102,7 +102,6 @@ CONFIG_FRAMEBUFFER_CONSOLE=y
 CONFIG_LOGO=y
 CONFIG_MMC=y
 CONFIG_MMC_ATMELMCI=y
-CONFIG_MMC_ATMELMCI_DMA=y
 CONFIG_NEW_LEDS=y
 CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_ATMEL_PWM=y
diff --git a/arch/powerpc/include/asm/ppc-opcode.h b/arch/powerpc/include/asm/ppc-opcode.h
index d81f994..762f7a6 100644
--- a/arch/powerpc/include/asm/ppc-opcode.h
+++ b/arch/powerpc/include/asm/ppc-opcode.h
@@ -45,6 +45,10 @@
 #define PPC_INST_MFSPR_DSCR_MASK	0xfc1fffff
 #define PPC_INST_MTSPR_DSCR		0x7c1103a6
 #define PPC_INST_MTSPR_DSCR_MASK	0xfc1fffff
+#define PPC_INST_MFSPR_DSCR_USER	0x7c0302a6
+#define PPC_INST_MFSPR_DSCR_USER_MASK	0xfc1fffff
+#define PPC_INST_MTSPR_DSCR_USER	0x7c0303a6
+#define PPC_INST_MTSPR_DSCR_USER_MASK	0xfc1fffff
 #define PPC_INST_SLBFEE			0x7c0007a7
 
 #define PPC_INST_STRING			0x7c00042a
diff --git a/arch/powerpc/include/asm/rtas.h b/arch/powerpc/include/asm/rtas.h
index 557cff8..5e7e008 100644
--- a/arch/powerpc/include/asm/rtas.h
+++ b/arch/powerpc/include/asm/rtas.h
@@ -262,6 +262,8 @@ extern void rtas_progress(char *s, unsigned short hex);
 extern void rtas_initialize(void);
 extern int rtas_suspend_cpu(struct rtas_suspend_me_data *data);
 extern int rtas_suspend_last_cpu(struct rtas_suspend_me_data *data);
+extern int rtas_online_cpus_mask(cpumask_var_t cpus);
+extern int rtas_offline_cpus_mask(cpumask_var_t cpus);
 extern int rtas_ibm_suspend_me(struct rtas_args *);
 
 struct rtc_time;
diff --git a/arch/powerpc/kernel/head_64.S b/arch/powerpc/kernel/head_64.S
index 9e07bd0..1a3607b 100644
--- a/arch/powerpc/kernel/head_64.S
+++ b/arch/powerpc/kernel/head_64.S
@@ -489,6 +489,7 @@ _GLOBAL(copy_and_flush)
 	sync
 	addi	r5,r5,8
 	addi	r6,r6,8
+	isync
 	blr
 
 .align 8
diff --git a/arch/powerpc/kernel/rtas.c b/arch/powerpc/kernel/rtas.c
index fcec382..225e9f2 100644
--- a/arch/powerpc/kernel/rtas.c
+++ b/arch/powerpc/kernel/rtas.c
@@ -19,6 +19,7 @@
 #include <linux/init.h>
 #include <linux/capability.h>
 #include <linux/delay.h>
+#include <linux/cpu.h>
 #include <linux/smp.h>
 #include <linux/completion.h>
 #include <linux/cpumask.h>
@@ -808,6 +809,95 @@ static void rtas_percpu_suspend_me(void *info)
 	__rtas_suspend_cpu((struct rtas_suspend_me_data *)info, 1);
 }
 
+enum rtas_cpu_state {
+	DOWN,
+	UP,
+};
+
+#ifndef CONFIG_SMP
+static int rtas_cpu_state_change_mask(enum rtas_cpu_state state,
+				cpumask_var_t cpus)
+{
+	if (!cpumask_empty(cpus)) {
+		cpumask_clear(cpus);
+		return -EINVAL;
+	} else
+		return 0;
+}
+#else
+/* On return cpumask will be altered to indicate CPUs changed.
+ * CPUs with states changed will be set in the mask,
+ * CPUs with status unchanged will be unset in the mask. */
+static int rtas_cpu_state_change_mask(enum rtas_cpu_state state,
+				cpumask_var_t cpus)
+{
+	int cpu;
+	int cpuret = 0;
+	int ret = 0;
+
+	if (cpumask_empty(cpus))
+		return 0;
+
+	for_each_cpu(cpu, cpus) {
+		switch (state) {
+		case DOWN:
+			cpuret = cpu_down(cpu);
+			break;
+		case UP:
+			cpuret = cpu_up(cpu);
+			break;
+		}
+		if (cpuret) {
+			pr_debug("%s: cpu_%s for cpu#%d returned %d.\n",
+					__func__,
+					((state == UP) ? "up" : "down"),
+					cpu, cpuret);
+			if (!ret)
+				ret = cpuret;
+			if (state == UP) {
+				/* clear bits for unchanged cpus, return */
+				cpumask_shift_right(cpus, cpus, cpu);
+				cpumask_shift_left(cpus, cpus, cpu);
+				break;
+			} else {
+				/* clear bit for unchanged cpu, continue */
+				cpumask_clear_cpu(cpu, cpus);
+			}
+		}
+	}
+
+	return ret;
+}
+#endif
+
+int rtas_online_cpus_mask(cpumask_var_t cpus)
+{
+	int ret;
+
+	ret = rtas_cpu_state_change_mask(UP, cpus);
+
+	if (ret) {
+		cpumask_var_t tmp_mask;
+
+		if (!alloc_cpumask_var(&tmp_mask, GFP_TEMPORARY))
+			return ret;
+
+		/* Use tmp_mask to preserve cpus mask from first failure */
+		cpumask_copy(tmp_mask, cpus);
+		rtas_offline_cpus_mask(tmp_mask);
+		free_cpumask_var(tmp_mask);
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(rtas_online_cpus_mask);
+
+int rtas_offline_cpus_mask(cpumask_var_t cpus)
+{
+	return rtas_cpu_state_change_mask(DOWN, cpus);
+}
+EXPORT_SYMBOL(rtas_offline_cpus_mask);
+
 int rtas_ibm_suspend_me(struct rtas_args *args)
 {
 	long state;
@@ -815,6 +905,8 @@ int rtas_ibm_suspend_me(struct rtas_args *args)
 	unsigned long retbuf[PLPAR_HCALL_BUFSIZE];
 	struct rtas_suspend_me_data data;
 	DECLARE_COMPLETION_ONSTACK(done);
+	cpumask_var_t offline_mask;
+	int cpuret;
 
 	if (!rtas_service_present("ibm,suspend-me"))
 		return -ENOSYS;
@@ -838,11 +930,24 @@ int rtas_ibm_suspend_me(struct rtas_args *args)
 		return 0;
 	}
 
+	if (!alloc_cpumask_var(&offline_mask, GFP_TEMPORARY))
+		return -ENOMEM;
+
 	atomic_set(&data.working, 0);
 	atomic_set(&data.done, 0);
 	atomic_set(&data.error, 0);
 	data.token = rtas_token("ibm,suspend-me");
 	data.complete = &done;
+
+	/* All present CPUs must be online */
+	cpumask_andnot(offline_mask, cpu_present_mask, cpu_online_mask);
+	cpuret = rtas_online_cpus_mask(offline_mask);
+	if (cpuret) {
+		pr_err("%s: Could not bring present CPUs online.\n", __func__);
+		atomic_set(&data.error, cpuret);
+		goto out;
+	}
+
 	stop_topology_update();
 
 	/* Call function on all CPUs.  One of us will make the
@@ -858,6 +963,14 @@ int rtas_ibm_suspend_me(struct rtas_args *args)
 
 	start_topology_update();
 
+	/* Take down CPUs not online prior to suspend */
+	cpuret = rtas_offline_cpus_mask(offline_mask);
+	if (cpuret)
+		pr_warn("%s: Could not restore CPUs to offline state.\n",
+				__func__);
+
+out:
+	free_cpumask_var(offline_mask);
 	return atomic_read(&data.error);
 }
 #else /* CONFIG_PPC_PSERIES */
diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
index ae0843f..3bb7197 100644
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -960,7 +960,10 @@ static int emulate_instruction(struct pt_regs *regs)
 
 #ifdef CONFIG_PPC64
 	/* Emulate the mfspr rD, DSCR. */
-	if (((instword & PPC_INST_MFSPR_DSCR_MASK) == PPC_INST_MFSPR_DSCR) &&
+	if ((((instword & PPC_INST_MFSPR_DSCR_USER_MASK) ==
+		PPC_INST_MFSPR_DSCR_USER) ||
+	     ((instword & PPC_INST_MFSPR_DSCR_MASK) ==
+		PPC_INST_MFSPR_DSCR)) &&
 			cpu_has_feature(CPU_FTR_DSCR)) {
 		PPC_WARN_EMULATED(mfdscr, regs);
 		rd = (instword >> 21) & 0x1f;
@@ -968,7 +971,10 @@ static int emulate_instruction(struct pt_regs *regs)
 		return 0;
 	}
 	/* Emulate the mtspr DSCR, rD. */
-	if (((instword & PPC_INST_MTSPR_DSCR_MASK) == PPC_INST_MTSPR_DSCR) &&
+	if ((((instword & PPC_INST_MTSPR_DSCR_USER_MASK) ==
+		PPC_INST_MTSPR_DSCR_USER) ||
+	     ((instword & PPC_INST_MTSPR_DSCR_MASK) ==
+		PPC_INST_MTSPR_DSCR)) &&
 			cpu_has_feature(CPU_FTR_DSCR)) {
 		PPC_WARN_EMULATED(mtdscr, regs);
 		rd = (instword >> 21) & 0x1f;
diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
index 1e95556..4ec32a6 100644
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -201,7 +201,7 @@ int __node_distance(int a, int b)
 	int distance = LOCAL_DISTANCE;
 
 	if (!form1_affinity)
-		return distance;
+		return ((a == b) ? LOCAL_DISTANCE : REMOTE_DISTANCE);
 
 	for (i = 0; i < distance_ref_points_depth; i++) {
 		if (distance_lookup_table[a][i] == distance_lookup_table[b][i])
diff --git a/arch/powerpc/platforms/cell/spufs/inode.c b/arch/powerpc/platforms/cell/spufs/inode.c
index 66519d2..de32bf6 100644
--- a/arch/powerpc/platforms/cell/spufs/inode.c
+++ b/arch/powerpc/platforms/cell/spufs/inode.c
@@ -99,6 +99,7 @@ spufs_new_inode(struct super_block *sb, umode_t mode)
 	if (!inode)
 		goto out;
 
+	inode->i_ino = get_next_ino();
 	inode->i_mode = mode;
 	inode->i_uid = current_fsuid();
 	inode->i_gid = current_fsgid();
diff --git a/arch/powerpc/platforms/pseries/suspend.c b/arch/powerpc/platforms/pseries/suspend.c
index 47226e0..5f997e7 100644
--- a/arch/powerpc/platforms/pseries/suspend.c
+++ b/arch/powerpc/platforms/pseries/suspend.c
@@ -16,6 +16,7 @@
   * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
   */
 
+#include <linux/cpu.h>
 #include <linux/delay.h>
 #include <linux/suspend.h>
 #include <linux/stat.h>
@@ -126,11 +127,15 @@ static ssize_t store_hibernate(struct device *dev,
 			       struct device_attribute *attr,
 			       const char *buf, size_t count)
 {
+	cpumask_var_t offline_mask;
 	int rc;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
+	if (!alloc_cpumask_var(&offline_mask, GFP_TEMPORARY))
+		return -ENOMEM;
+
 	stream_id = simple_strtoul(buf, NULL, 16);
 
 	do {
@@ -140,15 +145,32 @@ static ssize_t store_hibernate(struct device *dev,
 	} while (rc == -EAGAIN);
 
 	if (!rc) {
+		/* All present CPUs must be online */
+		cpumask_andnot(offline_mask, cpu_present_mask,
+				cpu_online_mask);
+		rc = rtas_online_cpus_mask(offline_mask);
+		if (rc) {
+			pr_err("%s: Could not bring present CPUs online.\n",
+					__func__);
+			goto out;
+		}
+
 		stop_topology_update();
 		rc = pm_suspend(PM_SUSPEND_MEM);
 		start_topology_update();
+
+		/* Take down CPUs not online prior to suspend */
+		if (!rtas_offline_cpus_mask(offline_mask))
+			pr_warn("%s: Could not restore CPUs to offline "
+					"state.\n", __func__);
 	}
 
 	stream_id = 0;
 
 	if (!rc)
 		rc = count;
+out:
+	free_cpumask_var(offline_mask);
 	return rc;
 }
 
diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index b322741..0d6400e 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -67,6 +67,10 @@ static inline int is_zero_pfn(unsigned long pfn)
 
 #define my_zero_pfn(addr)	page_to_pfn(ZERO_PAGE(addr))
 
+/* TODO: s390 cannot support io_remap_pfn_range... */
+#define io_remap_pfn_range(vma, vaddr, pfn, size, prot) 	       \
+	remap_pfn_range(vma, vaddr, pfn, size, prot)
+
 #endif /* !__ASSEMBLY__ */
 
 /*
diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index fe12881..68c9a958 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -339,11 +339,17 @@ config HARDWALL
 config KERNEL_PL
 	int "Processor protection level for kernel"
 	range 1 2
-	default "1"
+	default 2 if TILEGX
+	default 1 if !TILEGX
 	---help---
-	  This setting determines the processor protection level the
-	  kernel will be built to run at.  Generally you should use
-	  the default value here.
+	  Since MDE 4.2, the Tilera hypervisor runs the kernel
+	  at PL2 by default.  If running under an older hypervisor,
+	  or as a KVM guest, you must run at PL1.  (The current
+	  hypervisor may also be recompiled with "make HV_PL=2" to
+	  allow it to run a kernel at PL1, but clients running at PL1
+	  are not expected to be supported indefinitely.)
+
+	  If you're not sure, don't change the default.
 
 endmenu  # Tilera-specific configuration
 
diff --git a/arch/tile/include/hv/hypervisor.h b/arch/tile/include/hv/hypervisor.h
index ccd847e..837dca5 100644
--- a/arch/tile/include/hv/hypervisor.h
+++ b/arch/tile/include/hv/hypervisor.h
@@ -107,7 +107,22 @@
 #define HV_DISPATCH_ENTRY_SIZE 32
 
 /** Version of the hypervisor interface defined by this file */
-#define _HV_VERSION 11
+#define _HV_VERSION 13
+
+/** Last version of the hypervisor interface with old hv_init() ABI.
+ *
+ * The change from version 12 to version 13 corresponds to launching
+ * the client by default at PL2 instead of PL1 (corresponding to the
+ * hv itself running at PL3 instead of PL2).  To make this explicit,
+ * the hv_init() API was also extended so the client can report its
+ * desired PL, resulting in a more helpful failure diagnostic.  If you
+ * call hv_init() with _HV_VERSION_OLD_HV_INIT and omit the client_pl
+ * argument, the hypervisor will assume client_pl = 1.
+ *
+ * Note that this is a deprecated solution and we do not expect to
+ * support clients of the Tilera hypervisor running at PL1 indefinitely.
+ */
+#define _HV_VERSION_OLD_HV_INIT 12
 
 /* Index into hypervisor interface dispatch code blocks.
  *
@@ -377,7 +392,11 @@ typedef int HV_Errno;
 #ifndef __ASSEMBLER__
 
 /** Pass HV_VERSION to hv_init to request this version of the interface. */
-typedef enum { HV_VERSION = _HV_VERSION } HV_VersionNumber;
+typedef enum {
+  HV_VERSION = _HV_VERSION,
+  HV_VERSION_OLD_HV_INIT = _HV_VERSION_OLD_HV_INIT,
+
+} HV_VersionNumber;
 
 /** Initializes the hypervisor.
  *
@@ -385,9 +404,11 @@ typedef enum { HV_VERSION = _HV_VERSION } HV_VersionNumber;
  * that this program expects, typically HV_VERSION.
  * @param chip_num Architecture number of the chip the client was built for.
  * @param chip_rev_num Revision number of the chip the client was built for.
+ * @param client_pl Privilege level the client is built for
+ *   (not required if interface_version_number == HV_VERSION_OLD_HV_INIT).
  */
 void hv_init(HV_VersionNumber interface_version_number,
-             int chip_num, int chip_rev_num);
+             int chip_num, int chip_rev_num, int client_pl);
 
 
 /** Queries we can make for hv_sysconf().
diff --git a/arch/tile/kernel/head_32.S b/arch/tile/kernel/head_32.S
index f71bfee..ac11530 100644
--- a/arch/tile/kernel/head_32.S
+++ b/arch/tile/kernel/head_32.S
@@ -38,7 +38,7 @@ ENTRY(_start)
 	  movei r2, TILE_CHIP_REV
 	}
 	{
-	  moveli r0, _HV_VERSION
+	  moveli r0, _HV_VERSION_OLD_HV_INIT
 	  jal hv_init
 	}
 	/* Get a reasonable default ASID in r0 */
diff --git a/arch/tile/kernel/head_64.S b/arch/tile/kernel/head_64.S
index f9a2734..6093964 100644
--- a/arch/tile/kernel/head_64.S
+++ b/arch/tile/kernel/head_64.S
@@ -34,13 +34,19 @@
 ENTRY(_start)
 	/* Notify the hypervisor of what version of the API we want */
 	{
+#if KERNEL_PL == 1 && _HV_VERSION == 13
+	  /* Support older hypervisors by asking for API version 12. */
+	  movei r0, _HV_VERSION_OLD_HV_INIT
+#else
+	  movei r0, _HV_VERSION
+#endif
 	  movei r1, TILE_CHIP
-	  movei r2, TILE_CHIP_REV
 	}
 	{
-	  moveli r0, _HV_VERSION
-	  jal hv_init
+	  movei r2, TILE_CHIP_REV
+	  movei r3, KERNEL_PL
 	}
+	jal hv_init
 	/* Get a reasonable default ASID in r0 */
 	{
 	  move r0, zero
diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index 520b426..fd1a099 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -310,7 +310,7 @@ void intel_pmu_lbr_read(void)
  * - in case there is no HW filter
  * - in case the HW filter has errata or limitations
  */
-static void intel_pmu_setup_sw_lbr_filter(struct perf_event *event)
+static int intel_pmu_setup_sw_lbr_filter(struct perf_event *event)
 {
 	u64 br_type = event->attr.branch_sample_type;
 	int mask = 0;
@@ -318,8 +318,11 @@ static void intel_pmu_setup_sw_lbr_filter(struct perf_event *event)
 	if (br_type & PERF_SAMPLE_BRANCH_USER)
 		mask |= X86_BR_USER;
 
-	if (br_type & PERF_SAMPLE_BRANCH_KERNEL)
+	if (br_type & PERF_SAMPLE_BRANCH_KERNEL) {
+		if (perf_paranoid_kernel() && !capable(CAP_SYS_ADMIN))
+			return -EACCES;
 		mask |= X86_BR_KERNEL;
+	}
 
 	/* we ignore BRANCH_HV here */
 
@@ -339,6 +342,8 @@ static void intel_pmu_setup_sw_lbr_filter(struct perf_event *event)
 	 * be used by fixup code for some CPU
 	 */
 	event->hw.branch_reg.reg = mask;
+
+	return 0;
 }
 
 /*
@@ -386,7 +391,9 @@ int intel_pmu_setup_lbr_filter(struct perf_event *event)
 	/*
 	 * setup SW LBR filter
 	 */
-	intel_pmu_setup_sw_lbr_filter(event);
+	ret = intel_pmu_setup_sw_lbr_filter(event);
+	if (ret)
+		return ret;
 
 	/*
 	 * setup HW LBR filter, if any
@@ -442,8 +449,18 @@ static int branch_type(unsigned long from, unsigned long to)
 			return X86_BR_NONE;
 
 		addr = buf;
-	} else
-		addr = (void *)from;
+	} else {
+		/*
+		 * The LBR logs any address in the IP, even if the IP just
+		 * faulted. This means userspace can control the from address.
+		 * Ensure we don't blindy read any address by validating it is
+		 * a known text address.
+		 */
+		if (kernel_text_address(from))
+			addr = (void *)from;
+		else
+			return X86_BR_NONE;
+	}
 
 	/*
 	 * decoder needs to know the ABI especially
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 3dafc60..a14a835 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -165,10 +165,6 @@ u64 arch_irq_stat_cpu(unsigned int cpu)
 u64 arch_irq_stat(void)
 {
 	u64 sum = atomic_read(&irq_err_count);
-
-#ifdef CONFIG_X86_IO_APIC
-	sum += atomic_read(&irq_mis_count);
-#endif
 	return sum;
 }
 
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 61593fd..eed06fc 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -4920,6 +4920,12 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
 		if (err != EMULATE_DONE)
 			return 0;
 
+		if (vcpu->arch.halt_request) {
+			vcpu->arch.halt_request = 0;
+			ret = kvm_emulate_halt(vcpu);
+			goto out;
+		}
+
 		if (signal_pending(current))
 			goto out;
 		if (need_resched())
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 4e4dcda..4779d7c 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -45,11 +45,15 @@ static void __init find_early_table_space(struct map_range *mr, int nr_range)
 	int i;
 	unsigned long puds = 0, pmds = 0, ptes = 0, tables;
 	unsigned long start = 0, good_end;
+	unsigned long pgd_extra = 0;
 	phys_addr_t base;
 
 	for (i = 0; i < nr_range; i++) {
 		unsigned long range, extra;
 
+		if ((mr[i].end >> PGDIR_SHIFT) - (mr[i].start >> PGDIR_SHIFT))
+			pgd_extra++;
+
 		range = mr[i].end - mr[i].start;
 		puds += (range + PUD_SIZE - 1) >> PUD_SHIFT;
 
@@ -74,6 +78,7 @@ static void __init find_early_table_space(struct map_range *mr, int nr_range)
 	tables = roundup(puds * sizeof(pud_t), PAGE_SIZE);
 	tables += roundup(pmds * sizeof(pmd_t), PAGE_SIZE);
 	tables += roundup(ptes * sizeof(pte_t), PAGE_SIZE);
+	tables += (pgd_extra * PAGE_SIZE);
 
 #ifdef CONFIG_X86_32
 	/* for fixmap */
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 0b4f9c7..29f714e 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -141,6 +141,21 @@ static void xen_vcpu_setup(int cpu)
 
 	BUG_ON(HYPERVISOR_shared_info == &xen_dummy_shared_info);
 
+	/*
+	 * This path is called twice on PVHVM - first during bootup via
+	 * smp_init -> xen_hvm_cpu_notify, and then if the VCPU is being
+	 * hotplugged: cpu_up -> xen_hvm_cpu_notify.
+	 * As we can only do the VCPUOP_register_vcpu_info once lets
+	 * not over-write its result.
+	 *
+	 * For PV it is called during restore (xen_vcpu_restore) and bootup
+	 * (xen_setup_vcpu_info_placement). The hotplug mechanism does not
+	 * use this function.
+	 */
+	if (xen_hvm_domain()) {
+		if (per_cpu(xen_vcpu, cpu) == &per_cpu(xen_vcpu_info, cpu))
+			return;
+	}
 	if (cpu < MAX_VIRT_CPUS)
 		per_cpu(xen_vcpu,cpu) = &HYPERVISOR_shared_info->vcpu_info[cpu];
 
diff --git a/drivers/acpi/acpica/exfldio.c b/drivers/acpi/acpica/exfldio.c
index 149de45..af9f1f6 100644
--- a/drivers/acpi/acpica/exfldio.c
+++ b/drivers/acpi/acpica/exfldio.c
@@ -722,7 +722,19 @@ acpi_ex_extract_from_field(union acpi_operand_object *obj_desc,
 
 	if ((obj_desc->common_field.start_field_bit_offset == 0) &&
 	    (obj_desc->common_field.bit_length == access_bit_width)) {
-		status = acpi_ex_field_datum_io(obj_desc, 0, buffer, ACPI_READ);
+		if (buffer_length >= sizeof(u64)) {
+			status =
+			    acpi_ex_field_datum_io(obj_desc, 0, buffer,
+						   ACPI_READ);
+		} else {
+			/* Use raw_datum (u64) to handle buffers < 64 bits */
+
+			status =
+			    acpi_ex_field_datum_io(obj_desc, 0, &raw_datum,
+						   ACPI_READ);
+			ACPI_MEMCPY(buffer, &raw_datum, buffer_length);
+		}
+
 		return_ACPI_STATUS(status);
 	}
 
diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index a51df96..f9914e5 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -217,7 +217,7 @@ static int ec_check_sci_sync(struct acpi_ec *ec, u8 state)
 static int ec_poll(struct acpi_ec *ec)
 {
 	unsigned long flags;
-	int repeat = 2; /* number of command restarts */
+	int repeat = 5; /* number of command restarts */
 	while (repeat--) {
 		unsigned long delay = jiffies +
 			msecs_to_jiffies(ec_delay);
@@ -235,8 +235,6 @@ static int ec_poll(struct acpi_ec *ec)
 			}
 			advance_transaction(ec, acpi_ec_read_status(ec));
 		} while (time_before(jiffies, delay));
-		if (acpi_ec_read_status(ec) & ACPI_EC_FLAG_IBF)
-			break;
 		pr_debug(PREFIX "controller reset, restart transaction\n");
 		spin_lock_irqsave(&ec->curr_lock, flags);
 		start_transaction(ec);
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index ea4836e..e81cc53 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -2260,7 +2260,6 @@ static int drbd_asb_recover_1p(struct drbd_conf *mdev) __must_hold(local)
 		if (hg == -1 && mdev->state.role == R_PRIMARY) {
 			enum drbd_state_rv rv2;
 
-			drbd_set_role(mdev, R_SECONDARY, 0);
 			 /* drbd_change_state() does not sleep while in SS_IN_TRANSIENT_STATE,
 			  * we might be here in C_WF_REPORT_PARAMS which is transient.
 			  * we do not need to wait for the after state change work either. */
diff --git a/drivers/char/ipmi/ipmi_bt_sm.c b/drivers/char/ipmi/ipmi_bt_sm.c
index cdd4c09f..a22a7a5 100644
--- a/drivers/char/ipmi/ipmi_bt_sm.c
+++ b/drivers/char/ipmi/ipmi_bt_sm.c
@@ -95,9 +95,9 @@ struct si_sm_data {
 	enum bt_states	state;
 	unsigned char	seq;		/* BT sequence number */
 	struct si_sm_io	*io;
-	unsigned char	write_data[IPMI_MAX_MSG_LENGTH];
+	unsigned char	write_data[IPMI_MAX_MSG_LENGTH + 2]; /* +2 for memcpy */
 	int		write_count;
-	unsigned char	read_data[IPMI_MAX_MSG_LENGTH];
+	unsigned char	read_data[IPMI_MAX_MSG_LENGTH + 2]; /* +2 for memcpy */
 	int		read_count;
 	int		truncated;
 	long		timeout;	/* microseconds countdown */
diff --git a/drivers/char/ipmi/ipmi_devintf.c b/drivers/char/ipmi/ipmi_devintf.c
index 9eb360f..d5a5f02 100644
--- a/drivers/char/ipmi/ipmi_devintf.c
+++ b/drivers/char/ipmi/ipmi_devintf.c
@@ -837,13 +837,25 @@ static long compat_ipmi_ioctl(struct file *filep, unsigned int cmd,
 		return ipmi_ioctl(filep, cmd, arg);
 	}
 }
+
+static long unlocked_compat_ipmi_ioctl(struct file *filep, unsigned int cmd,
+				       unsigned long arg)
+{
+	int ret;
+
+	mutex_lock(&ipmi_mutex);
+	ret = compat_ipmi_ioctl(filep, cmd, arg);
+	mutex_unlock(&ipmi_mutex);
+
+	return ret;
+}
 #endif
 
 static const struct file_operations ipmi_fops = {
 	.owner		= THIS_MODULE,
 	.unlocked_ioctl	= ipmi_unlocked_ioctl,
 #ifdef CONFIG_COMPAT
-	.compat_ioctl   = compat_ipmi_ioctl,
+	.compat_ioctl   = unlocked_compat_ipmi_ioctl,
 #endif
 	.open		= ipmi_open,
 	.release	= ipmi_release,
diff --git a/drivers/cpufreq/exynos-cpufreq.c b/drivers/cpufreq/exynos-cpufreq.c
index b243a7e..0a28dc3 100644
--- a/drivers/cpufreq/exynos-cpufreq.c
+++ b/drivers/cpufreq/exynos-cpufreq.c
@@ -210,8 +210,6 @@ static int exynos_cpufreq_cpu_init(struct cpufreq_policy *policy)
 
 	cpufreq_frequency_table_get_attr(exynos_info->freq_table, policy->cpu);
 
-	locking_frequency = exynos_getspeed(0);
-
 	/* set the transition latency value */
 	policy->cpuinfo.transition_latency = 100000;
 
@@ -275,6 +273,8 @@ static int __init exynos_cpufreq_init(void)
 		goto err_vdd_arm;
 	}
 
+	locking_frequency = exynos_getspeed(0);
+
 	register_pm_notifier(&exynos_cpufreq_nb);
 
 	if (cpufreq_register_driver(&exynos_driver)) {
diff --git a/drivers/cpufreq/longhaul.c b/drivers/cpufreq/longhaul.c
index 53ddbc7..0bf5bd1 100644
--- a/drivers/cpufreq/longhaul.c
+++ b/drivers/cpufreq/longhaul.c
@@ -77,7 +77,7 @@ static unsigned int longhaul_index;
 static int scale_voltage;
 static int disable_acpi_c3;
 static int revid_errata;
-
+static int enable;
 
 /* Clock ratios multiplied by 10 */
 static int mults[32];
@@ -965,6 +965,10 @@ static int __init longhaul_init(void)
 	if (!x86_match_cpu(longhaul_id))
 		return -ENODEV;
 
+	if (!enable) {
+		printk(KERN_ERR PFX "Option \"enable\" not set. Aborting.\n");
+		return -ENODEV;
+	}
 #ifdef CONFIG_SMP
 	if (num_online_cpus() > 1) {
 		printk(KERN_ERR PFX "More than 1 CPU detected, "
@@ -1021,6 +1025,10 @@ MODULE_PARM_DESC(scale_voltage, "Scale voltage of processor");
  * such. */
 module_param(revid_errata, int, 0644);
 MODULE_PARM_DESC(revid_errata, "Ignore CPU Revision ID");
+/* By default driver is disabled to prevent incompatible
+ * system freeze. */
+module_param(enable, int, 0644);
+MODULE_PARM_DESC(enable, "Enable driver");
 
 MODULE_AUTHOR("Dave Jones <davej@redhat.com>");
 MODULE_DESCRIPTION("Longhaul driver for VIA Cyrix processors.");
diff --git a/drivers/dma/pch_dma.c b/drivers/dma/pch_dma.c
index 987ab5c..d5cbd44 100644
--- a/drivers/dma/pch_dma.c
+++ b/drivers/dma/pch_dma.c
@@ -476,7 +476,7 @@ static struct pch_dma_desc *pdc_desc_get(struct pch_dma_chan *pd_chan)
 	dev_dbg(chan2dev(&pd_chan->chan), "scanned %d descriptors\n", i);
 
 	if (!ret) {
-		ret = pdc_alloc_desc(&pd_chan->chan, GFP_NOIO);
+		ret = pdc_alloc_desc(&pd_chan->chan, GFP_ATOMIC);
 		if (ret) {
 			spin_lock(&pd_chan->lock);
 			pd_chan->descs_allocated++;
diff --git a/drivers/gpu/drm/ast/ast_drv.h b/drivers/gpu/drm/ast/ast_drv.h
index d4af9ed..85a6eeb 100644
--- a/drivers/gpu/drm/ast/ast_drv.h
+++ b/drivers/gpu/drm/ast/ast_drv.h
@@ -240,6 +240,8 @@ struct ast_fbdev {
 	void *sysram;
 	int size;
 	struct ttm_bo_kmap_obj mapping;
+	int x1, y1, x2, y2; /* dirty rect */
+	spinlock_t dirty_lock;
 };
 
 #define to_ast_crtc(x) container_of(x, struct ast_crtc, base)
diff --git a/drivers/gpu/drm/ast/ast_fb.c b/drivers/gpu/drm/ast/ast_fb.c
index 2fc8e9e..853f831 100644
--- a/drivers/gpu/drm/ast/ast_fb.c
+++ b/drivers/gpu/drm/ast/ast_fb.c
@@ -53,16 +53,52 @@ static void ast_dirty_update(struct ast_fbdev *afbdev,
 	int bpp = (afbdev->afb.base.bits_per_pixel + 7)/8;
 	int ret;
 	bool unmap = false;
+	bool store_for_later = false;
+	int x2, y2;
+	unsigned long flags;
 
 	obj = afbdev->afb.obj;
 	bo = gem_to_ast_bo(obj);
 
+	/*
+	 * try and reserve the BO, if we fail with busy
+	 * then the BO is being moved and we should
+	 * store up the damage until later.
+	 */
 	ret = ast_bo_reserve(bo, true);
 	if (ret) {
-		DRM_ERROR("failed to reserve fb bo\n");
+		if (ret != -EBUSY)
+			return;
+
+		store_for_later = true;
+	}
+
+	x2 = x + width - 1;
+	y2 = y + height - 1;
+	spin_lock_irqsave(&afbdev->dirty_lock, flags);
+
+	if (afbdev->y1 < y)
+		y = afbdev->y1;
+	if (afbdev->y2 > y2)
+		y2 = afbdev->y2;
+	if (afbdev->x1 < x)
+		x = afbdev->x1;
+	if (afbdev->x2 > x2)
+		x2 = afbdev->x2;
+
+	if (store_for_later) {
+		afbdev->x1 = x;
+		afbdev->x2 = x2;
+		afbdev->y1 = y;
+		afbdev->y2 = y2;
+		spin_unlock_irqrestore(&afbdev->dirty_lock, flags);
 		return;
 	}
 
+	afbdev->x1 = afbdev->y1 = INT_MAX;
+	afbdev->x2 = afbdev->y2 = 0;
+	spin_unlock_irqrestore(&afbdev->dirty_lock, flags);
+
 	if (!bo->kmap.virtual) {
 		ret = ttm_bo_kmap(&bo->bo, 0, bo->bo.num_pages, &bo->kmap);
 		if (ret) {
@@ -72,10 +108,10 @@ static void ast_dirty_update(struct ast_fbdev *afbdev,
 		}
 		unmap = true;
 	}
-	for (i = y; i < y + height; i++) {
+	for (i = y; i <= y2; i++) {
 		/* assume equal stride for now */
 		src_offset = dst_offset = i * afbdev->afb.base.pitches[0] + (x * bpp);
-		memcpy_toio(bo->kmap.virtual + src_offset, afbdev->sysram + src_offset, width * bpp);
+		memcpy_toio(bo->kmap.virtual + src_offset, afbdev->sysram + src_offset, (x2 - x + 1) * bpp);
 
 	}
 	if (unmap)
@@ -306,6 +342,7 @@ int ast_fbdev_init(struct drm_device *dev)
 
 	ast->fbdev = afbdev;
 	afbdev->helper.funcs = &ast_fb_helper_funcs;
+	spin_lock_init(&afbdev->dirty_lock);
 	ret = drm_fb_helper_init(dev, &afbdev->helper,
 				 1, 1);
 	if (ret) {
diff --git a/drivers/gpu/drm/ast/ast_ttm.c b/drivers/gpu/drm/ast/ast_ttm.c
index 6cf2ade..2a6027c 100644
--- a/drivers/gpu/drm/ast/ast_ttm.c
+++ b/drivers/gpu/drm/ast/ast_ttm.c
@@ -316,7 +316,7 @@ int ast_bo_reserve(struct ast_bo *bo, bool no_wait)
 
 	ret = ttm_bo_reserve(&bo->bo, true, no_wait, false, 0);
 	if (ret) {
-		if (ret != -ERESTARTSYS)
+		if (ret != -ERESTARTSYS && ret != -EBUSY)
 			DRM_ERROR("reserve failed %p\n", bo);
 		return ret;
 	}
diff --git a/drivers/gpu/drm/cirrus/cirrus_drv.h b/drivers/gpu/drm/cirrus/cirrus_drv.h
index 64ea597..9f29a90 100644
--- a/drivers/gpu/drm/cirrus/cirrus_drv.h
+++ b/drivers/gpu/drm/cirrus/cirrus_drv.h
@@ -155,6 +155,8 @@ struct cirrus_fbdev {
 	struct list_head fbdev_list;
 	void *sysram;
 	int size;
+	int x1, y1, x2, y2; /* dirty rect */
+	spinlock_t dirty_lock;
 };
 
 struct cirrus_bo {
diff --git a/drivers/gpu/drm/cirrus/cirrus_fbdev.c b/drivers/gpu/drm/cirrus/cirrus_fbdev.c
index 9a276a5..774bade 100644
--- a/drivers/gpu/drm/cirrus/cirrus_fbdev.c
+++ b/drivers/gpu/drm/cirrus/cirrus_fbdev.c
@@ -27,16 +27,51 @@ static void cirrus_dirty_update(struct cirrus_fbdev *afbdev,
 	int bpp = (afbdev->gfb.base.bits_per_pixel + 7)/8;
 	int ret;
 	bool unmap = false;
+	bool store_for_later = false;
+	int x2, y2;
+	unsigned long flags;
 
 	obj = afbdev->gfb.obj;
 	bo = gem_to_cirrus_bo(obj);
 
+	/*
+	 * try and reserve the BO, if we fail with busy
+	 * then the BO is being moved and we should
+	 * store up the damage until later.
+	 */
 	ret = cirrus_bo_reserve(bo, true);
 	if (ret) {
-		DRM_ERROR("failed to reserve fb bo\n");
+		if (ret != -EBUSY)
+			return;
+		store_for_later = true;
+	}
+
+	x2 = x + width - 1;
+	y2 = y + height - 1;
+	spin_lock_irqsave(&afbdev->dirty_lock, flags);
+
+	if (afbdev->y1 < y)
+		y = afbdev->y1;
+	if (afbdev->y2 > y2)
+		y2 = afbdev->y2;
+	if (afbdev->x1 < x)
+		x = afbdev->x1;
+	if (afbdev->x2 > x2)
+		x2 = afbdev->x2;
+
+	if (store_for_later) {
+		afbdev->x1 = x;
+		afbdev->x2 = x2;
+		afbdev->y1 = y;
+		afbdev->y2 = y2;
+		spin_unlock_irqrestore(&afbdev->dirty_lock, flags);
 		return;
 	}
 
+	afbdev->x1 = afbdev->y1 = INT_MAX;
+	afbdev->x2 = afbdev->y2 = 0;
+	spin_unlock_irqrestore(&afbdev->dirty_lock, flags);
+
 	if (!bo->kmap.virtual) {
 		ret = ttm_bo_kmap(&bo->bo, 0, bo->bo.num_pages, &bo->kmap);
 		if (ret) {
@@ -283,6 +318,7 @@ int cirrus_fbdev_init(struct cirrus_device *cdev)
 
 	cdev->mode_info.gfbdev = gfbdev;
 	gfbdev->helper.funcs = &cirrus_fb_helper_funcs;
+	spin_lock_init(&gfbdev->dirty_lock);
 
 	ret = drm_fb_helper_init(cdev->dev, &gfbdev->helper,
 				 cdev->num_crtc, CIRRUSFB_CONN_LIMIT);
diff --git a/drivers/gpu/drm/cirrus/cirrus_ttm.c b/drivers/gpu/drm/cirrus/cirrus_ttm.c
index 50e170f..d4b1b1d 100644
--- a/drivers/gpu/drm/cirrus/cirrus_ttm.c
+++ b/drivers/gpu/drm/cirrus/cirrus_ttm.c
@@ -321,7 +321,7 @@ int cirrus_bo_reserve(struct cirrus_bo *bo, bool no_wait)
 
 	ret = ttm_bo_reserve(&bo->bo, true, no_wait, false, 0);
 	if (ret) {
-		if (ret != -ERESTARTSYS)
+		if (ret != -ERESTARTSYS && ret != -EBUSY)
 			DRM_ERROR("reserve failed %p\n", bo);
 		return ret;
 	}
diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
index d58e69d..debd559 100644
--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -205,11 +205,11 @@ static void
 drm_gem_remove_prime_handles(struct drm_gem_object *obj, struct drm_file *filp)
 {
 	if (obj->import_attach) {
-		drm_prime_remove_imported_buf_handle(&filp->prime,
+		drm_prime_remove_buf_handle(&filp->prime,
 				obj->import_attach->dmabuf);
 	}
 	if (obj->export_dma_buf) {
-		drm_prime_remove_imported_buf_handle(&filp->prime,
+		drm_prime_remove_buf_handle(&filp->prime,
 				obj->export_dma_buf);
 	}
 }
diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c
index f546ff9..6497c53 100644
--- a/drivers/gpu/drm/drm_prime.c
+++ b/drivers/gpu/drm/drm_prime.c
@@ -61,6 +61,7 @@ struct drm_prime_member {
 	struct dma_buf *dma_buf;
 	uint32_t handle;
 };
+static int drm_prime_add_buf_handle(struct drm_prime_file_private *prime_fpriv, struct dma_buf *dma_buf, uint32_t handle);
 
 int drm_gem_prime_handle_to_fd(struct drm_device *dev,
 		struct drm_file *file_priv, uint32_t handle, uint32_t flags,
@@ -68,7 +69,8 @@ int drm_gem_prime_handle_to_fd(struct drm_device *dev,
 {
 	struct drm_gem_object *obj;
 	void *buf;
-	int ret;
+	int ret = 0;
+	struct dma_buf *dmabuf;
 
 	obj = drm_gem_object_lookup(dev, file_priv, handle);
 	if (!obj)
@@ -77,43 +79,44 @@ int drm_gem_prime_handle_to_fd(struct drm_device *dev,
 	mutex_lock(&file_priv->prime.lock);
 	/* re-export the original imported object */
 	if (obj->import_attach) {
-		get_dma_buf(obj->import_attach->dmabuf);
-		*prime_fd = dma_buf_fd(obj->import_attach->dmabuf, flags);
-		drm_gem_object_unreference_unlocked(obj);
-		mutex_unlock(&file_priv->prime.lock);
-		return 0;
+		dmabuf = obj->import_attach->dmabuf;
+		goto out_have_obj;
 	}
 
 	if (obj->export_dma_buf) {
-		get_dma_buf(obj->export_dma_buf);
-		*prime_fd = dma_buf_fd(obj->export_dma_buf, flags);
-		drm_gem_object_unreference_unlocked(obj);
-	} else {
-		buf = dev->driver->gem_prime_export(dev, obj, flags);
-		if (IS_ERR(buf)) {
-			/* normally the created dma-buf takes ownership of the ref,
-			 * but if that fails then drop the ref
-			 */
-			drm_gem_object_unreference_unlocked(obj);
-			mutex_unlock(&file_priv->prime.lock);
-			return PTR_ERR(buf);
-		}
-		obj->export_dma_buf = buf;
-		*prime_fd = dma_buf_fd(buf, flags);
+		dmabuf = obj->export_dma_buf;
+		goto out_have_obj;
 	}
+
+	buf = dev->driver->gem_prime_export(dev, obj, flags);
+	if (IS_ERR(buf)) {
+		/* normally the created dma-buf takes ownership of the ref,
+		 * but if that fails then drop the ref
+		 */
+		ret = PTR_ERR(buf);
+		goto out;
+	}
+	obj->export_dma_buf = buf;
+
 	/* if we've exported this buffer the cheat and add it to the import list
 	 * so we get the correct handle back
 	 */
-	ret = drm_prime_add_imported_buf_handle(&file_priv->prime,
-			obj->export_dma_buf, handle);
-	if (ret) {
-		drm_gem_object_unreference_unlocked(obj);
-		mutex_unlock(&file_priv->prime.lock);
-		return ret;
-	}
+	ret = drm_prime_add_buf_handle(&file_priv->prime,
+				       obj->export_dma_buf, handle);
+	if (ret)
+		goto out;
 
+	*prime_fd = dma_buf_fd(buf, flags);
 	mutex_unlock(&file_priv->prime.lock);
 	return 0;
+
+out_have_obj:
+	get_dma_buf(dmabuf);
+	*prime_fd = dma_buf_fd(dmabuf, flags);
+out:
+	drm_gem_object_unreference_unlocked(obj);
+	mutex_unlock(&file_priv->prime.lock);
+	return ret;
 }
 EXPORT_SYMBOL(drm_gem_prime_handle_to_fd);
 
@@ -130,7 +133,7 @@ int drm_gem_prime_fd_to_handle(struct drm_device *dev,
 
 	mutex_lock(&file_priv->prime.lock);
 
-	ret = drm_prime_lookup_imported_buf_handle(&file_priv->prime,
+	ret = drm_prime_lookup_buf_handle(&file_priv->prime,
 			dma_buf, handle);
 	if (!ret) {
 		ret = 0;
@@ -149,7 +152,7 @@ int drm_gem_prime_fd_to_handle(struct drm_device *dev,
 	if (ret)
 		goto out_put;
 
-	ret = drm_prime_add_imported_buf_handle(&file_priv->prime,
+	ret = drm_prime_add_buf_handle(&file_priv->prime,
 			dma_buf, *handle);
 	if (ret)
 		goto fail;
@@ -307,7 +310,7 @@ void drm_prime_destroy_file_private(struct drm_prime_file_private *prime_fpriv)
 }
 EXPORT_SYMBOL(drm_prime_destroy_file_private);
 
-int drm_prime_add_imported_buf_handle(struct drm_prime_file_private *prime_fpriv, struct dma_buf *dma_buf, uint32_t handle)
+static int drm_prime_add_buf_handle(struct drm_prime_file_private *prime_fpriv, struct dma_buf *dma_buf, uint32_t handle)
 {
 	struct drm_prime_member *member;
 
@@ -315,14 +318,14 @@ int drm_prime_add_imported_buf_handle(struct drm_prime_file_private *prime_fpriv
 	if (!member)
 		return -ENOMEM;
 
+	get_dma_buf(dma_buf);
 	member->dma_buf = dma_buf;
 	member->handle = handle;
 	list_add(&member->entry, &prime_fpriv->head);
 	return 0;
 }
-EXPORT_SYMBOL(drm_prime_add_imported_buf_handle);
 
-int drm_prime_lookup_imported_buf_handle(struct drm_prime_file_private *prime_fpriv, struct dma_buf *dma_buf, uint32_t *handle)
+int drm_prime_lookup_buf_handle(struct drm_prime_file_private *prime_fpriv, struct dma_buf *dma_buf, uint32_t *handle)
 {
 	struct drm_prime_member *member;
 
@@ -334,19 +337,20 @@ int drm_prime_lookup_imported_buf_handle(struct drm_prime_file_private *prime_fp
 	}
 	return -ENOENT;
 }
-EXPORT_SYMBOL(drm_prime_lookup_imported_buf_handle);
+EXPORT_SYMBOL(drm_prime_lookup_buf_handle);
 
-void drm_prime_remove_imported_buf_handle(struct drm_prime_file_private *prime_fpriv, struct dma_buf *dma_buf)
+void drm_prime_remove_buf_handle(struct drm_prime_file_private *prime_fpriv, struct dma_buf *dma_buf)
 {
 	struct drm_prime_member *member, *safe;
 
 	mutex_lock(&prime_fpriv->lock);
 	list_for_each_entry_safe(member, safe, &prime_fpriv->head, entry) {
 		if (member->dma_buf == dma_buf) {
+			dma_buf_put(dma_buf);
 			list_del(&member->entry);
 			kfree(member);
 		}
 	}
 	mutex_unlock(&prime_fpriv->lock);
 }
-EXPORT_SYMBOL(drm_prime_remove_imported_buf_handle);
+EXPORT_SYMBOL(drm_prime_remove_buf_handle);
diff --git a/drivers/gpu/drm/gma500/psb_irq.c b/drivers/gpu/drm/gma500/psb_irq.c
index 8652cdf..029eccf 100644
--- a/drivers/gpu/drm/gma500/psb_irq.c
+++ b/drivers/gpu/drm/gma500/psb_irq.c
@@ -211,7 +211,7 @@ irqreturn_t psb_irq_handler(DRM_IRQ_ARGS)
 
 	vdc_stat = PSB_RVDC32(PSB_INT_IDENTITY_R);
 
-	if (vdc_stat & _PSB_PIPE_EVENT_FLAG)
+	if (vdc_stat & (_PSB_PIPE_EVENT_FLAG|_PSB_IRQ_ASLE))
 		dsp_int = 1;
 
 	/* FIXME: Handle Medfield
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index a2c97bb..d85db22 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -650,6 +650,7 @@ typedef struct drm_i915_private {
 		unsigned long gtt_start;
 		unsigned long gtt_mappable_end;
 		unsigned long gtt_end;
+		unsigned long stolen_base; /* limited to low memory (32-bit) */
 
 		struct io_mapping *gtt_mapping;
 		int gtt_mtrr;
diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 7605f40..19e9f33 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -2332,17 +2332,35 @@ static inline int fence_number(struct drm_i915_private *dev_priv,
 	return fence - dev_priv->fence_regs;
 }
 
+static void i915_gem_write_fence__ipi(void *data)
+{
+	wbinvd();
+}
+
 static void i915_gem_object_update_fence(struct drm_i915_gem_object *obj,
 					 struct drm_i915_fence_reg *fence,
 					 bool enable)
 {
-	struct drm_i915_private *dev_priv = obj->base.dev->dev_private;
-	int reg = fence_number(dev_priv, fence);
-
-	i915_gem_write_fence(obj->base.dev, reg, enable ? obj : NULL);
+	struct drm_device *dev = obj->base.dev;
+	struct drm_i915_private *dev_priv = dev->dev_private;
+	int fence_reg = fence_number(dev_priv, fence);
+
+	/* In order to fully serialize access to the fenced region and
+	 * the update to the fence register we need to take extreme
+	 * measures on SNB+. In theory, the write to the fence register
+	 * flushes all memory transactions before, and coupled with the
+	 * mb() placed around the register write we serialise all memory
+	 * operations with respect to the changes in the tiler. Yet, on
+	 * SNB+ we need to take a step further and emit an explicit wbinvd()
+	 * on each processor in order to manually flush all memory
+	 * transactions before updating the fence register.
+	 */
+	if (HAS_LLC(obj->base.dev))
+		on_each_cpu(i915_gem_write_fence__ipi, NULL, 1);
+	i915_gem_write_fence(dev, fence_reg, enable ? obj : NULL);
 
 	if (enable) {
-		obj->fence_reg = reg;
+		obj->fence_reg = fence_reg;
 		fence->obj = obj;
 		list_move_tail(&fence->lru_list, &dev_priv->mm.fence_list);
 	} else {
diff --git a/drivers/gpu/drm/i915/i915_gem_stolen.c b/drivers/gpu/drm/i915/i915_gem_stolen.c
index ada2e90..d023ed6 100644
--- a/drivers/gpu/drm/i915/i915_gem_stolen.c
+++ b/drivers/gpu/drm/i915/i915_gem_stolen.c
@@ -43,56 +43,50 @@
  * for is a boon.
  */
 
-#define PTE_ADDRESS_MASK		0xfffff000
-#define PTE_ADDRESS_MASK_HIGH		0x000000f0 /* i915+ */
-#define PTE_MAPPING_TYPE_UNCACHED	(0 << 1)
-#define PTE_MAPPING_TYPE_DCACHE		(1 << 1) /* i830 only */
-#define PTE_MAPPING_TYPE_CACHED		(3 << 1)
-#define PTE_MAPPING_TYPE_MASK		(3 << 1)
-#define PTE_VALID			(1 << 0)
-
-/**
- * i915_stolen_to_phys - take an offset into stolen memory and turn it into
- *                       a physical one
- * @dev: drm device
- * @offset: address to translate
- *
- * Some chip functions require allocations from stolen space and need the
- * physical address of the memory in question.
- */
-static unsigned long i915_stolen_to_phys(struct drm_device *dev, u32 offset)
+static unsigned long i915_stolen_to_physical(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	struct pci_dev *pdev = dev_priv->bridge_dev;
 	u32 base;
 
-#if 0
 	/* On the machines I have tested the Graphics Base of Stolen Memory
-	 * is unreliable, so compute the base by subtracting the stolen memory
-	 * from the Top of Low Usable DRAM which is where the BIOS places
-	 * the graphics stolen memory.
+	 * is unreliable, so on those compute the base by subtracting the
+	 * stolen memory from the Top of Low Usable DRAM which is where the
+	 * BIOS places the graphics stolen memory.
+	 *
+	 * On gen2, the layout is slightly different with the Graphics Segment
+	 * immediately following Top of Memory (or Top of Usable DRAM). Note
+	 * it appears that TOUD is only reported by 865g, so we just use the
+	 * top of memory as determined by the e820 probe.
+	 *
+	 * XXX gen2 requires an unavailable symbol and 945gm fails with
+	 * its value of TOLUD.
 	 */
-	if (INTEL_INFO(dev)->gen > 3 || IS_G33(dev)) {
-		/* top 32bits are reserved = 0 */
+	base = 0;
+	if (INTEL_INFO(dev)->gen >= 6) {
+		/* Read Base Data of Stolen Memory Register (BDSM) directly.
+		 * Note that there is also a MCHBAR miror at 0x1080c0 or
+		 * we could use device 2:0x5c instead.
+		*/
+		pci_read_config_dword(pdev, 0xB0, &base);
+		base &= ~4095; /* lower bits used for locking register */
+	} else if (INTEL_INFO(dev)->gen > 3 || IS_G33(dev)) {
+		/* Read Graphics Base of Stolen Memory directly */
 		pci_read_config_dword(pdev, 0xA4, &base);
-	} else {
-		/* XXX presume 8xx is the same as i915 */
-		pci_bus_read_config_dword(pdev->bus, 2, 0x5C, &base);
-	}
-#else
-	if (INTEL_INFO(dev)->gen > 3 || IS_G33(dev)) {
-		u16 val;
-		pci_read_config_word(pdev, 0xb0, &val);
-		base = val >> 4 << 20;
-	} else {
+#if 0
+	} else if (IS_GEN3(dev)) {
 		u8 val;
+		/* Stolen is immediately below Top of Low Usable DRAM */
 		pci_read_config_byte(pdev, 0x9c, &val);
 		base = val >> 3 << 27;
-	}
-	base -= dev_priv->mm.gtt->stolen_size;
+		base -= dev_priv->mm.gtt->stolen_size;
+	} else {
+		/* Stolen is immediately above Top of Memory */
+		base = max_low_pfn_mapped << PAGE_SHIFT;
 #endif
+	}
 
-	return base + offset;
+	return base;
 }
 
 static void i915_warn_stolen(struct drm_device *dev)
@@ -117,7 +111,7 @@ static void i915_setup_compression(struct drm_device *dev, int size)
 	if (!compressed_fb)
 		goto err;
 
-	cfb_base = i915_stolen_to_phys(dev, compressed_fb->start);
+	cfb_base = dev_priv->mm.stolen_base + compressed_fb->start;
 	if (!cfb_base)
 		goto err_fb;
 
@@ -130,7 +124,7 @@ static void i915_setup_compression(struct drm_device *dev, int size)
 		if (!compressed_llb)
 			goto err_fb;
 
-		ll_base = i915_stolen_to_phys(dev, compressed_llb->start);
+		ll_base = dev_priv->mm.stolen_base + compressed_llb->start;
 		if (!ll_base)
 			goto err_llb;
 	}
@@ -149,7 +143,7 @@ static void i915_setup_compression(struct drm_device *dev, int size)
 	}
 
 	DRM_DEBUG_KMS("FBC base 0x%08lx, ll base 0x%08lx, size %dM\n",
-		      cfb_base, ll_base, size >> 20);
+		      (long)cfb_base, (long)ll_base, size >> 20);
 	return;
 
 err_llb:
@@ -181,6 +175,13 @@ int i915_gem_init_stolen(struct drm_device *dev)
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	unsigned long prealloc_size = dev_priv->mm.gtt->stolen_size;
 
+	dev_priv->mm.stolen_base = i915_stolen_to_physical(dev);
+	if (dev_priv->mm.stolen_base == 0)
+		return 0;
+
+	DRM_DEBUG_KMS("found %d bytes of stolen memory at %08lx\n",
+		      dev_priv->mm.gtt->stolen_size, dev_priv->mm.stolen_base);
+
 	/* Basic memrange allocator for stolen space */
 	drm_mm_init(&dev_priv->mm.stolen, 0, prealloc_size);
 
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 2ec0617..290d89d 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -7146,6 +7146,9 @@ void intel_modeset_cleanup(struct drm_device *dev)
 	del_timer_sync(&dev_priv->idle_timer);
 	cancel_work_sync(&dev_priv->idle_work);
 
+	/* destroy backlight, if any, before the connectors */
+	intel_panel_destroy_backlight(dev);
+
 	drm_mode_config_cleanup(dev);
 }
 
diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index 0abe7ec..b6f6963 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -2336,11 +2336,6 @@ done:
 static void
 intel_dp_destroy(struct drm_connector *connector)
 {
-	struct drm_device *dev = connector->dev;
-
-	if (intel_dpd_is_edp(dev))
-		intel_panel_destroy_backlight(dev);
-
 	drm_sysfs_connector_remove(connector);
 	drm_connector_cleanup(connector);
 	kfree(connector);
diff --git a/drivers/gpu/drm/i915/intel_dvo.c b/drivers/gpu/drm/i915/intel_dvo.c
index 60ba50b9..35dc618 100644
--- a/drivers/gpu/drm/i915/intel_dvo.c
+++ b/drivers/gpu/drm/i915/intel_dvo.c
@@ -370,6 +370,7 @@ void intel_dvo_init(struct drm_device *dev)
 		const struct intel_dvo_device *dvo = &intel_dvo_devices[i];
 		struct i2c_adapter *i2c;
 		int gpio;
+		bool dvoinit;
 
 		/* Allow the I2C driver info to specify the GPIO to be used in
 		 * special cases, but otherwise default to what's defined
@@ -389,7 +390,17 @@ void intel_dvo_init(struct drm_device *dev)
 		i2c = intel_gmbus_get_adapter(dev_priv, gpio);
 
 		intel_dvo->dev = *dvo;
-		if (!dvo->dev_ops->init(&intel_dvo->dev, i2c))
+
+		/* GMBUS NAK handling seems to be unstable, hence let the
+		 * transmitter detection run in bit banging mode for now.
+		 */
+		intel_gmbus_force_bit(i2c, true);
+
+		dvoinit = dvo->dev_ops->init(&intel_dvo->dev, i2c);
+
+		intel_gmbus_force_bit(i2c, false);
+
+		if (!dvoinit)
 			continue;
 
 		intel_encoder->type = INTEL_OUTPUT_DVO;
diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index 183a8d0..6d6bf60 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -559,8 +559,6 @@ static void intel_lvds_destroy(struct drm_connector *connector)
 	struct drm_device *dev = connector->dev;
 	struct drm_i915_private *dev_priv = dev->dev_private;
 
-	intel_panel_destroy_backlight(dev);
-
 	if (dev_priv->lid_notifier.notifier_call)
 		acpi_lid_notifier_unregister(&dev_priv->lid_notifier);
 	drm_sysfs_connector_remove(connector);
@@ -794,6 +792,14 @@ static const struct dmi_system_id intel_no_lvds[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "X7SPA-H"),
 		},
 	},
+	{
+		.callback = intel_no_lvds_dmi_callback,
+		.ident = "Fujitsu Esprimo Q900",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ESPRIMO Q900"),
+		},
+	},
 
 	{ }	/* terminating entry */
 };
diff --git a/drivers/gpu/drm/i915/intel_panel.c b/drivers/gpu/drm/i915/intel_panel.c
index 2a1625d..d5fd67e 100644
--- a/drivers/gpu/drm/i915/intel_panel.c
+++ b/drivers/gpu/drm/i915/intel_panel.c
@@ -361,6 +361,9 @@ int intel_panel_setup_backlight(struct drm_device *dev)
 
 	intel_panel_init_backlight(dev);
 
+	if (WARN_ON(dev_priv->backlight))
+		return -ENODEV;
+
 	if (dev_priv->int_lvds_connector)
 		connector = dev_priv->int_lvds_connector;
 	else if (dev_priv->int_edp_connector)
@@ -389,8 +392,10 @@ int intel_panel_setup_backlight(struct drm_device *dev)
 void intel_panel_destroy_backlight(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
-	if (dev_priv->backlight)
+	if (dev_priv->backlight) {
 		backlight_device_unregister(dev_priv->backlight);
+		dev_priv->backlight = NULL;
+	}
 }
 #else
 int intel_panel_setup_backlight(struct drm_device *dev)
diff --git a/drivers/gpu/drm/mgag200/mgag200_drv.h b/drivers/gpu/drm/mgag200/mgag200_drv.h
index 6f13b35..aa2fa4d 100644
--- a/drivers/gpu/drm/mgag200/mgag200_drv.h
+++ b/drivers/gpu/drm/mgag200/mgag200_drv.h
@@ -116,6 +116,8 @@ struct mga_fbdev {
 	void *sysram;
 	int size;
 	struct ttm_bo_kmap_obj mapping;
+	int x1, y1, x2, y2; /* dirty rect */
+	spinlock_t dirty_lock;
 };
 
 struct mga_crtc {
diff --git a/drivers/gpu/drm/mgag200/mgag200_fb.c b/drivers/gpu/drm/mgag200/mgag200_fb.c
index 880d336..f5f0366 100644
--- a/drivers/gpu/drm/mgag200/mgag200_fb.c
+++ b/drivers/gpu/drm/mgag200/mgag200_fb.c
@@ -29,16 +29,52 @@ static void mga_dirty_update(struct mga_fbdev *mfbdev,
 	int bpp = (mfbdev->mfb.base.bits_per_pixel + 7)/8;
 	int ret;
 	bool unmap = false;
+	bool store_for_later = false;
+	int x2, y2;
+	unsigned long flags;
 
 	obj = mfbdev->mfb.obj;
 	bo = gem_to_mga_bo(obj);
 
+	/*
+	 * try and reserve the BO, if we fail with busy
+	 * then the BO is being moved and we should
+	 * store up the damage until later.
+	 */
 	ret = mgag200_bo_reserve(bo, true);
 	if (ret) {
-		DRM_ERROR("failed to reserve fb bo\n");
+		if (ret != -EBUSY)
+			return;
+
+		store_for_later = true;
+	}
+
+	x2 = x + width - 1;
+	y2 = y + height - 1;
+	spin_lock_irqsave(&mfbdev->dirty_lock, flags);
+
+	if (mfbdev->y1 < y)
+		y = mfbdev->y1;
+	if (mfbdev->y2 > y2)
+		y2 = mfbdev->y2;
+	if (mfbdev->x1 < x)
+		x = mfbdev->x1;
+	if (mfbdev->x2 > x2)
+		x2 = mfbdev->x2;
+
+	if (store_for_later) {
+		mfbdev->x1 = x;
+		mfbdev->x2 = x2;
+		mfbdev->y1 = y;
+		mfbdev->y2 = y2;
+		spin_unlock_irqrestore(&mfbdev->dirty_lock, flags);
 		return;
 	}
 
+	mfbdev->x1 = mfbdev->y1 = INT_MAX;
+	mfbdev->x2 = mfbdev->y2 = 0;
+	spin_unlock_irqrestore(&mfbdev->dirty_lock, flags);
+
 	if (!bo->kmap.virtual) {
 		ret = ttm_bo_kmap(&bo->bo, 0, bo->bo.num_pages, &bo->kmap);
 		if (ret) {
@@ -48,10 +84,10 @@ static void mga_dirty_update(struct mga_fbdev *mfbdev,
 		}
 		unmap = true;
 	}
-	for (i = y; i < y + height; i++) {
+	for (i = y; i <= y2; i++) {
 		/* assume equal stride for now */
 		src_offset = dst_offset = i * mfbdev->mfb.base.pitches[0] + (x * bpp);
-		memcpy_toio(bo->kmap.virtual + src_offset, mfbdev->sysram + src_offset, width * bpp);
+		memcpy_toio(bo->kmap.virtual + src_offset, mfbdev->sysram + src_offset, (x2 - x + 1) * bpp);
 
 	}
 	if (unmap)
@@ -270,6 +306,7 @@ int mgag200_fbdev_init(struct mga_device *mdev)
 
 	mdev->mfbdev = mfbdev;
 	mfbdev->helper.funcs = &mga_fb_helper_funcs;
+	spin_lock_init(&mfbdev->dirty_lock);
 
 	ret = drm_fb_helper_init(mdev->dev, &mfbdev->helper,
 				 mdev->num_crtc, MGAG200FB_CONN_LIMIT);
diff --git a/drivers/gpu/drm/mgag200/mgag200_mode.c b/drivers/gpu/drm/mgag200/mgag200_mode.c
index abb9776..4860c35 100644
--- a/drivers/gpu/drm/mgag200/mgag200_mode.c
+++ b/drivers/gpu/drm/mgag200/mgag200_mode.c
@@ -190,12 +190,12 @@ static int mga_g200wb_set_plls(struct mga_device *mdev, long clock)
 		WREG8(DAC_INDEX, MGA1064_PIX_CLK_CTL);
 		tmp = RREG8(DAC_DATA);
 		tmp |= MGA1064_PIX_CLK_CTL_CLK_DIS;
-		WREG_DAC(MGA1064_PIX_CLK_CTL_CLK_DIS, tmp);
+		WREG8(DAC_DATA, tmp);
 
 		WREG8(DAC_INDEX, MGA1064_REMHEADCTL);
 		tmp = RREG8(DAC_DATA);
 		tmp |= MGA1064_REMHEADCTL_CLKDIS;
-		WREG_DAC(MGA1064_REMHEADCTL, tmp);
+		WREG8(DAC_DATA, tmp);
 
 		/* select PLL Set C */
 		tmp = RREG8(MGAREG_MEM_MISC_READ);
@@ -205,7 +205,7 @@ static int mga_g200wb_set_plls(struct mga_device *mdev, long clock)
 		WREG8(DAC_INDEX, MGA1064_PIX_CLK_CTL);
 		tmp = RREG8(DAC_DATA);
 		tmp |= MGA1064_PIX_CLK_CTL_CLK_POW_DOWN | 0x80;
-		WREG_DAC(MGA1064_PIX_CLK_CTL, tmp);
+		WREG8(DAC_DATA, tmp);
 
 		udelay(500);
 
@@ -213,7 +213,7 @@ static int mga_g200wb_set_plls(struct mga_device *mdev, long clock)
 		WREG8(DAC_INDEX, MGA1064_VREF_CTL);
 		tmp = RREG8(DAC_DATA);
 		tmp &= ~0x04;
-		WREG_DAC(MGA1064_VREF_CTL, tmp);
+		WREG8(DAC_DATA, tmp);
 
 		udelay(50);
 
@@ -237,13 +237,13 @@ static int mga_g200wb_set_plls(struct mga_device *mdev, long clock)
 		tmp = RREG8(DAC_DATA);
 		tmp &= ~MGA1064_PIX_CLK_CTL_SEL_MSK;
 		tmp |= MGA1064_PIX_CLK_CTL_SEL_PLL;
-		WREG_DAC(MGA1064_PIX_CLK_CTL, tmp);
+		WREG8(DAC_DATA, tmp);
 
 		WREG8(DAC_INDEX, MGA1064_REMHEADCTL);
 		tmp = RREG8(DAC_DATA);
 		tmp &= ~MGA1064_REMHEADCTL_CLKSL_MSK;
 		tmp |= MGA1064_REMHEADCTL_CLKSL_PLL;
-		WREG_DAC(MGA1064_REMHEADCTL, tmp);
+		WREG8(DAC_DATA, tmp);
 
 		/* reset dotclock rate bit */
 		WREG8(MGAREG_SEQ_INDEX, 1);
@@ -254,7 +254,7 @@ static int mga_g200wb_set_plls(struct mga_device *mdev, long clock)
 		WREG8(DAC_INDEX, MGA1064_PIX_CLK_CTL);
 		tmp = RREG8(DAC_DATA);
 		tmp &= ~MGA1064_PIX_CLK_CTL_CLK_DIS;
-		WREG_DAC(MGA1064_PIX_CLK_CTL, tmp);
+		WREG8(DAC_DATA, tmp);
 
 		vcount = RREG8(MGAREG_VCOUNT);
 
@@ -319,7 +319,7 @@ static int mga_g200ev_set_plls(struct mga_device *mdev, long clock)
 	WREG8(DAC_INDEX, MGA1064_PIX_CLK_CTL);
 	tmp = RREG8(DAC_DATA);
 	tmp |= MGA1064_PIX_CLK_CTL_CLK_DIS;
-	WREG_DAC(MGA1064_PIX_CLK_CTL_CLK_DIS, tmp);
+	WREG8(DAC_DATA, tmp);
 
 	tmp = RREG8(MGAREG_MEM_MISC_READ);
 	tmp |= 0x3 << 2;
@@ -327,12 +327,12 @@ static int mga_g200ev_set_plls(struct mga_device *mdev, long clock)
 
 	WREG8(DAC_INDEX, MGA1064_PIX_PLL_STAT);
 	tmp = RREG8(DAC_DATA);
-	WREG_DAC(MGA1064_PIX_PLL_STAT, tmp & ~0x40);
+	WREG8(DAC_DATA, tmp & ~0x40);
 
 	WREG8(DAC_INDEX, MGA1064_PIX_CLK_CTL);
 	tmp = RREG8(DAC_DATA);
 	tmp |= MGA1064_PIX_CLK_CTL_CLK_POW_DOWN;
-	WREG_DAC(MGA1064_PIX_CLK_CTL, tmp);
+	WREG8(DAC_DATA, tmp);
 
 	WREG_DAC(MGA1064_EV_PIX_PLLC_M, m);
 	WREG_DAC(MGA1064_EV_PIX_PLLC_N, n);
@@ -343,7 +343,7 @@ static int mga_g200ev_set_plls(struct mga_device *mdev, long clock)
 	WREG8(DAC_INDEX, MGA1064_PIX_CLK_CTL);
 	tmp = RREG8(DAC_DATA);
 	tmp &= ~MGA1064_PIX_CLK_CTL_CLK_POW_DOWN;
-	WREG_DAC(MGA1064_PIX_CLK_CTL, tmp);
+	WREG8(DAC_DATA, tmp);
 
 	udelay(500);
 
@@ -351,11 +351,11 @@ static int mga_g200ev_set_plls(struct mga_device *mdev, long clock)
 	tmp = RREG8(DAC_DATA);
 	tmp &= ~MGA1064_PIX_CLK_CTL_SEL_MSK;
 	tmp |= MGA1064_PIX_CLK_CTL_SEL_PLL;
-	WREG_DAC(MGA1064_PIX_CLK_CTL, tmp);
+	WREG8(DAC_DATA, tmp);
 
 	WREG8(DAC_INDEX, MGA1064_PIX_PLL_STAT);
 	tmp = RREG8(DAC_DATA);
-	WREG_DAC(MGA1064_PIX_PLL_STAT, tmp | 0x40);
+	WREG8(DAC_DATA, tmp | 0x40);
 
 	tmp = RREG8(MGAREG_MEM_MISC_READ);
 	tmp |= (0x3 << 2);
@@ -364,7 +364,7 @@ static int mga_g200ev_set_plls(struct mga_device *mdev, long clock)
 	WREG8(DAC_INDEX, MGA1064_PIX_CLK_CTL);
 	tmp = RREG8(DAC_DATA);
 	tmp &= ~MGA1064_PIX_CLK_CTL_CLK_DIS;
-	WREG_DAC(MGA1064_PIX_CLK_CTL, tmp);
+	WREG8(DAC_DATA, tmp);
 
 	return 0;
 }
@@ -417,7 +417,7 @@ static int mga_g200eh_set_plls(struct mga_device *mdev, long clock)
 		WREG8(DAC_INDEX, MGA1064_PIX_CLK_CTL);
 		tmp = RREG8(DAC_DATA);
 		tmp |= MGA1064_PIX_CLK_CTL_CLK_DIS;
-		WREG_DAC(MGA1064_PIX_CLK_CTL_CLK_DIS, tmp);
+		WREG8(DAC_DATA, tmp);
 
 		tmp = RREG8(MGAREG_MEM_MISC_READ);
 		tmp |= 0x3 << 2;
@@ -426,7 +426,7 @@ static int mga_g200eh_set_plls(struct mga_device *mdev, long clock)
 		WREG8(DAC_INDEX, MGA1064_PIX_CLK_CTL);
 		tmp = RREG8(DAC_DATA);
 		tmp |= MGA1064_PIX_CLK_CTL_CLK_POW_DOWN;
-		WREG_DAC(MGA1064_PIX_CLK_CTL, tmp);
+		WREG8(DAC_DATA, tmp);
 
 		udelay(500);
 
@@ -440,13 +440,13 @@ static int mga_g200eh_set_plls(struct mga_device *mdev, long clock)
 		tmp = RREG8(DAC_DATA);
 		tmp &= ~MGA1064_PIX_CLK_CTL_SEL_MSK;
 		tmp |= MGA1064_PIX_CLK_CTL_SEL_PLL;
-		WREG_DAC(MGA1064_PIX_CLK_CTL, tmp);
+		WREG8(DAC_DATA, tmp);
 
 		WREG8(DAC_INDEX, MGA1064_PIX_CLK_CTL);
 		tmp = RREG8(DAC_DATA);
 		tmp &= ~MGA1064_PIX_CLK_CTL_CLK_DIS;
 		tmp &= ~MGA1064_PIX_CLK_CTL_CLK_POW_DOWN;
-		WREG_DAC(MGA1064_PIX_CLK_CTL, tmp);
+		WREG8(DAC_DATA, tmp);
 
 		vcount = RREG8(MGAREG_VCOUNT);
 
@@ -516,12 +516,12 @@ static int mga_g200er_set_plls(struct mga_device *mdev, long clock)
 	WREG8(DAC_INDEX, MGA1064_PIX_CLK_CTL);
 	tmp = RREG8(DAC_DATA);
 	tmp |= MGA1064_PIX_CLK_CTL_CLK_DIS;
-	WREG_DAC(MGA1064_PIX_CLK_CTL_CLK_DIS, tmp);
+	WREG8(DAC_DATA, tmp);
 
 	WREG8(DAC_INDEX, MGA1064_REMHEADCTL);
 	tmp = RREG8(DAC_DATA);
 	tmp |= MGA1064_REMHEADCTL_CLKDIS;
-	WREG_DAC(MGA1064_REMHEADCTL, tmp);
+	WREG8(DAC_DATA, tmp);
 
 	tmp = RREG8(MGAREG_MEM_MISC_READ);
 	tmp |= (0x3<<2) | 0xc0;
@@ -531,7 +531,7 @@ static int mga_g200er_set_plls(struct mga_device *mdev, long clock)
 	tmp = RREG8(DAC_DATA);
 	tmp &= ~MGA1064_PIX_CLK_CTL_CLK_DIS;
 	tmp |= MGA1064_PIX_CLK_CTL_CLK_POW_DOWN;
-	WREG_DAC(MGA1064_PIX_CLK_CTL, tmp);
+	WREG8(DAC_DATA, tmp);
 
 	udelay(500);
 
@@ -658,12 +658,26 @@ static void mga_g200wb_commit(struct drm_crtc *crtc)
 	WREG_DAC(MGA1064_GEN_IO_DATA, tmp);
 }
 
-
+/*
+   This is how the framebuffer base address is stored in g200 cards:
+   * Assume @offset is the gpu_addr variable of the framebuffer object
+   * Then addr is the number of _pixels_ (not bytes) from the start of
+     VRAM to the first pixel we want to display. (divided by 2 for 32bit
+     framebuffers)
+   * addr is stored in the CRTCEXT0, CRTCC and CRTCD registers
+   addr<20> -> CRTCEXT0<6>
+   addr<19-16> -> CRTCEXT0<3-0>
+   addr<15-8> -> CRTCC<7-0>
+   addr<7-0> -> CRTCD<7-0>
+   CRTCEXT0 has to be programmed last to trigger an update and make the
+   new addr variable take effect.
+ */
 void mga_set_start_address(struct drm_crtc *crtc, unsigned offset)
 {
 	struct mga_device *mdev = crtc->dev->dev_private;
 	u32 addr;
 	int count;
+	u8 crtcext0;
 
 	while (RREG8(0x1fda) & 0x08);
 	while (!(RREG8(0x1fda) & 0x08));
@@ -671,10 +685,17 @@ void mga_set_start_address(struct drm_crtc *crtc, unsigned offset)
 	count = RREG8(MGAREG_VCOUNT) + 2;
 	while (RREG8(MGAREG_VCOUNT) < count);
 
-	addr = offset >> 2;
+	WREG8(MGAREG_CRTCEXT_INDEX, 0);
+	crtcext0 = RREG8(MGAREG_CRTCEXT_DATA);
+	crtcext0 &= 0xB0;
+	addr = offset / 8;
+	/* Can't store addresses any higher than that...
+	   but we also don't have more than 16MB of memory, so it should be fine. */
+	WARN_ON(addr > 0x1fffff);
+	crtcext0 |= (!!(addr & (1<<20)))<<6;
 	WREG_CRT(0x0d, (u8)(addr & 0xff));
 	WREG_CRT(0x0c, (u8)(addr >> 8) & 0xff);
-	WREG_CRT(0xaf, (u8)(addr >> 16) & 0xf);
+	WREG_ECRT(0x0, ((u8)(addr >> 16) & 0xf) | crtcext0);
 }
 
 
diff --git a/drivers/gpu/drm/mgag200/mgag200_ttm.c b/drivers/gpu/drm/mgag200/mgag200_ttm.c
index b223dcb..a707394 100644
--- a/drivers/gpu/drm/mgag200/mgag200_ttm.c
+++ b/drivers/gpu/drm/mgag200/mgag200_ttm.c
@@ -315,8 +315,8 @@ int mgag200_bo_reserve(struct mgag200_bo *bo, bool no_wait)
 
 	ret = ttm_bo_reserve(&bo->bo, true, no_wait, false, 0);
 	if (ret) {
-		if (ret != -ERESTARTSYS)
-			DRM_ERROR("reserve failed %p\n", bo);
+		if (ret != -ERESTARTSYS && ret != -EBUSY)
+			DRM_ERROR("reserve failed %p %d\n", bo, ret);
 		return ret;
 	}
 	return 0;
diff --git a/drivers/gpu/drm/radeon/atom.c b/drivers/gpu/drm/radeon/atom.c
index 5ce9bf5..43672b6 100644
--- a/drivers/gpu/drm/radeon/atom.c
+++ b/drivers/gpu/drm/radeon/atom.c
@@ -1389,10 +1389,10 @@ int atom_allocate_fb_scratch(struct atom_context *ctx)
 		firmware_usage = (struct _ATOM_VRAM_USAGE_BY_FIRMWARE *)(ctx->bios + data_offset);
 
 		DRM_DEBUG("atom firmware requested %08x %dkb\n",
-			  firmware_usage->asFirmwareVramReserveInfo[0].ulStartAddrUsedByFirmware,
-			  firmware_usage->asFirmwareVramReserveInfo[0].usFirmwareUseInKb);
+			  le32_to_cpu(firmware_usage->asFirmwareVramReserveInfo[0].ulStartAddrUsedByFirmware),
+			  le16_to_cpu(firmware_usage->asFirmwareVramReserveInfo[0].usFirmwareUseInKb));
 
-		usage_bytes = firmware_usage->asFirmwareVramReserveInfo[0].usFirmwareUseInKb * 1024;
+		usage_bytes = le16_to_cpu(firmware_usage->asFirmwareVramReserveInfo[0].usFirmwareUseInKb) * 1024;
 	}
 	ctx->scratch_size_bytes = 0;
 	if (usage_bytes == 0)
diff --git a/drivers/gpu/drm/radeon/atombios_crtc.c b/drivers/gpu/drm/radeon/atombios_crtc.c
index 08b71a3..c4e646f 100644
--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -573,6 +573,9 @@ static u32 atombios_adjust_pll(struct drm_crtc *crtc,
 		/* use frac fb div on APUs */
 		if (ASIC_IS_DCE41(rdev) || ASIC_IS_DCE61(rdev))
 			pll->flags |= RADEON_PLL_USE_FRAC_FB_DIV;
+		/* use frac fb div on RS780/RS880 */
+		if ((rdev->family == CHIP_RS780) || (rdev->family == CHIP_RS880))
+			pll->flags |= RADEON_PLL_USE_FRAC_FB_DIV;
 		if (ASIC_IS_DCE32(rdev) && mode->clock > 165000)
 			pll->flags |= RADEON_PLL_USE_FRAC_FB_DIV;
 	} else {
diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/evergreen.c
index ccac010..dd708a3 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -445,6 +445,16 @@ void evergreen_hpd_init(struct radeon_device *rdev)
 
 	list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
 		struct radeon_connector *radeon_connector = to_radeon_connector(connector);
+
+		if (connector->connector_type == DRM_MODE_CONNECTOR_eDP ||
+		    connector->connector_type == DRM_MODE_CONNECTOR_LVDS) {
+			/* don't try to enable hpd on eDP or LVDS avoid breaking the
+			 * aux dp channel on imac and help (but not completely fix)
+			 * https://bugzilla.redhat.com/show_bug.cgi?id=726143
+			 * also avoid interrupt storms during dpms.
+			 */
+			continue;
+		}
 		switch (radeon_connector->hpd.hpd) {
 		case RADEON_HPD_1:
 			WREG32(DC_HPD1_CONTROL, tmp);
@@ -1146,17 +1156,16 @@ void evergreen_mc_stop(struct radeon_device *rdev, struct evergreen_mc_save *sav
 				tmp = RREG32(EVERGREEN_CRTC_BLANK_CONTROL + crtc_offsets[i]);
 				if (!(tmp & EVERGREEN_CRTC_BLANK_DATA_EN)) {
 					radeon_wait_for_vblank(rdev, i);
-					tmp |= EVERGREEN_CRTC_BLANK_DATA_EN;
 					WREG32(EVERGREEN_CRTC_UPDATE_LOCK + crtc_offsets[i], 1);
+					tmp |= EVERGREEN_CRTC_BLANK_DATA_EN;
 					WREG32(EVERGREEN_CRTC_BLANK_CONTROL + crtc_offsets[i], tmp);
-					WREG32(EVERGREEN_CRTC_UPDATE_LOCK + crtc_offsets[i], 0);
 				}
 			} else {
 				tmp = RREG32(EVERGREEN_CRTC_CONTROL + crtc_offsets[i]);
 				if (!(tmp & EVERGREEN_CRTC_DISP_READ_REQUEST_DISABLE)) {
 					radeon_wait_for_vblank(rdev, i);
-					tmp |= EVERGREEN_CRTC_DISP_READ_REQUEST_DISABLE;
 					WREG32(EVERGREEN_CRTC_UPDATE_LOCK + crtc_offsets[i], 1);
+					tmp |= EVERGREEN_CRTC_DISP_READ_REQUEST_DISABLE;
 					WREG32(EVERGREEN_CRTC_CONTROL + crtc_offsets[i], tmp);
 					WREG32(EVERGREEN_CRTC_UPDATE_LOCK + crtc_offsets[i], 0);
 				}
@@ -1168,6 +1177,15 @@ void evergreen_mc_stop(struct radeon_device *rdev, struct evergreen_mc_save *sav
 					break;
 				udelay(1);
 			}
+
+			/* XXX this is a hack to avoid strange behavior with EFI on certain systems */
+			WREG32(EVERGREEN_CRTC_UPDATE_LOCK + crtc_offsets[i], 1);
+			tmp = RREG32(EVERGREEN_CRTC_CONTROL + crtc_offsets[i]);
+			tmp &= ~EVERGREEN_CRTC_MASTER_EN;
+			WREG32(EVERGREEN_CRTC_CONTROL + crtc_offsets[i], tmp);
+			WREG32(EVERGREEN_CRTC_UPDATE_LOCK + crtc_offsets[i], 0);
+			save->crtc_enabled[i] = false;
+			/* ***** */
 		} else {
 			save->crtc_enabled[i] = false;
 		}
@@ -1185,6 +1203,22 @@ void evergreen_mc_stop(struct radeon_device *rdev, struct evergreen_mc_save *sav
 	}
 	/* wait for the MC to settle */
 	udelay(100);
+
+	/* lock double buffered regs */
+	for (i = 0; i < rdev->num_crtc; i++) {
+		if (save->crtc_enabled[i]) {
+			tmp = RREG32(EVERGREEN_GRPH_UPDATE + crtc_offsets[i]);
+			if (!(tmp & EVERGREEN_GRPH_UPDATE_LOCK)) {
+				tmp |= EVERGREEN_GRPH_UPDATE_LOCK;
+				WREG32(EVERGREEN_GRPH_UPDATE + crtc_offsets[i], tmp);
+			}
+			tmp = RREG32(EVERGREEN_MASTER_UPDATE_LOCK + crtc_offsets[i]);
+			if (!(tmp & 1)) {
+				tmp |= 1;
+				WREG32(EVERGREEN_MASTER_UPDATE_LOCK + crtc_offsets[i], tmp);
+			}
+		}
+	}
 }
 
 void evergreen_mc_resume(struct radeon_device *rdev, struct evergreen_mc_save *save)
@@ -1206,6 +1240,33 @@ void evergreen_mc_resume(struct radeon_device *rdev, struct evergreen_mc_save *s
 	WREG32(EVERGREEN_VGA_MEMORY_BASE_ADDRESS_HIGH, upper_32_bits(rdev->mc.vram_start));
 	WREG32(EVERGREEN_VGA_MEMORY_BASE_ADDRESS, (u32)rdev->mc.vram_start);
 
+	/* unlock regs and wait for update */
+	for (i = 0; i < rdev->num_crtc; i++) {
+		if (save->crtc_enabled[i]) {
+			tmp = RREG32(EVERGREEN_MASTER_UPDATE_MODE + crtc_offsets[i]);
+			if ((tmp & 0x3) != 0) {
+				tmp &= ~0x3;
+				WREG32(EVERGREEN_MASTER_UPDATE_MODE + crtc_offsets[i], tmp);
+			}
+			tmp = RREG32(EVERGREEN_GRPH_UPDATE + crtc_offsets[i]);
+			if (tmp & EVERGREEN_GRPH_UPDATE_LOCK) {
+				tmp &= ~EVERGREEN_GRPH_UPDATE_LOCK;
+				WREG32(EVERGREEN_GRPH_UPDATE + crtc_offsets[i], tmp);
+			}
+			tmp = RREG32(EVERGREEN_MASTER_UPDATE_LOCK + crtc_offsets[i]);
+			if (tmp & 1) {
+				tmp &= ~1;
+				WREG32(EVERGREEN_MASTER_UPDATE_LOCK + crtc_offsets[i], tmp);
+			}
+			for (j = 0; j < rdev->usec_timeout; j++) {
+				tmp = RREG32(EVERGREEN_GRPH_UPDATE + crtc_offsets[i]);
+				if ((tmp & EVERGREEN_GRPH_SURFACE_UPDATE_PENDING) == 0)
+					break;
+				udelay(1);
+			}
+		}
+	}
+
 	/* unblackout the MC */
 	tmp = RREG32(MC_SHARED_BLACKOUT_CNTL);
 	tmp &= ~BLACKOUT_MODE_MASK;
diff --git a/drivers/gpu/drm/radeon/evergreen_reg.h b/drivers/gpu/drm/radeon/evergreen_reg.h
index 034f4c2..3e9773a 100644
--- a/drivers/gpu/drm/radeon/evergreen_reg.h
+++ b/drivers/gpu/drm/radeon/evergreen_reg.h
@@ -225,6 +225,8 @@
 #define EVERGREEN_CRTC_STATUS_POSITION                  0x6e90
 #define EVERGREEN_MASTER_UPDATE_MODE                    0x6ef8
 #define EVERGREEN_CRTC_UPDATE_LOCK                      0x6ed4
+#define EVERGREEN_MASTER_UPDATE_LOCK                    0x6ef4
+#define EVERGREEN_MASTER_UPDATE_MODE                    0x6ef8
 
 #define EVERGREEN_DC_GPIO_HPD_MASK                      0x64b0
 #define EVERGREEN_DC_GPIO_HPD_A                         0x64b4
diff --git a/drivers/gpu/drm/radeon/ni.c b/drivers/gpu/drm/radeon/ni.c
index 0aa705e..137b1f5 100644
--- a/drivers/gpu/drm/radeon/ni.c
+++ b/drivers/gpu/drm/radeon/ni.c
@@ -471,7 +471,8 @@ static void cayman_gpu_init(struct radeon_device *rdev)
 		    (rdev->pdev->device == 0x990F) ||
 		    (rdev->pdev->device == 0x9910) ||
 		    (rdev->pdev->device == 0x9917) ||
-		    (rdev->pdev->device == 0x9999)) {
+		    (rdev->pdev->device == 0x9999) ||
+		    (rdev->pdev->device == 0x999C)) {
 			rdev->config.cayman.max_simds_per_se = 6;
 			rdev->config.cayman.max_backends_per_se = 2;
 		} else if ((rdev->pdev->device == 0x9903) ||
@@ -480,7 +481,8 @@ static void cayman_gpu_init(struct radeon_device *rdev)
 			   (rdev->pdev->device == 0x990D) ||
 			   (rdev->pdev->device == 0x990E) ||
 			   (rdev->pdev->device == 0x9913) ||
-			   (rdev->pdev->device == 0x9918)) {
+			   (rdev->pdev->device == 0x9918) ||
+			   (rdev->pdev->device == 0x999D)) {
 			rdev->config.cayman.max_simds_per_se = 4;
 			rdev->config.cayman.max_backends_per_se = 2;
 		} else if ((rdev->pdev->device == 0x9919) ||
@@ -619,6 +621,8 @@ static void cayman_gpu_init(struct radeon_device *rdev)
 
 	WREG32(GB_ADDR_CONFIG, gb_addr_config);
 	WREG32(DMIF_ADDR_CONFIG, gb_addr_config);
+	if (ASIC_IS_DCE6(rdev))
+		WREG32(DMIF_ADDR_CALC, gb_addr_config);
 	WREG32(HDP_ADDR_CONFIG, gb_addr_config);
 
 	if ((rdev->config.cayman.max_backends_per_se == 1) &&
diff --git a/drivers/gpu/drm/radeon/nid.h b/drivers/gpu/drm/radeon/nid.h
index 5e76c2f5..dd334a2 100644
--- a/drivers/gpu/drm/radeon/nid.h
+++ b/drivers/gpu/drm/radeon/nid.h
@@ -45,6 +45,10 @@
 #define ARUBA_GB_ADDR_CONFIG_GOLDEN        0x12010001
 
 #define DMIF_ADDR_CONFIG  				0xBD4
+
+/* DCE6 only */
+#define DMIF_ADDR_CALC  				0xC00
+
 #define	SRBM_GFX_CNTL				        0x0E44
 #define		RINGID(x)					(((x) & 0x3) << 0)
 #define		VMID(x)						(((x) & 0x7) << 0)
diff --git a/drivers/gpu/drm/radeon/r300_cmdbuf.c b/drivers/gpu/drm/radeon/r300_cmdbuf.c
index 1fe98b4..9aa02be 100644
--- a/drivers/gpu/drm/radeon/r300_cmdbuf.c
+++ b/drivers/gpu/drm/radeon/r300_cmdbuf.c
@@ -74,7 +74,7 @@ static int r300_emit_cliprects(drm_radeon_private_t *dev_priv,
 		OUT_RING(CP_PACKET0(R300_RE_CLIPRECT_TL_0, nr * 2 - 1));
 
 		for (i = 0; i < nr; ++i) {
-			if (DRM_COPY_FROM_USER_UNCHECKED
+			if (DRM_COPY_FROM_USER
 			    (&box, &cmdbuf->boxes[n + i], sizeof(box))) {
 				DRM_ERROR("copy cliprect faulted\n");
 				return -EFAULT;
diff --git a/drivers/gpu/drm/radeon/r600_hdmi.c b/drivers/gpu/drm/radeon/r600_hdmi.c
index 851a477..26ce6c1 100644
--- a/drivers/gpu/drm/radeon/r600_hdmi.c
+++ b/drivers/gpu/drm/radeon/r600_hdmi.c
@@ -489,7 +489,7 @@ void r600_hdmi_enable(struct drm_encoder *encoder)
 	offset = dig->afmt->offset;
 
 	/* Older chipsets require setting HDMI and routing manually */
-	if (rdev->family >= CHIP_R600 && !ASIC_IS_DCE3(rdev)) {
+	if (ASIC_IS_DCE2(rdev) && !ASIC_IS_DCE3(rdev)) {
 		hdmi = HDMI0_ERROR_ACK | HDMI0_ENABLE;
 		switch (radeon_encoder->encoder_id) {
 		case ENCODER_OBJECT_ID_INTERNAL_KLDSCP_TMDS1:
@@ -559,7 +559,7 @@ void r600_hdmi_disable(struct drm_encoder *encoder)
 	radeon_irq_set(rdev);
 
 	/* Older chipsets not handled by AtomBIOS */
-	if (rdev->family >= CHIP_R600 && !ASIC_IS_DCE3(rdev)) {
+	if (ASIC_IS_DCE2(rdev) && !ASIC_IS_DCE3(rdev)) {
 		switch (radeon_encoder->encoder_id) {
 		case ENCODER_OBJECT_ID_INTERNAL_KLDSCP_TMDS1:
 			WREG32_P(AVIVO_TMDSA_CNTL, 0,
diff --git a/drivers/gpu/drm/radeon/radeon_atombios.c b/drivers/gpu/drm/radeon/radeon_atombios.c
index 5e30e12..38d87e1 100644
--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -1998,6 +1998,8 @@ static int radeon_atombios_parse_power_table_1_3(struct radeon_device *rdev)
 	num_modes = power_info->info.ucNumOfPowerModeEntries;
 	if (num_modes > ATOM_MAX_NUMBEROF_POWER_BLOCK)
 		num_modes = ATOM_MAX_NUMBEROF_POWER_BLOCK;
+	if (num_modes == 0)
+		return state_index;
 	rdev->pm.power_state = kzalloc(sizeof(struct radeon_power_state) * num_modes, GFP_KERNEL);
 	if (!rdev->pm.power_state)
 		return state_index;
@@ -2396,6 +2398,8 @@ static int radeon_atombios_parse_power_table_4_5(struct radeon_device *rdev)
 	power_info = (union power_info *)(mode_info->atom_context->bios + data_offset);
 
 	radeon_atombios_add_pplib_thermal_controller(rdev, &power_info->pplib.sThermalController);
+	if (power_info->pplib.ucNumStates == 0)
+		return state_index;
 	rdev->pm.power_state = kzalloc(sizeof(struct radeon_power_state) *
 				       power_info->pplib.ucNumStates, GFP_KERNEL);
 	if (!rdev->pm.power_state)
@@ -2478,6 +2482,7 @@ static int radeon_atombios_parse_power_table_6(struct radeon_device *rdev)
 	int index = GetIndexIntoMasterTable(DATA, PowerPlayInfo);
         u16 data_offset;
 	u8 frev, crev;
+	u8 *power_state_offset;
 
 	if (!atom_parse_data_header(mode_info->atom_context, index, NULL,
 				   &frev, &crev, &data_offset))
@@ -2494,15 +2499,17 @@ static int radeon_atombios_parse_power_table_6(struct radeon_device *rdev)
 	non_clock_info_array = (struct _NonClockInfoArray *)
 		(mode_info->atom_context->bios + data_offset +
 		 le16_to_cpu(power_info->pplib.usNonClockInfoArrayOffset));
+	if (state_array->ucNumEntries == 0)
+		return state_index;
 	rdev->pm.power_state = kzalloc(sizeof(struct radeon_power_state) *
 				       state_array->ucNumEntries, GFP_KERNEL);
 	if (!rdev->pm.power_state)
 		return state_index;
+	power_state_offset = (u8 *)state_array->states;
 	for (i = 0; i < state_array->ucNumEntries; i++) {
 		mode_index = 0;
-		power_state = (union pplib_power_state *)&state_array->states[i];
-		/* XXX this might be an inagua bug... */
-		non_clock_array_index = i; /* power_state->v2.nonClockInfoIndex */
+		power_state = (union pplib_power_state *)power_state_offset;
+		non_clock_array_index = power_state->v2.nonClockInfoIndex;
 		non_clock_info = (struct _ATOM_PPLIB_NONCLOCK_INFO *)
 			&non_clock_info_array->nonClockInfo[non_clock_array_index];
 		rdev->pm.power_state[i].clock_info = kzalloc(sizeof(struct radeon_pm_clock_info) *
@@ -2514,9 +2521,6 @@ static int radeon_atombios_parse_power_table_6(struct radeon_device *rdev)
 		if (power_state->v2.ucNumDPMLevels) {
 			for (j = 0; j < power_state->v2.ucNumDPMLevels; j++) {
 				clock_array_index = power_state->v2.clockInfoIndex[j];
-				/* XXX this might be an inagua bug... */
-				if (clock_array_index >= clock_info_array->ucNumEntries)
-					continue;
 				clock_info = (union pplib_clock_info *)
 					&clock_info_array->clockInfo[clock_array_index * clock_info_array->ucEntrySize];
 				valid = radeon_atombios_parse_pplib_clock_info(rdev,
@@ -2538,6 +2542,7 @@ static int radeon_atombios_parse_power_table_6(struct radeon_device *rdev)
 								   non_clock_info);
 			state_index++;
 		}
+		power_state_offset += 2 + power_state->v2.ucNumDPMLevels;
 	}
 	/* if multiple clock modes, mark the lowest as no display */
 	for (i = 0; i < state_index; i++) {
@@ -2584,7 +2589,9 @@ void radeon_atombios_get_power_modes(struct radeon_device *rdev)
 		default:
 			break;
 		}
-	} else {
+	}
+
+	if (state_index == 0) {
 		rdev->pm.power_state = kzalloc(sizeof(struct radeon_power_state), GFP_KERNEL);
 		if (rdev->pm.power_state) {
 			rdev->pm.power_state[0].clock_info =
diff --git a/drivers/gpu/drm/radeon/radeon_kms.c b/drivers/gpu/drm/radeon/radeon_kms.c
index 5c58d7d..c574139 100644
--- a/drivers/gpu/drm/radeon/radeon_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_kms.c
@@ -39,8 +39,12 @@ int radeon_driver_unload_kms(struct drm_device *dev)
 
 	if (rdev == NULL)
 		return 0;
+	if (rdev->rmmio == NULL)
+		goto done_free;
 	radeon_modeset_fini(rdev);
 	radeon_device_fini(rdev);
+
+done_free:
 	kfree(rdev);
 	dev->dev_private = NULL;
 	return 0;
diff --git a/drivers/gpu/drm/radeon/radeon_pm.c b/drivers/gpu/drm/radeon/radeon_pm.c
index 0c4ca48..c7f3d6c 100644
--- a/drivers/gpu/drm/radeon/radeon_pm.c
+++ b/drivers/gpu/drm/radeon/radeon_pm.c
@@ -864,7 +864,11 @@ static int radeon_debugfs_pm_info(struct seq_file *m, void *data)
 	struct radeon_device *rdev = dev->dev_private;
 
 	seq_printf(m, "default engine clock: %u0 kHz\n", rdev->pm.default_sclk);
-	seq_printf(m, "current engine clock: %u0 kHz\n", radeon_get_engine_clock(rdev));
+	/* radeon_get_engine_clock is not reliable on APUs so just print the current clock */
+	if ((rdev->family >= CHIP_PALM) && (rdev->flags & RADEON_IS_IGP))
+		seq_printf(m, "current engine clock: %u0 kHz\n", rdev->pm.current_sclk);
+	else
+		seq_printf(m, "current engine clock: %u0 kHz\n", radeon_get_engine_clock(rdev));
 	seq_printf(m, "default memory clock: %u0 kHz\n", rdev->pm.default_mclk);
 	if (rdev->asic->pm.get_memory_clock)
 		seq_printf(m, "current memory clock: %u0 kHz\n", radeon_get_memory_clock(rdev));
diff --git a/drivers/gpu/drm/radeon/si.c b/drivers/gpu/drm/radeon/si.c
index 29e42de..c43a544 100644
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -1374,7 +1374,7 @@ static void si_select_se_sh(struct radeon_device *rdev,
 	u32 data = INSTANCE_BROADCAST_WRITES;
 
 	if ((se_num == 0xffffffff) && (sh_num == 0xffffffff))
-		data = SH_BROADCAST_WRITES | SE_BROADCAST_WRITES;
+		data |= SH_BROADCAST_WRITES | SE_BROADCAST_WRITES;
 	else if (se_num == 0xffffffff)
 		data |= SE_BROADCAST_WRITES | SH_INDEX(sh_num);
 	else if (sh_num == 0xffffffff)
@@ -1659,6 +1659,7 @@ static void si_gpu_init(struct radeon_device *rdev)
 
 	WREG32(GB_ADDR_CONFIG, gb_addr_config);
 	WREG32(DMIF_ADDR_CONFIG, gb_addr_config);
+	WREG32(DMIF_ADDR_CALC, gb_addr_config);
 	WREG32(HDP_ADDR_CONFIG, gb_addr_config);
 
 	si_tiling_mode_table_init(rdev);
diff --git a/drivers/gpu/drm/radeon/sid.h b/drivers/gpu/drm/radeon/sid.h
index 06b17e6..916e13f 100644
--- a/drivers/gpu/drm/radeon/sid.h
+++ b/drivers/gpu/drm/radeon/sid.h
@@ -60,6 +60,8 @@
 
 #define DMIF_ADDR_CONFIG  				0xBD4
 
+#define DMIF_ADDR_CALC  				0xC00
+
 #define	SRBM_STATUS				        0xE50
 
 #define	CC_SYS_RB_BACKEND_DISABLE			0xe80
diff --git a/drivers/i2c/busses/i2c-xiic.c b/drivers/i2c/busses/i2c-xiic.c
index 641d0e5..15d20de 100644
--- a/drivers/i2c/busses/i2c-xiic.c
+++ b/drivers/i2c/busses/i2c-xiic.c
@@ -312,10 +312,8 @@ static void xiic_fill_tx_fifo(struct xiic_i2c *i2c)
 			/* last message in transfer -> STOP */
 			data |= XIIC_TX_DYN_STOP_MASK;
 			dev_dbg(i2c->adap.dev.parent, "%s TX STOP\n", __func__);
-
-			xiic_setreg16(i2c, XIIC_DTR_REG_OFFSET, data);
-		} else
-			xiic_setreg8(i2c, XIIC_DTR_REG_OFFSET, data);
+		}
+		xiic_setreg16(i2c, XIIC_DTR_REG_OFFSET, data);
 	}
 }
 
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 5f4659e..8bd2d5f 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1117,6 +1117,7 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	s->pending_pool = mempool_create_slab_pool(MIN_IOS, pending_cache);
 	if (!s->pending_pool) {
 		ti->error = "Could not allocate mempool for pending exceptions";
+		r = -ENOMEM;
 		goto bad_pending_pool;
 	}
 
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 5f52a9a..1307ba8 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2035,6 +2035,7 @@ static int pool_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		 * thin devices' discard limits consistent).
 		 */
 		ti->discards_supported = 1;
+		ti->discard_zeroes_data_unsupported = 1;
 	}
 	ti->private = pt;
 
@@ -2496,7 +2497,6 @@ static void set_discard_limits(struct pool *pool, struct queue_limits *limits)
 	 * bios that overlap 2 blocks.
 	 */
 	limits->discard_granularity = pool->sectors_per_block << SECTOR_SHIFT;
-	limits->discard_zeroes_data = pool->pf.zero_new_blocks;
 }
 
 static void pool_io_hints(struct dm_target *ti, struct queue_limits *limits)
diff --git a/drivers/mfd/adp5520.c b/drivers/mfd/adp5520.c
index 8d816cc..105f820 100644
--- a/drivers/mfd/adp5520.c
+++ b/drivers/mfd/adp5520.c
@@ -36,6 +36,7 @@ struct adp5520_chip {
 	struct blocking_notifier_head notifier_list;
 	int irq;
 	unsigned long id;
+	uint8_t mode;
 };
 
 static int __adp5520_read(struct i2c_client *client,
@@ -326,7 +327,10 @@ static int adp5520_suspend(struct device *dev)
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adp5520_chip *chip = dev_get_drvdata(&client->dev);
 
-	adp5520_clr_bits(chip->dev, ADP5520_MODE_STATUS, ADP5520_nSTNBY);
+	adp5520_read(chip->dev, ADP5520_MODE_STATUS, &chip->mode);
+	/* All other bits are W1C */
+	chip->mode &= ADP5520_BL_EN | ADP5520_DIM_EN | ADP5520_nSTNBY;
+	adp5520_write(chip->dev, ADP5520_MODE_STATUS, 0);
 	return 0;
 }
 
@@ -335,7 +339,7 @@ static int adp5520_resume(struct device *dev)
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adp5520_chip *chip = dev_get_drvdata(&client->dev);
 
-	adp5520_set_bits(chip->dev, ADP5520_MODE_STATUS, ADP5520_nSTNBY);
+	adp5520_write(chip->dev, ADP5520_MODE_STATUS, chip->mode);
 	return 0;
 }
 #endif
diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index 4f4489a..bb9e81d 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -368,13 +368,13 @@ static int mmc_read_ext_csd(struct mmc_card *card, u8 *ext_csd)
 		ext_csd[EXT_CSD_SEC_FEATURE_SUPPORT];
 	card->ext_csd.raw_trim_mult =
 		ext_csd[EXT_CSD_TRIM_MULT];
+	card->ext_csd.raw_partition_support = ext_csd[EXT_CSD_PARTITION_SUPPORT];
 	if (card->ext_csd.rev >= 4) {
 		/*
 		 * Enhanced area feature support -- check whether the eMMC
 		 * card has the Enhanced area enabled.  If so, export enhanced
 		 * area offset and size to user by adding sysfs interface.
 		 */
-		card->ext_csd.raw_partition_support = ext_csd[EXT_CSD_PARTITION_SUPPORT];
 		if ((ext_csd[EXT_CSD_PARTITION_SUPPORT] & 0x2) &&
 		    (ext_csd[EXT_CSD_PARTITION_ATTRIBUTE] & 0x1)) {
 			hc_erase_grp_sz =
diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index aa131b3..1449469 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -300,16 +300,6 @@ config MMC_ATMELMCI
 
 endchoice
 
-config MMC_ATMELMCI_DMA
-	bool "Atmel MCI DMA support"
-	depends on MMC_ATMELMCI && (AVR32 || ARCH_AT91SAM9G45) && DMA_ENGINE
-	help
-	  Say Y here to have the Atmel MCI driver use a DMA engine to
-	  do data transfers and thus increase the throughput and
-	  reduce the CPU utilization.
-
-	  If unsure, say N.
-
 config MMC_MSM
 	tristate "Qualcomm SDCC Controller Support"
 	depends on MMC && ARCH_MSM
diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index 1a69c63..ac472be 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -175,6 +175,7 @@ struct atmel_mci {
 	void __iomem		*regs;
 
 	struct scatterlist	*sg;
+	unsigned int		sg_len;
 	unsigned int		pio_offset;
 	unsigned int		*buffer;
 	unsigned int		buf_size;
@@ -819,6 +820,7 @@ static u32 atmci_prepare_data(struct atmel_mci *host, struct mmc_data *data)
 	data->error = -EINPROGRESS;
 
 	host->sg = data->sg;
+	host->sg_len = data->sg_len;
 	host->data = data;
 	host->data_chan = NULL;
 
@@ -1751,7 +1753,8 @@ static void atmci_read_data_pio(struct atmel_mci *host)
 			if (offset == sg->length) {
 				flush_dcache_page(sg_page(sg));
 				host->sg = sg = sg_next(sg);
-				if (!sg)
+				host->sg_len--;
+				if (!sg || !host->sg_len)
 					goto done;
 
 				offset = 0;
@@ -1764,7 +1767,8 @@ static void atmci_read_data_pio(struct atmel_mci *host)
 
 			flush_dcache_page(sg_page(sg));
 			host->sg = sg = sg_next(sg);
-			if (!sg)
+			host->sg_len--;
+			if (!sg || !host->sg_len)
 				goto done;
 
 			offset = 4 - remaining;
@@ -1815,7 +1819,8 @@ static void atmci_write_data_pio(struct atmel_mci *host)
 			nbytes += 4;
 			if (offset == sg->length) {
 				host->sg = sg = sg_next(sg);
-				if (!sg)
+				host->sg_len--;
+				if (!sg || !host->sg_len)
 					goto done;
 
 				offset = 0;
@@ -1829,7 +1834,8 @@ static void atmci_write_data_pio(struct atmel_mci *host)
 			nbytes += remaining;
 
 			host->sg = sg = sg_next(sg);
-			if (!sg) {
+			host->sg_len--;
+			if (!sg || !host->sg_len) {
 				atmci_writel(host, ATMCI_TDR, value);
 				goto done;
 			}
@@ -2401,10 +2407,8 @@ static int __exit atmci_remove(struct platform_device *pdev)
 	atmci_readl(host, ATMCI_SR);
 	clk_disable(host->mck);
 
-#ifdef CONFIG_MMC_ATMELMCI_DMA
 	if (host->dma.chan)
 		dma_release_channel(host->dma.chan);
-#endif
 
 	free_irq(platform_get_irq(pdev, 0), host);
 	iounmap(host->regs);
diff --git a/drivers/net/ethernet/3com/3c509.c b/drivers/net/ethernet/3com/3c509.c
index 1a8eef2..ce8fb21 100644
--- a/drivers/net/ethernet/3com/3c509.c
+++ b/drivers/net/ethernet/3com/3c509.c
@@ -308,6 +308,7 @@ static int __devinit el3_isa_match(struct device *pdev,
 	if (!dev)
 		return -ENOMEM;
 
+	SET_NETDEV_DEV(dev, pdev);
 	netdev_boot_setup_check(dev);
 
 	if (!request_region(ioaddr, EL3_IO_EXTENT, "3c509-isa")) {
@@ -598,6 +599,7 @@ static int __init el3_eisa_probe (struct device *device)
 		return -ENOMEM;
 	}
 
+	SET_NETDEV_DEV(dev, device);
 	netdev_boot_setup_check(dev);
 
 	el3_dev_fill(dev, phys_addr, ioaddr, irq, if_port, EL3_EISA);
diff --git a/drivers/net/ethernet/3com/3c59x.c b/drivers/net/ethernet/3com/3c59x.c
index e463d10..5673d6e 100644
--- a/drivers/net/ethernet/3com/3c59x.c
+++ b/drivers/net/ethernet/3com/3c59x.c
@@ -632,7 +632,6 @@ struct vortex_private {
 		pm_state_valid:1,				/* pci_dev->saved_config_space has sane contents */
 		open:1,
 		medialock:1,
-		must_free_region:1,				/* Flag: if zero, Cardbus owns the I/O region */
 		large_frames:1,			/* accept large frames */
 		handling_irq:1;			/* private in_irq indicator */
 	/* {get|set}_wol operations are already serialized by rtnl.
@@ -951,7 +950,7 @@ static int __devexit vortex_eisa_remove(struct device *device)
 
 	unregister_netdev(dev);
 	iowrite16(TotalReset|0x14, ioaddr + EL3_CMD);
-	release_region(dev->base_addr, VORTEX_TOTAL_SIZE);
+	release_region(edev->base_addr, VORTEX_TOTAL_SIZE);
 
 	free_netdev(dev);
 	return 0;
@@ -1012,6 +1011,12 @@ static int __devinit vortex_init_one(struct pci_dev *pdev,
 	if (rc < 0)
 		goto out;
 
+	rc = pci_request_regions(pdev, DRV_NAME);
+	if (rc < 0) {
+		pci_disable_device(pdev);
+		goto out;
+	}
+
 	unit = vortex_cards_found;
 
 	if (global_use_mmio < 0 && (unit >= MAX_UNITS || use_mmio[unit] < 0)) {
@@ -1027,6 +1032,7 @@ static int __devinit vortex_init_one(struct pci_dev *pdev,
 	if (!ioaddr) /* If mapping fails, fall-back to BAR 0... */
 		ioaddr = pci_iomap(pdev, 0, 0);
 	if (!ioaddr) {
+		pci_release_regions(pdev);
 		pci_disable_device(pdev);
 		rc = -ENOMEM;
 		goto out;
@@ -1036,6 +1042,7 @@ static int __devinit vortex_init_one(struct pci_dev *pdev,
 			   ent->driver_data, unit);
 	if (rc < 0) {
 		pci_iounmap(pdev, ioaddr);
+		pci_release_regions(pdev);
 		pci_disable_device(pdev);
 		goto out;
 	}
@@ -1179,11 +1186,6 @@ static int __devinit vortex_probe1(struct device *gendev,
 
 	/* PCI-only startup logic */
 	if (pdev) {
-		/* EISA resources already marked, so only PCI needs to do this here */
-		/* Ignore return value, because Cardbus drivers already allocate for us */
-		if (request_region(dev->base_addr, vci->io_size, print_name) != NULL)
-			vp->must_free_region = 1;
-
 		/* enable bus-mastering if necessary */
 		if (vci->flags & PCI_USES_MASTER)
 			pci_set_master(pdev);
@@ -1221,7 +1223,7 @@ static int __devinit vortex_probe1(struct device *gendev,
 					   &vp->rx_ring_dma);
 	retval = -ENOMEM;
 	if (!vp->rx_ring)
-		goto free_region;
+		goto free_device;
 
 	vp->tx_ring = (struct boom_tx_desc *)(vp->rx_ring + RX_RING_SIZE);
 	vp->tx_ring_dma = vp->rx_ring_dma + sizeof(struct boom_rx_desc) * RX_RING_SIZE;
@@ -1486,9 +1488,7 @@ free_ring:
 							+ sizeof(struct boom_tx_desc) * TX_RING_SIZE,
 						vp->rx_ring,
 						vp->rx_ring_dma);
-free_region:
-	if (vp->must_free_region)
-		release_region(dev->base_addr, vci->io_size);
+free_device:
 	free_netdev(dev);
 	pr_err(PFX "vortex_probe1 fails.  Returns %d\n", retval);
 out:
@@ -3256,8 +3256,9 @@ static void __devexit vortex_remove_one(struct pci_dev *pdev)
 							+ sizeof(struct boom_tx_desc) * TX_RING_SIZE,
 						vp->rx_ring,
 						vp->rx_ring_dma);
-	if (vp->must_free_region)
-		release_region(dev->base_addr, vp->io_size);
+
+	pci_release_regions(pdev);
+
 	free_netdev(dev);
 }
 
diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index b68d28a..33a1760 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -1327,7 +1327,7 @@ static const struct net_device_ops ibmveth_netdev_ops = {
 static int __devinit ibmveth_probe(struct vio_dev *dev,
 				   const struct vio_device_id *id)
 {
-	int rc, i;
+	int rc, i, mac_len;
 	struct net_device *netdev;
 	struct ibmveth_adapter *adapter;
 	unsigned char *mac_addr_p;
@@ -1337,11 +1337,19 @@ static int __devinit ibmveth_probe(struct vio_dev *dev,
 		dev->unit_address);
 
 	mac_addr_p = (unsigned char *)vio_get_attribute(dev, VETH_MAC_ADDR,
-							NULL);
+							&mac_len);
 	if (!mac_addr_p) {
 		dev_err(&dev->dev, "Can't find VETH_MAC_ADDR attribute\n");
 		return -EINVAL;
 	}
+	/* Workaround for old/broken pHyp */
+	if (mac_len == 8)
+		mac_addr_p += 2;
+	else if (mac_len != 6) {
+		dev_err(&dev->dev, "VETH_MAC_ADDR attribute wrong len %d\n",
+			mac_len);
+		return -EINVAL;
+	}
 
 	mcastFilterSize_p = (unsigned int *)vio_get_attribute(dev,
 						VETH_MCAST_FILTER_SIZE, NULL);
@@ -1366,17 +1374,6 @@ static int __devinit ibmveth_probe(struct vio_dev *dev,
 
 	netif_napi_add(netdev, &adapter->napi, ibmveth_poll, 16);
 
-	/*
-	 * Some older boxes running PHYP non-natively have an OF that returns
-	 * a 8-byte local-mac-address field (and the first 2 bytes have to be
-	 * ignored) while newer boxes' OF return a 6-byte field. Note that
-	 * IEEE 1275 specifies that local-mac-address must be a 6-byte field.
-	 * The RPA doc specifies that the first byte must be 10b, so we'll
-	 * just look for it to solve this 8 vs. 6 byte field issue
-	 */
-	if ((*mac_addr_p & 0x3) != 0x02)
-		mac_addr_p += 2;
-
 	adapter->mac_addr = 0;
 	memcpy(&adapter->mac_addr, mac_addr_p, 6);
 
diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index a32d221..f250232 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -1687,8 +1687,6 @@ static void rtl8169_rx_vlan_tag(struct RxDesc *desc, struct sk_buff *skb)
 
 	if (opts2 & RxVlanTag)
 		__vlan_hwaccel_put_tag(skb, swab16(opts2 & 0xffff));
-
-	desc->opts2 = 0;
 }
 
 static int rtl8169_gset_tbi(struct net_device *dev, struct ethtool_cmd *cmd)
@@ -4576,8 +4574,10 @@ static void rtl_hw_start_8168bb(struct rtl8169_private *tp)
 
 	RTL_W16(CPlusCmd, RTL_R16(CPlusCmd) & ~R8168_CPCMD_QUIRK_MASK);
 
-	rtl_tx_performance_tweak(pdev,
-		(0x5 << MAX_READ_REQUEST_SHIFT) | PCI_EXP_DEVCTL_NOSNOOP_EN);
+	if (tp->dev->mtu <= ETH_DATA_LEN) {
+		rtl_tx_performance_tweak(pdev, (0x5 << MAX_READ_REQUEST_SHIFT) |
+					 PCI_EXP_DEVCTL_NOSNOOP_EN);
+	}
 }
 
 static void rtl_hw_start_8168bef(struct rtl8169_private *tp)
@@ -4600,7 +4600,8 @@ static void __rtl_hw_start_8168cp(struct rtl8169_private *tp)
 
 	RTL_W8(Config3, RTL_R8(Config3) & ~Beacon_en);
 
-	rtl_tx_performance_tweak(pdev, 0x5 << MAX_READ_REQUEST_SHIFT);
+	if (tp->dev->mtu <= ETH_DATA_LEN)
+		rtl_tx_performance_tweak(pdev, 0x5 << MAX_READ_REQUEST_SHIFT);
 
 	rtl_disable_clock_request(pdev);
 
@@ -4634,7 +4635,8 @@ static void rtl_hw_start_8168cp_2(struct rtl8169_private *tp)
 
 	RTL_W8(Config3, RTL_R8(Config3) & ~Beacon_en);
 
-	rtl_tx_performance_tweak(pdev, 0x5 << MAX_READ_REQUEST_SHIFT);
+	if (tp->dev->mtu <= ETH_DATA_LEN)
+		rtl_tx_performance_tweak(pdev, 0x5 << MAX_READ_REQUEST_SHIFT);
 
 	RTL_W16(CPlusCmd, RTL_R16(CPlusCmd) & ~R8168_CPCMD_QUIRK_MASK);
 }
@@ -4653,7 +4655,8 @@ static void rtl_hw_start_8168cp_3(struct rtl8169_private *tp)
 
 	RTL_W8(MaxTxPacketSize, TxPacketMax);
 
-	rtl_tx_performance_tweak(pdev, 0x5 << MAX_READ_REQUEST_SHIFT);
+	if (tp->dev->mtu <= ETH_DATA_LEN)
+		rtl_tx_performance_tweak(pdev, 0x5 << MAX_READ_REQUEST_SHIFT);
 
 	RTL_W16(CPlusCmd, RTL_R16(CPlusCmd) & ~R8168_CPCMD_QUIRK_MASK);
 }
@@ -4714,7 +4717,8 @@ static void rtl_hw_start_8168d(struct rtl8169_private *tp)
 
 	RTL_W8(MaxTxPacketSize, TxPacketMax);
 
-	rtl_tx_performance_tweak(pdev, 0x5 << MAX_READ_REQUEST_SHIFT);
+	if (tp->dev->mtu <= ETH_DATA_LEN)
+		rtl_tx_performance_tweak(pdev, 0x5 << MAX_READ_REQUEST_SHIFT);
 
 	RTL_W16(CPlusCmd, RTL_R16(CPlusCmd) & ~R8168_CPCMD_QUIRK_MASK);
 }
@@ -4726,7 +4730,8 @@ static void rtl_hw_start_8168dp(struct rtl8169_private *tp)
 
 	rtl_csi_access_enable_1(tp);
 
-	rtl_tx_performance_tweak(pdev, 0x5 << MAX_READ_REQUEST_SHIFT);
+	if (tp->dev->mtu <= ETH_DATA_LEN)
+		rtl_tx_performance_tweak(pdev, 0x5 << MAX_READ_REQUEST_SHIFT);
 
 	RTL_W8(MaxTxPacketSize, TxPacketMax);
 
@@ -4785,7 +4790,8 @@ static void rtl_hw_start_8168e_1(struct rtl8169_private *tp)
 
 	rtl_ephy_init(ioaddr, e_info_8168e_1, ARRAY_SIZE(e_info_8168e_1));
 
-	rtl_tx_performance_tweak(pdev, 0x5 << MAX_READ_REQUEST_SHIFT);
+	if (tp->dev->mtu <= ETH_DATA_LEN)
+		rtl_tx_performance_tweak(pdev, 0x5 << MAX_READ_REQUEST_SHIFT);
 
 	RTL_W8(MaxTxPacketSize, TxPacketMax);
 
@@ -4811,7 +4817,8 @@ static void rtl_hw_start_8168e_2(struct rtl8169_private *tp)
 
 	rtl_ephy_init(ioaddr, e_info_8168e_2, ARRAY_SIZE(e_info_8168e_2));
 
-	rtl_tx_performance_tweak(pdev, 0x5 << MAX_READ_REQUEST_SHIFT);
+	if (tp->dev->mtu <= ETH_DATA_LEN)
+		rtl_tx_performance_tweak(pdev, 0x5 << MAX_READ_REQUEST_SHIFT);
 
 	rtl_eri_write(ioaddr, 0xc0, ERIAR_MASK_0011, 0x0000, ERIAR_EXGMAC);
 	rtl_eri_write(ioaddr, 0xb8, ERIAR_MASK_0011, 0x0000, ERIAR_EXGMAC);
@@ -5787,8 +5794,6 @@ static int rtl_rx(struct net_device *dev, struct rtl8169_private *tp, u32 budget
 			    !(status & (RxRWT | RxFOVF)) &&
 			    (dev->features & NETIF_F_RXALL))
 				goto process_pkt;
-
-			rtl8169_mark_to_asic(desc, rx_buf_sz);
 		} else {
 			struct sk_buff *skb;
 			dma_addr_t addr;
@@ -5809,16 +5814,14 @@ process_pkt:
 			if (unlikely(rtl8169_fragmented_frame(status))) {
 				dev->stats.rx_dropped++;
 				dev->stats.rx_length_errors++;
-				rtl8169_mark_to_asic(desc, rx_buf_sz);
-				continue;
+				goto release_descriptor;
 			}
 
 			skb = rtl8169_try_rx_copy(tp->Rx_databuff[entry],
 						  tp, pkt_size, addr);
-			rtl8169_mark_to_asic(desc, rx_buf_sz);
 			if (!skb) {
 				dev->stats.rx_dropped++;
-				continue;
+				goto release_descriptor;
 			}
 
 			rtl8169_rx_csum(skb, status);
@@ -5834,6 +5837,10 @@ process_pkt:
 			tp->rx_stats.bytes += pkt_size;
 			u64_stats_update_end(&tp->rx_stats.syncp);
 		}
+release_descriptor:
+		desc->opts2 = 0;
+		wmb();
+		rtl8169_mark_to_asic(desc, rx_buf_sz);
 	}
 
 	count = cur_rx - tp->cur_rx;
diff --git a/drivers/net/ethernet/sfc/mcdi.c b/drivers/net/ethernet/sfc/mcdi.c
index eb85217..192026f 100644
--- a/drivers/net/ethernet/sfc/mcdi.c
+++ b/drivers/net/ethernet/sfc/mcdi.c
@@ -640,7 +640,7 @@ fail:
 int efx_mcdi_get_board_cfg(struct efx_nic *efx, u8 *mac_address,
 			   u16 *fw_subtype_list, u32 *capabilities)
 {
-	uint8_t outbuf[MC_CMD_GET_BOARD_CFG_OUT_LENMIN];
+	uint8_t outbuf[MC_CMD_GET_BOARD_CFG_OUT_LENMAX];
 	size_t outlen, offset, i;
 	int port_num = efx_port_num(efx);
 	int rc;
diff --git a/drivers/net/ethernet/tile/tilegx.c b/drivers/net/ethernet/tile/tilegx.c
index 83b4b38..c93004a 100644
--- a/drivers/net/ethernet/tile/tilegx.c
+++ b/drivers/net/ethernet/tile/tilegx.c
@@ -927,7 +927,7 @@ static int tile_net_setup_interrupts(struct net_device *dev)
 		if (info->has_iqueue) {
 			gxio_mpipe_request_notif_ring_interrupt(
 				&context, cpu_x(cpu), cpu_y(cpu),
-				1, ingress_irq, info->iqueue.ring);
+				KERNEL_PL, ingress_irq, info->iqueue.ring);
 		}
 	}
 
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 666fc20..0bec603 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -204,7 +204,8 @@ static rx_handler_result_t macvlan_handle_frame(struct sk_buff **pskb)
 	}
 
 	if (port->passthru)
-		vlan = list_first_entry(&port->vlans, struct macvlan_dev, list);
+		vlan = list_first_or_null_rcu(&port->vlans,
+					      struct macvlan_dev, list);
 	else
 		vlan = macvlan_hash_lookup(port, eth->h_dest);
 	if (vlan == NULL)
@@ -771,7 +772,7 @@ int macvlan_common_newlink(struct net *src_net, struct net_device *dev,
 	if (err < 0)
 		goto destroy_port;
 
-	list_add_tail(&vlan->list, &port->vlans);
+	list_add_tail_rcu(&vlan->list, &port->vlans);
 	netif_stacked_transfer_operstate(lowerdev, dev);
 
 	return 0;
@@ -797,7 +798,7 @@ void macvlan_dellink(struct net_device *dev, struct list_head *head)
 {
 	struct macvlan_dev *vlan = netdev_priv(dev);
 
-	list_del(&vlan->list);
+	list_del_rcu(&vlan->list);
 	unregister_netdevice_queue(dev, head);
 }
 EXPORT_SYMBOL_GPL(macvlan_dellink);
diff --git a/drivers/net/usb/cdc_ether.c b/drivers/net/usb/cdc_ether.c
index c4c593d..e7d4238 100644
--- a/drivers/net/usb/cdc_ether.c
+++ b/drivers/net/usb/cdc_ether.c
@@ -633,6 +633,13 @@ static const struct usb_device_id	products [] = {
 	.driver_info = 0,
 },
 
+/* Dell Wireless 5804 (Novatel E371) - handled by qmi_wwan */
+{
+	USB_DEVICE_AND_INTERFACE_INFO(DELL_VENDOR_ID, 0x819b, USB_CLASS_COMM,
+			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
+	.driver_info = 0,
+},
+
 /*
  * WHITELIST!!!
  *
diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index e064b1d..7589509 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -9,6 +9,7 @@
 #include <linux/module.h>
 #include <linux/netdevice.h>
 #include <linux/ethtool.h>
+#include <linux/etherdevice.h>
 #include <linux/mii.h>
 #include <linux/usb.h>
 #include <linux/usb/cdc.h>
@@ -174,6 +175,93 @@ err:
 	return status;
 }
 
+/* default ethernet address used by the modem */
+static const u8 default_modem_addr[ETH_ALEN] = {0x02, 0x50, 0xf3};
+
+/* Make up an ethernet header if the packet doesn't have one.
+ *
+ * A firmware bug common among several devices cause them to send raw
+ * IP packets under some circumstances.  There is no way for the
+ * driver/host to know when this will happen.  And even when the bug
+ * hits, some packets will still arrive with an intact header.
+ *
+ * The supported devices are only capably of sending IPv4, IPv6 and
+ * ARP packets on a point-to-point link. Any packet with an ethernet
+ * header will have either our address or a broadcast/multicast
+ * address as destination.  ARP packets will always have a header.
+ *
+ * This means that this function will reliably add the appropriate
+ * header iff necessary, provided our hardware address does not start
+ * with 4 or 6.
+ *
+ * Another common firmware bug results in all packets being addressed
+ * to 00:a0:c6:00:00:00 despite the host address being different.
+ * This function will also fixup such packets.
+ */
+static int qmi_wwan_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
+{
+	__be16 proto;
+
+	/* usbnet rx_complete guarantees that skb->len is at least
+	 * hard_header_len, so we can inspect the dest address without
+	 * checking skb->len
+	 */
+	switch (skb->data[0] & 0xf0) {
+	case 0x40:
+		proto = htons(ETH_P_IP);
+		break;
+	case 0x60:
+		proto = htons(ETH_P_IPV6);
+		break;
+	case 0x00:
+		if (is_multicast_ether_addr(skb->data))
+			return 1;
+		/* possibly bogus destination - rewrite just in case */
+		skb_reset_mac_header(skb);
+		goto fix_dest;
+	default:
+		/* pass along other packets without modifications */
+		return 1;
+	}
+	if (skb_headroom(skb) < ETH_HLEN)
+		return 0;
+	skb_push(skb, ETH_HLEN);
+	skb_reset_mac_header(skb);
+	eth_hdr(skb)->h_proto = proto;
+	memset(eth_hdr(skb)->h_source, 0, ETH_ALEN);
+fix_dest:
+	memcpy(eth_hdr(skb)->h_dest, dev->net->dev_addr, ETH_ALEN);
+	return 1;
+}
+
+/* very simplistic detection of IPv4 or IPv6 headers */
+static bool possibly_iphdr(const char *data)
+{
+	return (data[0] & 0xd0) == 0x40;
+}
+
+/* disallow addresses which may be confused with IP headers */
+static int qmi_wwan_mac_addr(struct net_device *dev, void *p)
+{
+	struct sockaddr *addr = p;
+
+	if (!is_valid_ether_addr(addr->sa_data) ||
+	    possibly_iphdr(addr->sa_data))
+		return -EADDRNOTAVAIL;
+	memcpy(dev->dev_addr, addr->sa_data, ETH_ALEN);
+	return 0;
+}
+
+static const struct net_device_ops qmi_wwan_netdev_ops = {
+	.ndo_open		= usbnet_open,
+	.ndo_stop		= usbnet_stop,
+	.ndo_start_xmit		= usbnet_start_xmit,
+	.ndo_tx_timeout		= usbnet_tx_timeout,
+	.ndo_change_mtu		= usbnet_change_mtu,
+	.ndo_set_mac_address	= qmi_wwan_mac_addr,
+	.ndo_validate_addr	= eth_validate_addr,
+};
+
 /* using a counter to merge subdriver requests with our own into a combined state */
 static int qmi_wwan_manage_power(struct usbnet *dev, int on)
 {
@@ -257,6 +345,18 @@ static int qmi_wwan_bind_shared(struct usbnet *dev, struct usb_interface *intf)
 	/* save subdriver struct for suspend/resume wrappers */
 	dev->data[0] = (unsigned long)subdriver;
 
+	/* Never use the same address on both ends of the link, even
+	 * if the buggy firmware told us to.
+	 */
+	if (!compare_ether_addr(dev->net->dev_addr, default_modem_addr))
+		eth_hw_addr_random(dev->net);
+
+	/* make MAC addr easily distinguishable from an IP header */
+	if (possibly_iphdr(dev->net->dev_addr)) {
+		dev->net->dev_addr[0] |= 0x02;	/* set local assignment bit */
+		dev->net->dev_addr[0] &= 0xbf;	/* clear "IP" bit */
+	}
+	dev->net->netdev_ops = &qmi_wwan_netdev_ops;
 err:
 	return rv;
 }
@@ -326,6 +426,7 @@ static const struct driver_info	qmi_wwan_shared = {
 	.bind		= qmi_wwan_bind_shared,
 	.unbind		= qmi_wwan_unbind_shared,
 	.manage_power	= qmi_wwan_manage_power,
+	.rx_fixup       = qmi_wwan_rx_fixup,
 };
 
 static const struct driver_info	qmi_wwan_force_int0 = {
@@ -607,6 +708,13 @@ static const struct usb_device_id products[] = {
 					      USB_CDC_PROTO_NONE),
 		.driver_info        = (unsigned long)&qmi_wwan_info,
 	},
+	{	/* Dell Wireless 5804 (Novatel E371) */
+		USB_DEVICE_AND_INTERFACE_INFO(0x413C, 0x819b,
+					      USB_CLASS_COMM,
+					      USB_CDC_SUBCLASS_ETHERNET,
+					      USB_CDC_PROTO_NONE),
+		.driver_info        = (unsigned long)&qmi_wwan_info,
+	},
 
 	/* Gobi 1000 devices */
 	{QMI_GOBI1K_DEVICE(0x05c6, 0x9212)},	/* Acer Gobi Modem Device */
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 68dd853..e8da084 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1722,6 +1722,7 @@ static int ath9k_sta_add(struct ieee80211_hw *hw,
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_node *an = (struct ath_node *) sta->drv_priv;
 	struct ieee80211_key_conf ps_key = { };
+	int key;
 
 	ath_node_attach(sc, sta, vif);
 
@@ -1729,7 +1730,9 @@ static int ath9k_sta_add(struct ieee80211_hw *hw,
 	    vif->type != NL80211_IFTYPE_AP_VLAN)
 		return 0;
 
-	an->ps_key = ath_key_config(common, vif, sta, &ps_key);
+	key = ath_key_config(common, vif, sta, &ps_key);
+	if (key > 0)
+		an->ps_key = key;
 
 	return 0;
 }
@@ -1746,6 +1749,7 @@ static void ath9k_del_ps_key(struct ath_softc *sc,
 	    return;
 
 	ath_key_delete(common, &ps_key);
+	an->ps_key = 0;
 }
 
 static int ath9k_sta_remove(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/b43/dma.c b/drivers/net/wireless/b43/dma.c
index 1221469..ee3d640 100644
--- a/drivers/net/wireless/b43/dma.c
+++ b/drivers/net/wireless/b43/dma.c
@@ -1733,6 +1733,25 @@ drop_recycle_buffer:
 	sync_descbuffer_for_device(ring, dmaaddr, ring->rx_buffersize);
 }
 
+void b43_dma_handle_rx_overflow(struct b43_dmaring *ring)
+{
+	int current_slot, previous_slot;
+
+	B43_WARN_ON(ring->tx);
+
+	/* Device has filled all buffers, drop all packets and let TCP
+	 * decrease speed.
+	 * Decrement RX index by one will let the device to see all slots
+	 * as free again
+	 */
+	/*
+	*TODO: How to increase rx_drop in mac80211?
+	*/
+	current_slot = ring->ops->get_current_rxslot(ring);
+	previous_slot = prev_slot(ring, current_slot);
+	ring->ops->set_current_rxslot(ring, previous_slot);
+}
+
 void b43_dma_rx(struct b43_dmaring *ring)
 {
 	const struct b43_dma_ops *ops = ring->ops;
diff --git a/drivers/net/wireless/b43/dma.h b/drivers/net/wireless/b43/dma.h
index 9fdd198..df8c8cd 100644
--- a/drivers/net/wireless/b43/dma.h
+++ b/drivers/net/wireless/b43/dma.h
@@ -9,7 +9,7 @@
 /* DMA-Interrupt reasons. */
 #define B43_DMAIRQ_FATALMASK	((1 << 10) | (1 << 11) | (1 << 12) \
 					 | (1 << 14) | (1 << 15))
-#define B43_DMAIRQ_NONFATALMASK	(1 << 13)
+#define B43_DMAIRQ_RDESC_UFLOW		(1 << 13)
 #define B43_DMAIRQ_RX_DONE		(1 << 16)
 
 /*** 32-bit DMA Engine. ***/
@@ -295,6 +295,8 @@ int b43_dma_tx(struct b43_wldev *dev,
 void b43_dma_handle_txstatus(struct b43_wldev *dev,
 			     const struct b43_txstatus *status);
 
+void b43_dma_handle_rx_overflow(struct b43_dmaring *ring);
+
 void b43_dma_rx(struct b43_dmaring *ring);
 
 void b43_dma_direct_fifo_rx(struct b43_wldev *dev,
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 12603b8..f8fd420 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -1895,30 +1895,18 @@ static void b43_do_interrupt_thread(struct b43_wldev *dev)
 		}
 	}
 
-	if (unlikely(merged_dma_reason & (B43_DMAIRQ_FATALMASK |
-					  B43_DMAIRQ_NONFATALMASK))) {
-		if (merged_dma_reason & B43_DMAIRQ_FATALMASK) {
-			b43err(dev->wl, "Fatal DMA error: "
-			       "0x%08X, 0x%08X, 0x%08X, "
-			       "0x%08X, 0x%08X, 0x%08X\n",
-			       dma_reason[0], dma_reason[1],
-			       dma_reason[2], dma_reason[3],
-			       dma_reason[4], dma_reason[5]);
-			b43err(dev->wl, "This device does not support DMA "
+	if (unlikely(merged_dma_reason & (B43_DMAIRQ_FATALMASK))) {
+		b43err(dev->wl,
+			"Fatal DMA error: 0x%08X, 0x%08X, 0x%08X, 0x%08X, 0x%08X, 0x%08X\n",
+			dma_reason[0], dma_reason[1],
+			dma_reason[2], dma_reason[3],
+			dma_reason[4], dma_reason[5]);
+		b43err(dev->wl, "This device does not support DMA "
 			       "on your system. It will now be switched to PIO.\n");
-			/* Fall back to PIO transfers if we get fatal DMA errors! */
-			dev->use_pio = true;
-			b43_controller_restart(dev, "DMA error");
-			return;
-		}
-		if (merged_dma_reason & B43_DMAIRQ_NONFATALMASK) {
-			b43err(dev->wl, "DMA error: "
-			       "0x%08X, 0x%08X, 0x%08X, "
-			       "0x%08X, 0x%08X, 0x%08X\n",
-			       dma_reason[0], dma_reason[1],
-			       dma_reason[2], dma_reason[3],
-			       dma_reason[4], dma_reason[5]);
-		}
+		/* Fall back to PIO transfers if we get fatal DMA errors! */
+		dev->use_pio = true;
+		b43_controller_restart(dev, "DMA error");
+		return;
 	}
 
 	if (unlikely(reason & B43_IRQ_UCODE_DEBUG))
@@ -1937,6 +1925,11 @@ static void b43_do_interrupt_thread(struct b43_wldev *dev)
 		handle_irq_noise(dev);
 
 	/* Check the DMA reason registers for received data. */
+	if (dma_reason[0] & B43_DMAIRQ_RDESC_UFLOW) {
+		if (B43_DEBUG)
+			b43warn(dev->wl, "RX descriptor underrun\n");
+		b43_dma_handle_rx_overflow(dev->dma.rx_ring);
+	}
 	if (dma_reason[0] & B43_DMAIRQ_RX_DONE) {
 		if (b43_using_pio_transfers(dev))
 			b43_pio_rx(dev->pio.rx_queue);
@@ -1994,7 +1987,7 @@ static irqreturn_t b43_do_interrupt(struct b43_wldev *dev)
 		return IRQ_NONE;
 
 	dev->dma_reason[0] = b43_read32(dev, B43_MMIO_DMA0_REASON)
-	    & 0x0001DC00;
+	    & 0x0001FC00;
 	dev->dma_reason[1] = b43_read32(dev, B43_MMIO_DMA1_REASON)
 	    & 0x0000DC00;
 	dev->dma_reason[2] = b43_read32(dev, B43_MMIO_DMA2_REASON)
@@ -3121,7 +3114,7 @@ static int b43_chip_init(struct b43_wldev *dev)
 		b43_write32(dev, 0x018C, 0x02000000);
 	}
 	b43_write32(dev, B43_MMIO_GEN_IRQ_REASON, 0x00004000);
-	b43_write32(dev, B43_MMIO_DMA0_IRQ_MASK, 0x0001DC00);
+	b43_write32(dev, B43_MMIO_DMA0_IRQ_MASK, 0x0001FC00);
 	b43_write32(dev, B43_MMIO_DMA1_IRQ_MASK, 0x0000DC00);
 	b43_write32(dev, B43_MMIO_DMA2_IRQ_MASK, 0x0000DC00);
 	b43_write32(dev, B43_MMIO_DMA3_IRQ_MASK, 0x0001DC00);
diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index 0c8a1c2..f482515 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -243,6 +243,7 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
 	{IWL_PCI_DEVICE(0x088F, 0x4260, iwl6035_2agn_cfg)},
 	{IWL_PCI_DEVICE(0x088E, 0x4460, iwl6035_2agn_cfg)},
 	{IWL_PCI_DEVICE(0x088E, 0x4860, iwl6035_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x088F, 0x5260, iwl6035_2agn_cfg)},
 
 /* 105 Series */
 	{IWL_PCI_DEVICE(0x0894, 0x0022, iwl105_bgn_cfg)},
diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index fc3b6f4..40b7f0e 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -1141,6 +1141,7 @@ mwifiex_process_hs_config(struct mwifiex_adapter *adapter)
 	adapter->if_ops.wakeup(adapter);
 	adapter->hs_activated = false;
 	adapter->is_hs_configured = false;
+	adapter->is_suspended = false;
 	mwifiex_hs_activated_event(mwifiex_get_priv(adapter,
 						    MWIFIEX_BSS_ROLE_ANY),
 				   false);
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index a5db9f1a..fc6ae9b 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -105,7 +105,7 @@ int mwifiex_request_set_multicast_list(struct mwifiex_private *priv,
 	} else {
 		/* Multicast */
 		priv->curr_pkt_filter &= ~HostCmd_ACT_MAC_PROMISCUOUS_ENABLE;
-		if (mcast_list->mode == MWIFIEX_MULTICAST_MODE) {
+		if (mcast_list->mode == MWIFIEX_ALL_MULTI_MODE) {
 			dev_dbg(priv->adapter->dev,
 				"info: Enabling All Multicast!\n");
 			priv->curr_pkt_filter |=
@@ -117,20 +117,11 @@ int mwifiex_request_set_multicast_list(struct mwifiex_private *priv,
 				dev_dbg(priv->adapter->dev,
 					"info: Set multicast list=%d\n",
 				       mcast_list->num_multicast_addr);
-				/* Set multicast addresses to firmware */
-				if (old_pkt_filter == priv->curr_pkt_filter) {
-					/* Send request to firmware */
-					ret = mwifiex_send_cmd_async(priv,
-						HostCmd_CMD_MAC_MULTICAST_ADR,
-						HostCmd_ACT_GEN_SET, 0,
-						mcast_list);
-				} else {
-					/* Send request to firmware */
-					ret = mwifiex_send_cmd_async(priv,
-						HostCmd_CMD_MAC_MULTICAST_ADR,
-						HostCmd_ACT_GEN_SET, 0,
-						mcast_list);
-				}
+				/* Send multicast addresses to firmware */
+				ret = mwifiex_send_cmd_async(priv,
+					HostCmd_CMD_MAC_MULTICAST_ADR,
+					HostCmd_ACT_GEN_SET, 0,
+					mcast_list);
 			}
 		}
 	}
diff --git a/drivers/platform/x86/hp_accel.c b/drivers/platform/x86/hp_accel.c
index 22b2dfa..fdacfce 100644
--- a/drivers/platform/x86/hp_accel.c
+++ b/drivers/platform/x86/hp_accel.c
@@ -362,7 +362,8 @@ static int lis3lv02d_suspend(struct acpi_device *device, pm_message_t state)
 
 static int lis3lv02d_resume(struct acpi_device *device)
 {
-	return lis3lv02d_poweron(&lis3_dev);
+	lis3lv02d_poweron(&lis3_dev);
+	return 0;
 }
 #else
 #define lis3lv02d_suspend NULL
diff --git a/drivers/rtc/rtc-pcf2123.c b/drivers/rtc/rtc-pcf2123.c
index 8361187..9ea2555 100644
--- a/drivers/rtc/rtc-pcf2123.c
+++ b/drivers/rtc/rtc-pcf2123.c
@@ -264,6 +264,7 @@ static int __devinit pcf2123_probe(struct spi_device *spi)
 
 	if (!(rxbuf[0] & 0x20)) {
 		dev_err(&spi->dev, "chip not found\n");
+		ret = -ENODEV;
 		goto kfree_exit;
 	}
 
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 043395d0..45518b7 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -141,6 +141,7 @@ sd_store_cache_type(struct device *dev, struct device_attribute *attr,
 	char *buffer_data;
 	struct scsi_mode_data data;
 	struct scsi_sense_hdr sshdr;
+	const char *temp = "temporary ";
 	int len;
 
 	if (sdp->type != TYPE_DISK)
@@ -149,6 +150,13 @@ sd_store_cache_type(struct device *dev, struct device_attribute *attr,
 		 * it's not worth the risk */
 		return -EINVAL;
 
+	if (strncmp(buf, temp, sizeof(temp) - 1) == 0) {
+		buf += sizeof(temp) - 1;
+		sdkp->cache_override = 1;
+	} else {
+		sdkp->cache_override = 0;
+	}
+
 	for (i = 0; i < ARRAY_SIZE(sd_cache_types); i++) {
 		len = strlen(sd_cache_types[i]);
 		if (strncmp(sd_cache_types[i], buf, len) == 0 &&
@@ -161,6 +169,13 @@ sd_store_cache_type(struct device *dev, struct device_attribute *attr,
 		return -EINVAL;
 	rcd = ct & 0x01 ? 1 : 0;
 	wce = ct & 0x02 ? 1 : 0;
+
+	if (sdkp->cache_override) {
+		sdkp->WCE = wce;
+		sdkp->RCD = rcd;
+		return count;
+	}
+
 	if (scsi_mode_sense(sdp, 0x08, 8, buffer, sizeof(buffer), SD_TIMEOUT,
 			    SD_MAX_RETRIES, &data, NULL))
 		return -EINVAL;
@@ -2127,6 +2142,10 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
 	int old_rcd = sdkp->RCD;
 	int old_dpofua = sdkp->DPOFUA;
 
+
+	if (sdkp->cache_override)
+		return;
+
 	first_len = 4;
 	if (sdp->skip_ms_page_8) {
 		if (sdp->type == TYPE_RBC)
@@ -2608,6 +2627,7 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
 	sdkp->capacity = 0;
 	sdkp->media_present = 1;
 	sdkp->write_prot = 0;
+	sdkp->cache_override = 0;
 	sdkp->WCE = 0;
 	sdkp->RCD = 0;
 	sdkp->ATO = 0;
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index f703f48..e2b2956 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -67,6 +67,7 @@ struct scsi_disk {
 	u8		protection_type;/* Data Integrity Field */
 	u8		provisioning_mode;
 	unsigned	ATO : 1;	/* state of disk ATO bit */
+	unsigned	cache_override : 1; /* temp override of WCE,RCD */
 	unsigned	WCE : 1;	/* state of disk WCE bit */
 	unsigned	RCD : 1;	/* state of disk RCD bit, unused */
 	unsigned	DPOFUA : 1;	/* state of disk DPOFUA bit */
diff --git a/drivers/target/iscsi/iscsi_target_erl1.c b/drivers/target/iscsi/iscsi_target_erl1.c
index ecdd46d..0f49a97 100644
--- a/drivers/target/iscsi/iscsi_target_erl1.c
+++ b/drivers/target/iscsi/iscsi_target_erl1.c
@@ -819,7 +819,7 @@ static int iscsit_attach_ooo_cmdsn(
 		/*
 		 * CmdSN is greater than the tail of the list.
 		 */
-		if (ooo_tail->cmdsn < ooo_cmdsn->cmdsn)
+		if (iscsi_sna_lt(ooo_tail->cmdsn, ooo_cmdsn->cmdsn))
 			list_add_tail(&ooo_cmdsn->ooo_list,
 					&sess->sess_ooo_cmdsn_list);
 		else {
@@ -829,11 +829,12 @@ static int iscsit_attach_ooo_cmdsn(
 			 */
 			list_for_each_entry(ooo_tmp, &sess->sess_ooo_cmdsn_list,
 						ooo_list) {
-				if (ooo_tmp->cmdsn < ooo_cmdsn->cmdsn)
+				if (iscsi_sna_lt(ooo_tmp->cmdsn, ooo_cmdsn->cmdsn))
 					continue;
 
+				/* Insert before this entry */
 				list_add(&ooo_cmdsn->ooo_list,
-					&ooo_tmp->ooo_list);
+					ooo_tmp->ooo_list.prev);
 				break;
 			}
 		}
diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 848d0bc..8d0b1e8 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2459,14 +2459,21 @@ static int handle_tx_event(struct xhci_hcd *xhci,
 		 * TD list.
 		 */
 		if (list_empty(&ep_ring->td_list)) {
-			xhci_warn(xhci, "WARN Event TRB for slot %d ep %d "
-					"with no TDs queued?\n",
-				  TRB_TO_SLOT_ID(le32_to_cpu(event->flags)),
-				  ep_index);
-			xhci_dbg(xhci, "Event TRB with TRB type ID %u\n",
-				 (le32_to_cpu(event->flags) &
-				  TRB_TYPE_BITMASK)>>10);
-			xhci_print_trb_offsets(xhci, (union xhci_trb *) event);
+			/*
+			 * A stopped endpoint may generate an extra completion
+			 * event if the device was suspended.  Don't print
+			 * warnings.
+			 */
+			if (!(trb_comp_code == COMP_STOP ||
+						trb_comp_code == COMP_STOP_INVAL)) {
+				xhci_warn(xhci, "WARN Event TRB for slot %d ep %d with no TDs queued?\n",
+						TRB_TO_SLOT_ID(le32_to_cpu(event->flags)),
+						ep_index);
+				xhci_dbg(xhci, "Event TRB with TRB type ID %u\n",
+						(le32_to_cpu(event->flags) &
+						 TRB_TYPE_BITMASK)>>10);
+				xhci_print_trb_offsets(xhci, (union xhci_trb *) event);
+			}
 			if (ep->skip) {
 				ep->skip = false;
 				xhci_dbg(xhci, "td_list is empty while skip "
diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index 18ded2d..a01317c 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -1228,6 +1228,8 @@ static void fbcon_deinit(struct vc_data *vc)
 finished:
 
 	fbcon_free_font(p, free_font);
+	if (free_font)
+		vc->vc_font.data = NULL;
 
 	if (!con_is_bound(&fb_con))
 		fbcon_exit();
diff --git a/drivers/watchdog/watchdog_dev.c b/drivers/watchdog/watchdog_dev.c
index ef8edec..05a5310 100644
--- a/drivers/watchdog/watchdog_dev.c
+++ b/drivers/watchdog/watchdog_dev.c
@@ -524,6 +524,7 @@ int watchdog_dev_register(struct watchdog_device *watchdog)
 	int err, devno;
 
 	if (watchdog->id == 0) {
+		old_wdd = watchdog;
 		watchdog_miscdev.parent = watchdog->parent;
 		err = misc_register(&watchdog_miscdev);
 		if (err != 0) {
@@ -532,9 +533,9 @@ int watchdog_dev_register(struct watchdog_device *watchdog)
 			if (err == -EBUSY)
 				pr_err("%s: a legacy watchdog module is probably present.\n",
 					watchdog->info->identity);
+			old_wdd = NULL;
 			return err;
 		}
-		old_wdd = watchdog;
 	}
 
 	/* Fill in the data structures */
diff --git a/fs/autofs4/expire.c b/fs/autofs4/expire.c
index 1feb68e..b1cdb0a 100644
--- a/fs/autofs4/expire.c
+++ b/fs/autofs4/expire.c
@@ -61,15 +61,6 @@ static int autofs4_mount_busy(struct vfsmount *mnt, struct dentry *dentry)
 		/* This is an autofs submount, we can't expire it */
 		if (autofs_type_indirect(sbi->type))
 			goto done;
-
-		/*
-		 * Otherwise it's an offset mount and we need to check
-		 * if we can umount its mount, if there is one.
-		 */
-		if (!d_mountpoint(path.dentry)) {
-			status = 0;
-			goto done;
-		}
 	}
 
 	/* Update the expiry counter if fs is busy */
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 9777e2f..4986dd3 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1980,7 +1980,11 @@ repeat:
 		group = ac->ac_g_ex.fe_group;
 
 		for (i = 0; i < ngroups; group++, i++) {
-			if (group == ngroups)
+			/*
+			 * Artificially restricted ngroups for non-extent
+			 * files makes group > ngroups possible on first loop.
+			 */
+			if (group >= ngroups)
 				group = 0;
 
 			/* This now checks without needing the buddy page */
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 097a7b0..d0ba1a9 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1680,6 +1680,10 @@ int ext4_resize_fs(struct super_block *sb, ext4_fsblk_t n_blocks_count)
 		return 0;
 
 	ext4_get_group_no_and_offset(sb, n_blocks_count - 1, &n_group, &offset);
+	if (n_group > (0xFFFFFFFFUL / EXT4_INODES_PER_GROUP(sb))) {
+		ext4_warning(sb, "resize would cause inodes_count overflow");
+		return -EINVAL;
+	}
 	ext4_get_group_no_and_offset(sb, o_blocks_count - 1, &o_group, &offset);
 
 	n_desc_blocks = (n_group + EXT4_DESC_PER_BLOCK(sb)) /
diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index cc9281b..c24fe37 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -927,9 +927,13 @@ static int can_do_hugetlb_shm(void)
 	return capable(CAP_IPC_LOCK) || in_group_p(sysctl_hugetlb_shm_group);
 }
 
-struct file *hugetlb_file_setup(const char *name, unsigned long addr,
-				size_t size, vm_flags_t acctflag,
-				struct user_struct **user, int creat_flags)
+/*
+ * Note that size should be aligned to proper hugepage size in caller side,
+ * otherwise hugetlb_reserve_pages reserves one less hugepages than intended.
+ */
+struct file *hugetlb_file_setup(const char *name, size_t size,
+				vm_flags_t acctflag, struct user_struct **user,
+				int creat_flags)
 {
 	int error = -ENOMEM;
 	struct file *file;
@@ -937,8 +941,6 @@ struct file *hugetlb_file_setup(const char *name, unsigned long addr,
 	struct path path;
 	struct dentry *root;
 	struct qstr quick_string;
-	struct hstate *hstate;
-	unsigned long num_pages;
 
 	*user = NULL;
 	if (!hugetlbfs_vfsmount)
@@ -972,12 +974,10 @@ struct file *hugetlb_file_setup(const char *name, unsigned long addr,
 	if (!inode)
 		goto out_dentry;
 
-	hstate = hstate_inode(inode);
-	size += addr & ~huge_page_mask(hstate);
-	num_pages = ALIGN(size, huge_page_size(hstate)) >>
-			huge_page_shift(hstate);
 	error = -ENOMEM;
-	if (hugetlb_reserve_pages(inode, 0, num_pages, NULL, acctflag))
+	if (hugetlb_reserve_pages(inode, 0,
+			size >> huge_page_shift(hstate_inode(inode)), NULL,
+			acctflag))
 		goto out_inode;
 
 	d_instantiate(path.dentry, inode);
diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index dd0308d..372eece 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -270,6 +270,7 @@ static __be32
 do_open_fhandle(struct svc_rqst *rqstp, struct svc_fh *current_fh, struct nfsd4_open *open)
 {
 	__be32 status;
+	int accmode = 0;
 
 	/* We don't know the target directory, and therefore can not
 	* set the change info
@@ -283,9 +284,19 @@ do_open_fhandle(struct svc_rqst *rqstp, struct svc_fh *current_fh, struct nfsd4_
 
 	open->op_truncate = (open->op_iattr.ia_valid & ATTR_SIZE) &&
 		(open->op_iattr.ia_size == 0);
+	/*
+	 * In the delegation case, the client is telling us about an
+	 * open that it *already* performed locally, some time ago.  We
+	 * should let it succeed now if possible.
+	 *
+	 * In the case of a CLAIM_FH open, on the other hand, the client
+	 * may be counting on us to enforce permissions (the Linux 4.1
+	 * client uses this for normal opens, for example).
+	 */
+	if (open->op_claim_type == NFS4_OPEN_CLAIM_DELEG_CUR_FH)
+		accmode = NFSD_MAY_OWNER_OVERRIDE;
 
-	status = do_open_permission(rqstp, current_fh, open,
-				    NFSD_MAY_OWNER_OVERRIDE);
+	status = do_open_permission(rqstp, current_fh, open, accmode);
 
 	return status;
 }
@@ -893,14 +904,14 @@ nfsd4_write(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 
 	nfs4_lock_state();
 	status = nfs4_preprocess_stateid_op(cstate, stateid, WR_STATE, &filp);
-	if (filp)
-		get_file(filp);
-	nfs4_unlock_state();
-
 	if (status) {
+		nfs4_unlock_state();
 		dprintk("NFSD: nfsd4_write: couldn't process stateid!\n");
 		return status;
 	}
+	if (filp)
+		get_file(filp);
+	nfs4_unlock_state();
 
 	cnt = write->wr_buflen;
 	write->wr_how_written = write->wr_stable_how;
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index c4daf96..718338f 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -214,13 +214,7 @@ static void __nfs4_file_put_access(struct nfs4_file *fp, int oflag)
 {
 	if (atomic_dec_and_test(&fp->fi_access[oflag])) {
 		nfs4_file_put_fd(fp, oflag);
-		/*
-		 * It's also safe to get rid of the RDWR open *if*
-		 * we no longer have need of the other kind of access
-		 * or if we already have the other kind of open:
-		 */
-		if (fp->fi_fds[1-oflag]
-			|| atomic_read(&fp->fi_access[1 - oflag]) == 0)
+		if (atomic_read(&fp->fi_access[1 - oflag]) == 0)
 			nfs4_file_put_fd(fp, O_RDWR);
 	}
 }
diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 4684514..b2ae2da 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -343,10 +343,7 @@ nfsd4_decode_fattr(struct nfsd4_compoundargs *argp, u32 *bmval,
 			   all 32 bits of 'nseconds'. */
 			READ_BUF(12);
 			len += 12;
-			READ32(dummy32);
-			if (dummy32)
-				return nfserr_inval;
-			READ32(iattr->ia_atime.tv_sec);
+			READ64(iattr->ia_atime.tv_sec);
 			READ32(iattr->ia_atime.tv_nsec);
 			if (iattr->ia_atime.tv_nsec >= (u32)1000000000)
 				return nfserr_inval;
@@ -369,10 +366,7 @@ nfsd4_decode_fattr(struct nfsd4_compoundargs *argp, u32 *bmval,
 			   all 32 bits of 'nseconds'. */
 			READ_BUF(12);
 			len += 12;
-			READ32(dummy32);
-			if (dummy32)
-				return nfserr_inval;
-			READ32(iattr->ia_mtime.tv_sec);
+			READ64(iattr->ia_mtime.tv_sec);
 			READ32(iattr->ia_mtime.tv_nsec);
 			if (iattr->ia_mtime.tv_nsec >= (u32)1000000000)
 				return nfserr_inval;
@@ -2397,8 +2391,7 @@ out_acl:
 	if (bmval1 & FATTR4_WORD1_TIME_ACCESS) {
 		if ((buflen -= 12) < 0)
 			goto out_resource;
-		WRITE32(0);
-		WRITE32(stat.atime.tv_sec);
+		WRITE64((s64)stat.atime.tv_sec);
 		WRITE32(stat.atime.tv_nsec);
 	}
 	if (bmval1 & FATTR4_WORD1_TIME_DELTA) {
@@ -2411,15 +2404,13 @@ out_acl:
 	if (bmval1 & FATTR4_WORD1_TIME_METADATA) {
 		if ((buflen -= 12) < 0)
 			goto out_resource;
-		WRITE32(0);
-		WRITE32(stat.ctime.tv_sec);
+		WRITE64((s64)stat.ctime.tv_sec);
 		WRITE32(stat.ctime.tv_nsec);
 	}
 	if (bmval1 & FATTR4_WORD1_TIME_MODIFY) {
 		if ((buflen -= 12) < 0)
 			goto out_resource;
-		WRITE32(0);
-		WRITE32(stat.mtime.tv_sec);
+		WRITE64((s64)stat.mtime.tv_sec);
 		WRITE32(stat.mtime.tv_nsec);
 	}
 	if (bmval1 & FATTR4_WORD1_MOUNTED_ON_FILEID) {
diff --git a/include/drm/drmP.h b/include/drm/drmP.h
index 31ad880..29942fe 100644
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -1566,9 +1566,8 @@ extern void drm_prime_gem_destroy(struct drm_gem_object *obj, struct sg_table *s
 
 void drm_prime_init_file_private(struct drm_prime_file_private *prime_fpriv);
 void drm_prime_destroy_file_private(struct drm_prime_file_private *prime_fpriv);
-int drm_prime_add_imported_buf_handle(struct drm_prime_file_private *prime_fpriv, struct dma_buf *dma_buf, uint32_t handle);
-int drm_prime_lookup_imported_buf_handle(struct drm_prime_file_private *prime_fpriv, struct dma_buf *dma_buf, uint32_t *handle);
-void drm_prime_remove_imported_buf_handle(struct drm_prime_file_private *prime_fpriv, struct dma_buf *dma_buf);
+int drm_prime_lookup_buf_handle(struct drm_prime_file_private *prime_fpriv, struct dma_buf *dma_buf, uint32_t *handle);
+void drm_prime_remove_buf_handle(struct drm_prime_file_private *prime_fpriv, struct dma_buf *dma_buf);
 
 int drm_prime_add_dma_buf(struct drm_device *dev, struct drm_gem_object *obj);
 int drm_prime_lookup_obj(struct drm_device *dev, struct dma_buf *buf,
diff --git a/include/drm/drm_pciids.h b/include/drm/drm_pciids.h
index 1b7557a..56650b7 100644
--- a/include/drm/drm_pciids.h
+++ b/include/drm/drm_pciids.h
@@ -227,6 +227,7 @@
 	{0x1002, 0x6819, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_PITCAIRN|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6820, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_VERDE|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6821, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_VERDE|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP}, \
+	{0x1002, 0x6822, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_VERDE|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6823, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_VERDE|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6824, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_VERDE|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6825, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_VERDE|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP}, \
@@ -234,11 +235,13 @@
 	{0x1002, 0x6827, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_VERDE|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6828, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_VERDE|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6829, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_VERDE|RADEON_NEW_MEMMAP}, \
+	{0x1002, 0x682A, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_VERDE|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x682B, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_VERDE|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x682D, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_VERDE|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x682F, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_VERDE|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6830, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_VERDE|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6831, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_VERDE|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP}, \
+	{0x1002, 0x6835, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_VERDE|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6837, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_VERDE|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6838, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_VERDE|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6839, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_VERDE|RADEON_NEW_MEMMAP}, \
@@ -590,6 +593,8 @@
 	{0x1002, 0x9999, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ARUBA|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
 	{0x1002, 0x999A, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ARUBA|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
 	{0x1002, 0x999B, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ARUBA|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
+	{0x1002, 0x999C, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ARUBA|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
+	{0x1002, 0x999D, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ARUBA|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
 	{0x1002, 0x99A0, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ARUBA|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
 	{0x1002, 0x99A2, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ARUBA|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
 	{0x1002, 0x99A4, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_ARUBA|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
diff --git a/include/linux/audit.h b/include/linux/audit.h
index eaa7c9f..41b4e49 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -481,7 +481,7 @@ static inline void audit_syscall_entry(int arch, int major, unsigned long a0,
 				       unsigned long a1, unsigned long a2,
 				       unsigned long a3)
 {
-	if (unlikely(!audit_dummy_context()))
+	if (unlikely(current->audit_context))
 		__audit_syscall_entry(arch, major, a0, a1, a2, a3);
 }
 static inline void audit_syscall_exit(void *pt_regs)
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index d5d6bbe..b8cdad6 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -152,8 +152,7 @@ static inline struct hugetlbfs_sb_info *HUGETLBFS_SB(struct super_block *sb)
 
 extern const struct file_operations hugetlbfs_file_operations;
 extern const struct vm_operations_struct hugetlb_vm_ops;
-struct file *hugetlb_file_setup(const char *name, unsigned long addr,
-				size_t size, vm_flags_t acct,
+struct file *hugetlb_file_setup(const char *name, size_t size, vm_flags_t acct,
 				struct user_struct **user, int creat_flags);
 
 static inline int is_file_hugepages(struct file *file)
@@ -170,8 +169,8 @@ static inline int is_file_hugepages(struct file *file)
 
 #define is_file_hugepages(file)			0
 static inline struct file *
-hugetlb_file_setup(const char *name, unsigned long addr, size_t size,
-		vm_flags_t acctflag, struct user_struct **user, int creat_flags)
+hugetlb_file_setup(const char *name, size_t size, vm_flags_t acctflag,
+		struct user_struct **user, int creat_flags)
 {
 	return ERR_PTR(-ENOSYS);
 }
@@ -302,7 +301,7 @@ static inline unsigned hstate_index_to_shift(unsigned index)
 	return hstates[index].order + PAGE_SHIFT;
 }
 
-#else
+#else	/* CONFIG_HUGETLB_PAGE */
 struct hstate {};
 #define alloc_huge_page_node(h, nid) NULL
 #define alloc_bootmem_huge_page(h) NULL
diff --git a/include/linux/if_cablemodem.h b/include/linux/if_cablemodem.h
index 9ca1007..ee6b3c4 100644
--- a/include/linux/if_cablemodem.h
+++ b/include/linux/if_cablemodem.h
@@ -12,11 +12,11 @@
  */
 
 /* some useful defines for sb1000.c e cmconfig.c - fv */
-#define SIOCGCMSTATS		SIOCDEVPRIVATE+0	/* get cable modem stats */
-#define SIOCGCMFIRMWARE		SIOCDEVPRIVATE+1	/* get cm firmware version */
-#define SIOCGCMFREQUENCY	SIOCDEVPRIVATE+2	/* get cable modem frequency */
-#define SIOCSCMFREQUENCY	SIOCDEVPRIVATE+3	/* set cable modem frequency */
-#define SIOCGCMPIDS			SIOCDEVPRIVATE+4	/* get cable modem PIDs */
-#define SIOCSCMPIDS			SIOCDEVPRIVATE+5	/* set cable modem PIDs */
+#define SIOCGCMSTATS		(SIOCDEVPRIVATE+0)	/* get cable modem stats */
+#define SIOCGCMFIRMWARE		(SIOCDEVPRIVATE+1)	/* get cm firmware version */
+#define SIOCGCMFREQUENCY	(SIOCDEVPRIVATE+2)	/* get cable modem frequency */
+#define SIOCSCMFREQUENCY	(SIOCDEVPRIVATE+3)	/* set cable modem frequency */
+#define SIOCGCMPIDS			(SIOCDEVPRIVATE+4)	/* get cable modem PIDs */
+#define SIOCSCMPIDS			(SIOCDEVPRIVATE+5)	/* set cable modem PIDs */
 
 #endif
diff --git a/include/net/sock.h b/include/net/sock.h
index 5e904e6..2a3d405 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -807,6 +807,18 @@ struct inet_hashinfo;
 struct raw_hashinfo;
 struct module;
 
+/*
+ * caches using SLAB_DESTROY_BY_RCU should let .next pointer from nulls nodes
+ * un-modified. Special care is taken when initializing object to zero.
+ */
+static inline void sk_prot_clear_nulls(struct sock *sk, int size)
+{
+	if (offsetof(struct sock, sk_node.next) != 0)
+		memset(sk, 0, offsetof(struct sock, sk_node.next));
+	memset(&sk->sk_node.pprev, 0,
+	       size - offsetof(struct sock, sk_node.pprev));
+}
+
 /* Networking protocol blocks we attach to sockets.
  * socket layer -> transport layer interface
  * transport -> network interface is defined by struct inet_proto
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 851f8fa..4857dce 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -982,6 +982,7 @@ static inline bool tcp_prequeue(struct sock *sk, struct sk_buff *skb)
 	if (sysctl_tcp_low_latency || !tp->ucopy.task)
 		return false;
 
+	skb_dst_force(skb);
 	__skb_queue_tail(&tp->ucopy.prequeue, skb);
 	tp->ucopy.memory += skb->truesize;
 	if (tp->ucopy.memory > sk->sk_rcvbuf) {
diff --git a/ipc/shm.c b/ipc/shm.c
index f5ba6ac..54e17db 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -491,10 +491,12 @@ static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
 
 	sprintf (name, "SYSV%08x", key);
 	if (shmflg & SHM_HUGETLB) {
+		size_t hugesize = ALIGN(size, huge_page_size(&default_hstate));
+
 		/* hugetlb_file_setup applies strict accounting */
 		if (shmflg & SHM_NORESERVE)
 			acctflag = VM_NORESERVE;
-		file = hugetlb_file_setup(name, 0, size, acctflag,
+		file = hugetlb_file_setup(name, hugesize, acctflag,
 					&shp->mlock_user, HUGETLB_SHMFS_INODE);
 	} else {
 		/*
diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
index 31fdc48..0caf1f8 100644
--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@ -608,9 +608,9 @@ void audit_trim_trees(void)
 		}
 		spin_unlock(&hash_lock);
 		trim_marked(tree);
-		put_tree(tree);
 		drop_collected_mounts(root_mnt);
 skip_it:
+		put_tree(tree);
 		mutex_lock(&audit_filter_mutex);
 	}
 	list_del(&cursor);
diff --git a/kernel/kmod.c b/kernel/kmod.c
index ff2c7cb..cc76ad6 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -541,6 +541,11 @@ int call_usermodehelper_exec(struct subprocess_info *sub_info, int wait)
 	int retval = 0;
 
 	helper_lock();
+	if (!sub_info->path) {
+		retval = -EINVAL;
+		goto out;
+	}
+
 	if (sub_info->path[0] == '\0')
 		goto out;
 
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index cc1825f..5d969d8 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -889,7 +889,7 @@ void tick_cancel_sched_timer(int cpu)
 		hrtimer_cancel(&ts->sched_timer);
 # endif
 
-	ts->nohz_mode = NOHZ_MODE_INACTIVE;
+	memset(ts, 0, sizeof(*ts));
 }
 #endif
 
diff --git a/kernel/timer.c b/kernel/timer.c
index ad4ced1..742912b 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1688,12 +1688,12 @@ static int __cpuinit init_timers_cpu(int cpu)
 			boot_done = 1;
 			base = &boot_tvec_bases;
 		}
+		spin_lock_init(&base->lock);
 		tvec_base_done[cpu] = 1;
 	} else {
 		base = per_cpu(tvec_bases, cpu);
 	}
 
-	spin_lock_init(&base->lock);
 
 	for (j = 0; j < TVN_SIZE; j++) {
 		INIT_LIST_HEAD(base->tv5.vec + j);
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 431dba8..289197a 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -777,7 +777,11 @@ static int filter_set_pred(struct event_filter *filter,
 
 static void __free_preds(struct event_filter *filter)
 {
+	int i;
+
 	if (filter->preds) {
+		for (i = 0; i < filter->n_preds; i++)
+			kfree(filter->preds[i].ops);
 		kfree(filter->preds);
 		filter->preds = NULL;
 	}
diff --git a/mm/mmap.c b/mm/mmap.c
index 76b70c9..f1a9a72 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1116,15 +1116,19 @@ SYSCALL_DEFINE6(mmap_pgoff, unsigned long, addr, unsigned long, len,
 		file = fget(fd);
 		if (!file)
 			goto out;
+		if (is_file_hugepages(file))
+			len = ALIGN(len, huge_page_size(hstate_file(file)));
 	} else if (flags & MAP_HUGETLB) {
 		struct user_struct *user = NULL;
+
+		len = ALIGN(len, huge_page_size(&default_hstate));
 		/*
 		 * VM_NORESERVE is used because the reservations will be
 		 * taken when vm_ops->mmap() is called
 		 * A dummy user value is used because we are not locking
 		 * memory so no accounting is necessary
 		 */
-		file = hugetlb_file_setup(HUGETLB_ANON_FILE, addr, len,
+		file = hugetlb_file_setup(HUGETLB_ANON_FILE, len,
 						VM_NORESERVE, &user,
 						HUGETLB_ANONHUGE_INODE);
 		if (IS_ERR(file))
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index da1bc9c..7005e08 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -598,7 +598,7 @@ static netdev_features_t vlan_dev_fix_features(struct net_device *dev,
 	netdev_features_t features)
 {
 	struct net_device *real_dev = vlan_dev_priv(dev)->real_dev;
-	u32 old_features = features;
+	netdev_features_t old_features = features;
 
 	features &= real_dev->vlan_features;
 	features |= NETIF_F_RXCSUM;
diff --git a/net/bridge/br_stp_timer.c b/net/bridge/br_stp_timer.c
index a6747e6..acc63a4 100644
--- a/net/bridge/br_stp_timer.c
+++ b/net/bridge/br_stp_timer.c
@@ -107,7 +107,7 @@ static void br_tcn_timer_expired(unsigned long arg)
 
 	br_debug(br, "tcn timer expired\n");
 	spin_lock(&br->lock);
-	if (br->dev->flags & IFF_UP) {
+	if (!br_is_root_bridge(br) && (br->dev->flags & IFF_UP)) {
 		br_transmit_tcn(br);
 
 		mod_timer(&br->tcn_timer,jiffies + br->bridge_hello_time);
diff --git a/net/core/dev.c b/net/core/dev.c
index ba9d7a7..a0eaa60 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2168,7 +2168,7 @@ EXPORT_SYMBOL(netif_skb_features);
  *	   support DMA from it.
  */
 static inline int skb_needs_linearize(struct sk_buff *skb,
-				      int features)
+				      netdev_features_t features)
 {
 	return skb_is_nonlinear(skb) &&
 			((skb_has_frag_list(skb) &&
diff --git a/net/core/ethtool.c b/net/core/ethtool.c
index 9c2afb4..86253eb 100644
--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -1384,7 +1384,7 @@ int dev_ethtool(struct net *net, struct ifreq *ifr)
 	void __user *useraddr = ifr->ifr_data;
 	u32 ethcmd;
 	int rc;
-	u32 old_features;
+	netdev_features_t old_features;
 
 	if (!dev || !netif_device_present(dev))
 		return -ENODEV;
diff --git a/net/core/sock.c b/net/core/sock.c
index 5d30122..457ae99 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1085,18 +1085,6 @@ static void sock_copy(struct sock *nsk, const struct sock *osk)
 #endif
 }
 
-/*
- * caches using SLAB_DESTROY_BY_RCU should let .next pointer from nulls nodes
- * un-modified. Special care is taken when initializing object to zero.
- */
-static inline void sk_prot_clear_nulls(struct sock *sk, int size)
-{
-	if (offsetof(struct sock, sk_node.next) != 0)
-		memset(sk, 0, offsetof(struct sock, sk_node.next));
-	memset(&sk->sk_node.pprev, 0,
-	       size - offsetof(struct sock, sk_node.pprev));
-}
-
 void sk_prot_clear_portaddr_nulls(struct sock *sk, int size)
 {
 	unsigned long nulls1, nulls2;
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 5d10b81..989c024 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -2034,6 +2034,17 @@ void tcp6_proc_exit(struct net *net)
 }
 #endif
 
+static void tcp_v6_clear_sk(struct sock *sk, int size)
+{
+	struct inet_sock *inet = inet_sk(sk);
+
+	/* we do not want to clear pinet6 field, because of RCU lookups */
+	sk_prot_clear_nulls(sk, offsetof(struct inet_sock, pinet6));
+
+	size -= offsetof(struct inet_sock, pinet6) + sizeof(inet->pinet6);
+	memset(&inet->pinet6 + 1, 0, size);
+}
+
 struct proto tcpv6_prot = {
 	.name			= "TCPv6",
 	.owner			= THIS_MODULE,
@@ -2075,6 +2086,7 @@ struct proto tcpv6_prot = {
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
 	.proto_cgroup		= tcp_proto_cgroup,
 #endif
+	.clear_sk		= tcp_v6_clear_sk,
 };
 
 static const struct inet6_protocol tcpv6_protocol = {
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index f05099f..3a5491d 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1499,6 +1499,17 @@ void udp6_proc_exit(struct net *net) {
 }
 #endif /* CONFIG_PROC_FS */
 
+void udp_v6_clear_sk(struct sock *sk, int size)
+{
+	struct inet_sock *inet = inet_sk(sk);
+
+	/* we do not want to clear pinet6 field, because of RCU lookups */
+	sk_prot_clear_portaddr_nulls(sk, offsetof(struct inet_sock, pinet6));
+
+	size -= offsetof(struct inet_sock, pinet6) + sizeof(inet->pinet6);
+	memset(&inet->pinet6 + 1, 0, size);
+}
+
 /* ------------------------------------------------------------------------ */
 
 struct proto udpv6_prot = {
@@ -1529,7 +1540,7 @@ struct proto udpv6_prot = {
 	.compat_setsockopt = compat_udpv6_setsockopt,
 	.compat_getsockopt = compat_udpv6_getsockopt,
 #endif
-	.clear_sk	   = sk_prot_clear_portaddr_nulls,
+	.clear_sk	   = udp_v6_clear_sk,
 };
 
 static struct inet_protosw udpv6_protosw = {
diff --git a/net/ipv6/udp_impl.h b/net/ipv6/udp_impl.h
index d757104..4691ed5 100644
--- a/net/ipv6/udp_impl.h
+++ b/net/ipv6/udp_impl.h
@@ -31,6 +31,8 @@ extern int	udpv6_recvmsg(struct kiocb *iocb, struct sock *sk,
 extern int	udpv6_queue_rcv_skb(struct sock * sk, struct sk_buff *skb);
 extern void	udpv6_destroy_sock(struct sock *sk);
 
+extern void udp_v6_clear_sk(struct sock *sk, int size);
+
 #ifdef CONFIG_PROC_FS
 extern int	udp6_seq_show(struct seq_file *seq, void *v);
 #endif
diff --git a/net/ipv6/udplite.c b/net/ipv6/udplite.c
index 1d08e21..dfcc4be 100644
--- a/net/ipv6/udplite.c
+++ b/net/ipv6/udplite.c
@@ -56,7 +56,7 @@ struct proto udplitev6_prot = {
 	.compat_setsockopt = compat_udpv6_setsockopt,
 	.compat_getsockopt = compat_udpv6_getsockopt,
 #endif
-	.clear_sk	   = sk_prot_clear_portaddr_nulls,
+	.clear_sk	   = udp_v6_clear_sk,
 };
 
 static struct inet_protosw udplite6_protosw = {
diff --git a/net/ipv6/xfrm6_policy.c b/net/ipv6/xfrm6_policy.c
index 8625fba..1cfb9a4 100644
--- a/net/ipv6/xfrm6_policy.c
+++ b/net/ipv6/xfrm6_policy.c
@@ -96,8 +96,10 @@ static int xfrm6_fill_dst(struct xfrm_dst *xdst, struct net_device *dev,
 	dev_hold(dev);
 
 	xdst->u.rt6.rt6i_idev = in6_dev_get(dev);
-	if (!xdst->u.rt6.rt6i_idev)
+	if (!xdst->u.rt6.rt6i_idev) {
+		dev_put(dev);
 		return -ENODEV;
+	}
 
 	xdst->u.rt6.rt6i_peer = rt->rt6i_peer;
 	if (rt->rt6i_peer)
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 02b1ef8..4137d01 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -812,37 +812,33 @@ static void prb_open_block(struct tpacket_kbdq_core *pkc1,
 
 	smp_rmb();
 
-	if (likely(TP_STATUS_KERNEL == BLOCK_STATUS(pbd1))) {
+	/* We could have just memset this but we will lose the
+	 * flexibility of making the priv area sticky
+	 */
 
-		/* We could have just memset this but we will lose the
-		 * flexibility of making the priv area sticky
-		 */
-		BLOCK_SNUM(pbd1) = pkc1->knxt_seq_num++;
-		BLOCK_NUM_PKTS(pbd1) = 0;
-		BLOCK_LEN(pbd1) = BLK_PLUS_PRIV(pkc1->blk_sizeof_priv);
-		getnstimeofday(&ts);
-		h1->ts_first_pkt.ts_sec = ts.tv_sec;
-		h1->ts_first_pkt.ts_nsec = ts.tv_nsec;
-		pkc1->pkblk_start = (char *)pbd1;
-		pkc1->nxt_offset = (char *)(pkc1->pkblk_start +
-		BLK_PLUS_PRIV(pkc1->blk_sizeof_priv));
-		BLOCK_O2FP(pbd1) = (__u32)BLK_PLUS_PRIV(pkc1->blk_sizeof_priv);
-		BLOCK_O2PRIV(pbd1) = BLK_HDR_LEN;
-		pbd1->version = pkc1->version;
-		pkc1->prev = pkc1->nxt_offset;
-		pkc1->pkblk_end = pkc1->pkblk_start + pkc1->kblk_size;
-		prb_thaw_queue(pkc1);
-		_prb_refresh_rx_retire_blk_timer(pkc1);
+	BLOCK_SNUM(pbd1) = pkc1->knxt_seq_num++;
+	BLOCK_NUM_PKTS(pbd1) = 0;
+	BLOCK_LEN(pbd1) = BLK_PLUS_PRIV(pkc1->blk_sizeof_priv);
 
-		smp_wmb();
+	getnstimeofday(&ts);
 
-		return;
-	}
+	h1->ts_first_pkt.ts_sec = ts.tv_sec;
+	h1->ts_first_pkt.ts_nsec = ts.tv_nsec;
 
-	WARN(1, "ERROR block:%p is NOT FREE status:%d kactive_blk_num:%d\n",
-		pbd1, BLOCK_STATUS(pbd1), pkc1->kactive_blk_num);
-	dump_stack();
-	BUG();
+	pkc1->pkblk_start = (char *)pbd1;
+	pkc1->nxt_offset = pkc1->pkblk_start + BLK_PLUS_PRIV(pkc1->blk_sizeof_priv);
+
+	BLOCK_O2FP(pbd1) = (__u32)BLK_PLUS_PRIV(pkc1->blk_sizeof_priv);
+	BLOCK_O2PRIV(pbd1) = BLK_HDR_LEN;
+
+	pbd1->version = pkc1->version;
+	pkc1->prev = pkc1->nxt_offset;
+	pkc1->pkblk_end = pkc1->pkblk_start + pkc1->kblk_size;
+
+	prb_thaw_queue(pkc1);
+	_prb_refresh_rx_retire_blk_timer(pkc1);
+
+	smp_wmb();
 }
 
 /*
@@ -933,10 +929,6 @@ static void prb_retire_current_block(struct tpacket_kbdq_core *pkc,
 		prb_close_block(pkc, pbd, po, status);
 		return;
 	}
-
-	WARN(1, "ERROR-pbd[%d]:%p\n", pkc->kactive_blk_num, pbd);
-	dump_stack();
-	BUG();
 }
 
 static int prb_curr_blk_in_use(struct tpacket_kbdq_core *pkc,
diff --git a/net/sched/act_ipt.c b/net/sched/act_ipt.c
index 60e281a..bfba52f 100644
--- a/net/sched/act_ipt.c
+++ b/net/sched/act_ipt.c
@@ -8,7 +8,7 @@
  *		as published by the Free Software Foundation; either version
  *		2 of the License, or (at your option) any later version.
  *
- * Copyright:	Jamal Hadi Salim (2002-4)
+ * Copyright:	Jamal Hadi Salim (2002-13)
  */
 
 #include <linux/types.h>
@@ -300,17 +300,44 @@ static struct tc_action_ops act_ipt_ops = {
 	.walk		=	tcf_generic_walker
 };
 
-MODULE_AUTHOR("Jamal Hadi Salim(2002-4)");
+static struct tc_action_ops act_xt_ops = {
+	.kind		=	"xt",
+	.hinfo		=	&ipt_hash_info,
+	.type		=	TCA_ACT_IPT,
+	.capab		=	TCA_CAP_NONE,
+	.owner		=	THIS_MODULE,
+	.act		=	tcf_ipt,
+	.dump		=	tcf_ipt_dump,
+	.cleanup	=	tcf_ipt_cleanup,
+	.lookup		=	tcf_hash_search,
+	.init		=	tcf_ipt_init,
+	.walk		=	tcf_generic_walker
+};
+
+MODULE_AUTHOR("Jamal Hadi Salim(2002-13)");
 MODULE_DESCRIPTION("Iptables target actions");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("act_xt");
 
 static int __init ipt_init_module(void)
 {
-	return tcf_register_action(&act_ipt_ops);
+	int ret1, ret2;
+	ret1 = tcf_register_action(&act_xt_ops);
+	if (ret1 < 0)
+		printk("Failed to load xt action\n");
+	ret2 = tcf_register_action(&act_ipt_ops);
+	if (ret2 < 0)
+		printk("Failed to load ipt action\n");
+
+	if (ret1 < 0 && ret2 < 0)
+		return ret1;
+	else
+		return 0;
 }
 
 static void __exit ipt_cleanup_module(void)
 {
+	tcf_unregister_action(&act_xt_ops);
 	tcf_unregister_action(&act_ipt_ops);
 }
 
diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index e6b34c8..f33bb78 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -609,6 +609,9 @@ int snd_hda_queue_unsol_event(struct hda_bus *bus, u32 res, u32 res_ex)
 	struct hda_bus_unsolicited *unsol;
 	unsigned int wp;
 
+	if (!bus || !bus->workq)
+		return 0;
+
 	trace_hda_unsol_event(bus, res, res_ex);
 	unsol = bus->unsol;
 	if (!unsol)
diff --git a/sound/soc/codecs/max98088.c b/sound/soc/codecs/max98088.c
index af7324b..4790568 100644
--- a/sound/soc/codecs/max98088.c
+++ b/sound/soc/codecs/max98088.c
@@ -2006,7 +2006,7 @@ static int max98088_probe(struct snd_soc_codec *codec)
                        ret);
                goto err_access;
        }
-       dev_info(codec->dev, "revision %c\n", ret + 'A');
+       dev_info(codec->dev, "revision %c\n", ret - 0x40 + 'A');
 
        snd_soc_write(codec, M98088_REG_51_PWR_SYS, M98088_PWRSV);
 
diff --git a/sound/soc/codecs/wm8994.c b/sound/soc/codecs/wm8994.c
index 7b9b4ef..44719a3 100644
--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -2778,6 +2778,7 @@ static int wm8994_aif3_hw_params(struct snd_pcm_substream *substream,
 		default:
 			return 0;
 		}
+		break;
 	default:
 		return 0;
 	}
diff --git a/sound/usb/card.c b/sound/usb/card.c
index b3f5ad4..aa25e04 100644
--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -619,7 +619,9 @@ int snd_usb_autoresume(struct snd_usb_audio *chip)
 	int err = -ENODEV;
 
 	down_read(&chip->shutdown_rwsem);
-	if (!chip->shutdown && !chip->probing)
+	if (chip->probing)
+		err = 0;
+	else if (!chip->shutdown)
 		err = usb_autopm_get_interface(chip->pm_intf);
 	up_read(&chip->shutdown_rwsem);
 
diff --git a/sound/usb/card.h b/sound/usb/card.h
index d5c2e3a..48b7e2f 100644
--- a/sound/usb/card.h
+++ b/sound/usb/card.h
@@ -110,6 +110,7 @@ struct snd_usb_substream {
 	unsigned int altset_idx;     /* USB data format: index of alternate setting */
 	unsigned int txfr_quirk:1;	/* allow sub-frame alignment */
 	unsigned int fmt_type;		/* USB audio format type (1-3) */
+	unsigned int pkt_offset_adj;	/* Bytes to drop from beginning of packets (for non-compliant devices) */
 
 	unsigned int running: 1;	/* running status */
 
diff --git a/sound/usb/midi.c b/sound/usb/midi.c
index 34b9bb7..e5fee18 100644
--- a/sound/usb/midi.c
+++ b/sound/usb/midi.c
@@ -126,7 +126,6 @@ struct snd_usb_midi {
 		struct snd_usb_midi_in_endpoint *in;
 	} endpoints[MIDI_MAX_ENDPOINTS];
 	unsigned long input_triggered;
-	bool autopm_reference;
 	unsigned int opened[2];
 	unsigned char disconnected;
 	unsigned char input_running;
@@ -1040,7 +1039,6 @@ static int substream_open(struct snd_rawmidi_substream *substream, int dir,
 {
 	struct snd_usb_midi* umidi = substream->rmidi->private_data;
 	struct snd_kcontrol *ctl;
-	int err;
 
 	down_read(&umidi->disc_rwsem);
 	if (umidi->disconnected) {
@@ -1051,13 +1049,6 @@ static int substream_open(struct snd_rawmidi_substream *substream, int dir,
 	mutex_lock(&umidi->mutex);
 	if (open) {
 		if (!umidi->opened[0] && !umidi->opened[1]) {
-			err = usb_autopm_get_interface(umidi->iface);
-			umidi->autopm_reference = err >= 0;
-			if (err < 0 && err != -EACCES) {
-				mutex_unlock(&umidi->mutex);
-				up_read(&umidi->disc_rwsem);
-				return -EIO;
-			}
 			if (umidi->roland_load_ctl) {
 				ctl = umidi->roland_load_ctl;
 				ctl->vd[0].access |= SNDRV_CTL_ELEM_ACCESS_INACTIVE;
@@ -1080,8 +1071,6 @@ static int substream_open(struct snd_rawmidi_substream *substream, int dir,
 				snd_ctl_notify(umidi->card,
 				       SNDRV_CTL_EVENT_MASK_INFO, &ctl->id);
 			}
-			if (umidi->autopm_reference)
-				usb_autopm_put_interface(umidi->iface);
 		}
 	}
 	mutex_unlock(&umidi->mutex);
@@ -2256,6 +2245,8 @@ int snd_usbmidi_create(struct snd_card *card,
 		return err;
 	}
 
+	usb_autopm_get_interface_no_resume(umidi->iface);
+
 	list_add_tail(&umidi->list, midi_list);
 	return 0;
 }
diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index ee3c15c..5fb0164 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -1014,7 +1014,7 @@ static void retire_capture_urb(struct snd_usb_substream *subs,
 	stride = runtime->frame_bits >> 3;
 
 	for (i = 0; i < urb->number_of_packets; i++) {
-		cp = (unsigned char *)urb->transfer_buffer + urb->iso_frame_desc[i].offset;
+		cp = (unsigned char *)urb->transfer_buffer + urb->iso_frame_desc[i].offset + subs->pkt_offset_adj;
 		if (urb->iso_frame_desc[i].status && printk_ratelimit()) {
 			snd_printdd(KERN_ERR "frame %d active: %d\n", i, urb->iso_frame_desc[i].status);
 			// continue;
diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index b7fa802..9c82f8b 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -748,6 +748,7 @@ static void set_format_emu_quirk(struct snd_usb_substream *subs,
 		break;
 	}
 	snd_emuusb_set_samplerate(subs->stream->chip, emu_samplerate_id);
+	subs->pkt_offset_adj = (emu_samplerate_id >= EMU_QUIRK_SR_176400HZ) ? 4 : 0;
 }
 
 void snd_usb_set_format_quirk(struct snd_usb_substream *subs,
diff --git a/sound/usb/stream.c b/sound/usb/stream.c
index 1de0c8c..1891e49b 100644
--- a/sound/usb/stream.c
+++ b/sound/usb/stream.c
@@ -91,6 +91,7 @@ static void snd_usb_init_substream(struct snd_usb_stream *as,
 	subs->dev = as->chip->dev;
 	subs->txfr_quirk = as->chip->txfr_quirk;
 	subs->speed = snd_usb_get_speed(subs->dev);
+	subs->pkt_offset_adj = 0;
 
 	snd_usb_set_pcm_ops(as->pcm, stream);
 
@@ -193,6 +194,14 @@ static int parse_uac_endpoint_attributes(struct snd_usb_audio *chip,
 	if (!csep && altsd->bNumEndpoints >= 2)
 		csep = snd_usb_find_desc(alts->endpoint[1].extra, alts->endpoint[1].extralen, NULL, USB_DT_CS_ENDPOINT);
 
+	/*
+	 * If we can't locate the USB_DT_CS_ENDPOINT descriptor in the extra
+	 * bytes after the first endpoint, go search the entire interface.
+	 * Some devices have it directly *before* the standard endpoint.
+	 */
+	if (!csep)
+		csep = snd_usb_find_desc(alts->extra, alts->extralen, NULL, USB_DT_CS_ENDPOINT);
+
 	if (!csep || csep->bLength < 7 ||
 	    csep->bDescriptorSubtype != UAC_EP_GENERAL) {
 		snd_printk(KERN_WARNING "%d:%u:%d : no or invalid"
