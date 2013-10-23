Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445Ab3JWDD5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 23:03:57 -0400
Received: from intranet.asianux.com ([58.214.24.6]:39103 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185Ab3JWDD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 23:03:56 -0400
X-Spam-Score: -100.8
Message-ID: <52673C5B.4090703@asianux.com>
Date: Wed, 23 Oct 2013 11:02:51 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "vgupta@synopsys.com" <vgupta@synopsys.com>, Arnd Bergmann <arnd@arndb.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        pierrick.hascoet@abilis.com, christian.ruppert@abilis.com,
        noamc@ezchip.com
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] arc: kernel: remove '__init' for get_hw_config_num_irq()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_hw_config_num_irq() may be called by normal iss_model_init_smp()
which is a function pointer for 'init_smp' which may be called by
first_lines_of_secondary() which also need be normal too.

The related warning (with allmodconfig):

    MODPOST vmlinux.o
  WARNING: vmlinux.o(.text+0x5814): Section mismatch in reference from the function iss_model_init_smp() to the function .init.text:get_hw_config_num_irq()
  The function iss_model_init_smp() references
  the function __init get_hw_config_num_irq().
  This is often because iss_model_init_smp lacks a __init
  annotation or the annotation of get_hw_config_num_irq is wrong.


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/arc/include/asm/irq.h |    2 +-
 arch/arc/kernel/irq.c      |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arc/include/asm/irq.h b/arch/arc/include/asm/irq.h
index 548207f..291a70d 100644
--- a/arch/arc/include/asm/irq.h
+++ b/arch/arc/include/asm/irq.h
@@ -19,7 +19,7 @@
 #include <asm-generic/irq.h>
 
 extern void arc_init_IRQ(void);
-extern int __init get_hw_config_num_irq(void);
+extern int get_hw_config_num_irq(void);
 
 void arc_local_timer_setup(unsigned int cpu);
 
diff --git a/arch/arc/kernel/irq.c b/arch/arc/kernel/irq.c
index 5fc9245..e2bdfe5 100644
--- a/arch/arc/kernel/irq.c
+++ b/arch/arc/kernel/irq.c
@@ -146,7 +146,7 @@ void arch_do_IRQ(unsigned int irq, struct pt_regs *regs)
 	set_irq_regs(old_regs);
 }
 
-int __init get_hw_config_num_irq(void)
+int get_hw_config_num_irq(void)
 {
 	uint32_t val = read_aux_reg(ARC_REG_VECBASE_BCR);
 
-- 
1.7.7.6
