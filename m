Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659AbaB0LMv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 06:12:51 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:38251 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbaB0LMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 06:12:50 -0500
Date: Thu, 27 Feb 2014 16:42:38 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Borislav Petkov <bp@alien8.de>, Prarit Bhargava <prarit@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Toshi Kani <toshi.kani@hp.com>, Andrew Jones <drjones@redhat.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "Robert P. J. Day" <rpjday@crashcourse.ca>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>,
        David Miller <davem@davemloft.net>,
        Rashika Kheria <rashika.kheria@gmail.com>, josh@joshtriplett.org
Subject: [PATCH 03/46] kernel: Move prototype declaration to header file
 include/linux/cpu.h
Message-ID: <2f6da4289a80fcde70aec12f65c135fbf719e338.1393493276.git.rashika.kheria@gmail.com>
References: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add prototype declaration to header file include/linux/cpu.h because
they are used by more than one file.

This eliminates the following warning in kernel/cpu.c:
kernel/cpu.c:512:13: warning: no previous prototype for ‘arch_enable_nonboot_cpus_begin’ [-Wmissing-prototypes]
kernel/cpu.c:516:13: warning: no previous prototype for ‘arch_enable_nonboot_cpus_end’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 arch/x86/kernel/smpboot.c |    1 +
 include/linux/cpu.h       |    2 ++
 2 files changed, 3 insertions(+)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index a32da80..e428764 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -49,6 +49,7 @@
 #include <linux/bootmem.h>
 #include <linux/err.h>
 #include <linux/nmi.h>
+#include <linux/cpu.h>
 #include <linux/tboot.h>
 #include <linux/stackprotector.h>
 #include <linux/gfp.h>
diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index 03e235ad..9f633b0 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -38,6 +38,8 @@ extern void cpu_remove_dev_attr(struct device_attribute *attr);
 
 extern int cpu_add_dev_attr_group(struct attribute_group *attrs);
 extern void cpu_remove_dev_attr_group(struct attribute_group *attrs);
+void arch_enable_nonboot_cpus_begin(void);
+void arch_enable_nonboot_cpus_end(void);
 
 #ifdef CONFIG_HOTPLUG_CPU
 extern void unregister_cpu(struct cpu *cpu);
-- 
1.7.9.5

