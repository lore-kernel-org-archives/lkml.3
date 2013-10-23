Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213Ab3JWCGJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 22:06:09 -0400
Received: from intranet.asianux.com ([58.214.24.6]:22905 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859Ab3JWCGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 22:06:05 -0400
X-Spam-Score: -100.8
Message-ID: <52672ECD.9010800@asianux.com>
Date: Wed, 23 Oct 2013 10:05:01 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "vgupta@synopsys.com" <vgupta@synopsys.com>,
        Mike Frysinger <vapier@gentoo.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, Arnd Bergmann <arnd@arndb.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        realmz paranoid <realmz6@gmail.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
        Parisc List <linux-parisc@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] arch: *: remove '__init' for setup_profiling_timer()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of architectures not use '__init' for setup_profiling_timer(), so
need remove it, or can generate warning (e.g. arc with allmodconfig):

    MODPOST vmlinux.o
  WARNING: vmlinux.o(.text+0x3c682): Section mismatch in reference from the function write_profile() to the function .init.text:setup_profiling_timer()
  The function write_profile() references
  the function __init setup_profiling_timer().
  This is often because write_profile lacks a __init
  annotation or the annotation of setup_profiling_timer is wrong.


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/arc/kernel/smp.c          |    2 +-
 arch/blackfin/mach-bf561/smp.c |    2 +-
 arch/parisc/kernel/smp.c       |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arc/kernel/smp.c b/arch/arc/kernel/smp.c
index bca3052..3bdac11 100644
--- a/arch/arc/kernel/smp.c
+++ b/arch/arc/kernel/smp.c
@@ -187,7 +187,7 @@ int __cpu_up(unsigned int cpu, struct task_struct *idle)
 /*
  * not supported here
  */
-int __init setup_profiling_timer(unsigned int multiplier)
+int setup_profiling_timer(unsigned int multiplier)
 {
 	return -EINVAL;
 }
diff --git a/arch/blackfin/mach-bf561/smp.c b/arch/blackfin/mach-bf561/smp.c
index 11789be..3bef058 100644
--- a/arch/blackfin/mach-bf561/smp.c
+++ b/arch/blackfin/mach-bf561/smp.c
@@ -43,7 +43,7 @@ void __init platform_prepare_cpus(unsigned int max_cpus)
 	init_cpu_present(&mask);
 }
 
-int __init setup_profiling_timer(unsigned int multiplier) /* not supported */
+int setup_profiling_timer(unsigned int multiplier) /* not supported */
 {
 	return -EINVAL;
 }
diff --git a/arch/parisc/kernel/smp.c b/arch/parisc/kernel/smp.c
index 8a252f2..2e8cd36 100644
--- a/arch/parisc/kernel/smp.c
+++ b/arch/parisc/kernel/smp.c
@@ -433,7 +433,7 @@ int __cpu_up(unsigned int cpu, struct task_struct *tidle)
 }
 
 #ifdef CONFIG_PROC_FS
-int __init
+int
 setup_profiling_timer(unsigned int multiplier)
 {
 	return -EINVAL;
-- 
1.7.7.6
