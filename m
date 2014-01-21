Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243AbaAUV1I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 16:27:08 -0500
Received: from mail1.windriver.com ([147.11.146.13]:50852 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932101AbaAUV0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 16:26:13 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arch@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Doug Thompson <dougthompson@xmission.com>,
        Borislav Petkov <bp@alien8.de>, Ralf Baechle <ralf@linux-mips.org>,
        David Daney <david.daney@cavium.com>, <linux-edac@vger.kernel.org>
Subject: [PATCH 65/73] drivers/edac: delete non-required instances of include <linux/init.h>
Date: Tue, 21 Jan 2014 16:23:08 -0500
Message-ID: <1390339396-3479-66-git-send-email-paul.gortmaker@windriver.com>
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

Cc: Doug Thompson <dougthompson@xmission.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: David Daney <david.daney@cavium.com>
Cc: linux-edac@vger.kernel.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/edac/amd64_edac.h      | 1 -
 drivers/edac/edac_device.c     | 1 -
 drivers/edac/edac_mc.c         | 1 -
 drivers/edac/edac_pci.c        | 1 -
 drivers/edac/octeon_edac-l2c.c | 1 -
 drivers/edac/octeon_edac-lmc.c | 1 -
 drivers/edac/octeon_edac-pc.c  | 1 -
 drivers/edac/octeon_edac-pci.c | 1 -
 8 files changed, 8 deletions(-)

diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index 6dc1fcc..75d2d12 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -64,7 +64,6 @@
 
 #include <linux/module.h>
 #include <linux/ctype.h>
-#include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/pci_ids.h>
 #include <linux/slab.h>
diff --git a/drivers/edac/edac_device.c b/drivers/edac/edac_device.c
index 592af5f..8c3f104 100644
--- a/drivers/edac/edac_device.c
+++ b/drivers/edac/edac_device.c
@@ -15,7 +15,6 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/smp.h>
-#include <linux/init.h>
 #include <linux/sysctl.h>
 #include <linux/highmem.h>
 #include <linux/timer.h>
diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index e8c9ef0..b20ecb7 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -17,7 +17,6 @@
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/smp.h>
-#include <linux/init.h>
 #include <linux/sysctl.h>
 #include <linux/highmem.h>
 #include <linux/timer.h>
diff --git a/drivers/edac/edac_pci.c b/drivers/edac/edac_pci.c
index 2cf44b4d..90dd64f 100644
--- a/drivers/edac/edac_pci.c
+++ b/drivers/edac/edac_pci.c
@@ -12,7 +12,6 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/smp.h>
-#include <linux/init.h>
 #include <linux/sysctl.h>
 #include <linux/highmem.h>
 #include <linux/timer.h>
diff --git a/drivers/edac/octeon_edac-l2c.c b/drivers/edac/octeon_edac-l2c.c
index 7e98084..c049af4 100644
--- a/drivers/edac/octeon_edac-l2c.c
+++ b/drivers/edac/octeon_edac-l2c.c
@@ -9,7 +9,6 @@
  *   written by Ralf Baechle <ralf@linux-mips.org>
  */
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/io.h>
 #include <linux/edac.h>
diff --git a/drivers/edac/octeon_edac-lmc.c b/drivers/edac/octeon_edac-lmc.c
index 93412d6..3c0d68c 100644
--- a/drivers/edac/octeon_edac-lmc.c
+++ b/drivers/edac/octeon_edac-lmc.c
@@ -7,7 +7,6 @@
  *   written by Ralf Baechle <ralf@linux-mips.org>
  */
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/io.h>
 #include <linux/edac.h>
diff --git a/drivers/edac/octeon_edac-pc.c b/drivers/edac/octeon_edac-pc.c
index 0f83c33..e32cf48 100644
--- a/drivers/edac/octeon_edac-pc.c
+++ b/drivers/edac/octeon_edac-pc.c
@@ -9,7 +9,6 @@
  *   written by Ralf Baechle <ralf@linux-mips.org>
  */
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
diff --git a/drivers/edac/octeon_edac-pci.c b/drivers/edac/octeon_edac-pci.c
index 9ca73ce..fdf0b42 100644
--- a/drivers/edac/octeon_edac-pci.c
+++ b/drivers/edac/octeon_edac-pci.c
@@ -8,7 +8,6 @@
  *   written by Ralf Baechle <ralf@linux-mips.org>
  */
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/io.h>
 #include <linux/edac.h>
-- 
1.8.4.1

