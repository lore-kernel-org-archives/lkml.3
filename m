Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759546AbaGDS7y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 14:59:54 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:20657 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752536AbaGDS7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 14:59:53 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvAMAAj5tlNbsGwr/2dsb2JhbABagw6scAUBAQEBAQEFAW4BmWeBCxd1hGAjgRo3iEYBtU6VIIVwiTIdhC0FmnaLTIhAg0U7
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org
Subject: [PATCH 1/1] arch: x86: use PTR_ERR_OR_ZERO
Date: Fri,  4 Jul 2014 20:59:48 +0200
Message-Id: <1404500388-21626-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

replace IS_ERR/PTR_ERR

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 arch/x86/kernel/cpuid.c          | 2 +-
 arch/x86/kernel/msr.c            | 2 +-
 arch/x86/kernel/pcspeaker.c      | 2 +-
 arch/x86/kernel/sysfb.c          | 2 +-
 arch/x86/kernel/sysfb_simplefb.c | 4 +---
 5 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpuid.c b/arch/x86/kernel/cpuid.c
index 3225ae6c..83741a7 100644
--- a/arch/x86/kernel/cpuid.c
+++ b/arch/x86/kernel/cpuid.c
@@ -143,7 +143,7 @@ static int cpuid_device_create(int cpu)
 
 	dev = device_create(cpuid_class, NULL, MKDEV(CPUID_MAJOR, cpu), NULL,
 			    "cpu%d", cpu);
-	return IS_ERR(dev) ? PTR_ERR(dev) : 0;
+	return PTR_ERR_OR_ZERO(dev);
 }
 
 static void cpuid_device_destroy(int cpu)
diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
index c9603ac..6e4f77f 100644
--- a/arch/x86/kernel/msr.c
+++ b/arch/x86/kernel/msr.c
@@ -206,7 +206,7 @@ static int msr_device_create(int cpu)
 
 	dev = device_create(msr_class, NULL, MKDEV(MSR_MAJOR, cpu), NULL,
 			    "msr%d", cpu);
-	return IS_ERR(dev) ? PTR_ERR(dev) : 0;
+	return PTR_ERR_OR_ZERO(dev);
 }
 
 static void msr_device_destroy(int cpu)
diff --git a/arch/x86/kernel/pcspeaker.c b/arch/x86/kernel/pcspeaker.c
index a311ffc..b04ee2c 100644
--- a/arch/x86/kernel/pcspeaker.c
+++ b/arch/x86/kernel/pcspeaker.c
@@ -8,6 +8,6 @@ static __init int add_pcspkr(void)
 
 	pd = platform_device_register_simple("pcspkr", -1, NULL, 0);
 
-	return IS_ERR(pd) ? PTR_ERR(pd) : 0;
+	return PTR_ERR_OR_ZERO(pd);
 }
 device_initcall(add_pcspkr);
diff --git a/arch/x86/kernel/sysfb.c b/arch/x86/kernel/sysfb.c
index 193ec2c..160386e 100644
--- a/arch/x86/kernel/sysfb.c
+++ b/arch/x86/kernel/sysfb.c
@@ -67,7 +67,7 @@ static __init int sysfb_init(void)
 
 	pd = platform_device_register_resndata(NULL, name, 0,
 					       NULL, 0, si, sizeof(*si));
-	return IS_ERR(pd) ? PTR_ERR(pd) : 0;
+	return PTR_ERR_OR_ZERO(pd);
 }
 
 /* must execute after PCI subsystem for EFI quirks */
diff --git a/arch/x86/kernel/sysfb_simplefb.c b/arch/x86/kernel/sysfb_simplefb.c
index 86179d4..088f58b 100644
--- a/arch/x86/kernel/sysfb_simplefb.c
+++ b/arch/x86/kernel/sysfb_simplefb.c
@@ -88,8 +88,6 @@ __init int create_simplefb(const struct screen_info *si,
 
 	pd = platform_device_register_resndata(NULL, "simple-framebuffer", 0,
 					       &res, 1, mode, sizeof(*mode));
-	if (IS_ERR(pd))
-		return PTR_ERR(pd);
 
-	return 0;
+	return PTR_ERR_OR_ZERO(pd);
 }
-- 
1.9.1

