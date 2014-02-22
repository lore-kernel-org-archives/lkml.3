Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913AbaBVI2m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 03:28:42 -0500
Received: from sauhun.de ([89.238.76.85]:59818 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736AbaBVI2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 03:28:40 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Magnus Damm <magnus.damm@gmail.com>, kbuild-all@01.org,
        daniel.lezcano@linaro.org, Wolfram Sang <wsa@the-dreams.de>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
Subject: [PATCH] avr32: remove cpu_data macro to fix compiles
Date: Sat, 22 Feb 2014 09:28:27 +0100
Message-Id: <1393057709-17925-1-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <53060d5d.XcmAdOiLt1MCo6Y5%fengguang.wu@intel.com>
References: <53060d5d.XcmAdOiLt1MCo6Y5%fengguang.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Having cpu_data as a parameterless macro can easily cause build failures
because it can be a variable name like in linux/pm_domain.h [1]. So,
remove the macro and convert its only user. Because this architecture
cannot do SMP, remove the whole SMP block, too. Only compile tested due
to no hardware.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>

[1] https://lists.01.org/pipermail/kbuild-all/2014-February/003252.html
---

 arch/avr32/include/asm/bugs.h      | 2 +-
 arch/avr32/include/asm/processor.h | 7 +------
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/arch/avr32/include/asm/bugs.h b/arch/avr32/include/asm/bugs.h
index 7635e77..278661b 100644
--- a/arch/avr32/include/asm/bugs.h
+++ b/arch/avr32/include/asm/bugs.h
@@ -9,7 +9,7 @@
 
 static void __init check_bugs(void)
 {
-	cpu_data->loops_per_jiffy = loops_per_jiffy;
+	boot_cpu_data.loops_per_jiffy = loops_per_jiffy;
 }
 
 #endif /* __ASM_AVR32_BUGS_H */
diff --git a/arch/avr32/include/asm/processor.h b/arch/avr32/include/asm/processor.h
index 48d71c5..972adcc 100644
--- a/arch/avr32/include/asm/processor.h
+++ b/arch/avr32/include/asm/processor.h
@@ -83,13 +83,8 @@ static inline unsigned int avr32_get_chip_revision(struct avr32_cpuinfo *cpu)
 
 extern struct avr32_cpuinfo boot_cpu_data;
 
-#ifdef CONFIG_SMP
-extern struct avr32_cpuinfo cpu_data[];
-#define current_cpu_data cpu_data[smp_processor_id()]
-#else
-#define cpu_data (&boot_cpu_data)
+/* No SMP support so far */
 #define current_cpu_data boot_cpu_data
-#endif
 
 /* This decides where the kernel will search for a free chunk of vm
  * space during mmap's
-- 
1.8.5.1

