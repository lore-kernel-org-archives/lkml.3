Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758043AbaDVVOI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 17:14:08 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:51220 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756450AbaDVVN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 17:13:57 -0400
Message-ID: <5356DB92.1060600@semaphore.gr>
Date: Wed, 23 Apr 2014 00:13:54 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>
CC: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] cpufreq: powernow-k8: Fix checkpatch warnings
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following checkpatch warnings:

- WARNING: Prefer pr_err(... to printk(KERN_ERR ...
- WARNING: Prefer pr_info(... to printk(KERN_INFO ...
- WARNING: Prefer pr_warn(... to printk(KERN_WARNING ...
- WARNING: quoted string split across lines
- WARNING: line over 80 characters
- WARNING: please, no spaces at the start of a line

Also, define the pr_fmt macro instead of PFX for the module name.

Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
---
 drivers/cpufreq/powernow-k8.c | 180 ++++++++++++++++++------------------------
 drivers/cpufreq/powernow-k8.h |  11 ++-
 2 files changed, 84 insertions(+), 107 deletions(-)

diff --git a/drivers/cpufreq/powernow-k8.c b/drivers/cpufreq/powernow-k8.c
index 1b6ae6b..fa0386e 100644
--- a/drivers/cpufreq/powernow-k8.c
+++ b/drivers/cpufreq/powernow-k8.c
@@ -27,6 +27,8 @@
  *  power and thermal data sheets, (e.g. 30417.pdf, 30430.pdf, 43375.pdf)
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/smp.h>
 #include <linux/module.h>
@@ -45,7 +47,6 @@
 #include <linux/mutex.h>
 #include <acpi/processor.h>
 
-#define PFX "powernow-k8: "
 #define VERSION "version 2.20.00"
 #include "powernow-k8.h"
 
@@ -161,7 +162,7 @@ static int write_new_fid(struct powernow_k8_data *data, u32 fid)
 	u32 i = 0;
 
 	if ((fid & INVALID_FID_MASK) || (data->currvid & INVALID_VID_MASK)) {
-		printk(KERN_ERR PFX "internal error - overflow on fid write\n");
+		pr_err("internal error - overflow on fid write\n");
 		return 1;
 	}
 
@@ -175,9 +176,7 @@ static int write_new_fid(struct powernow_k8_data *data, u32 fid)
 	do {
 		wrmsr(MSR_FIDVID_CTL, lo, data->plllock * PLL_LOCK_CONVERSION);
 		if (i++ > 100) {
-			printk(KERN_ERR PFX
-				"Hardware error - pending bit very stuck - "
-				"no further pstate changes possible\n");
+			pr_err("Hardware error - pending bit very stuck - no further pstate changes possible\n");
 			return 1;
 		}
 	} while (query_current_values_with_pending_wait(data));
@@ -185,16 +184,14 @@ static int write_new_fid(struct powernow_k8_data *data, u32 fid)
 	count_off_irt(data);
 
 	if (savevid != data->currvid) {
-		printk(KERN_ERR PFX
-			"vid change on fid trans, old 0x%x, new 0x%x\n",
-			savevid, data->currvid);
+		pr_err("vid change on fid trans, old 0x%x, new 0x%x\n",
+		       savevid, data->currvid);
 		return 1;
 	}
 
 	if (fid != data->currfid) {
-		printk(KERN_ERR PFX
-			"fid trans failed, fid 0x%x, curr 0x%x\n", fid,
-			data->currfid);
+		pr_err("fid trans failed, fid 0x%x, curr 0x%x\n", fid,
+		       data->currfid);
 		return 1;
 	}
 
@@ -209,7 +206,7 @@ static int write_new_vid(struct powernow_k8_data *data, u32 vid)
 	int i = 0;
 
 	if ((data->currfid & INVALID_FID_MASK) || (vid & INVALID_VID_MASK)) {
-		printk(KERN_ERR PFX "internal error - overflow on vid write\n");
+		pr_err("internal error - overflow on vid write\n");
 		return 1;
 	}
 
@@ -223,23 +220,19 @@ static int write_new_vid(struct powernow_k8_data *data, u32 vid)
 	do {
 		wrmsr(MSR_FIDVID_CTL, lo, STOP_GRANT_5NS);
 		if (i++ > 100) {
-			printk(KERN_ERR PFX "internal error - pending bit "
-					"very stuck - no further pstate "
-					"changes possible\n");
+			pr_err("internal error - pending bit very stuck - no further pstate changes possible\n");
 			return 1;
 		}
 	} while (query_current_values_with_pending_wait(data));
 
 	if (savefid != data->currfid) {
-		printk(KERN_ERR PFX "fid changed on vid trans, old "
-			"0x%x new 0x%x\n",
-		       savefid, data->currfid);
+		pr_err("fid changed on vid trans, old 0x%x new 0x%x\n",
+			savefid, data->currfid);
 		return 1;
 	}
 
 	if (vid != data->currvid) {
-		printk(KERN_ERR PFX "vid trans failed, vid 0x%x, "
-				"curr 0x%x\n",
+		pr_err("vid trans failed, vid 0x%x, curr 0x%x\n",
 				vid, data->currvid);
 		return 1;
 	}
@@ -283,8 +276,7 @@ static int transition_fid_vid(struct powernow_k8_data *data,
 		return 1;
 
 	if ((reqfid != data->currfid) || (reqvid != data->currvid)) {
-		printk(KERN_ERR PFX "failed (cpu%d): req 0x%x 0x%x, "
-				"curr 0x%x 0x%x\n",
+		pr_err("failed (cpu%d): req 0x%x 0x%x, curr 0x%x 0x%x\n",
 				smp_processor_id(),
 				reqfid, reqvid, data->currfid, data->currvid);
 		return 1;
@@ -304,8 +296,7 @@ static int core_voltage_pre_transition(struct powernow_k8_data *data,
 	u32 savefid = data->currfid;
 	u32 maxvid, lo, rvomult = 1;
 
-	pr_debug("ph1 (cpu%d): start, currfid 0x%x, currvid 0x%x, "
-		"reqvid 0x%x, rvo 0x%x\n",
+	pr_debug("ph1 (cpu%d): start, currfid 0x%x, currvid 0x%x, reqvid 0x%x, rvo 0x%x\n",
 		smp_processor_id(),
 		data->currfid, data->currvid, reqvid, data->rvo);
 
@@ -342,7 +333,7 @@ static int core_voltage_pre_transition(struct powernow_k8_data *data,
 		return 1;
 
 	if (savefid != data->currfid) {
-		printk(KERN_ERR PFX "ph1 err, currfid changed 0x%x\n",
+		pr_err("ph1 err, currfid changed 0x%x\n",
 				data->currfid);
 		return 1;
 	}
@@ -360,13 +351,11 @@ static int core_frequency_transition(struct powernow_k8_data *data, u32 reqfid)
 	u32 fid_interval, savevid = data->currvid;
 
 	if (data->currfid == reqfid) {
-		printk(KERN_ERR PFX "ph2 null fid transition 0x%x\n",
-				data->currfid);
+		pr_err("ph2 null fid transition 0x%x\n", data->currfid);
 		return 0;
 	}
 
-	pr_debug("ph2 (cpu%d): starting, currfid 0x%x, currvid 0x%x, "
-		"reqfid 0x%x\n",
+	pr_debug("ph2 (cpu%d): starting, currfid 0x%x, currvid 0x%x, reqfid 0x%x\n",
 		smp_processor_id(),
 		data->currfid, data->currvid, reqfid);
 
@@ -409,15 +398,13 @@ static int core_frequency_transition(struct powernow_k8_data *data, u32 reqfid)
 		return 1;
 
 	if (data->currfid != reqfid) {
-		printk(KERN_ERR PFX
-			"ph2: mismatch, failed fid transition, "
-			"curr 0x%x, req 0x%x\n",
+		pr_err("ph2: mismatch, failed fid transition, curr 0x%x, req 0x%x\n",
 			data->currfid, reqfid);
 		return 1;
 	}
 
 	if (savevid != data->currvid) {
-		printk(KERN_ERR PFX "ph2: vid changed, save 0x%x, curr 0x%x\n",
+		pr_err("ph2: vid changed, save 0x%x, curr 0x%x\n",
 			savevid, data->currvid);
 		return 1;
 	}
@@ -444,16 +431,13 @@ static int core_voltage_post_transition(struct powernow_k8_data *data,
 			return 1;
 
 		if (savefid != data->currfid) {
-			printk(KERN_ERR PFX
-			       "ph3: bad fid change, save 0x%x, curr 0x%x\n",
+			pr_err("ph3: bad fid change, save 0x%x, curr 0x%x\n",
 			       savefid, data->currfid);
 			return 1;
 		}
 
 		if (data->currvid != reqvid) {
-			printk(KERN_ERR PFX
-			       "ph3: failed vid transition\n, "
-			       "req 0x%x, curr 0x%x",
+			pr_err("ph3: failed vid transition\n, req 0x%x, curr 0x%x",
 			       reqvid, data->currvid);
 			return 1;
 		}
@@ -498,23 +482,20 @@ static void check_supported_cpu(void *_rc)
 	if ((eax & CPUID_XFAM) == CPUID_XFAM_K8) {
 		if (((eax & CPUID_USE_XFAM_XMOD) != CPUID_USE_XFAM_XMOD) ||
 		    ((eax & CPUID_XMOD) > CPUID_XMOD_REV_MASK)) {
-			printk(KERN_INFO PFX
-				"Processor cpuid %x not supported\n", eax);
+			pr_info("Processor cpuid %x not supported\n", eax);
 			return;
 		}
 
 		eax = cpuid_eax(CPUID_GET_MAX_CAPABILITIES);
 		if (eax < CPUID_FREQ_VOLT_CAPABILITIES) {
-			printk(KERN_INFO PFX
-			       "No frequency change capabilities detected\n");
+			pr_info("No frequency change capabilities detected\n");
 			return;
 		}
 
 		cpuid(CPUID_FREQ_VOLT_CAPABILITIES, &eax, &ebx, &ecx, &edx);
 		if ((edx & P_STATE_TRANSITION_CAPABLE)
 			!= P_STATE_TRANSITION_CAPABLE) {
-			printk(KERN_INFO PFX
-				"Power state transitions not supported\n");
+			pr_info("Power state transitions not supported\n");
 			return;
 		}
 		*rc = 0;
@@ -529,43 +510,39 @@ static int check_pst_table(struct powernow_k8_data *data, struct pst_s *pst,
 
 	for (j = 0; j < data->numps; j++) {
 		if (pst[j].vid > LEAST_VID) {
-			printk(KERN_ERR FW_BUG PFX "vid %d invalid : 0x%x\n",
-			       j, pst[j].vid);
+			pr_err(FW_BUG "vid %d invalid : 0x%x\n", j,
+			       pst[j].vid);
 			return -EINVAL;
 		}
 		if (pst[j].vid < data->rvo) {
 			/* vid + rvo >= 0 */
-			printk(KERN_ERR FW_BUG PFX "0 vid exceeded with pstate"
-			       " %d\n", j);
+			pr_err(FW_BUG "0 vid exceeded with pstate %d\n", j);
 			return -ENODEV;
 		}
 		if (pst[j].vid < maxvid + data->rvo) {
 			/* vid + rvo >= maxvid */
-			printk(KERN_ERR FW_BUG PFX "maxvid exceeded with pstate"
-			       " %d\n", j);
+			pr_err(FW_BUG "maxvid exceeded with pstate %d\n", j);
 			return -ENODEV;
 		}
 		if (pst[j].fid > MAX_FID) {
-			printk(KERN_ERR FW_BUG PFX "maxfid exceeded with pstate"
-			       " %d\n", j);
+			pr_err(FW_BUG "maxfid exceeded with pstate %d\n", j);
 			return -ENODEV;
 		}
 		if (j && (pst[j].fid < HI_FID_TABLE_BOTTOM)) {
 			/* Only first fid is allowed to be in "low" range */
-			printk(KERN_ERR FW_BUG PFX "two low fids - %d : "
-			       "0x%x\n", j, pst[j].fid);
+			pr_err(FW_BUG "two low fids - %d : 0x%x\n", j,
+			       pst[j].fid);
 			return -EINVAL;
 		}
 		if (pst[j].fid < lastfid)
 			lastfid = pst[j].fid;
 	}
 	if (lastfid & 1) {
-		printk(KERN_ERR FW_BUG PFX "lastfid invalid\n");
+		pr_err(FW_BUG "lastfid invalid\n");
 		return -EINVAL;
 	}
 	if (lastfid > LO_FID_TABLE_TOP)
-		printk(KERN_INFO FW_BUG PFX
-			"first fid not from lo freq table\n");
+		pr_info(FW_BUG "first fid not from lo freq table\n");
 
 	return 0;
 }
@@ -582,16 +559,14 @@ static void print_basics(struct powernow_k8_data *data)
 	for (j = 0; j < data->numps; j++) {
 		if (data->powernow_table[j].frequency !=
 				CPUFREQ_ENTRY_INVALID) {
-				printk(KERN_INFO PFX
-					"fid 0x%x (%d MHz), vid 0x%x\n",
-					data->powernow_table[j].driver_data & 0xff,
-					data->powernow_table[j].frequency/1000,
-					data->powernow_table[j].driver_data >> 8);
+			pr_info("fid 0x%x (%d MHz), vid 0x%x\n",
+				data->powernow_table[j].driver_data & 0xff,
+				data->powernow_table[j].frequency/1000,
+				data->powernow_table[j].driver_data >> 8);
 		}
 	}
 	if (data->batps)
-		printk(KERN_INFO PFX "Only %d pstates on battery\n",
-				data->batps);
+		pr_info("Only %d pstates on battery\n", data->batps);
 }
 
 static int fill_powernow_table(struct powernow_k8_data *data,
@@ -602,21 +577,20 @@ static int fill_powernow_table(struct powernow_k8_data *data,
 
 	if (data->batps) {
 		/* use ACPI support to get full speed on mains power */
-		printk(KERN_WARNING PFX
-			"Only %d pstates usable (use ACPI driver for full "
-			"range\n", data->batps);
+		pr_warn("Only %d pstates usable (use ACPI driver for full range\n",
+			data->batps);
 		data->numps = data->batps;
 	}
 
 	for (j = 1; j < data->numps; j++) {
 		if (pst[j-1].fid >= pst[j].fid) {
-			printk(KERN_ERR PFX "PST out of sequence\n");
+			pr_err("PST out of sequence\n");
 			return -EINVAL;
 		}
 	}
 
 	if (data->numps < 2) {
-		printk(KERN_ERR PFX "no p states to transition\n");
+		pr_err("no p states to transition\n");
 		return -ENODEV;
 	}
 
@@ -626,14 +600,16 @@ static int fill_powernow_table(struct powernow_k8_data *data,
 	powernow_table = kzalloc((sizeof(*powernow_table)
 		* (data->numps + 1)), GFP_KERNEL);
 	if (!powernow_table) {
-		printk(KERN_ERR PFX "powernow_table memory alloc failure\n");
+		pr_err("powernow_table memory alloc failure\n");
 		return -ENOMEM;
 	}
 
 	for (j = 0; j < data->numps; j++) {
 		int freq;
-		powernow_table[j].driver_data = pst[j].fid; /* lower 8 bits */
-		powernow_table[j].driver_data |= (pst[j].vid << 8); /* upper 8 bits */
+		/* lower 8 bits */
+		powernow_table[j].driver_data = pst[j].fid;
+		/* upper 8 bits */
+		powernow_table[j].driver_data |= (pst[j].vid << 8);
 		freq = find_khz_freq_from_fid(pst[j].fid);
 		powernow_table[j].frequency = freq;
 	}
@@ -681,13 +657,13 @@ static int find_psb_table(struct powernow_k8_data *data)
 
 		pr_debug("table vers: 0x%x\n", psb->tableversion);
 		if (psb->tableversion != PSB_VERSION_1_4) {
-			printk(KERN_ERR FW_BUG PFX "PSB table is not v1.4\n");
+			pr_err(FW_BUG "PSB table is not v1.4\n");
 			return -ENODEV;
 		}
 
 		pr_debug("flags: 0x%x\n", psb->flags1);
 		if (psb->flags1) {
-			printk(KERN_ERR FW_BUG PFX "unknown flags\n");
+			pr_err(FW_BUG "unknown flags\n");
 			return -ENODEV;
 		}
 
@@ -704,7 +680,8 @@ static int find_psb_table(struct powernow_k8_data *data)
 
 		pr_debug("ramp voltage offset: %d\n", data->rvo);
 		pr_debug("isochronous relief time: %d\n", data->irt);
-		pr_debug("maximum voltage step: %d - 0x%x\n", mvs, data->vidmvs);
+		pr_debug("maximum voltage step: %d - 0x%x\n", mvs,
+			 data->vidmvs);
 
 		pr_debug("numpst: 0x%x\n", psb->num_tables);
 		cpst = psb->num_tables;
@@ -716,7 +693,7 @@ static int find_psb_table(struct powernow_k8_data *data)
 				cpst = 1;
 		}
 		if (cpst != 1) {
-			printk(KERN_ERR FW_BUG PFX "numpst must be 1\n");
+			pr_err(FW_BUG "numpst must be 1\n");
 			return -ENODEV;
 		}
 
@@ -742,9 +719,8 @@ static int find_psb_table(struct powernow_k8_data *data)
 	 * BIOS and Kernel Developer's Guide, which is available on
 	 * www.amd.com
 	 */
-	printk(KERN_ERR FW_BUG PFX "No PSB or ACPI _PSS objects\n");
-	printk(KERN_ERR PFX "Make sure that your BIOS is up to date"
-		" and Cool'N'Quiet support is enabled in BIOS setup\n");
+	pr_err(FW_BUG "No PSB or ACPI _PSS objects\n");
+	pr_err("Make sure that your BIOS is up to date and Cool'N'Quiet support is enabled in BIOS setup\n");
 	return -ENODEV;
 }
 
@@ -819,8 +795,7 @@ static int powernow_k8_cpu_init_acpi(struct powernow_k8_data *data)
 	acpi_processor_notify_smm(THIS_MODULE);
 
 	if (!zalloc_cpumask_var(&data->acpi_data.shared_cpu_map, GFP_KERNEL)) {
-		printk(KERN_ERR PFX
-				"unable to alloc powernow_k8_data cpumask\n");
+		pr_err("unable to alloc powernow_k8_data cpumask\n");
 		ret_val = -ENOMEM;
 		goto err_out_mem;
 	}
@@ -885,9 +860,8 @@ static int fill_powernow_table_fidvid(struct powernow_k8_data *data,
 		}
 
 		if (freq != (data->acpi_data.states[i].core_frequency * 1000)) {
-			printk(KERN_INFO PFX "invalid freq entries "
-				"%u kHz vs. %u kHz\n", freq,
-				(unsigned int)
+			pr_info("invalid freq entries %u kHz vs. %u kHz\n",
+				freq, (unsigned int)
 				(data->acpi_data.states[i].core_frequency
 				 * 1000));
 			invalidate_entry(powernow_table, i);
@@ -916,7 +890,7 @@ static int get_transition_latency(struct powernow_k8_data *data)
 			max_latency = cur_latency;
 	}
 	if (max_latency == 0) {
-		pr_err(FW_WARN PFX "Invalid zero transition latency\n");
+		pr_err(FW_WARN "Invalid zero transition latency\n");
 		max_latency = 1;
 	}
 	/* value in usecs, needs to be in nanoseconds */
@@ -991,7 +965,7 @@ static long powernowk8_target_fn(void *arg)
 	checkvid = data->currvid;
 
 	if (pending_bit_stuck()) {
-		printk(KERN_ERR PFX "failing targ, change pending bit set\n");
+		pr_err("failing targ, change pending bit set\n");
 		return -EIO;
 	}
 
@@ -1007,8 +981,7 @@ static long powernowk8_target_fn(void *arg)
 
 	if ((checkvid != data->currvid) ||
 	    (checkfid != data->currfid)) {
-		pr_info(PFX
-		       "error - out of sync, fix 0x%x 0x%x, vid 0x%x 0x%x\n",
+		pr_info("error - out of sync, fix 0x%x 0x%x, vid 0x%x 0x%x\n",
 		       checkfid, data->currfid,
 		       checkvid, data->currvid);
 	}
@@ -1020,7 +993,7 @@ static long powernowk8_target_fn(void *arg)
 	ret = transition_frequency_fidvid(data, newstate);
 
 	if (ret) {
-		printk(KERN_ERR PFX "transition frequency failed\n");
+		pr_err("transition frequency failed\n");
 		mutex_unlock(&fidvid_mutex);
 		return 1;
 	}
@@ -1049,7 +1022,7 @@ static void powernowk8_cpu_init_on_cpu(void *_init_on_cpu)
 	struct init_on_cpu *init_on_cpu = _init_on_cpu;
 
 	if (pending_bit_stuck()) {
-		printk(KERN_ERR PFX "failing init, change pending bit set\n");
+		pr_err("failing init, change pending bit set\n");
 		init_on_cpu->rc = -ENODEV;
 		return;
 	}
@@ -1066,9 +1039,12 @@ static void powernowk8_cpu_init_on_cpu(void *_init_on_cpu)
 
 static const char missing_pss_msg[] =
 	KERN_ERR
-	FW_BUG PFX "No compatible ACPI _PSS objects found.\n"
-	FW_BUG PFX "First, make sure Cool'N'Quiet is enabled in the BIOS.\n"
-	FW_BUG PFX "If that doesn't help, try upgrading your BIOS.\n";
+	FW_BUG KBUILD_MODNAME
+	"No compatible ACPI _PSS objects found.\n"
+	FW_BUG KBUILD_MODNAME
+	"First, make sure Cool'N'Quiet is enabled in the BIOS.\n"
+	FW_BUG KBUILD_MODNAME
+	"If that doesn't help, try upgrading your BIOS.\n";
 
 /* per CPU init entry point to the driver */
 static int powernowk8_cpu_init(struct cpufreq_policy *pol)
@@ -1083,7 +1059,7 @@ static int powernowk8_cpu_init(struct cpufreq_policy *pol)
 
 	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (!data) {
-		printk(KERN_ERR PFX "unable to alloc powernow_k8_data");
+		pr_err("unable to alloc powernow_k8_data");
 		return -ENOMEM;
 	}
 
@@ -1099,9 +1075,7 @@ static int powernowk8_cpu_init(struct cpufreq_policy *pol)
 			goto err_out;
 		}
 		if (pol->cpu != 0) {
-			printk(KERN_ERR FW_BUG PFX "No ACPI _PSS objects for "
-			       "CPU other than CPU0. Complain to your BIOS "
-			       "vendor.\n");
+			pr_err(FW_BUG "No ACPI _PSS objects for CPU other than CPU0. Complain to your BIOS vendor.\n");
 			goto err_out;
 		}
 		rc = find_psb_table(data);
@@ -1129,7 +1103,7 @@ static int powernowk8_cpu_init(struct cpufreq_policy *pol)
 
 	/* min/max the cpu is capable of */
 	if (cpufreq_table_validate_and_show(pol, data->powernow_table)) {
-		printk(KERN_ERR FW_BUG PFX "invalid powernow_table\n");
+		pr_err(FW_BUG "invalid powernow_table\n");
 		powernow_k8_cpu_exit_acpi(data);
 		kfree(data->powernow_table);
 		kfree(data);
@@ -1220,12 +1194,12 @@ static void __request_acpi_cpufreq(void)
 		goto request;
 
 	if (strncmp(cur_drv, drv, min_t(size_t, strlen(cur_drv), strlen(drv))))
-		pr_warn(PFX "WTF driver: %s\n", cur_drv);
+		pr_warn("WTF driver: %s\n", cur_drv);
 
 	return;
 
  request:
-	pr_warn(PFX "This CPU is not supported anymore, using acpi-cpufreq instead.\n");
+	pr_warn("This CPU is not supported anymore, using acpi-cpufreq instead.\n");
 	request_module(drv);
 }
 
@@ -1260,7 +1234,7 @@ static int powernowk8_init(void)
 	if (ret)
 		return ret;
 
-	pr_info(PFX "Found %d %s (%d cpu cores) (" VERSION ")\n",
+	pr_info("Found %d %s (%d cpu cores) (" VERSION ")\n",
 		num_online_nodes(), boot_cpu_data.x86_model_id, supported_cpus);
 
 	return ret;
@@ -1274,8 +1248,8 @@ static void __exit powernowk8_exit(void)
 	cpufreq_unregister_driver(&cpufreq_amd64_driver);
 }
 
-MODULE_AUTHOR("Paul Devriendt <paul.devriendt@amd.com> and "
-		"Mark Langsdorf <mark.langsdorf@amd.com>");
+MODULE_AUTHOR("Paul Devriendt <paul.devriendt@amd.com>");
+MODULE_AUTHOR("Mark Langsdorf <mark.langsdorf@amd.com>");
 MODULE_DESCRIPTION("AMD Athlon 64 and Opteron processor frequency driver.");
 MODULE_LICENSE("GPL");
 
diff --git a/drivers/cpufreq/powernow-k8.h b/drivers/cpufreq/powernow-k8.h
index 79329d4..0f4aa07 100644
--- a/drivers/cpufreq/powernow-k8.h
+++ b/drivers/cpufreq/powernow-k8.h
@@ -19,7 +19,7 @@ struct powernow_k8_data {
 	u32 vidmvs;  /* usable value calculated from mvs */
 	u32 vstable; /* voltage stabilization time, units 20 us */
 	u32 plllock; /* pll lock time, units 1 us */
-        u32 exttype; /* extended interface = 1 */
+	u32 exttype; /* extended interface = 1 */
 
 	/* keep track of the current fid / vid or pstate */
 	u32 currvid;
@@ -182,9 +182,12 @@ struct pst_s {
 
 static int core_voltage_pre_transition(struct powernow_k8_data *data,
 	u32 reqvid, u32 regfid);
-static int core_voltage_post_transition(struct powernow_k8_data *data, u32 reqvid);
+static int core_voltage_post_transition(struct powernow_k8_data *data,
+					u32 reqvid);
 static int core_frequency_transition(struct powernow_k8_data *data, u32 reqfid);
 
-static void powernow_k8_acpi_pst_values(struct powernow_k8_data *data, unsigned int index);
+static void powernow_k8_acpi_pst_values(struct powernow_k8_data *data,
+					unsigned int index);
 
-static int fill_powernow_table_fidvid(struct powernow_k8_data *data, struct cpufreq_frequency_table *powernow_table);
+static int fill_powernow_table_fidvid(struct powernow_k8_data *data,
+			struct cpufreq_frequency_table *powernow_table);
-- 
1.9.0
