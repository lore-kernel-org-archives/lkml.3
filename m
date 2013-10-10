Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289Ab3JJF4D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 01:56:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:30735 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751215Ab3JJF4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 01:56:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1069,1371106800"; 
   d="scan'208";a="417008912"
From: David Cohen <david.a.cohen@linux.intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        platform-driver-x86@vger.kernel.org,
        Kuppuswamy Sathyanarayanan 
	<sathyanarayanan.kuppuswamy@linux.intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCH v2 01/10] mrst: Fixed printk/pr_* related issues
Date: Wed,  9 Oct 2013 22:59:58 -0700
Message-Id: <1381384807-14146-2-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1381384807-14146-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1381384807-14146-1-git-send-email-david.a.cohen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>

Fixed printk and pr_* related issues in mrst related files.

Signed-off-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
---
 arch/x86/platform/mrst/early_printk_mrst.c |    2 +-
 arch/x86/platform/mrst/mrst.c              |    2 +-
 arch/x86/platform/mrst/vrtc.c              |    5 ++---
 3 files changed, 4 insertions(+), 5 deletions(-)

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
index 3ca5957..b9aeb54 100644
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
index 5e355b1..ca4f7d9 100644
--- a/arch/x86/platform/mrst/vrtc.c
+++ b/arch/x86/platform/mrst/vrtc.c
@@ -79,7 +79,7 @@ void vrtc_get_time(struct timespec *now)
 	/* vRTC YEAR reg contains the offset to 1972 */
 	year += 1972;
 
-	printk(KERN_INFO "vRTC: sec: %d min: %d hour: %d day: %d "
+	pr_info("vRTC: sec: %d min: %d hour: %d day: %d "
 		"mon: %d year: %d\n", sec, min, hour, mday, mon, year);
 
 	now->tv_sec = mktime(year, mon, mday, hour, min, sec);
@@ -109,8 +109,7 @@ int vrtc_set_mmss(const struct timespec *now)
 		vrtc_cmos_write(tm.tm_sec, RTC_SECONDS);
 		spin_unlock_irqrestore(&rtc_lock, flags);
 	} else {
-		printk(KERN_ERR
-		       "%s: Invalid vRTC value: write of %lx to vRTC failed\n",
+		pr_err("%s: Invalid vRTC value: write of %lx to vRTC failed\n",
 			__FUNCTION__, now->tv_sec);
 		retval = -EINVAL;
 	}
-- 
1.7.9.5

