Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749AbaCYTfZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 15:35:25 -0400
Received: from smtprelay0205.hostedemail.com ([216.40.44.205]:55196 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753770AbaCYTfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 15:35:20 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:1801:2198:2199:2393:2559:2562:3138:3139:3140:3141:3142:3352:3865:3866:3867:4250:4321:4605:5007:6117:6119:6261:10004:10026:10848:11026:11233:11657:11658:11914:12043:12438:12517:12519:12555:12691:12737:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: camp50_111e6d93ea04b
X-Filterd-Recvd-Size: 2811
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: "Venkatesh Pallipadi (Venki)" <venki@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [PATCH 2/5] x86: Convert last uses of __FUNCTION__ to __func__
Date: Tue, 25 Mar 2014 12:35:04 -0700
Message-Id: <f85b0d53be92e0b7f2c2aa5fdc572c1bc3ad624c.1395775901.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1395775901.git.joe@perches.com>
References: <cover.1395775901.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just about all of these have been converted to __func__,
so convert the last uses.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/x86/kernel/hpet.c                       | 2 +-
 arch/x86/kernel/rtc.c                        | 4 ++--
 arch/x86/platform/intel-mid/intel_mid_vrtc.c | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 55db6a2..2e8a506 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -171,7 +171,7 @@ static void _hpet_print_config(const char *function, int line)
 #define hpet_print_config()					\
 do {								\
 	if (hpet_verbose)					\
-		_hpet_print_config(__FUNCTION__, __LINE__);	\
+		_hpet_print_config(__func__, __LINE__);		\
 } while (0)
 
 /*
diff --git a/arch/x86/kernel/rtc.c b/arch/x86/kernel/rtc.c
index ca9622a..05d91d5 100644
--- a/arch/x86/kernel/rtc.c
+++ b/arch/x86/kernel/rtc.c
@@ -49,11 +49,11 @@ int mach_set_rtc_mmss(const struct timespec *now)
 		retval = set_rtc_time(&tm);
 		if (retval)
 			printk(KERN_ERR "%s: RTC write failed with error %d\n",
-			       __FUNCTION__, retval);
+			       __func__, retval);
 	} else {
 		printk(KERN_ERR
 		       "%s: Invalid RTC value: write of %lx to RTC failed\n",
-			__FUNCTION__, nowtime);
+		       __func__, nowtime);
 		retval = -EINVAL;
 	}
 	return retval;
diff --git a/arch/x86/platform/intel-mid/intel_mid_vrtc.c b/arch/x86/platform/intel-mid/intel_mid_vrtc.c
index 4762cff..cb595ad 100644
--- a/arch/x86/platform/intel-mid/intel_mid_vrtc.c
+++ b/arch/x86/platform/intel-mid/intel_mid_vrtc.c
@@ -110,7 +110,7 @@ int vrtc_set_mmss(const struct timespec *now)
 		spin_unlock_irqrestore(&rtc_lock, flags);
 	} else {
 		pr_err("%s: Invalid vRTC value: write of %lx to vRTC failed\n",
-			__FUNCTION__, now->tv_sec);
+		       __func__, now->tv_sec);
 		retval = -EINVAL;
 	}
 	return retval;
-- 
1.8.1.2.459.gbcd45b4.dirty

