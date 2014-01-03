Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936AbaACAY3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 19:24:29 -0500
Received: from mail1.windriver.com ([147.11.146.13]:44150 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754173AbaACAY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 19:24:27 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-serial@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH] tty: delete non-required instances of include <linux/init.h>
Date: Thu, 2 Jan 2014 19:23:47 -0500
Message-ID: <1388708627-23741-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

None of these files are actually using any __init type directives
and hence don't need to include <linux/init.h>.  Most are just a
left over from __devinit and __cpuinit removal, or simply due to
code getting copied from one driver to the next.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/tty/goldfish.c                      | 1 -
 drivers/tty/hvc/hvsi_lib.c                  | 1 -
 drivers/tty/ipwireless/tty.c                | 1 -
 drivers/tty/serial/8250/8250_dw.c           | 1 -
 drivers/tty/serial/8250/8250_em.c           | 1 -
 drivers/tty/serial/8250/8250_pci.c          | 1 -
 drivers/tty/serial/8250/8250_pnp.c          | 1 -
 drivers/tty/serial/8250/serial_cs.c         | 1 -
 drivers/tty/serial/cpm_uart/cpm_uart_cpm1.c | 1 -
 drivers/tty/serial/cpm_uart/cpm_uart_cpm2.c | 1 -
 drivers/tty/serial/kgdb_nmi.c               | 1 -
 drivers/tty/serial/of_serial.c              | 1 -
 drivers/tty/tty_buffer.c                    | 1 -
 drivers/tty/tty_ldisc.c                     | 1 -
 drivers/tty/tty_port.c                      | 1 -
 15 files changed, 15 deletions(-)

diff --git a/drivers/tty/goldfish.c b/drivers/tty/goldfish.c
index f17d2e4..75dc9d2 100644
--- a/drivers/tty/goldfish.c
+++ b/drivers/tty/goldfish.c
@@ -14,7 +14,6 @@
  */
 
 #include <linux/console.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
 #include <linux/tty.h>
diff --git a/drivers/tty/hvc/hvsi_lib.c b/drivers/tty/hvc/hvsi_lib.c
index 347050e..7ae6c29 100644
--- a/drivers/tty/hvc/hvsi_lib.c
+++ b/drivers/tty/hvc/hvsi_lib.c
@@ -1,5 +1,4 @@
 #include <linux/types.h>
-#include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/console.h>
diff --git a/drivers/tty/ipwireless/tty.c b/drivers/tty/ipwireless/tty.c
index 8fd72ff..ebd5bff 100644
--- a/drivers/tty/ipwireless/tty.c
+++ b/drivers/tty/ipwireless/tty.c
@@ -15,7 +15,6 @@
  *   Copyright (C) 2007 David Sterba
  */
 
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
diff --git a/drivers/tty/serial/8250/8250_dw.c b/drivers/tty/serial/8250/8250_dw.c
index aa30271..faa64e6 100644
--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -14,7 +14,6 @@
  * raised, the LCR needs to be rewritten and the uart status register read.
  */
 #include <linux/device.h>
-#include <linux/init.h>
 #include <linux/io.h>
 #include <linux/module.h>
 #include <linux/serial_8250.h>
diff --git a/drivers/tty/serial/8250/8250_em.c b/drivers/tty/serial/8250/8250_em.c
index d1a9078..56c8723 100644
--- a/drivers/tty/serial/8250/8250_em.c
+++ b/drivers/tty/serial/8250/8250_em.c
@@ -18,7 +18,6 @@
  */
 
 #include <linux/device.h>
-#include <linux/init.h>
 #include <linux/io.h>
 #include <linux/module.h>
 #include <linux/serial_8250.h>
diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
index 77d0aca..50228ee 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -11,7 +11,6 @@
  */
 #undef DEBUG
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/string.h>
 #include <linux/kernel.h>
diff --git a/drivers/tty/serial/8250/8250_pnp.c b/drivers/tty/serial/8250/8250_pnp.c
index 35d9ab9..682a2fb 100644
--- a/drivers/tty/serial/8250/8250_pnp.c
+++ b/drivers/tty/serial/8250/8250_pnp.c
@@ -12,7 +12,6 @@
  * the Free Software Foundation; either version 2 of the License.
  */
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/pnp.h>
 #include <linux/string.h>
diff --git a/drivers/tty/serial/8250/serial_cs.c b/drivers/tty/serial/8250/serial_cs.c
index 1b74b88..4d180c9 100644
--- a/drivers/tty/serial/8250/serial_cs.c
+++ b/drivers/tty/serial/8250/serial_cs.c
@@ -34,7 +34,6 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/ptrace.h>
 #include <linux/slab.h>
 #include <linux/string.h>
diff --git a/drivers/tty/serial/cpm_uart/cpm_uart_cpm1.c b/drivers/tty/serial/cpm_uart/cpm_uart_cpm1.c
index 527a969..6d3b22e 100644
--- a/drivers/tty/serial/cpm_uart/cpm_uart_cpm1.c
+++ b/drivers/tty/serial/cpm_uart/cpm_uart_cpm1.c
@@ -29,7 +29,6 @@
 #include <linux/tty.h>
 #include <linux/gfp.h>
 #include <linux/ioport.h>
-#include <linux/init.h>
 #include <linux/serial.h>
 #include <linux/console.h>
 #include <linux/sysrq.h>
diff --git a/drivers/tty/serial/cpm_uart/cpm_uart_cpm2.c b/drivers/tty/serial/cpm_uart/cpm_uart_cpm2.c
index a4927e6..f46d2ca 100644
--- a/drivers/tty/serial/cpm_uart/cpm_uart_cpm2.c
+++ b/drivers/tty/serial/cpm_uart/cpm_uart_cpm2.c
@@ -29,7 +29,6 @@
 #include <linux/tty.h>
 #include <linux/ioport.h>
 #include <linux/slab.h>
-#include <linux/init.h>
 #include <linux/serial.h>
 #include <linux/console.h>
 #include <linux/sysrq.h>
diff --git a/drivers/tty/serial/kgdb_nmi.c b/drivers/tty/serial/kgdb_nmi.c
index 5dafcf1..5f673b7 100644
--- a/drivers/tty/serial/kgdb_nmi.c
+++ b/drivers/tty/serial/kgdb_nmi.c
@@ -15,7 +15,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/compiler.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/errno.h>
 #include <linux/atomic.h>
diff --git a/drivers/tty/serial/of_serial.c b/drivers/tty/serial/of_serial.c
index 2caf9c6..9924660 100644
--- a/drivers/tty/serial/of_serial.c
+++ b/drivers/tty/serial/of_serial.c
@@ -9,7 +9,6 @@
  *  2 of the License, or (at your option) any later version.
  *
  */
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index 3002e20..765125d 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -11,7 +11,6 @@
 #include <linux/string.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
-#include <linux/init.h>
 #include <linux/wait.h>
 #include <linux/bitops.h>
 #include <linux/delay.h>
diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index 6458e11..2d822aa 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -11,7 +11,6 @@
 #include <linux/slab.h>
 #include <linux/poll.h>
 #include <linux/proc_fs.h>
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/wait.h>
diff --git a/drivers/tty/tty_port.c b/drivers/tty/tty_port.c
index c94d234..3f746c8 100644
--- a/drivers/tty/tty_port.c
+++ b/drivers/tty/tty_port.c
@@ -12,7 +12,6 @@
 #include <linux/string.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
-#include <linux/init.h>
 #include <linux/wait.h>
 #include <linux/bitops.h>
 #include <linux/delay.h>
-- 
1.8.4.1

