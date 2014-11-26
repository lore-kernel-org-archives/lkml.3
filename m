Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741AbaKZXUk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 18:20:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59088 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573AbaKZXUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 18:20:37 -0500
Date: Wed, 26 Nov 2014 15:19:39 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-73bfd6eb8955d7a68d9e93d86eaa7b4f36f0ff04@git.kernel.org>
Cc: rdunlap@infradead.org, yinghai@kernel.org, grant.likely@linaro.org,
        mingo@kernel.org, benh@kernel.crashing.org, bp@alien8.de,
        rjw@rjwysocki.net, linux-kernel@vger.kernel.org,
        jiang.liu@linux.intel.com, gregkh@linuxfoundation.org,
        wangyijing@huawei.com, konrad.wilk@oracle.com, tony.luck@intel.com,
        hpa@zytor.com, joro@8bytes.org, bhelgaas@google.com, jroedel@suse.de,
        tglx@linutronix.de
Reply-To: joro@8bytes.org, bhelgaas@google.com, jroedel@suse.de,
        tglx@linutronix.de, wangyijing@huawei.com, tony.luck@intel.com,
        konrad.wilk@oracle.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jiang.liu@linux.intel.com, gregkh@linuxfoundation.org,
        rdunlap@infradead.org, yinghai@kernel.org, mingo@kernel.org,
        grant.likely@linaro.org, benh@kernel.crashing.org, rjw@rjwysocki.net,
        bp@alien8.de
In-Reply-To: <1416901802-24211-28-git-send-email-jiang.liu@linux.intel.com>
References: <1416901802-24211-28-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq:
  Kill x86_io_apic_ops.write and x86_io_apic_ops.modify
Git-Commit-ID: 73bfd6eb8955d7a68d9e93d86eaa7b4f36f0ff04
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  73bfd6eb8955d7a68d9e93d86eaa7b4f36f0ff04
Gitweb:     http://git.kernel.org/tip/73bfd6eb8955d7a68d9e93d86eaa7b4f36f0ff04
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Tue, 25 Nov 2014 15:49:51 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 26 Nov 2014 23:52:48 +0100

x86, irq: Kill x86_io_apic_ops.write and x86_io_apic_ops.modify

x86_io_apic_ops.write is always set to native_io_apic_write(),
and nobody overrides it. So get rid of the indirection by changing
native_io_apic_write() as io_apic_write() and killing
x86_io_apic_ops.write.

Do the same for x86_io_apic_ops.modify and native_io_apic_modify().

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Yijing Wang <wangyijing@huawei.com>
Cc: Grant Likely <grant.likely@linaro.org>
Link: http://lkml.kernel.org/r/1416901802-24211-28-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/asm/io_apic.h  | 13 -------------
 arch/x86/include/asm/x86_init.h |  2 --
 arch/x86/kernel/apic/io_apic.c  |  6 ++++--
 arch/x86/kernel/x86_init.c      |  2 --
 4 files changed, 4 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 1597c77..21578af 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -208,8 +208,6 @@ extern void disable_ioapic_support(void);
 
 extern void __init native_io_apic_init_mappings(void);
 extern unsigned int native_io_apic_read(unsigned int apic, unsigned int reg);
-extern void native_io_apic_write(unsigned int apic, unsigned int reg, unsigned int val);
-extern void native_io_apic_modify(unsigned int apic, unsigned int reg, unsigned int val);
 extern void native_disable_io_apic(void);
 
 static inline unsigned int io_apic_read(unsigned int apic, unsigned int reg)
@@ -217,15 +215,6 @@ static inline unsigned int io_apic_read(unsigned int apic, unsigned int reg)
 	return x86_io_apic_ops.read(apic, reg);
 }
 
-static inline void io_apic_write(unsigned int apic, unsigned int reg, unsigned int value)
-{
-	x86_io_apic_ops.write(apic, reg, value);
-}
-static inline void io_apic_modify(unsigned int apic, unsigned int reg, unsigned int value)
-{
-	x86_io_apic_ops.modify(apic, reg, value);
-}
-
 extern void setup_IO_APIC(void);
 extern void enable_IO_APIC(void);
 extern void disable_IO_APIC(void);
@@ -266,8 +255,6 @@ static inline void mp_save_irq(struct mpc_intsrc *m) { };
 static inline void disable_ioapic_support(void) { }
 #define native_io_apic_init_mappings	NULL
 #define native_io_apic_read		NULL
-#define native_io_apic_write		NULL
-#define native_io_apic_modify		NULL
 #define native_disable_io_apic		NULL
 #endif
 
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 09d4dab..844b37d 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -182,8 +182,6 @@ struct x86_msi_ops {
 struct x86_io_apic_ops {
 	void		(*init)   (void);
 	unsigned int	(*read)   (unsigned int apic, unsigned int reg);
-	void		(*write)  (unsigned int apic, unsigned int reg, unsigned int value);
-	void		(*modify) (unsigned int apic, unsigned int reg, unsigned int value);
 	void		(*disable)(void);
 };
 
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index f0ef583..7a3679e 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -277,7 +277,8 @@ unsigned int native_io_apic_read(unsigned int apic, unsigned int reg)
 	return readl(&io_apic->data);
 }
 
-void native_io_apic_write(unsigned int apic, unsigned int reg, unsigned int value)
+static void io_apic_write(unsigned int apic, unsigned int reg,
+			  unsigned int value)
 {
 	struct io_apic __iomem *io_apic = io_apic_base(apic);
 
@@ -291,7 +292,8 @@ void native_io_apic_write(unsigned int apic, unsigned int reg, unsigned int valu
  *
  * Older SiS APIC requires we rewrite the index register
  */
-void native_io_apic_modify(unsigned int apic, unsigned int reg, unsigned int value)
+static void io_apic_modify(unsigned int apic, unsigned int reg,
+			   unsigned int value)
 {
 	struct io_apic __iomem *io_apic = io_apic_base(apic);
 
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index f612dc0..633f078 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -141,7 +141,5 @@ void arch_restore_msi_irqs(struct pci_dev *dev)
 struct x86_io_apic_ops x86_io_apic_ops = {
 	.init			= native_io_apic_init_mappings,
 	.read			= native_io_apic_read,
-	.write			= native_io_apic_write,
-	.modify			= native_io_apic_modify,
 	.disable		= native_disable_io_apic,
 };
