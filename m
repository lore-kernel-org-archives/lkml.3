Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993AbaAUVZt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 16:25:49 -0500
Received: from mail1.windriver.com ([147.11.146.13]:50772 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754858AbaAUVZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 16:25:31 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arch@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>
Subject: [PATCH 57/73] drivers/infiniband: delete non-required instances of include <linux/init.h>
Date: Tue, 21 Jan 2014 16:23:00 -0500
Message-ID: <1390339396-3479-58-git-send-email-paul.gortmaker@windriver.com>
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

Cc: Roland Dreier <roland@kernel.org>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/infiniband/hw/amso1100/c2.c          | 1 -
 drivers/infiniband/hw/amso1100/c2_pd.c       | 1 -
 drivers/infiniband/hw/amso1100/c2_provider.c | 1 -
 drivers/infiniband/hw/amso1100/c2_rnic.c     | 1 -
 drivers/infiniband/hw/mlx4/alias_GUID.c      | 1 -
 drivers/infiniband/hw/nes/nes_cm.c           | 1 -
 drivers/infiniband/hw/nes/nes_utils.c        | 1 -
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c    | 1 -
 8 files changed, 8 deletions(-)

diff --git a/drivers/infiniband/hw/amso1100/c2.c b/drivers/infiniband/hw/amso1100/c2.c
index d53cf51..b191058 100644
--- a/drivers/infiniband/hw/amso1100/c2.c
+++ b/drivers/infiniband/hw/amso1100/c2.c
@@ -45,7 +45,6 @@
 #include <linux/in.h>
 #include <linux/ip.h>
 #include <linux/tcp.h>
-#include <linux/init.h>
 #include <linux/dma-mapping.h>
 #include <linux/slab.h>
 #include <linux/prefetch.h>
diff --git a/drivers/infiniband/hw/amso1100/c2_pd.c b/drivers/infiniband/hw/amso1100/c2_pd.c
index f3e81dc..995ecb2 100644
--- a/drivers/infiniband/hw/amso1100/c2_pd.c
+++ b/drivers/infiniband/hw/amso1100/c2_pd.c
@@ -33,7 +33,6 @@
  * SOFTWARE.
  */
 
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/errno.h>
 
diff --git a/drivers/infiniband/hw/amso1100/c2_provider.c b/drivers/infiniband/hw/amso1100/c2_provider.c
index 07eb3a8..70844f8 100644
--- a/drivers/infiniband/hw/amso1100/c2_provider.c
+++ b/drivers/infiniband/hw/amso1100/c2_provider.c
@@ -46,7 +46,6 @@
 #include <linux/in.h>
 #include <linux/ip.h>
 #include <linux/tcp.h>
-#include <linux/init.h>
 #include <linux/dma-mapping.h>
 #include <linux/if_arp.h>
 #include <linux/vmalloc.h>
diff --git a/drivers/infiniband/hw/amso1100/c2_rnic.c b/drivers/infiniband/hw/amso1100/c2_rnic.c
index b7c9869..bc055c3 100644
--- a/drivers/infiniband/hw/amso1100/c2_rnic.c
+++ b/drivers/infiniband/hw/amso1100/c2_rnic.c
@@ -46,7 +46,6 @@
 #include <linux/in.h>
 #include <linux/ip.h>
 #include <linux/tcp.h>
-#include <linux/init.h>
 #include <linux/dma-mapping.h>
 #include <linux/mm.h>
 #include <linux/inet.h>
diff --git a/drivers/infiniband/hw/mlx4/alias_GUID.c b/drivers/infiniband/hw/mlx4/alias_GUID.c
index 2f215b9..12072b4 100644
--- a/drivers/infiniband/hw/mlx4/alias_GUID.c
+++ b/drivers/infiniband/hw/mlx4/alias_GUID.c
@@ -39,7 +39,6 @@
 #include <rdma/ib_pack.h>
 #include <linux/mlx4/cmd.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/errno.h>
 #include <rdma/ib_user_verbs.h>
 #include <linux/delay.h>
diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index 9c9f2f5..d885424 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -38,7 +38,6 @@
 #include <linux/skbuff.h>
 #include <linux/ip.h>
 #include <linux/tcp.h>
-#include <linux/init.h>
 #include <linux/if_arp.h>
 #include <linux/if_vlan.h>
 #include <linux/notifier.h>
diff --git a/drivers/infiniband/hw/nes/nes_utils.c b/drivers/infiniband/hw/nes/nes_utils.c
index 2042c0f..1080762 100644
--- a/drivers/infiniband/hw/nes/nes_utils.c
+++ b/drivers/infiniband/hw/nes/nes_utils.c
@@ -43,7 +43,6 @@
 #include <linux/in.h>
 #include <linux/ip.h>
 #include <linux/tcp.h>
-#include <linux/init.h>
 
 #include <asm/io.h>
 #include <asm/irq.h>
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
index 9fad7b5..6e7b53c 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
@@ -32,7 +32,6 @@
 
 #include <linux/module.h>
 
-#include <linux/init.h>
 #include <linux/seq_file.h>
 
 #include <asm/uaccess.h>
-- 
1.8.4.1

