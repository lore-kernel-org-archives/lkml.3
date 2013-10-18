Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864Ab3JRAds (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 20:33:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50150 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756607Ab3JRAdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 20:33:47 -0400
Date: Thu, 17 Oct 2013 17:33:28 -0700
From: tip-bot for Kuppuswamy Sathyanarayanan <tipbot@zytor.com>
Message-ID: <tip-001d4c7aea587ce0865c07ec45aa56ecbefd431a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        david.a.cohen@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        david.a.cohen@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1382049336-21316-2-git-send-email-david.a.cohen@linux.intel.com>
References: <1382049336-21316-2-git-send-email-david.a.cohen@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/intel-mid] mrst: Fixed printk/pr_* related issues
Git-Commit-ID: 001d4c7aea587ce0865c07ec45aa56ecbefd431a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 17 Oct 2013 17:33:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  001d4c7aea587ce0865c07ec45aa56ecbefd431a
Gitweb:     http://git.kernel.org/tip/001d4c7aea587ce0865c07ec45aa56ecbefd431a
Author:     Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
AuthorDate: Thu, 17 Oct 2013 15:35:25 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 17 Oct 2013 16:40:33 -0700

mrst: Fixed printk/pr_* related issues

Fixed printk and pr_* related issues in mrst related files.

Signed-off-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Link: http://lkml.kernel.org/r/1382049336-21316-2-git-send-email-david.a.cohen@linux.intel.com
Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/platform/mrst/early_printk_mrst.c | 2 +-
 arch/x86/platform/mrst/mrst.c              | 2 +-
 arch/x86/platform/mrst/vrtc.c              | 5 ++---
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
