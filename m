Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967373Ab3E3DDt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 23:03:49 -0400
Received: from mga03.intel.com ([143.182.124.21]:16462 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756978Ab3E3DDn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 23:03:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,768,1363158000"; 
   d="scan'208";a="342312620"
From: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
To: x86@kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, lenb@kernel.org,
        linux-kernel@vger.kernel.org, mark.gross@intel.com,
        len.brown@intel.com, david.a.cohen@intel.com, fei.yang@intel.com,
        sathyanarayanan.kuppuswamy@intel.com
Subject: [PATCH v1 01/13] mrst: Fixed printk/pr_* related issues
Date: Wed, 29 May 2013 19:45:11 -0700
Message-Id: <1369881923-27067-2-git-send-email-sathyanarayanan.kuppuswamy@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1369881923-27067-1-git-send-email-sathyanarayanan.kuppuswamy@intel.com>
References: <1369881923-27067-1-git-send-email-sathyanarayanan.kuppuswamy@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed printk and pr_* related issues in mrst related files.

Change-Id: I7dafe04f1cd6a0ee2c97672b98441ade5b2000a7
Signed-off-by: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
---
 arch/x86/pci/mrst.c                        |    2 +-
 arch/x86/platform/mrst/early_printk_mrst.c |    2 +-
 arch/x86/platform/mrst/mrst.c              |    2 +-
 arch/x86/platform/mrst/vrtc.c              |    5 ++---
 4 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/pci/mrst.c b/arch/x86/pci/mrst.c
index 6eb18c4..a08cf1b 100644
--- a/arch/x86/pci/mrst.c
+++ b/arch/x86/pci/mrst.c
@@ -235,7 +235,7 @@ struct pci_ops pci_mrst_ops = {
  */
 int __init pci_mrst_init(void)
 {
-	printk(KERN_INFO "Intel MID platform detected, using MID PCI ops\n");
+	pr_info("Intel MID platform detected, using MID PCI ops\n");
 	pci_mmcfg_late_init();
 	pcibios_enable_irq = mrst_pci_irq_enable;
 	pci_root_ops = pci_mrst_ops;
diff --git a/arch/x86/platform/mrst/early_printk_mrst.c b/arch/x86/platform/mrst/early_printk_mrst.c
index 028454f..95880f7 100644
--- a/arch/x86/platform/mrst/early_printk_mrst.c
+++ b/arch/x86/platform/mrst/early_printk_mrst.c
@@ -213,7 +213,7 @@ static void early_mrst_spi_putc(char c)
 	}
 
 	if (!timeout)
-		pr_warning("MRST earlycon: timed out\n");
+		pr_warn("MRST earlycon: timed out\n");
 	else
 		max3110_write_data(c);
 }
diff --git a/arch/x86/platform/mrst/mrst.c b/arch/x86/platform/mrst/mrst.c
index a0a0a43..fbfbe36 100644
--- a/arch/x86/platform/mrst/mrst.c
+++ b/arch/x86/platform/mrst/mrst.c
@@ -328,7 +328,7 @@ static inline int __init setup_x86_mrst_timer(char *arg)
 	else if (strcmp("lapic_and_apbt", arg) == 0)
 		mrst_timer_options = MRST_TIMER_LAPIC_APBT;
 	else {
-		pr_warning("X86 MRST timer option %s not recognised"
+		pr_warn("X86 MRST timer option %s not recognised"
 			   " use x86_mrst_timer=apbt_only or lapic_and_apbt\n",
 			   arg);
 		return -EINVAL;
diff --git a/arch/x86/platform/mrst/vrtc.c b/arch/x86/platform/mrst/vrtc.c
index d62b0a3..d735deb 100644
--- a/arch/x86/platform/mrst/vrtc.c
+++ b/arch/x86/platform/mrst/vrtc.c
@@ -79,7 +79,7 @@ unsigned long vrtc_get_time(void)
 	/* vRTC YEAR reg contains the offset to 1972 */
 	year += 1972;
 
-	printk(KERN_INFO "vRTC: sec: %d min: %d hour: %d day: %d "
+	pr_info("vRTC: sec: %d min: %d hour: %d day: %d "
 		"mon: %d year: %d\n", sec, min, hour, mday, mon, year);
 
 	return mktime(year, mon, mday, hour, min, sec);
@@ -108,8 +108,7 @@ int vrtc_set_mmss(unsigned long nowtime)
 		vrtc_cmos_write(tm.tm_sec, RTC_SECONDS);
 		spin_unlock_irqrestore(&rtc_lock, flags);
 	} else {
-		printk(KERN_ERR
-		       "%s: Invalid vRTC value: write of %lx to vRTC failed\n",
+		pr_err("%s: Invalid vRTC value: write of %lx to vRTC failed\n",
 			__FUNCTION__, nowtime);
 		retval = -EINVAL;
 	}
-- 
1.7.9.5

