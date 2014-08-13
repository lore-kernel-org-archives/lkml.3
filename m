Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451AbaHMF4I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 01:56:08 -0400
Received: from natalenko.name ([78.47.77.148]:34579 "EHLO natalenko.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757AbaHMF4G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 01:56:06 -0400
DMARC-Filter: OpenDMARC Filter v1.2.0 natalenko.name C158CA50F
Authentication-Results: mail.natalenko.name; dmarc=none header.from=natalenko.name
From: Oleksandr Natalenko <oleksandr@natalenko.name>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [BUG] oops in cpufreq driver with AMD Kaveri CPU
Date: Wed, 13 Aug 2014 08:56:02 +0300
Message-ID: <22004375.5nGJFy1vsr@spock>
User-Agent: KMail/4.13.3 (Linux/3.15.0-pf5; KDE/4.13.3; x86_64; ; )
In-Reply-To: <CAKohpomF9QLLG-6evXWeUvrR9k7Y8ypVNdXyE4cAi=EFOQviHQ@mail.gmail.com>
References: <4708675.eITUXPv8Ih@spock> <3606476.mQLS7miLfb@spock> <CAKohpomF9QLLG-6evXWeUvrR9k7Y8ypVNdXyE4cAi=EFOQviHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart1741808.8bflPRIdRA"
Content-Transfer-Encoding: 7Bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--nextPart1741808.8bflPRIdRA
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Wednesday 13 August 2014 10:02:26 Viresh Kumar wrote:
> That's why you should have copied the diff here, so that I could have
> confirmed if what you have done is correct or not.

You may check my modifications here [1] or attached to this email.

[1] https://gist.github.com/bdcc7d41883b5e077974

-- 
Oleksandr post-factum Natalenko, MSc
pf-kernel community
https://natalenko.name/
--nextPart1741808.8bflPRIdRA
Content-Disposition: attachment; filename="0001-add-cpufreq-debug.patch"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="UTF-8"; name="0001-add-cpufreq-debug.patch"

>From 493cd190339201c264cdc4cbc1c96c70c786a776 Mon Sep 17 00:00:00 2001
From: Oleksandr Natalenko <oleksandr@natalenko.name>
Date: Wed, 13 Aug 2014 08:54:09 +0300
Subject: [PATCH] add cpufreq debug

---
 arch/arm/kernel/smp.c                            | 2 ++
 arch/arm/kernel/smp_twd.c                        | 2 ++
 arch/arm/mach-pxa/viper.c                        | 2 ++
 arch/arm/mach-s3c24xx/mach-osiris-dvs.c          | 2 ++
 arch/blackfin/mach-common/dpmc.c                 | 2 ++
 arch/cris/arch-v32/kernel/time.c                 | 3 +++
 arch/powerpc/oprofile/op_model_cell.c            | 3 +++
 arch/sparc/kernel/time_64.c                      | 2 ++
 arch/x86/kernel/tsc.c                            | 2 ++
 arch/x86/kvm/x86.c                               | 2 ++
 drivers/acpi/processor_perflib.c                 | 2 ++
 drivers/acpi/processor_thermal.c                 | 2 ++
 drivers/cpufreq/cpufreq.c                        | 1 +
 drivers/cpufreq/cpufreq_stats.c                  | 2 ++
 drivers/cpufreq/cris-artpec3-cpufreq.c           | 3 +++
 drivers/cpufreq/cris-etraxfs-cpufreq.c           | 3 +++
 drivers/cpufreq/loongson2_cpufreq.c              | 2 ++
 drivers/cpufreq/ppc_cbe_cpufreq_pmi.c            | 2 ++
 drivers/gpu/drm/tilcdc/tilcdc_drv.c              | 3 +++
 drivers/i2c/busses/i2c-davinci.c                 | 2 ++
 drivers/i2c/busses/i2c-s3c2410.c                 | 2 ++
 drivers/macintosh/windfarm_cpufreq_clamp.c       | 2 ++
 drivers/mmc/host/davinci_mmc.c                   | 2 ++
 drivers/mmc/host/s3cmci.c                        | 2 ++
 drivers/mtd/nand/s3c2410.c                       | 2 ++
 drivers/pcmcia/soc_common.c                      | 2 ++
 drivers/staging/tidspbridge/rmgr/drv_interface.c | 2 ++
 drivers/thermal/cpu_cooling.c                    | 2 ++
 drivers/tty/serial/samsung.c                     | 2 ++
 drivers/tty/serial/sh-sci.c                      | 2 ++
 drivers/video/fbdev/da8xx-fb.c                   | 2 ++
 drivers/video/fbdev/nuc900fb.c                   | 1 +
 drivers/video/fbdev/pxafb.c                      | 2 ++
 drivers/video/fbdev/s3c2410fb.c                  | 2 ++
 drivers/video/fbdev/sa1100fb.c                   | 2 ++
 drivers/watchdog/s3c2410_wdt.c                   | 2 ++
 36 files changed, 75 insertions(+)

diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 7c4fada..57dff15 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -660,6 +660,8 @@ static int cpufreq_callback(struct notifier_block *nb,
 	struct cpufreq_freqs *freq = data;
 	int cpu = freq->cpu;
 
+	pr_info("%s\n", __func__);
+
 	if (freq->flags & CPUFREQ_CONST_LOOPS)
 		return NOTIFY_OK;
 
diff --git a/arch/arm/kernel/smp_twd.c b/arch/arm/kernel/smp_twd.c
index dfc3213..986df64 100644
--- a/arch/arm/kernel/smp_twd.c
+++ b/arch/arm/kernel/smp_twd.c
@@ -161,6 +161,8 @@ static int twd_cpufreq_transition(struct notifier_block *nb,
 {
 	struct cpufreq_freqs *freqs = data;
 
+	pr_info("%s\n", __func__);
+
 	/*
 	 * The twd clock events must be reprogrammed to account for the new
 	 * frequency.  The timer is local to a cpu, so cross-call to the
diff --git a/arch/arm/mach-pxa/viper.c b/arch/arm/mach-pxa/viper.c
index 41f27f6..c047617 100644
--- a/arch/arm/mach-pxa/viper.c
+++ b/arch/arm/mach-pxa/viper.c
@@ -868,6 +868,8 @@ static int viper_cpufreq_notifier(struct notifier_block *nb,
 {
 	struct cpufreq_freqs *freq = data;
 
+	pr_info("%s\n", __func__);
+
 	/* TODO: Adjust timings??? */
 
 	switch (val) {
diff --git a/arch/arm/mach-s3c24xx/mach-osiris-dvs.c b/arch/arm/mach-s3c24xx/mach-osiris-dvs.c
index 33afb91..1caf694 100644
--- a/arch/arm/mach-s3c24xx/mach-osiris-dvs.c
+++ b/arch/arm/mach-s3c24xx/mach-osiris-dvs.c
@@ -61,6 +61,8 @@ static int osiris_dvs_notify(struct notifier_block *nb,
 	bool new_dvs = is_dvs(&freqs->new);
 	int ret = 0;
 
+	pr_info("%s\n", __func__);
+
 	if (!dvs_en)
 		return 0;
 
diff --git a/arch/blackfin/mach-common/dpmc.c b/arch/blackfin/mach-common/dpmc.c
index 724a8c5..1fd9a05 100644
--- a/arch/blackfin/mach-common/dpmc.c
+++ b/arch/blackfin/mach-common/dpmc.c
@@ -103,6 +103,8 @@ vreg_cpufreq_notifier(struct notifier_block *nb, unsigned long val, void *data)
 {
 	struct cpufreq_freqs *freq = data;
 
+	pr_info("%s\n", __func__);
+
 	if (freq->cpu != CPUFREQ_CPU)
 		return 0;
 
diff --git a/arch/cris/arch-v32/kernel/time.c b/arch/cris/arch-v32/kernel/time.c
index ee66866..b7cb448 100644
--- a/arch/cris/arch-v32/kernel/time.c
+++ b/arch/cris/arch-v32/kernel/time.c
@@ -303,6 +303,9 @@ cris_time_freq_notifier(struct notifier_block *nb, unsigned long val,
 			void *data)
 {
 	struct cpufreq_freqs *freqs = data;
+
+	pr_info("%s\n", __func__);
+
 	if (val == CPUFREQ_POSTCHANGE) {
 		reg_timer_r_tmr0_data data;
 		reg_timer_rw_tmr0_div div = (freqs->new * 500) / HZ;
diff --git a/arch/powerpc/oprofile/op_model_cell.c b/arch/powerpc/oprofile/op_model_cell.c
index 863d893..283c5d1 100644
--- a/arch/powerpc/oprofile/op_model_cell.c
+++ b/arch/powerpc/oprofile/op_model_cell.c
@@ -1120,6 +1120,9 @@ oprof_cpufreq_notify(struct notifier_block *nb, unsigned long val, void *data)
 {
 	int ret = 0;
 	struct cpufreq_freqs *frq = data;
+
+	pr_info("%s\n", __func__);
+
 	if ((val == CPUFREQ_PRECHANGE && frq->old < frq->new) ||
 	    (val == CPUFREQ_POSTCHANGE && frq->old > frq->new))
 		set_spu_profiling_frequency(frq->new, spu_cycle_reset);
diff --git a/arch/sparc/kernel/time_64.c b/arch/sparc/kernel/time_64.c
index 3fddf64..af62a1a 100644
--- a/arch/sparc/kernel/time_64.c
+++ b/arch/sparc/kernel/time_64.c
@@ -654,6 +654,8 @@ static int sparc64_cpufreq_notifier(struct notifier_block *nb, unsigned long val
 	unsigned int cpu = freq->cpu;
 	struct freq_table *ft = &per_cpu(sparc64_freq_table, cpu);
 
+	pr_info("%s\n", __func__);
+
 	if (!ft->ref_freq) {
 		ft->ref_freq = freq->old;
 		ft->clock_tick_ref = cpu_data(cpu).clock_tick;
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index ea03031..81b9bbc 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -899,6 +899,8 @@ static int time_cpufreq_notifier(struct notifier_block *nb, unsigned long val,
 	struct cpufreq_freqs *freq = data;
 	unsigned long *lpj;
 
+	pr_info("%s\n", __func__);
+
 	if (cpu_has(&cpu_data(freq->cpu), X86_FEATURE_CONSTANT_TSC))
 		return 0;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ef432f8..dcba683 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5402,6 +5402,8 @@ static int kvmclock_cpu_notifier(struct notifier_block *nfb,
 {
 	unsigned int cpu = (unsigned long)hcpu;
 
+	pr_info("%s\n", __func__);
+
 	switch (action) {
 		case CPU_ONLINE:
 		case CPU_DOWN_FAILED:
diff --git a/drivers/acpi/processor_perflib.c b/drivers/acpi/processor_perflib.c
index cfc8aba..eb858f7 100644
--- a/drivers/acpi/processor_perflib.c
+++ b/drivers/acpi/processor_perflib.c
@@ -79,6 +79,8 @@ static int acpi_processor_ppc_notifier(struct notifier_block *nb,
 	struct acpi_processor *pr;
 	unsigned int ppc = 0;
 
+	pr_info("CPUFREQ_NOTIFIER: %s\n", __func__);
+
 	if (event == CPUFREQ_START && ignore_ppc <= 0) {
 		ignore_ppc = 0;
 		return 0;
diff --git a/drivers/acpi/processor_thermal.c b/drivers/acpi/processor_thermal.c
index e003663..ef8fcec 100644
--- a/drivers/acpi/processor_thermal.c
+++ b/drivers/acpi/processor_thermal.c
@@ -89,6 +89,8 @@ static int acpi_thermal_cpufreq_notifier(struct notifier_block *nb,
 	struct cpufreq_policy *policy = data;
 	unsigned long max_freq = 0;
 
+	pr_info("CPUFREQ_NOTIFIER: %s\n", __func__);
+
 	if (event != CPUFREQ_ADJUST)
 		goto out;
 
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 6f02485..9255321 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1764,6 +1764,7 @@ int cpufreq_register_notifier(struct notifier_block *nb, unsigned int list)
 
 	switch (list) {
 	case CPUFREQ_TRANSITION_NOTIFIER:
+		pr_info("Registered transition notifier: %p, (%p)\n", nb->notifier_call, &nb->notifier_call);
 		ret = srcu_notifier_chain_register(
 				&cpufreq_transition_notifier_list, nb);
 		break;
diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
index 0cd9b4d..aed067c 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -298,6 +298,8 @@ static int cpufreq_stat_notifier_trans(struct notifier_block *nb,
 	struct cpufreq_stats *stat;
 	int old_index, new_index;
 
+	pr_info("CPUFREQ_NOTIFIER: %s\n", __func__);
+
 	if (val != CPUFREQ_POSTCHANGE)
 		return 0;
 
diff --git a/drivers/cpufreq/cris-artpec3-cpufreq.c b/drivers/cpufreq/cris-artpec3-cpufreq.c
index 601b88c..357bc51 100644
--- a/drivers/cpufreq/cris-artpec3-cpufreq.c
+++ b/drivers/cpufreq/cris-artpec3-cpufreq.c
@@ -76,6 +76,9 @@ cris_sdram_freq_notifier(struct notifier_block *nb, unsigned long val,
 {
 	int i;
 	struct cpufreq_freqs *freqs = data;
+
+	pr_info("%s\n", __func__);
+
 	if (val == CPUFREQ_PRECHANGE) {
 		reg_ddr2_rw_cfg cfg =
 		  REG_RD(ddr2, regi_ddr2_ctrl, rw_cfg);
diff --git a/drivers/cpufreq/cris-etraxfs-cpufreq.c b/drivers/cpufreq/cris-etraxfs-cpufreq.c
index 22b2cdd..acc859d 100644
--- a/drivers/cpufreq/cris-etraxfs-cpufreq.c
+++ b/drivers/cpufreq/cris-etraxfs-cpufreq.c
@@ -76,6 +76,9 @@ cris_sdram_freq_notifier(struct notifier_block *nb, unsigned long val,
 {
 	int i;
 	struct cpufreq_freqs *freqs = data;
+
+	pr_info("%s\n", __func__);
+
 	if (val == CPUFREQ_PRECHANGE) {
 		reg_bif_core_rw_sdram_timing timing =
 		    REG_RD(bif_core, regi_bif_core, rw_sdram_timing);
diff --git a/drivers/cpufreq/loongson2_cpufreq.c b/drivers/cpufreq/loongson2_cpufreq.c
index d4add86..42446f4 100644
--- a/drivers/cpufreq/loongson2_cpufreq.c
+++ b/drivers/cpufreq/loongson2_cpufreq.c
@@ -36,6 +36,8 @@ static struct notifier_block loongson2_cpufreq_notifier_block = {
 static int loongson2_cpu_freq_notifier(struct notifier_block *nb,
 					unsigned long val, void *data)
 {
+	pr_info("%s\n", __func__);
+
 	if (val == CPUFREQ_POSTCHANGE)
 		current_cpu_data.udelay_val = loops_per_jiffy;
 
diff --git a/drivers/cpufreq/ppc_cbe_cpufreq_pmi.c b/drivers/cpufreq/ppc_cbe_cpufreq_pmi.c
index d29e8da..0f1f2b1 100644
--- a/drivers/cpufreq/ppc_cbe_cpufreq_pmi.c
+++ b/drivers/cpufreq/ppc_cbe_cpufreq_pmi.c
@@ -97,6 +97,8 @@ static int pmi_notifier(struct notifier_block *nb,
 	struct cpufreq_frequency_table *cbe_freqs;
 	u8 node;
 
+	pr_info("%s\n", __func__);
+
 	/* Should this really be called for CPUFREQ_ADJUST, CPUFREQ_INCOMPATIBLE
 	 * and CPUFREQ_NOTIFY policy events?)
 	 */
diff --git a/drivers/gpu/drm/tilcdc/tilcdc_drv.c b/drivers/gpu/drm/tilcdc/tilcdc_drv.c
index b20b694..6defd4b 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_drv.c
+++ b/drivers/gpu/drm/tilcdc/tilcdc_drv.c
@@ -102,6 +102,9 @@ static int cpufreq_transition(struct notifier_block *nb,
 {
 	struct tilcdc_drm_private *priv = container_of(nb,
 			struct tilcdc_drm_private, freq_transition);
+
+	pr_info("%s\n", __func__);
+
 	if (val == CPUFREQ_POSTCHANGE) {
 		if (priv->lcd_fck_rate != clk_get_rate(priv->clk)) {
 			priv->lcd_fck_rate = clk_get_rate(priv->clk);
diff --git a/drivers/i2c/busses/i2c-davinci.c b/drivers/i2c/busses/i2c-davinci.c
index 389bc68..8228027 100644
--- a/drivers/i2c/busses/i2c-davinci.c
+++ b/drivers/i2c/busses/i2c-davinci.c
@@ -589,6 +589,8 @@ static int i2c_davinci_cpufreq_transition(struct notifier_block *nb,
 {
 	struct davinci_i2c_dev *dev;
 
+	pr_info("%s\n", __func__);
+
 	dev = container_of(nb, struct davinci_i2c_dev, freq_transition);
 	if (val == CPUFREQ_PRECHANGE) {
 		wait_for_completion(&dev->xfr_complete);
diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
index e828a1d..0c0ee6b 100644
--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -928,6 +928,8 @@ static int s3c24xx_i2c_cpufreq_transition(struct notifier_block *nb,
 	int delta_f;
 	int ret;
 
+	pr_info("%s\n", __func__);
+
 	delta_f = clk_get_rate(i2c->clk) - i2c->clkrate;
 
 	/* if we're post-change and the input clock has slowed down
diff --git a/drivers/macintosh/windfarm_cpufreq_clamp.c b/drivers/macintosh/windfarm_cpufreq_clamp.c
index 72d1fdf..8342ae1 100644
--- a/drivers/macintosh/windfarm_cpufreq_clamp.c
+++ b/drivers/macintosh/windfarm_cpufreq_clamp.c
@@ -22,6 +22,8 @@ static int clamp_notifier_call(struct notifier_block *self,
 	struct cpufreq_policy *p = data;
 	unsigned long max_freq;
 
+	pr_info("%s\n", __func__);
+
 	if (event != CPUFREQ_ADJUST)
 		return 0;
 
diff --git a/drivers/mmc/host/davinci_mmc.c b/drivers/mmc/host/davinci_mmc.c
index 5d4c5e0..bbb5a0e 100644
--- a/drivers/mmc/host/davinci_mmc.c
+++ b/drivers/mmc/host/davinci_mmc.c
@@ -1110,6 +1110,8 @@ static int mmc_davinci_cpufreq_transition(struct notifier_block *nb,
 	struct mmc_host *mmc;
 	unsigned long flags;
 
+	pr_info("%s\n", __func__);
+
 	host = container_of(nb, struct mmc_davinci_host, freq_transition);
 	mmc = host->mmc;
 	mmc_pclk = clk_get_rate(host->clk);
diff --git a/drivers/mmc/host/s3cmci.c b/drivers/mmc/host/s3cmci.c
index f237826..6bbdc6e 100644
--- a/drivers/mmc/host/s3cmci.c
+++ b/drivers/mmc/host/s3cmci.c
@@ -1451,6 +1451,8 @@ static int s3cmci_cpufreq_transition(struct notifier_block *nb,
 	unsigned long newclk;
 	unsigned long flags;
 
+	pr_info("%s\n", __func__);
+
 	host = container_of(nb, struct s3cmci_host, freq_transition);
 	newclk = clk_get_rate(host->clk);
 	mmc = host->mmc;
diff --git a/drivers/mtd/nand/s3c2410.c b/drivers/mtd/nand/s3c2410.c
index 79acbb8..d8eb2ee 100644
--- a/drivers/mtd/nand/s3c2410.c
+++ b/drivers/mtd/nand/s3c2410.c
@@ -686,6 +686,8 @@ static int s3c2410_nand_cpufreq_transition(struct notifier_block *nb,
 	struct s3c2410_nand_info *info;
 	unsigned long newclk;
 
+	pr_info("%s\n", __func__);
+
 	info = container_of(nb, struct s3c2410_nand_info, freq_transition);
 	newclk = clk_get_rate(info->clk);
 
diff --git a/drivers/pcmcia/soc_common.c b/drivers/pcmcia/soc_common.c
index a2bc6ee..e67eb30 100644
--- a/drivers/pcmcia/soc_common.c
+++ b/drivers/pcmcia/soc_common.c
@@ -644,6 +644,8 @@ soc_pcmcia_notifier(struct notifier_block *nb, unsigned long val, void *data)
 	struct cpufreq_freqs *freqs = data;
 	int ret = 0;
 
+	pr_info("%s\n", __func__);
+
 	mutex_lock(&soc_pcmcia_sockets_lock);
 	list_for_each_entry(skt, &soc_pcmcia_sockets, node)
 		if (skt->ops->frequency_change)
diff --git a/drivers/staging/tidspbridge/rmgr/drv_interface.c b/drivers/staging/tidspbridge/rmgr/drv_interface.c
index 74d31da..a93e2e4 100644
--- a/drivers/staging/tidspbridge/rmgr/drv_interface.c
+++ b/drivers/staging/tidspbridge/rmgr/drv_interface.c
@@ -380,6 +380,8 @@ static int dspbridge_scale_notification(struct notifier_block *op,
 	struct omap_dsp_platform_data *pdata =
 	    omap_dspbridge_dev->dev.platform_data;
 
+	pr_info("%s\n", __func__);
+
 	if (CPUFREQ_POSTCHANGE == val && pdata->dsp_get_opp)
 		pwr_pm_post_scale(PRCM_VDD1, pdata->dsp_get_opp());
 
diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
index 84a75f8..6f42abc 100644
--- a/drivers/thermal/cpu_cooling.c
+++ b/drivers/thermal/cpu_cooling.c
@@ -317,6 +317,8 @@ static int cpufreq_thermal_notifier(struct notifier_block *nb,
 	struct cpufreq_policy *policy = data;
 	unsigned long max_freq = 0;
 
+	pr_info("%s\n", __func__);
+
 	if (event != CPUFREQ_ADJUST || notify_device == NOTIFY_INVALID)
 		return 0;
 
diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
index c1d3ebd..0dabb16 100644
--- a/drivers/tty/serial/samsung.c
+++ b/drivers/tty/serial/samsung.c
@@ -1066,6 +1066,8 @@ static int s3c24xx_serial_cpufreq_transition(struct notifier_block *nb,
 	struct s3c24xx_uart_port *port;
 	struct uart_port *uport;
 
+	pr_info("%s\n", __func__);
+
 	port = container_of(nb, struct s3c24xx_uart_port, freq_transition);
 	uport = &port->port;
 
diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
index 88236da..aaa78fa 100644
--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -1039,6 +1039,8 @@ static int sci_notifier(struct notifier_block *self,
 	struct sci_port *sci_port;
 	unsigned long flags;
 
+	pr_info("%s\n", __func__);
+
 	sci_port = container_of(self, struct sci_port, freq_transition);
 
 	if (phase == CPUFREQ_POSTCHANGE) {
diff --git a/drivers/video/fbdev/da8xx-fb.c b/drivers/video/fbdev/da8xx-fb.c
index a8484f7..4edf809 100644
--- a/drivers/video/fbdev/da8xx-fb.c
+++ b/drivers/video/fbdev/da8xx-fb.c
@@ -1048,6 +1048,8 @@ static int lcd_da8xx_cpufreq_transition(struct notifier_block *nb,
 {
 	struct da8xx_fb_par *par;
 
+	pr_info("%s\n", __func__);
+
 	par = container_of(nb, struct da8xx_fb_par, freq_transition);
 	if (val == CPUFREQ_POSTCHANGE) {
 		if (par->lcdc_clk_rate != clk_get_rate(par->lcdc_clk)) {
diff --git a/drivers/video/fbdev/nuc900fb.c b/drivers/video/fbdev/nuc900fb.c
index 478f980..a2d62bc 100644
--- a/drivers/video/fbdev/nuc900fb.c
+++ b/drivers/video/fbdev/nuc900fb.c
@@ -484,6 +484,7 @@ static inline void nuc900fb_cpufreq_deregister(struct nuc900fb_info *fbi)
 static inline int nuc900fb_cpufreq_transition(struct notifier_block *nb,
 				       unsigned long val, void *data)
 {
+	pr_info("%s\n", __func__);
 	return 0;
 }
 
diff --git a/drivers/video/fbdev/pxafb.c b/drivers/video/fbdev/pxafb.c
index 1ecd9ce..227eec7 100644
--- a/drivers/video/fbdev/pxafb.c
+++ b/drivers/video/fbdev/pxafb.c
@@ -1640,6 +1640,8 @@ pxafb_freq_transition(struct notifier_block *nb, unsigned long val, void *data)
 	/* TODO struct cpufreq_freqs *f = data; */
 	u_int pcd;
 
+	pr_info("%s\n", __func__);
+
 	switch (val) {
 	case CPUFREQ_PRECHANGE:
 #ifdef CONFIG_FB_PXA_OVERLAY
diff --git a/drivers/video/fbdev/s3c2410fb.c b/drivers/video/fbdev/s3c2410fb.c
index 81af5a6..eae9fc5 100644
--- a/drivers/video/fbdev/s3c2410fb.c
+++ b/drivers/video/fbdev/s3c2410fb.c
@@ -776,6 +776,8 @@ static int s3c2410fb_cpufreq_transition(struct notifier_block *nb,
 	struct fb_info *fbinfo;
 	long delta_f;
 
+	pr_info("%s\n", __func__);
+
 	info = container_of(nb, struct s3c2410fb_info, freq_transition);
 	fbinfo = platform_get_drvdata(to_platform_device(info->dev));
 
diff --git a/drivers/video/fbdev/sa1100fb.c b/drivers/video/fbdev/sa1100fb.c
index 580c444..da092bd 100644
--- a/drivers/video/fbdev/sa1100fb.c
+++ b/drivers/video/fbdev/sa1100fb.c
@@ -1006,6 +1006,8 @@ sa1100fb_freq_transition(struct notifier_block *nb, unsigned long val,
 	struct cpufreq_freqs *f = data;
 	u_int pcd;
 
+	pr_info("%s\n", __func__);
+
 	switch (val) {
 	case CPUFREQ_PRECHANGE:
 		set_ctrlr_state(fbi, C_DISABLE_CLKCHANGE);
diff --git a/drivers/watchdog/s3c2410_wdt.c b/drivers/watchdog/s3c2410_wdt.c
index 7c6ccd0..a01b11b 100644
--- a/drivers/watchdog/s3c2410_wdt.c
+++ b/drivers/watchdog/s3c2410_wdt.c
@@ -379,6 +379,8 @@ static int s3c2410wdt_cpufreq_transition(struct notifier_block *nb,
 	int ret;
 	struct s3c2410_wdt *wdt = freq_to_wdt(nb);
 
+	pr_info("%s\n", __func__);
+
 	if (!s3c2410wdt_is_running(wdt))
 		goto done;
 
-- 
1.9.1


--nextPart1741808.8bflPRIdRA--

