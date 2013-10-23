Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493Ab3JWCNN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 22:13:13 -0400
Received: from intranet.asianux.com ([58.214.24.6]:33892 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754925Ab3JWCNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 22:13:12 -0400
X-Spam-Score: -100.8
Message-ID: <52673075.3080201@asianux.com>
Date: Wed, 23 Oct 2013 10:12:05 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "vgupta@synopsys.com" <vgupta@synopsys.com>, Arnd Bergmann <arnd@arndb.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        pierrick.hascoet@abilis.com, christian.ruppert@abilis.com
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] arc: include: asm: remove '__init' for setup_processor()
 and arc_init_IRQ()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They haven't '__init' in definition, but has '__init' in declaration.
And normal function start_kernel_secondary() may call setup_processor()
which will call arc_init_IRQ().

So need remove '__init' for both of them. The related warning (with
allmodconfig):

    MODPOST vmlinux.o
  WARNING: vmlinux.o(.text+0x3084): Section mismatch in reference from the function start_kernel_secondary() to the function .init.text:setup_processor()
  The function start_kernel_secondary() references
  the function __init setup_processor().
  This is often because start_kernel_secondary lacks a __init
  annotation or the annotation of setup_processor is wrong.


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/arc/include/asm/irq.h   |    2 +-
 arch/arc/include/asm/setup.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arc/include/asm/irq.h b/arch/arc/include/asm/irq.h
index c0a7210..548207f 100644
--- a/arch/arc/include/asm/irq.h
+++ b/arch/arc/include/asm/irq.h
@@ -18,7 +18,7 @@
 
 #include <asm-generic/irq.h>
 
-extern void __init arc_init_IRQ(void);
+extern void arc_init_IRQ(void);
 extern int __init get_hw_config_num_irq(void);
 
 void arc_local_timer_setup(unsigned int cpu);
diff --git a/arch/arc/include/asm/setup.h b/arch/arc/include/asm/setup.h
index 229e506..e10f8ce 100644
--- a/arch/arc/include/asm/setup.h
+++ b/arch/arc/include/asm/setup.h
@@ -31,7 +31,7 @@ struct cpuinfo_data {
 extern int root_mountflags, end_mem;
 extern int running_on_hw;
 
-void __init setup_processor(void);
+void setup_processor(void);
 void __init setup_arch_memory(void);
 
 #endif /* __ASMARC_SETUP_H */
-- 
1.7.7.6
