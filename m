Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679AbaAUVlp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 16:41:45 -0500
Received: from mail.windriver.com ([147.11.1.11]:56336 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754498AbaAUVYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 16:24:54 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arch@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "David S. Miller" <davem@davemloft.net>, <sparclinux@vger.kernel.org>
Subject: [PATCH 35/73] sparc: delete non-required instances of include <linux/init.h>
Date: Tue, 21 Jan 2014 16:22:38 -0500
Message-ID: <1390339396-3479-36-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
References: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

None of these files are actually using any __init type directives
and hence don't need to include <linux/init.h>.  Most are just a
left over from __devinit and __cpuinit removal, or simply due to
code getting copied from one driver to the next.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/sparc/kernel/cpumap.c           | 1 -
 arch/sparc/kernel/ebus.c             | 1 -
 arch/sparc/kernel/hvtramp.S          | 1 -
 arch/sparc/kernel/of_device_common.c | 1 -
 arch/sparc/kernel/pci_common.c       | 1 -
 arch/sparc/kernel/process_32.c       | 1 -
 arch/sparc/kernel/sparc_ksyms_32.c   | 1 -
 arch/sparc/kernel/sparc_ksyms_64.c   | 1 -
 arch/sparc/kernel/trampoline_32.S    | 1 -
 arch/sparc/kernel/trampoline_64.S    | 1 -
 arch/sparc/mm/hugetlbpage.c          | 1 -
 arch/sparc/mm/tlb.c                  | 1 -
 arch/sparc/prom/p1275.c              | 1 -
 drivers/sbus/char/bbc_i2c.c          | 1 -
 drivers/sbus/char/display7seg.c      | 1 -
 drivers/sbus/char/envctrl.c          | 1 -
 drivers/sbus/char/flash.c            | 1 -
 drivers/sbus/char/uctrl.c            | 1 -
 18 files changed, 18 deletions(-)

diff --git a/arch/sparc/kernel/cpumap.c b/arch/sparc/kernel/cpumap.c
index cb5d272..de1c844 100644
--- a/arch/sparc/kernel/cpumap.c
+++ b/arch/sparc/kernel/cpumap.c
@@ -6,7 +6,6 @@
 #include <linux/export.h>
 #include <linux/slab.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/cpumask.h>
 #include <linux/spinlock.h>
 #include <asm/cpudata.h>
diff --git a/arch/sparc/kernel/ebus.c b/arch/sparc/kernel/ebus.c
index e306fb08..acf8314 100644
--- a/arch/sparc/kernel/ebus.c
+++ b/arch/sparc/kernel/ebus.c
@@ -7,7 +7,6 @@
 #include <linux/export.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 
diff --git a/arch/sparc/kernel/hvtramp.S b/arch/sparc/kernel/hvtramp.S
index 4eb1a5a..b7ddcdd 100644
--- a/arch/sparc/kernel/hvtramp.S
+++ b/arch/sparc/kernel/hvtramp.S
@@ -3,7 +3,6 @@
  * Copyright (C) 2007, 2008 David S. Miller <davem@davemloft.net>
  */
 
-#include <linux/init.h>
 
 #include <asm/thread_info.h>
 #include <asm/hypervisor.h>
diff --git a/arch/sparc/kernel/of_device_common.c b/arch/sparc/kernel/of_device_common.c
index de199bf..3241f56 100644
--- a/arch/sparc/kernel/of_device_common.c
+++ b/arch/sparc/kernel/of_device_common.c
@@ -1,7 +1,6 @@
 #include <linux/string.h>
 #include <linux/kernel.h>
 #include <linux/of.h>
-#include <linux/init.h>
 #include <linux/export.h>
 #include <linux/mod_devicetable.h>
 #include <linux/errno.h>
diff --git a/arch/sparc/kernel/pci_common.c b/arch/sparc/kernel/pci_common.c
index a689598..944a065 100644
--- a/arch/sparc/kernel/pci_common.c
+++ b/arch/sparc/kernel/pci_common.c
@@ -5,7 +5,6 @@
 
 #include <linux/string.h>
 #include <linux/slab.h>
-#include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/device.h>
 #include <linux/of_device.h>
diff --git a/arch/sparc/kernel/process_32.c b/arch/sparc/kernel/process_32.c
index fdd819d..510baec 100644
--- a/arch/sparc/kernel/process_32.c
+++ b/arch/sparc/kernel/process_32.c
@@ -22,7 +22,6 @@
 #include <linux/reboot.h>
 #include <linux/delay.h>
 #include <linux/pm.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 
 #include <asm/auxio.h>
diff --git a/arch/sparc/kernel/sparc_ksyms_32.c b/arch/sparc/kernel/sparc_ksyms_32.c
index e521c54..bf4ccb1 100644
--- a/arch/sparc/kernel/sparc_ksyms_32.c
+++ b/arch/sparc/kernel/sparc_ksyms_32.c
@@ -6,7 +6,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 
 #include <asm/pgtable.h>
 #include <asm/uaccess.h>
diff --git a/arch/sparc/kernel/sparc_ksyms_64.c b/arch/sparc/kernel/sparc_ksyms_64.c
index 9f5e24d..a92d5d2 100644
--- a/arch/sparc/kernel/sparc_ksyms_64.c
+++ b/arch/sparc/kernel/sparc_ksyms_64.c
@@ -7,7 +7,6 @@
 
 #include <linux/export.h>
 #include <linux/pci.h>
-#include <linux/init.h>
 #include <linux/bitops.h>
 
 #include <asm/cpudata.h>
diff --git a/arch/sparc/kernel/trampoline_32.S b/arch/sparc/kernel/trampoline_32.S
index 76dcbd3..3eed99f 100644
--- a/arch/sparc/kernel/trampoline_32.S
+++ b/arch/sparc/kernel/trampoline_32.S
@@ -5,7 +5,6 @@
  * Copyright (C) 1998 Jakub Jelinek (jj@sunsite.mff.cuni.cz)
  */
 
-#include <linux/init.h>
 #include <asm/head.h>
 #include <asm/psr.h>
 #include <asm/page.h>
diff --git a/arch/sparc/kernel/trampoline_64.S b/arch/sparc/kernel/trampoline_64.S
index ad4bde3..737f8cb 100644
--- a/arch/sparc/kernel/trampoline_64.S
+++ b/arch/sparc/kernel/trampoline_64.S
@@ -4,7 +4,6 @@
  * Copyright (C) 1997 David S. Miller (davem@caip.rutgers.edu)
  */
 
-#include <linux/init.h>
 
 #include <asm/head.h>
 #include <asm/asi.h>
diff --git a/arch/sparc/mm/hugetlbpage.c b/arch/sparc/mm/hugetlbpage.c
index 3096317..9bd9ce8 100644
--- a/arch/sparc/mm/hugetlbpage.c
+++ b/arch/sparc/mm/hugetlbpage.c
@@ -4,7 +4,6 @@
  * Copyright (C) 2002, 2003, 2006 David S. Miller (davem@davemloft.net)
  */
 
-#include <linux/init.h>
 #include <linux/fs.h>
 #include <linux/mm.h>
 #include <linux/hugetlb.h>
diff --git a/arch/sparc/mm/tlb.c b/arch/sparc/mm/tlb.c
index ad3bf4b..b12cb5e 100644
--- a/arch/sparc/mm/tlb.c
+++ b/arch/sparc/mm/tlb.c
@@ -4,7 +4,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/percpu.h>
 #include <linux/mm.h>
 #include <linux/swap.h>
diff --git a/arch/sparc/prom/p1275.c b/arch/sparc/prom/p1275.c
index 04a4540..e58b817 100644
--- a/arch/sparc/prom/p1275.c
+++ b/arch/sparc/prom/p1275.c
@@ -5,7 +5,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/sched.h>
 #include <linux/smp.h>
 #include <linux/string.h>
diff --git a/drivers/sbus/char/bbc_i2c.c b/drivers/sbus/char/bbc_i2c.c
index c1441ed..c7763e4 100644
--- a/drivers/sbus/char/bbc_i2c.c
+++ b/drivers/sbus/char/bbc_i2c.c
@@ -11,7 +11,6 @@
 #include <linux/sched.h>
 #include <linux/wait.h>
 #include <linux/delay.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
diff --git a/drivers/sbus/char/display7seg.c b/drivers/sbus/char/display7seg.c
index fc1339c..7c71e7b 100644
--- a/drivers/sbus/char/display7seg.c
+++ b/drivers/sbus/char/display7seg.c
@@ -9,7 +9,6 @@
 #include <linux/fs.h>
 #include <linux/errno.h>
 #include <linux/major.h>
-#include <linux/init.h>
 #include <linux/miscdevice.h>
 #include <linux/ioport.h>		/* request_region */
 #include <linux/slab.h>
diff --git a/drivers/sbus/char/envctrl.c b/drivers/sbus/char/envctrl.c
index ddbe5a9..af15a2f 100644
--- a/drivers/sbus/char/envctrl.c
+++ b/drivers/sbus/char/envctrl.c
@@ -19,7 +19,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/kthread.h>
 #include <linux/delay.h>
 #include <linux/ioport.h>
diff --git a/drivers/sbus/char/flash.c b/drivers/sbus/char/flash.c
index d9f268f..25c738e 100644
--- a/drivers/sbus/char/flash.c
+++ b/drivers/sbus/char/flash.c
@@ -9,7 +9,6 @@
 #include <linux/miscdevice.h>
 #include <linux/fcntl.h>
 #include <linux/poll.h>
-#include <linux/init.h>
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
 #include <linux/mm.h>
diff --git a/drivers/sbus/char/uctrl.c b/drivers/sbus/char/uctrl.c
index b0aae05..b7acafc 100644
--- a/drivers/sbus/char/uctrl.c
+++ b/drivers/sbus/char/uctrl.c
@@ -11,7 +11,6 @@
 #include <linux/slab.h>
 #include <linux/mutex.h>
 #include <linux/ioport.h>
-#include <linux/init.h>
 #include <linux/miscdevice.h>
 #include <linux/mm.h>
 #include <linux/of.h>
-- 
1.8.4.1

