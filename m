Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935698Ab3DPS0N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 14:26:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11745 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935351Ab3DPS0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 14:26:06 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 01/28] Include missing linux/slab.h inclusions [RFC]
To: linux-kernel@vger.kernel.org
From: David Howells <dhowells@redhat.com>
Cc: devel@driverdev.osuosl.org, linux-s390@vger.kernel.org,
        linux-efi@vger.kernel.org, x86@kernel.org, sparclinux@vger.kernel.org,
        linux-mtd@lists.infradead.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Date: Tue, 16 Apr 2013 19:25:54 +0100
Message-ID: <20130416182554.27773.86004.stgit@warthog.procyon.org.uk>
In-Reply-To: <20130416182550.27773.89310.stgit@warthog.procyon.org.uk>
References: <20130416182550.27773.89310.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include missing linux/slab.h inclusions where the source file is currently
expecting to get kmalloc() and co. through linux/proc_fs.h.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: linux-s390@vger.kernel.org
cc: sparclinux@vger.kernel.org
cc: linux-efi@vger.kernel.org
cc: linux-mtd@lists.infradead.org
cc: devel@driverdev.osuosl.org
cc: x86@kernel.org
---

 arch/s390/kernel/os_info.c           |    1 +
 arch/sparc/kernel/sun4d_irq.c        |    1 +
 arch/x86/platform/efi/efi.c          |    1 +
 arch/x86/platform/efi/efi_64.c       |    1 +
 drivers/mtd/mtdcore.c                |    1 +
 drivers/pps/clients/pps_parport.c    |    1 +
 drivers/staging/dgrp/dgrp_dpa_ops.c  |    1 +
 drivers/staging/dgrp/dgrp_mon_ops.c  |    1 +
 drivers/staging/dgrp/dgrp_net_ops.c  |    2 +-
 drivers/staging/dgrp/dgrp_specproc.c |    1 +
 fs/proc/self.c                       |    1 +
 11 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kernel/os_info.c b/arch/s390/kernel/os_info.c
index 46480d8..d112fc6 100644
--- a/arch/s390/kernel/os_info.c
+++ b/arch/s390/kernel/os_info.c
@@ -10,6 +10,7 @@
 
 #include <linux/crash_dump.h>
 #include <linux/kernel.h>
+#include <linux/slab.h>
 #include <asm/checksum.h>
 #include <asm/lowcore.h>
 #include <asm/os_info.h>
diff --git a/arch/sparc/kernel/sun4d_irq.c b/arch/sparc/kernel/sun4d_irq.c
index e490ac9..f8933be 100644
--- a/arch/sparc/kernel/sun4d_irq.c
+++ b/arch/sparc/kernel/sun4d_irq.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/kernel_stat.h>
+#include <linux/slab.h>
 #include <linux/seq_file.h>
 
 #include <asm/timer.h>
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 5f2ecaf..55ea7df 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -34,6 +34,7 @@
 #include <linux/efi-bgrt.h>
 #include <linux/export.h>
 #include <linux/bootmem.h>
+#include <linux/slab.h>
 #include <linux/memblock.h>
 #include <linux/spinlock.h>
 #include <linux/uaccess.h>
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 2b20038..39a0e7f 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -27,6 +27,7 @@
 #include <linux/uaccess.h>
 #include <linux/io.h>
 #include <linux/reboot.h>
+#include <linux/slab.h>
 
 #include <asm/setup.h>
 #include <asm/page.h>
diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index 61d5f56..322ca65 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -36,6 +36,7 @@
 #include <linux/idr.h>
 #include <linux/backing-dev.h>
 #include <linux/gfp.h>
+#include <linux/slab.h>
 
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/partitions.h>
diff --git a/drivers/pps/clients/pps_parport.c b/drivers/pps/clients/pps_parport.c
index e1b4705..38a8bbe 100644
--- a/drivers/pps/clients/pps_parport.c
+++ b/drivers/pps/clients/pps_parport.c
@@ -32,6 +32,7 @@
 #include <linux/init.h>
 #include <linux/irqnr.h>
 #include <linux/time.h>
+#include <linux/slab.h>
 #include <linux/parport.h>
 #include <linux/pps_kernel.h>
 
diff --git a/drivers/staging/dgrp/dgrp_dpa_ops.c b/drivers/staging/dgrp/dgrp_dpa_ops.c
index 43209c1..1fc13de 100644
--- a/drivers/staging/dgrp/dgrp_dpa_ops.c
+++ b/drivers/staging/dgrp/dgrp_dpa_ops.c
@@ -40,6 +40,7 @@
 #include <linux/cred.h>
 #include <linux/sched.h>
 #include <linux/ratelimit.h>
+#include <linux/slab.h>
 #include <asm/unaligned.h>
 
 #include "dgrp_common.h"
diff --git a/drivers/staging/dgrp/dgrp_mon_ops.c b/drivers/staging/dgrp/dgrp_mon_ops.c
index 6edbbf0..d18be41 100644
--- a/drivers/staging/dgrp/dgrp_mon_ops.c
+++ b/drivers/staging/dgrp/dgrp_mon_ops.c
@@ -37,6 +37,7 @@
 #include <linux/tty.h>
 #include <linux/sched.h>
 #include <asm/unaligned.h>
+#include <linux/slab.h>
 #include <linux/proc_fs.h>
 #include <linux/uaccess.h>
 
diff --git a/drivers/staging/dgrp/dgrp_net_ops.c b/drivers/staging/dgrp/dgrp_net_ops.c
index 5448fc7..9914f1c 100644
--- a/drivers/staging/dgrp/dgrp_net_ops.c
+++ b/drivers/staging/dgrp/dgrp_net_ops.c
@@ -35,7 +35,7 @@
 
 #include <linux/module.h>
 #include <linux/proc_fs.h>
-#include <linux/types.h>
+#include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/device.h>
 #include <linux/tty.h>
diff --git a/drivers/staging/dgrp/dgrp_specproc.c b/drivers/staging/dgrp/dgrp_specproc.c
index b990b26..205d80e 100644
--- a/drivers/staging/dgrp/dgrp_specproc.c
+++ b/drivers/staging/dgrp/dgrp_specproc.c
@@ -37,6 +37,7 @@
 #include <linux/sched.h>
 #include <linux/cred.h>
 #include <linux/proc_fs.h>
+#include <linux/slab.h>
 #include <linux/ctype.h>
 #include <linux/seq_file.h>
 #include <linux/uaccess.h>
diff --git a/fs/proc/self.c b/fs/proc/self.c
index 21940d8..6b6a993 100644
--- a/fs/proc/self.c
+++ b/fs/proc/self.c
@@ -1,5 +1,6 @@
 #include <linux/sched.h>
 #include <linux/namei.h>
+#include <linux/slab.h>
 #include <linux/pid_namespace.h>
 #include "internal.h"
 

