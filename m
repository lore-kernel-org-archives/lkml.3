Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751439AbaJDQus (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 12:50:48 -0400
Received: from smtprelay0103.hostedemail.com ([216.40.44.103]:53240 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750862AbaJDQuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 12:50:46 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:1:41:69:355:379:541:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1461:1515:1516:1518:1593:1594:1605:1730:1747:1777:1792:1981:2194:2199:2393:2559:2562:2640:2828:2904:3138:3139:3140:3141:3142:3865:3866:3867:3870:3871:4250:4321:4605:5007:6119:7652:8603:8957:9038:9040:10004:10848:11026:11473:11657:11658:11914:12043:12296:12438:12517:12519:12555:12679:12683:12729:12737:13972:14110:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: brass52_40a7e4956ee59
X-Filterd-Recvd-Size: 14731
Message-ID: <1412441442.3247.138.camel@joe-AO725>
Subject: [PATCH] mips: Convert pr_warning to pr_warn
From: Joe Perches <joe@perches.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips <linux-mips@linux-mips.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Sat, 04 Oct 2014 09:50:42 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the much more common pr_warn instead of pr_warning
with the goal of removing pr_warning eventually.

Other miscellanea:

o Coalesce formats
o Realign arguments

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/mips/ar7/platform.c                | 24 ++++++------
 arch/mips/include/asm/octeon/cvmx-pow.h | 69 +++++++++++++--------------------
 arch/mips/kernel/crash_dump.c           |  4 +-
 arch/mips/kernel/perf_event_mipsxx.c    |  7 ++--
 arch/mips/kernel/setup.c                |  2 +-
 arch/mips/pci/pci-tx4939.c              |  2 +-
 arch/mips/txx9/generic/setup_tx4927.c   |  4 +-
 arch/mips/txx9/generic/setup_tx4938.c   |  4 +-
 arch/mips/txx9/generic/setup_tx4939.c   |  4 +-
 9 files changed, 52 insertions(+), 68 deletions(-)

diff --git a/arch/mips/ar7/platform.c b/arch/mips/ar7/platform.c
index 7e2356f..af2441d 100644
--- a/arch/mips/ar7/platform.c
+++ b/arch/mips/ar7/platform.c
@@ -311,8 +311,7 @@ static void __init cpmac_get_mac(int instance, unsigned char *dev_addr)
 					&dev_addr[0], &dev_addr[1],
 					&dev_addr[2], &dev_addr[3],
 					&dev_addr[4], &dev_addr[5]) != 6) {
-			pr_warning("cannot parse mac address, "
-					"using random address\n");
+			pr_warn("cannot parse mac address, using random address\n");
 			eth_random_addr(dev_addr);
 		}
 	} else
@@ -665,7 +664,7 @@ static int __init ar7_register_devices(void)
 
 	res = platform_device_register(&physmap_flash);
 	if (res)
-		pr_warning("unable to register physmap-flash: %d\n", res);
+		pr_warn("unable to register physmap-flash: %d\n", res);
 
 	if (ar7_is_titan())
 		titan_fixup_devices();
@@ -673,13 +672,13 @@ static int __init ar7_register_devices(void)
 	ar7_device_disable(vlynq_low_data.reset_bit);
 	res = platform_device_register(&vlynq_low);
 	if (res)
-		pr_warning("unable to register vlynq-low: %d\n", res);
+		pr_warn("unable to register vlynq-low: %d\n", res);
 
 	if (ar7_has_high_vlynq()) {
 		ar7_device_disable(vlynq_high_data.reset_bit);
 		res = platform_device_register(&vlynq_high);
 		if (res)
-			pr_warning("unable to register vlynq-high: %d\n", res);
+			pr_warn("unable to register vlynq-high: %d\n", res);
 	}
 
 	if (ar7_has_high_cpmac()) {
@@ -689,9 +688,10 @@ static int __init ar7_register_devices(void)
 
 			res = platform_device_register(&cpmac_high);
 			if (res)
-				pr_warning("unable to register cpmac-high: %d\n", res);
+				pr_warn("unable to register cpmac-high: %d\n",
+					res);
 		} else
-			pr_warning("unable to add cpmac-high phy: %d\n", res);
+			pr_warn("unable to add cpmac-high phy: %d\n", res);
 	} else
 		cpmac_low_data.phy_mask = 0xffffffff;
 
@@ -700,18 +700,18 @@ static int __init ar7_register_devices(void)
 		cpmac_get_mac(0, cpmac_low_data.dev_addr);
 		res = platform_device_register(&cpmac_low);
 		if (res)
-			pr_warning("unable to register cpmac-low: %d\n", res);
+			pr_warn("unable to register cpmac-low: %d\n", res);
 	} else
-		pr_warning("unable to add cpmac-low phy: %d\n", res);
+		pr_warn("unable to add cpmac-low phy: %d\n", res);
 
 	detect_leds();
 	res = platform_device_register(&ar7_gpio_leds);
 	if (res)
-		pr_warning("unable to register leds: %d\n", res);
+		pr_warn("unable to register leds: %d\n", res);
 
 	res = platform_device_register(&ar7_udc);
 	if (res)
-		pr_warning("unable to register usb slave: %d\n", res);
+		pr_warn("unable to register usb slave: %d\n", res);
 
 	/* Register watchdog only if enabled in hardware */
 	bootcr = ioremap_nocache(AR7_REGS_DCL, 4);
@@ -726,7 +726,7 @@ static int __init ar7_register_devices(void)
 		ar7_wdt_res.end = ar7_wdt_res.start + 0x20;
 		res = platform_device_register(&ar7_wdt);
 		if (res)
-			pr_warning("unable to register watchdog: %d\n", res);
+			pr_warn("unable to register watchdog: %d\n", res);
 	}
 
 	return 0;
diff --git a/arch/mips/include/asm/octeon/cvmx-pow.h b/arch/mips/include/asm/octeon/cvmx-pow.h
index 4b4d0ec..2188e65 100644
--- a/arch/mips/include/asm/octeon/cvmx-pow.h
+++ b/arch/mips/include/asm/octeon/cvmx-pow.h
@@ -1066,7 +1066,7 @@ static inline void __cvmx_pow_warn_if_pending_switch(const char *function)
 	uint64_t switch_complete;
 	CVMX_MF_CHORD(switch_complete);
 	if (!switch_complete)
-		pr_warning("%s called with tag switch in progress\n", function);
+		pr_warn("%s called with tag switch in progress\n", function);
 }
 
 /**
@@ -1084,8 +1084,7 @@ static inline void cvmx_pow_tag_sw_wait(void)
 		if (unlikely(switch_complete))
 			break;
 		if (unlikely(cvmx_get_cycle() > start_cycle + MAX_CYCLES)) {
-			pr_warning("Tag switch is taking a long time, "
-				   "possible deadlock\n");
+			pr_warn("Tag switch is taking a long time, possible deadlock\n");
 			start_cycle = -MAX_CYCLES - 1;
 		}
 	}
@@ -1296,19 +1295,16 @@ static inline void cvmx_pow_tag_sw_nocheck(uint32_t tag,
 		__cvmx_pow_warn_if_pending_switch(__func__);
 		current_tag = cvmx_pow_get_current_tag();
 		if (current_tag.s.type == CVMX_POW_TAG_TYPE_NULL_NULL)
-			pr_warning("%s called with NULL_NULL tag\n",
-				   __func__);
+			pr_warn("%s called with NULL_NULL tag\n", __func__);
 		if (current_tag.s.type == CVMX_POW_TAG_TYPE_NULL)
-			pr_warning("%s called with NULL tag\n", __func__);
+			pr_warn("%s called with NULL tag\n", __func__);
 		if ((current_tag.s.type == tag_type)
 		   && (current_tag.s.tag == tag))
-			pr_warning("%s called to perform a tag switch to the "
-				   "same tag\n",
-			     __func__);
+			pr_warn("%s called to perform a tag switch to the same tag\n",
+				__func__);
 		if (tag_type == CVMX_POW_TAG_TYPE_NULL)
-			pr_warning("%s called to perform a tag switch to "
-				   "NULL. Use cvmx_pow_tag_sw_null() instead\n",
-			     __func__);
+			pr_warn("%s called to perform a tag switch to NULL. Use cvmx_pow_tag_sw_null() instead\n",
+				__func__);
 	}
 
 	/*
@@ -1407,23 +1403,19 @@ static inline void cvmx_pow_tag_sw_full_nocheck(cvmx_wqe_t *wqp, uint32_t tag,
 		__cvmx_pow_warn_if_pending_switch(__func__);
 		current_tag = cvmx_pow_get_current_tag();
 		if (current_tag.s.type == CVMX_POW_TAG_TYPE_NULL_NULL)
-			pr_warning("%s called with NULL_NULL tag\n",
-				   __func__);
+			pr_warn("%s called with NULL_NULL tag\n", __func__);
 		if ((current_tag.s.type == tag_type)
 		   && (current_tag.s.tag == tag))
-			pr_warning("%s called to perform a tag switch to "
-				   "the same tag\n",
-			     __func__);
+			pr_warn("%s called to perform a tag switch to the same tag\n",
+				__func__);
 		if (tag_type == CVMX_POW_TAG_TYPE_NULL)
-			pr_warning("%s called to perform a tag switch to "
-				   "NULL. Use cvmx_pow_tag_sw_null() instead\n",
-			     __func__);
+			pr_warn("%s called to perform a tag switch to NULL. Use cvmx_pow_tag_sw_null() instead\n",
+				__func__);
 		if (wqp != cvmx_phys_to_ptr(0x80))
 			if (wqp != cvmx_pow_get_current_wqp())
-				pr_warning("%s passed WQE(%p) doesn't match "
-					   "the address in the POW(%p)\n",
-				     __func__, wqp,
-				     cvmx_pow_get_current_wqp());
+				pr_warn("%s passed WQE(%p) doesn't match the address in the POW(%p)\n",
+					__func__, wqp,
+					cvmx_pow_get_current_wqp());
 	}
 
 	/*
@@ -1507,12 +1499,10 @@ static inline void cvmx_pow_tag_sw_null_nocheck(void)
 		__cvmx_pow_warn_if_pending_switch(__func__);
 		current_tag = cvmx_pow_get_current_tag();
 		if (current_tag.s.type == CVMX_POW_TAG_TYPE_NULL_NULL)
-			pr_warning("%s called with NULL_NULL tag\n",
-				   __func__);
+			pr_warn("%s called with NULL_NULL tag\n", __func__);
 		if (current_tag.s.type == CVMX_POW_TAG_TYPE_NULL)
-			pr_warning("%s called when we already have a "
-				   "NULL tag\n",
-			     __func__);
+			pr_warn("%s called when we already have a NULL tag\n",
+				__func__);
 	}
 
 	tag_req.u64 = 0;
@@ -1725,17 +1715,14 @@ static inline void cvmx_pow_tag_sw_desched_nocheck(
 		__cvmx_pow_warn_if_pending_switch(__func__);
 		current_tag = cvmx_pow_get_current_tag();
 		if (current_tag.s.type == CVMX_POW_TAG_TYPE_NULL_NULL)
-			pr_warning("%s called with NULL_NULL tag\n",
-				   __func__);
+			pr_warn("%s called with NULL_NULL tag\n", __func__);
 		if (current_tag.s.type == CVMX_POW_TAG_TYPE_NULL)
-			pr_warning("%s called with NULL tag. Deschedule not "
-				   "allowed from NULL state\n",
-			     __func__);
+			pr_warn("%s called with NULL tag. Deschedule not allowed from NULL state\n",
+				__func__);
 		if ((current_tag.s.type != CVMX_POW_TAG_TYPE_ATOMIC)
 			&& (tag_type != CVMX_POW_TAG_TYPE_ATOMIC))
-			pr_warning("%s called where neither the before or "
-				   "after tag is ATOMIC\n",
-			     __func__);
+			pr_warn("%s called where neither the before or after tag is ATOMIC\n",
+				__func__);
 	}
 
 	tag_req.u64 = 0;
@@ -1832,12 +1819,10 @@ static inline void cvmx_pow_desched(uint64_t no_sched)
 		__cvmx_pow_warn_if_pending_switch(__func__);
 		current_tag = cvmx_pow_get_current_tag();
 		if (current_tag.s.type == CVMX_POW_TAG_TYPE_NULL_NULL)
-			pr_warning("%s called with NULL_NULL tag\n",
-				   __func__);
+			pr_warn("%s called with NULL_NULL tag\n", __func__);
 		if (current_tag.s.type == CVMX_POW_TAG_TYPE_NULL)
-			pr_warning("%s called with NULL tag. Deschedule not "
-				   "expected from NULL state\n",
-			     __func__);
+			pr_warn("%s called with NULL tag. Deschedule not expected from NULL state\n",
+				__func__);
 	}
 
 	/* Need to make sure any writes to the work queue entry are complete */
diff --git a/arch/mips/kernel/crash_dump.c b/arch/mips/kernel/crash_dump.c
index f291cf9..6fe7790 100644
--- a/arch/mips/kernel/crash_dump.c
+++ b/arch/mips/kernel/crash_dump.c
@@ -38,7 +38,7 @@ ssize_t copy_oldmem_page(unsigned long pfn, char *buf,
 		kunmap_atomic(vaddr);
 	} else {
 		if (!kdump_buf_page) {
-			pr_warning("Kdump: Kdump buffer page not allocated\n");
+			pr_warn("Kdump: Kdump buffer page not allocated\n");
 
 			return -EFAULT;
 		}
@@ -57,7 +57,7 @@ static int __init kdump_buf_page_init(void)
 
 	kdump_buf_page = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!kdump_buf_page) {
-		pr_warning("Kdump: Failed to allocate kdump buffer page\n");
+		pr_warn("Kdump: Failed to allocate kdump buffer page\n");
 		ret = -ENOMEM;
 	}
 
diff --git a/arch/mips/kernel/perf_event_mipsxx.c b/arch/mips/kernel/perf_event_mipsxx.c
index a8f9cdc..7633d30 100644
--- a/arch/mips/kernel/perf_event_mipsxx.c
+++ b/arch/mips/kernel/perf_event_mipsxx.c
@@ -561,8 +561,8 @@ static int mipspmu_get_irq(void)
 			IRQF_PERCPU | IRQF_NOBALANCING | IRQF_NO_THREAD,
 			"mips_perf_pmu", NULL);
 		if (err) {
-			pr_warning("Unable to request IRQ%d for MIPS "
-			   "performance counters!\n", mipspmu.irq);
+			pr_warn("Unable to request IRQ%d for MIPS performance counters!\n",
+				mipspmu.irq);
 		}
 	} else if (cp0_perfcount_irq < 0) {
 		/*
@@ -572,8 +572,7 @@ static int mipspmu_get_irq(void)
 		perf_irq = mipsxx_pmu_handle_shared_irq;
 		err = 0;
 	} else {
-		pr_warning("The platform hasn't properly defined its "
-			"interrupt controller.\n");
+		pr_warn("The platform hasn't properly defined its interrupt controller\n");
 		err = -ENOENT;
 	}
 
diff --git a/arch/mips/kernel/setup.c b/arch/mips/kernel/setup.c
index b3b8f0d..938f157 100644
--- a/arch/mips/kernel/setup.c
+++ b/arch/mips/kernel/setup.c
@@ -89,7 +89,7 @@ void __init add_memory_region(phys_t start, phys_t size, long type)
 
 	/* Sanity check */
 	if (start + size < start) {
-		pr_warning("Trying to add an invalid memory region, skipped\n");
+		pr_warn("Trying to add an invalid memory region, skipped\n");
 		return;
 	}
 
diff --git a/arch/mips/pci/pci-tx4939.c b/arch/mips/pci/pci-tx4939.c
index c10fbf2..cd8ed09 100644
--- a/arch/mips/pci/pci-tx4939.c
+++ b/arch/mips/pci/pci-tx4939.c
@@ -103,5 +103,5 @@ void __init tx4939_setup_pcierr_irq(void)
 			tx4927_pcierr_interrupt,
 			0, "PCI error",
 			(void *)TX4939_PCIC_REG))
-		pr_warning("Failed to request irq for PCIERR\n");
+		pr_warn("Failed to request irq for PCIERR\n");
 }
diff --git a/arch/mips/txx9/generic/setup_tx4927.c b/arch/mips/txx9/generic/setup_tx4927.c
index e714d6c..a4664cb 100644
--- a/arch/mips/txx9/generic/setup_tx4927.c
+++ b/arch/mips/txx9/generic/setup_tx4927.c
@@ -29,8 +29,8 @@ static void __init tx4927_wdr_init(void)
 {
 	/* report watchdog reset status */
 	if (____raw_readq(&tx4927_ccfgptr->ccfg) & TX4927_CCFG_WDRST)
-		pr_warning("Watchdog reset detected at 0x%lx\n",
-			   read_c0_errorepc());
+		pr_warn("Watchdog reset detected at 0x%lx\n",
+			read_c0_errorepc());
 	/* clear WatchDogReset (W1C) */
 	tx4927_ccfg_set(TX4927_CCFG_WDRST);
 	/* do reset on watchdog */
diff --git a/arch/mips/txx9/generic/setup_tx4938.c b/arch/mips/txx9/generic/setup_tx4938.c
index 0a3bf2d..58cdb2a 100644
--- a/arch/mips/txx9/generic/setup_tx4938.c
+++ b/arch/mips/txx9/generic/setup_tx4938.c
@@ -31,8 +31,8 @@ static void __init tx4938_wdr_init(void)
 {
 	/* report watchdog reset status */
 	if (____raw_readq(&tx4938_ccfgptr->ccfg) & TX4938_CCFG_WDRST)
-		pr_warning("Watchdog reset detected at 0x%lx\n",
-			   read_c0_errorepc());
+		pr_warn("Watchdog reset detected at 0x%lx\n",
+			read_c0_errorepc());
 	/* clear WatchDogReset (W1C) */
 	tx4938_ccfg_set(TX4938_CCFG_WDRST);
 	/* do reset on watchdog */
diff --git a/arch/mips/txx9/generic/setup_tx4939.c b/arch/mips/txx9/generic/setup_tx4939.c
index b7eccbd..e3733cd 100644
--- a/arch/mips/txx9/generic/setup_tx4939.c
+++ b/arch/mips/txx9/generic/setup_tx4939.c
@@ -35,8 +35,8 @@ static void __init tx4939_wdr_init(void)
 {
 	/* report watchdog reset status */
 	if (____raw_readq(&tx4939_ccfgptr->ccfg) & TX4939_CCFG_WDRST)
-		pr_warning("Watchdog reset detected at 0x%lx\n",
-			   read_c0_errorepc());
+		pr_warn("Watchdog reset detected at 0x%lx\n",
+			read_c0_errorepc());
 	/* clear WatchDogReset (W1C) */
 	tx4939_ccfg_set(TX4939_CCFG_WDRST);
 	/* do reset on watchdog */


