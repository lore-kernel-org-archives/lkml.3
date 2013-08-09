Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031617Ab3HIXGN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 19:06:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:20518 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031511Ab3HIXEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 19:04:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,849,1367996400"; 
   d="scan'208";a="360454435"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, mingo@kernel.org, torvalds@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 03/13] tree-sweep: Include linux/sched.h for might_sleep users
Date: Fri,  9 Aug 2013 16:04:10 -0700
Message-Id: <1376089460-5459-4-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1376089460-5459-1-git-send-email-andi@firstfloor.org>
References: <1376089460-5459-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

might_sleep is moving from linux/kernel.h to linux/sched.h, so any users
need to include linux/sched.h

This was done with a mechanistic script and some uses may be redundant
(already included in some other include file). However it's good practice
to always include any needed symbols from the top level .c file.

Tested with x86-64 allyesconfig. I used to do a x86-32 allyesconfig
on a old kernel, but since that is broken now I didn't retest.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/arm/common/mcpm_entry.c                              | 1 +
 arch/arm/mach-omap2/omap_hwmod.c                          | 1 +
 arch/arm/mm/highmem.c                                     | 1 +
 arch/blackfin/kernel/bfin_gpio.c                          | 1 +
 arch/frv/mm/highmem.c                                     | 1 +
 arch/m32r/include/asm/uaccess.h                           | 1 +
 arch/microblaze/include/asm/highmem.h                     | 1 +
 arch/mn10300/include/asm/uaccess.h                        | 1 +
 arch/parisc/include/asm/cacheflush.h                      | 1 +
 arch/powerpc/include/asm/highmem.h                        | 1 +
 arch/powerpc/kernel/rtas.c                                | 1 +
 arch/powerpc/lib/checksum_wrappers_64.c                   | 1 +
 arch/powerpc/lib/usercopy_64.c                            | 1 +
 arch/tile/mm/highmem.c                                    | 1 +
 arch/x86/include/asm/checksum_32.h                        | 1 +
 arch/x86/lib/csum-wrappers_64.c                           | 1 +
 arch/x86/mm/highmem_32.c                                  | 1 +
 arch/x86/mm/mmio-mod.c                                    | 1 +
 block/blk-cgroup.c                                        | 1 +
 block/blk-core.c                                          | 1 +
 block/genhd.c                                             | 1 +
 drivers/base/dma-buf.c                                    | 1 +
 drivers/block/rsxx/dev.c                                  | 1 +
 drivers/dma/ipu/ipu_irq.c                                 | 1 +
 drivers/gpio/gpiolib.c                                    | 1 +
 drivers/ide/ide-io.c                                      | 1 +
 drivers/infiniband/hw/amso1100/c2_cq.c                    | 1 +
 drivers/infiniband/hw/cxgb3/iwch_cm.c                     | 1 +
 drivers/infiniband/hw/cxgb4/cm.c                          | 1 +
 drivers/md/dm.c                                           | 1 +
 drivers/md/raid5.c                                        | 1 +
 drivers/mmc/core/core.c                                   | 1 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c          | 1 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c            | 1 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h         | 1 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.c         | 1 +
 drivers/net/ethernet/intel/e1000e/netdev.c                | 1 +
 drivers/net/ethernet/intel/igbvf/netdev.c                 | 1 +
 drivers/net/ethernet/sfc/falcon.c                         | 1 +
 drivers/net/ieee802154/at86rf230.c                        | 1 +
 drivers/net/ieee802154/fakelb.c                           | 1 +
 drivers/net/wireless/ath/carl9170/usb.c                   | 1 +
 drivers/net/wireless/ath/wil6210/wmi.c                    | 1 +
 drivers/net/wireless/b43/dma.c                            | 1 +
 drivers/net/wireless/b43/main.c                           | 1 +
 drivers/net/wireless/b43/phy_a.c                          | 1 +
 drivers/net/wireless/b43/phy_g.c                          | 1 +
 drivers/net/wireless/b43legacy/dma.c                      | 1 +
 drivers/net/wireless/b43legacy/radio.c                    | 1 +
 drivers/net/wireless/cw1200/cw1200_spi.c                  | 1 +
 drivers/net/wireless/iwlwifi/dvm/sta.c                    | 1 +
 drivers/net/wireless/iwlwifi/iwl-op-mode.h                | 1 +
 drivers/net/wireless/iwlwifi/iwl-trans.h                  | 1 +
 drivers/net/wireless/libertas_tf/cmd.c                    | 1 +
 drivers/pci/iov.c                                         | 1 +
 drivers/pci/pci.c                                         | 1 +
 drivers/platform/olpc/olpc-ec.c                           | 1 +
 drivers/ssb/driver_pcicore.c                              | 1 +
 drivers/staging/lustre/lustre/llite/remote_perm.c         | 1 +
 drivers/staging/lustre/lustre/obdclass/cl_lock.c          | 1 +
 drivers/staging/lustre/lustre/obdclass/cl_object.c        | 1 +
 drivers/staging/lustre/lustre/obdclass/cl_page.c          | 1 +
 drivers/staging/lustre/lustre/osc/osc_lock.c              | 1 +
 drivers/staging/lustre/lustre/osc/osc_page.c              | 1 +
 drivers/staging/lustre/lustre/ptlrpc/client.c             | 1 +
 drivers/staging/lustre/lustre/ptlrpc/gss/gss_cli_upcall.c | 1 +
 drivers/staging/lustre/lustre/ptlrpc/gss/gss_pipefs.c     | 1 +
 drivers/staging/lustre/lustre/ptlrpc/sec.c                | 1 +
 drivers/staging/lustre/lustre/ptlrpc/sec_config.c         | 1 +
 drivers/staging/lustre/lustre/ptlrpc/sec_gc.c             | 1 +
 drivers/usb/core/hcd.c                                    | 1 +
 drivers/usb/core/urb.c                                    | 1 +
 drivers/video/atmel_lcdfb.c                               | 1 +
 fs/block_dev.c                                            | 1 +
 fs/buffer.c                                               | 1 +
 fs/dcache.c                                               | 1 +
 fs/ext3/inode.c                                           | 1 +
 fs/ext4/ext4_jbd2.c                                       | 1 +
 fs/ext4/inode.c                                           | 1 +
 fs/ext4/mballoc.c                                         | 1 +
 fs/file_table.c                                           | 1 +
 fs/inode.c                                                | 1 +
 fs/jbd/revoke.c                                           | 1 +
 fs/jbd2/revoke.c                                          | 1 +
 fs/locks.c                                                | 1 +
 fs/nfs/nfs4filelayoutdev.c                                | 1 +
 fs/nfs/nfs4proc.c                                         | 1 +
 fs/nfs/nfs4state.c                                        | 1 +
 fs/nilfs2/the_nilfs.c                                     | 1 +
 fs/xfs/xfs_mount.c                                        | 1 +
 include/asm-generic/gpio.h                                | 1 +
 include/linux/buffer_head.h                               | 1 +
 include/linux/clk.h                                       | 1 +
 include/linux/gpio.h                                      | 1 +
 include/linux/highmem.h                                   | 1 +
 include/linux/pagemap.h                                   | 1 +
 kernel/fork.c                                             | 1 +
 kernel/freezer.c                                          | 1 +
 kernel/irq/chip.c                                         | 1 +
 kernel/nsproxy.c                                          | 1 +
 kernel/printk/printk.c                                    | 1 +
 kernel/sched/core.c                                       | 1 +
 kernel/smp.c                                              | 1 +
 mm/hugetlb.c                                              | 1 +
 mm/memory.c                                               | 1 +
 mm/mmap.c                                                 | 1 +
 mm/rmap.c                                                 | 1 +
 net/caif/cfcnfg.c                                         | 1 +
 net/mac80211/driver-ops.h                                 | 1 +
 net/mac80211/key.c                                        | 1 +
 net/mac80211/main.c                                       | 1 +
 net/mac80211/sta_info.c                                   | 1 +
 net/phonet/pep.c                                          | 1 +
 net/sunrpc/clnt.c                                         | 1 +
 net/wimax/op-msg.c                                        | 1 +
 net/wimax/op-reset.c                                      | 1 +
 net/wimax/op-rfkill.c                                     | 1 +
 net/wireless/wext-proc.c                                  | 1 +
 sound/core/info.c                                         | 1 +
 virt/kvm/async_pf.c                                       | 1 +
 120 files changed, 120 insertions(+)

diff --git a/arch/arm/common/mcpm_entry.c b/arch/arm/common/mcpm_entry.c
index 370236d..c083f90 100644
--- a/arch/arm/common/mcpm_entry.c
+++ b/arch/arm/common/mcpm_entry.c
@@ -10,6 +10,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/sched.h>
 #include <linux/init.h>
 #include <linux/irqflags.h>
 
diff --git a/arch/arm/mach-omap2/omap_hwmod.c b/arch/arm/mach-omap2/omap_hwmod.c
index 7f4db12..04a2674 100644
--- a/arch/arm/mach-omap2/omap_hwmod.c
+++ b/arch/arm/mach-omap2/omap_hwmod.c
@@ -127,6 +127,7 @@
  */
 #undef DEBUG
 
+#include <linux/sched.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/io.h>
diff --git a/arch/arm/mm/highmem.c b/arch/arm/mm/highmem.c
index 21b9e1b..a8be1f1 100644
--- a/arch/arm/mm/highmem.c
+++ b/arch/arm/mm/highmem.c
@@ -10,6 +10,7 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/highmem.h>
 #include <linux/interrupt.h>
diff --git a/arch/blackfin/kernel/bfin_gpio.c b/arch/blackfin/kernel/bfin_gpio.c
index ed978f1..0efe3d5 100644
--- a/arch/blackfin/kernel/bfin_gpio.c
+++ b/arch/blackfin/kernel/bfin_gpio.c
@@ -6,6 +6,7 @@
  * Licensed under the GPL-2 or later
  */
 
+#include <linux/sched.h>
 #include <linux/delay.h>
 #include <linux/module.h>
 #include <linux/err.h>
diff --git a/arch/frv/mm/highmem.c b/arch/frv/mm/highmem.c
index bed9a9b..766ff5b 100644
--- a/arch/frv/mm/highmem.c
+++ b/arch/frv/mm/highmem.c
@@ -8,6 +8,7 @@
  * as published by the Free Software Foundation; either version
  * 2 of the License, or (at your option) any later version.
  */
+#include <linux/sched.h>
 #include <linux/highmem.h>
 #include <linux/module.h>
 
diff --git a/arch/m32r/include/asm/uaccess.h b/arch/m32r/include/asm/uaccess.h
index 84fe7ba..a097157 100644
--- a/arch/m32r/include/asm/uaccess.h
+++ b/arch/m32r/include/asm/uaccess.h
@@ -11,6 +11,7 @@
 /*
  * User space memory access functions
  */
+#include <linux/sched.h>
 #include <linux/errno.h>
 #include <linux/thread_info.h>
 #include <asm/page.h>
diff --git a/arch/microblaze/include/asm/highmem.h b/arch/microblaze/include/asm/highmem.h
index d046389..40c5b59 100644
--- a/arch/microblaze/include/asm/highmem.h
+++ b/arch/microblaze/include/asm/highmem.h
@@ -20,6 +20,7 @@
 #ifdef __KERNEL__
 
 #include <linux/init.h>
+#include <linux/sched.h>
 #include <linux/interrupt.h>
 #include <linux/uaccess.h>
 #include <asm/fixmap.h>
diff --git a/arch/mn10300/include/asm/uaccess.h b/arch/mn10300/include/asm/uaccess.h
index 5372787..274c9c2 100644
--- a/arch/mn10300/include/asm/uaccess.h
+++ b/arch/mn10300/include/asm/uaccess.h
@@ -14,6 +14,7 @@
 /*
  * User space memory access functions
  */
+#include <linux/sched.h>
 #include <linux/thread_info.h>
 #include <linux/kernel.h>
 #include <asm/page.h>
diff --git a/arch/parisc/include/asm/cacheflush.h b/arch/parisc/include/asm/cacheflush.h
index f0e2784..ab4ed76 100644
--- a/arch/parisc/include/asm/cacheflush.h
+++ b/arch/parisc/include/asm/cacheflush.h
@@ -2,6 +2,7 @@
 #define _PARISC_CACHEFLUSH_H
 
 #include <linux/mm.h>
+#include <linux/sched.h>
 #include <linux/uaccess.h>
 #include <asm/tlbflush.h>
 
diff --git a/arch/powerpc/include/asm/highmem.h b/arch/powerpc/include/asm/highmem.h
index caaf6e0..721bc1b 100644
--- a/arch/powerpc/include/asm/highmem.h
+++ b/arch/powerpc/include/asm/highmem.h
@@ -22,6 +22,7 @@
 
 #ifdef __KERNEL__
 
+#include <linux/sched.h>
 #include <linux/interrupt.h>
 #include <asm/kmap_types.h>
 #include <asm/tlbflush.h>
diff --git a/arch/powerpc/kernel/rtas.c b/arch/powerpc/kernel/rtas.c
index 80b5ef4..e479bcf 100644
--- a/arch/powerpc/kernel/rtas.c
+++ b/arch/powerpc/kernel/rtas.c
@@ -11,6 +11,7 @@
  *      2 of the License, or (at your option) any later version.
  */
 
+#include <linux/sched.h>
 #include <stdarg.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
diff --git a/arch/powerpc/lib/checksum_wrappers_64.c b/arch/powerpc/lib/checksum_wrappers_64.c
index 08e3a33..8d9598c 100644
--- a/arch/powerpc/lib/checksum_wrappers_64.c
+++ b/arch/powerpc/lib/checksum_wrappers_64.c
@@ -17,6 +17,7 @@
  *
  * Author: Anton Blanchard <anton@au.ibm.com>
  */
+#include <linux/sched.h>
 #include <linux/export.h>
 #include <linux/compiler.h>
 #include <linux/types.h>
diff --git a/arch/powerpc/lib/usercopy_64.c b/arch/powerpc/lib/usercopy_64.c
index 5eea6f3..8c8cfa6 100644
--- a/arch/powerpc/lib/usercopy_64.c
+++ b/arch/powerpc/lib/usercopy_64.c
@@ -6,6 +6,7 @@
  * as published by the Free Software Foundation; either version
  * 2 of the License, or (at your option) any later version.
  */
+#include <linux/sched.h>
 #include <linux/module.h>
 #include <asm/uaccess.h>
 
diff --git a/arch/tile/mm/highmem.c b/arch/tile/mm/highmem.c
index 347d123..f82b1e0 100644
--- a/arch/tile/mm/highmem.c
+++ b/arch/tile/mm/highmem.c
@@ -12,6 +12,7 @@
  *   more details.
  */
 
+#include <linux/sched.h>
 #include <linux/highmem.h>
 #include <linux/module.h>
 #include <linux/pagemap.h>
diff --git a/arch/x86/include/asm/checksum_32.h b/arch/x86/include/asm/checksum_32.h
index 46fc474..b9aa5d0 100644
--- a/arch/x86/include/asm/checksum_32.h
+++ b/arch/x86/include/asm/checksum_32.h
@@ -2,6 +2,7 @@
 #define _ASM_X86_CHECKSUM_32_H
 
 #include <linux/in6.h>
+#include <linux/sched.h>
 
 #include <asm/uaccess.h>
 
diff --git a/arch/x86/lib/csum-wrappers_64.c b/arch/x86/lib/csum-wrappers_64.c
index 25b7ae8..aaba241 100644
--- a/arch/x86/lib/csum-wrappers_64.c
+++ b/arch/x86/lib/csum-wrappers_64.c
@@ -4,6 +4,7 @@
  *
  * Wrappers of assembly checksum functions for x86-64.
  */
+#include <linux/sched.h>
 #include <asm/checksum.h>
 #include <linux/module.h>
 
diff --git a/arch/x86/mm/highmem_32.c b/arch/x86/mm/highmem_32.c
index 4500142..1212a56 100644
--- a/arch/x86/mm/highmem_32.c
+++ b/arch/x86/mm/highmem_32.c
@@ -1,3 +1,4 @@
+#include <linux/sched.h>
 #include <linux/highmem.h>
 #include <linux/module.h>
 #include <linux/swap.h> /* for totalram_pages */
diff --git a/arch/x86/mm/mmio-mod.c b/arch/x86/mm/mmio-mod.c
index 0057a7a..07b0235 100644
--- a/arch/x86/mm/mmio-mod.c
+++ b/arch/x86/mm/mmio-mod.c
@@ -24,6 +24,7 @@
 
 #define DEBUG 1
 
+#include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/debugfs.h>
 #include <linux/slab.h>
diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 290792a..20664e2 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -11,6 +11,7 @@
  * 	              Nauman Rafique <nauman@google.com>
  */
 #include <linux/ioprio.h>
+#include <linux/sched.h>
 #include <linux/kdev_t.h>
 #include <linux/module.h>
 #include <linux/err.h>
diff --git a/block/blk-core.c b/block/blk-core.c
index 93a18d1..cf9bb93 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -11,6 +11,7 @@
 /*
  * This handles all read/write requests to block devices
  */
+#include <linux/sched.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/backing-dev.h>
diff --git a/block/genhd.c b/block/genhd.c
index dadf42b..a5012aa9 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -2,6 +2,7 @@
  *  gendisk handling
  */
 
+#include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/genhd.h>
diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
index 6687ba7..b116b28 100644
--- a/drivers/base/dma-buf.c
+++ b/drivers/base/dma-buf.c
@@ -22,6 +22,7 @@
  * this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
+#include <linux/sched.h>
 #include <linux/fs.h>
 #include <linux/slab.h>
 #include <linux/dma-buf.h>
diff --git a/drivers/block/rsxx/dev.c b/drivers/block/rsxx/dev.c
index d7af441..a033bce 100644
--- a/drivers/block/rsxx/dev.c
+++ b/drivers/block/rsxx/dev.c
@@ -23,6 +23,7 @@
 */
 
 #include <linux/kernel.h>
+#include <linux/sched.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/pci.h>
diff --git a/drivers/dma/ipu/ipu_irq.c b/drivers/dma/ipu/ipu_irq.c
index 2e284a4..7f4b2e5 100644
--- a/drivers/dma/ipu/ipu_irq.c
+++ b/drivers/dma/ipu/ipu_irq.c
@@ -7,6 +7,7 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/sched.h>
 #include <linux/init.h>
 #include <linux/err.h>
 #include <linux/spinlock.h>
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index ff0fd65..906a80d 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1,3 +1,4 @@
+#include <linux/sched.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/interrupt.h>
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 177db6d..9aa758e 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -24,6 +24,7 @@
  */
  
  
+#include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/string.h>
diff --git a/drivers/infiniband/hw/amso1100/c2_cq.c b/drivers/infiniband/hw/amso1100/c2_cq.c
index 49e0e85..07f9d3a 100644
--- a/drivers/infiniband/hw/amso1100/c2_cq.c
+++ b/drivers/infiniband/hw/amso1100/c2_cq.c
@@ -35,6 +35,7 @@
  * SOFTWARE.
  *
  */
+#include <linux/sched.h>
 #include <linux/gfp.h>
 
 #include "c2.h"
diff --git a/drivers/infiniband/hw/cxgb3/iwch_cm.c b/drivers/infiniband/hw/cxgb3/iwch_cm.c
index 3e094cd..a0fba9c 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_cm.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_cm.c
@@ -29,6 +29,7 @@
  * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  * SOFTWARE.
  */
+#include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/list.h>
 #include <linux/slab.h>
diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 65c30ea..f0e6a5b 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -29,6 +29,7 @@
  * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  * SOFTWARE.
  */
+#include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/list.h>
 #include <linux/workqueue.h>
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 9e39d2b..43ee49a 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -5,6 +5,7 @@
  * This file is released under the GPL.
  */
 
+#include <linux/sched.h>
 #include "dm.h"
 #include "dm-uevent.h"
 
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 78ea443..fcf17e7 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -43,6 +43,7 @@
  * miss any bits.
  */
 
+#include <linux/sched.h>
 #include <linux/blkdev.h>
 #include <linux/kthread.h>
 #include <linux/raid/pq.h>
diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 49a5bca..f1832b0 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -10,6 +10,7 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
+#include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index e06186c..95eed3f 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -17,6 +17,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/kernel.h>
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c
index 8f03c98..d908719 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c
@@ -19,6 +19,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/crc32.h>
 #include <linux/netdevice.h>
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h
index d143a7c..01ebe72 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h
@@ -20,6 +20,7 @@
 #define BNX2X_SRIOV_H
 
 #include "bnx2x_vfpf.h"
+#include <linux/sched.h>
 #include "bnx2x.h"
 
 enum sample_bulletin_result {
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.c
index 98366ab..962e22a 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.c
@@ -17,6 +17,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/sched.h>
 #include "bnx2x_stats.h"
 #include "bnx2x_cmn.h"
 #include "bnx2x_sriov.h"
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 77f81cb..36aca7e 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -28,6 +28,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/init.h>
diff --git a/drivers/net/ethernet/intel/igbvf/netdev.c b/drivers/net/ethernet/intel/igbvf/netdev.c
index 93eb7ee..95d5430 100644
--- a/drivers/net/ethernet/intel/igbvf/netdev.c
+++ b/drivers/net/ethernet/intel/igbvf/netdev.c
@@ -27,6 +27,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/init.h>
diff --git a/drivers/net/ethernet/sfc/falcon.c b/drivers/net/ethernet/sfc/falcon.c
index 71998e7..a7a390f 100644
--- a/drivers/net/ethernet/sfc/falcon.c
+++ b/drivers/net/ethernet/sfc/falcon.c
@@ -8,6 +8,7 @@
  * by the Free Software Foundation, incorporated herein by reference.
  */
 
+#include <linux/sched.h>
 #include <linux/bitops.h>
 #include <linux/delay.h>
 #include <linux/pci.h>
diff --git a/drivers/net/ieee802154/at86rf230.c b/drivers/net/ieee802154/at86rf230.c
index 6f10b49..59350e3 100644
--- a/drivers/net/ieee802154/at86rf230.c
+++ b/drivers/net/ieee802154/at86rf230.c
@@ -21,6 +21,7 @@
  * Alexander Smirnov <alex.bluesman.smirnov@gmail.com>
  */
 #include <linux/kernel.h>
+#include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/interrupt.h>
 #include <linux/gpio.h>
diff --git a/drivers/net/ieee802154/fakelb.c b/drivers/net/ieee802154/fakelb.c
index b8d2217..124969c 100644
--- a/drivers/net/ieee802154/fakelb.c
+++ b/drivers/net/ieee802154/fakelb.c
@@ -23,6 +23,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/sched.h>
 #include <linux/timer.h>
 #include <linux/platform_device.h>
 #include <linux/netdevice.h>
diff --git a/drivers/net/wireless/ath/carl9170/usb.c b/drivers/net/wireless/ath/carl9170/usb.c
index 307bc0d..a6bc868 100644
--- a/drivers/net/wireless/ath/carl9170/usb.c
+++ b/drivers/net/wireless/ath/carl9170/usb.c
@@ -37,6 +37,7 @@
  *    OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+#include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/usb.h>
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index dc8059a..bc61ab3 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -15,6 +15,7 @@
  */
 
 #include <linux/etherdevice.h>
+#include <linux/sched.h>
 #include <linux/if_arp.h>
 
 #include "wil6210.h"
diff --git a/drivers/net/wireless/b43/dma.c b/drivers/net/wireless/b43/dma.c
index f7c70b3..2bdbd63 100644
--- a/drivers/net/wireless/b43/dma.c
+++ b/drivers/net/wireless/b43/dma.c
@@ -27,6 +27,7 @@
 
 */
 
+#include <linux/sched.h>
 #include "b43.h"
 #include "dma.h"
 #include "main.h"
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 0e933bb..6e49c09 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -32,6 +32,7 @@
 
 */
 
+#include <linux/sched.h>
 #include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/module.h>
diff --git a/drivers/net/wireless/b43/phy_a.c b/drivers/net/wireless/b43/phy_a.c
index a6c3810..0a7d6b6 100644
--- a/drivers/net/wireless/b43/phy_a.c
+++ b/drivers/net/wireless/b43/phy_a.c
@@ -26,6 +26,7 @@
 
 */
 
+#include <linux/sched.h>
 #include <linux/slab.h>
 
 #include "b43.h"
diff --git a/drivers/net/wireless/b43/phy_g.c b/drivers/net/wireless/b43/phy_g.c
index 12f467b..01141cd 100644
--- a/drivers/net/wireless/b43/phy_g.c
+++ b/drivers/net/wireless/b43/phy_g.c
@@ -26,6 +26,7 @@
 
 */
 
+#include <linux/sched.h>
 #include "b43.h"
 #include "phy_g.h"
 #include "phy_common.h"
diff --git a/drivers/net/wireless/b43legacy/dma.c b/drivers/net/wireless/b43legacy/dma.c
index faeafe2..f709415 100644
--- a/drivers/net/wireless/b43legacy/dma.c
+++ b/drivers/net/wireless/b43legacy/dma.c
@@ -27,6 +27,7 @@
 
 */
 
+#include <linux/sched.h>
 #include "b43legacy.h"
 #include "dma.h"
 #include "main.h"
diff --git a/drivers/net/wireless/b43legacy/radio.c b/drivers/net/wireless/b43legacy/radio.c
index 8961776..ff59e7e 100644
--- a/drivers/net/wireless/b43legacy/radio.c
+++ b/drivers/net/wireless/b43legacy/radio.c
@@ -29,6 +29,7 @@
 
 */
 
+#include <linux/sched.h>
 #include <linux/delay.h>
 
 #include "b43legacy.h"
diff --git a/drivers/net/wireless/cw1200/cw1200_spi.c b/drivers/net/wireless/cw1200/cw1200_spi.c
index d063760..c2795d4 100644
--- a/drivers/net/wireless/cw1200/cw1200_spi.c
+++ b/drivers/net/wireless/cw1200/cw1200_spi.c
@@ -14,6 +14,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/sched.h>
 #include <linux/gpio.h>
 #include <linux/delay.h>
 #include <linux/spinlock.h>
diff --git a/drivers/net/wireless/iwlwifi/dvm/sta.c b/drivers/net/wireless/iwlwifi/dvm/sta.c
index c3c13ce..71df3ce 100644
--- a/drivers/net/wireless/iwlwifi/dvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/dvm/sta.c
@@ -27,6 +27,7 @@
  *
  *****************************************************************************/
 #include <linux/etherdevice.h>
+#include <linux/sched.h>
 #include <net/mac80211.h>
 #include "iwl-trans.h"
 #include "dev.h"
diff --git a/drivers/net/wireless/iwlwifi/iwl-op-mode.h b/drivers/net/wireless/iwlwifi/iwl-op-mode.h
index 98c7aa7..92695a6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-op-mode.h
+++ b/drivers/net/wireless/iwlwifi/iwl-op-mode.h
@@ -64,6 +64,7 @@
 #define __iwl_op_mode_h__
 
 #include <linux/debugfs.h>
+#include <linux/sched.h>
 
 struct iwl_op_mode;
 struct iwl_trans;
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 8d91422c..231949f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -63,6 +63,7 @@
 #ifndef __iwl_trans_h__
 #define __iwl_trans_h__
 
+#include <linux/sched.h>
 #include <linux/ieee80211.h>
 #include <linux/mm.h> /* for page_address */
 #include <linux/lockdep.h>
diff --git a/drivers/net/wireless/libertas_tf/cmd.c b/drivers/net/wireless/libertas_tf/cmd.c
index 909ac36..fa69e9f 100644
--- a/drivers/net/wireless/libertas_tf/cmd.c
+++ b/drivers/net/wireless/libertas_tf/cmd.c
@@ -9,6 +9,7 @@
  */
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/sched.h>
 #include <linux/hardirq.h>
 #include <linux/slab.h>
 #include <linux/export.h>
diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index de8ffac..a581e34 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -8,6 +8,7 @@
  *   Address Translation Service 1.0
  */
 
+#include <linux/sched.h>
 #include <linux/pci.h>
 #include <linux/slab.h>
 #include <linux/mutex.h>
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index e37fea6..6b44f63 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -7,6 +7,7 @@
  *	Copyright 1997 -- 2000 Martin Mares <mj@ucw.cz>
  */
 
+#include <linux/sched.h>
 #include <linux/kernel.h>
 #include <linux/delay.h>
 #include <linux/init.h>
diff --git a/drivers/platform/olpc/olpc-ec.c b/drivers/platform/olpc/olpc-ec.c
index 0f9f859..dd3984a 100644
--- a/drivers/platform/olpc/olpc-ec.c
+++ b/drivers/platform/olpc/olpc-ec.c
@@ -6,6 +6,7 @@
  * Licensed under the GPL v2 or later.
  */
 #include <linux/completion.h>
+#include <linux/sched.h>
 #include <linux/debugfs.h>
 #include <linux/spinlock.h>
 #include <linux/mutex.h>
diff --git a/drivers/ssb/driver_pcicore.c b/drivers/ssb/driver_pcicore.c
index d75b72b..c343ee7 100644
--- a/drivers/ssb/driver_pcicore.c
+++ b/drivers/ssb/driver_pcicore.c
@@ -8,6 +8,7 @@
  * Licensed under the GNU/GPL. See COPYING for details.
  */
 
+#include <linux/sched.h>
 #include <linux/ssb/ssb.h>
 #include <linux/pci.h>
 #include <linux/export.h>
diff --git a/drivers/staging/lustre/lustre/llite/remote_perm.c b/drivers/staging/lustre/lustre/llite/remote_perm.c
index 68b2dc4..ceac936 100644
--- a/drivers/staging/lustre/lustre/llite/remote_perm.c
+++ b/drivers/staging/lustre/lustre/llite/remote_perm.c
@@ -44,6 +44,7 @@
 #define DEBUG_SUBSYSTEM S_LLITE
 
 #include <linux/module.h>
+#include <linux/sched.h>
 #include <linux/types.h>
 #include <linux/version.h>
 
diff --git a/drivers/staging/lustre/lustre/obdclass/cl_lock.c b/drivers/staging/lustre/lustre/obdclass/cl_lock.c
index d34e044..3fb55ff 100644
--- a/drivers/staging/lustre/lustre/obdclass/cl_lock.c
+++ b/drivers/staging/lustre/lustre/obdclass/cl_lock.c
@@ -41,6 +41,7 @@
 #define DEBUG_SUBSYSTEM S_CLASS
 
 #include <obd_class.h>
+#include <linux/sched.h>
 #include <obd_support.h>
 #include <lustre_fid.h>
 #include <linux/list.h>
diff --git a/drivers/staging/lustre/lustre/obdclass/cl_object.c b/drivers/staging/lustre/lustre/obdclass/cl_object.c
index cdb5fba..72a1ac4 100644
--- a/drivers/staging/lustre/lustre/obdclass/cl_object.c
+++ b/drivers/staging/lustre/lustre/obdclass/cl_object.c
@@ -52,6 +52,7 @@
 #define DEBUG_SUBSYSTEM S_CLASS
 
 #include <linux/libcfs/libcfs.h>
+#include <linux/sched.h>
 /* class_put_type() */
 #include <obd_class.h>
 #include <obd_support.h>
diff --git a/drivers/staging/lustre/lustre/obdclass/cl_page.c b/drivers/staging/lustre/lustre/obdclass/cl_page.c
index bb93359..f5189f8 100644
--- a/drivers/staging/lustre/lustre/obdclass/cl_page.c
+++ b/drivers/staging/lustre/lustre/obdclass/cl_page.c
@@ -41,6 +41,7 @@
 #define DEBUG_SUBSYSTEM S_CLASS
 
 #include <linux/libcfs/libcfs.h>
+#include <linux/sched.h>
 #include <obd_class.h>
 #include <obd_support.h>
 #include <linux/list.h>
diff --git a/drivers/staging/lustre/lustre/osc/osc_lock.c b/drivers/staging/lustre/lustre/osc/osc_lock.c
index 640bc3d..d38347b 100644
--- a/drivers/staging/lustre/lustre/osc/osc_lock.c
+++ b/drivers/staging/lustre/lustre/osc/osc_lock.c
@@ -43,6 +43,7 @@
 # include <linux/libcfs/libcfs.h>
 /* fid_build_reg_res_name() */
 #include <lustre_fid.h>
+#include <linux/sched.h>
 
 #include "osc_cl_internal.h"
 
diff --git a/drivers/staging/lustre/lustre/osc/osc_page.c b/drivers/staging/lustre/lustre/osc/osc_page.c
index baba959..ad2c6c7 100644
--- a/drivers/staging/lustre/lustre/osc/osc_page.c
+++ b/drivers/staging/lustre/lustre/osc/osc_page.c
@@ -41,6 +41,7 @@
 #define DEBUG_SUBSYSTEM S_OSC
 
 #include "osc_cl_internal.h"
+#include <linux/sched.h>
 
 static void osc_lru_del(struct client_obd *cli, struct osc_page *opg, bool del);
 static void osc_lru_add(struct client_obd *cli, struct osc_page *opg);
diff --git a/drivers/staging/lustre/lustre/ptlrpc/client.c b/drivers/staging/lustre/lustre/ptlrpc/client.c
index 22f7e65..6791b65 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/client.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/client.c
@@ -39,6 +39,7 @@
 #define DEBUG_SUBSYSTEM S_RPC
 
 #include <obd_support.h>
+#include <linux/sched.h>
 #include <obd_class.h>
 #include <lustre_lib.h>
 #include <lustre_ha.h>
diff --git a/drivers/staging/lustre/lustre/ptlrpc/gss/gss_cli_upcall.c b/drivers/staging/lustre/lustre/ptlrpc/gss/gss_cli_upcall.c
index 142c789..b2b893c 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/gss/gss_cli_upcall.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/gss/gss_cli_upcall.c
@@ -40,6 +40,7 @@
 
 #define DEBUG_SUBSYSTEM S_SEC
 #include <linux/init.h>
+#include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/dcache.h>
diff --git a/drivers/staging/lustre/lustre/ptlrpc/gss/gss_pipefs.c b/drivers/staging/lustre/lustre/ptlrpc/gss/gss_pipefs.c
index 3df7257..9dddaa8 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/gss/gss_pipefs.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/gss/gss_pipefs.c
@@ -48,6 +48,7 @@
 
 #define DEBUG_SUBSYSTEM S_SEC
 #include <linux/init.h>
+#include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/dcache.h>
diff --git a/drivers/staging/lustre/lustre/ptlrpc/sec.c b/drivers/staging/lustre/lustre/ptlrpc/sec.c
index 36e8bed..28dc4e6 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/sec.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/sec.c
@@ -41,6 +41,7 @@
 #define DEBUG_SUBSYSTEM S_SEC
 
 #include <linux/libcfs/libcfs.h>
+#include <linux/sched.h>
 #include <linux/crypto.h>
 #include <linux/key.h>
 
diff --git a/drivers/staging/lustre/lustre/ptlrpc/sec_config.c b/drivers/staging/lustre/lustre/ptlrpc/sec_config.c
index a45a392..c4b206c 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/sec_config.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/sec_config.c
@@ -37,6 +37,7 @@
 #define DEBUG_SUBSYSTEM S_SEC
 
 #include <linux/libcfs/libcfs.h>
+#include <linux/sched.h>
 #include <linux/crypto.h>
 #include <linux/key.h>
 
diff --git a/drivers/staging/lustre/lustre/ptlrpc/sec_gc.c b/drivers/staging/lustre/lustre/ptlrpc/sec_gc.c
index 4c96a14a..b512cbc 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/sec_gc.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/sec_gc.c
@@ -41,6 +41,7 @@
 #define DEBUG_SUBSYSTEM S_SEC
 
 #include <linux/libcfs/libcfs.h>
+#include <linux/sched.h>
 
 #include <obd_support.h>
 #include <obd_class.h>
diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index 014dc99..ae84867 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -23,6 +23,7 @@
  */
 
 #include <linux/bcd.h>
+#include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/version.h>
 #include <linux/kernel.h>
diff --git a/drivers/usb/core/urb.c b/drivers/usb/core/urb.c
index 16927fa..f033bcd0 100644
--- a/drivers/usb/core/urb.c
+++ b/drivers/usb/core/urb.c
@@ -1,3 +1,4 @@
+#include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/bitops.h>
diff --git a/drivers/video/atmel_lcdfb.c b/drivers/video/atmel_lcdfb.c
index effdb37..915836b 100644
--- a/drivers/video/atmel_lcdfb.c
+++ b/drivers/video/atmel_lcdfb.c
@@ -8,6 +8,7 @@
  * more details.
  */
 
+#include <linux/sched.h>
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
 #include <linux/dma-mapping.h>
diff --git a/fs/block_dev.c b/fs/block_dev.c
index c7bda5c..00f49af 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -5,6 +5,7 @@
  *  Copyright (C) 2001  Andrea Arcangeli <andrea@suse.de> SuSE
  */
 
+#include <linux/sched.h>
 #include <linux/init.h>
 #include <linux/mm.h>
 #include <linux/fcntl.h>
diff --git a/fs/buffer.c b/fs/buffer.c
index 4d74335..050c03b 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -18,6 +18,7 @@
  * async buffer flushing, 1999 Andrea Arcangeli <andrea@suse.de>
  */
 
+#include <linux/sched.h>
 #include <linux/kernel.h>
 #include <linux/syscalls.h>
 #include <linux/fs.h>
diff --git a/fs/dcache.c b/fs/dcache.c
index 87bdb53..ab41273 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -14,6 +14,7 @@
  * the dcache entry is deleted or garbage collected.
  */
 
+#include <linux/sched.h>
 #include <linux/syscalls.h>
 #include <linux/string.h>
 #include <linux/mm.h>
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 2bd8548..8caf634 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -22,6 +22,7 @@
  *  Assorted race fixes, rewrite of ext3_get_block() by Al Viro, 2000
  */
 
+#include <linux/sched.h>
 #include <linux/highuid.h>
 #include <linux/quotaops.h>
 #include <linux/writeback.h>
diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
index 72a3600..c94cb65 100644
--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -2,6 +2,7 @@
  * Interface between ext4 and JBD
  */
 
+#include <linux/sched.h>
 #include "ext4_jbd2.h"
 
 #include <trace/events/ext4.h>
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index dd32a2e..d12f990 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -18,6 +18,7 @@
  *  Assorted race fixes, rewrite of ext4_get_block() by Al Viro, 2000
  */
 
+#include <linux/sched.h>
 #include <linux/fs.h>
 #include <linux/time.h>
 #include <linux/jbd2.h>
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 4bbbf13b..108e7f6 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -22,6 +22,7 @@
  */
 
 #include "ext4_jbd2.h"
+#include <linux/sched.h>
 #include "mballoc.h"
 #include <linux/log2.h>
 #include <linux/module.h>
diff --git a/fs/file_table.c b/fs/file_table.c
index b44e4c5..b35edc4 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -5,6 +5,7 @@
  *  Copyright (C) 1997 David S. Miller (davem@caip.rutgers.edu)
  */
 
+#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/slab.h>
 #include <linux/file.h>
diff --git a/fs/inode.c b/fs/inode.c
index d6dfb09..ef3a12d 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2,6 +2,7 @@
  * (C) 1997 Linus Torvalds
  * (C) 1999 Andrea Arcangeli <andrea@suse.de> (dynamic inode allocation)
  */
+#include <linux/sched.h>
 #include <linux/export.h>
 #include <linux/fs.h>
 #include <linux/mm.h>
diff --git a/fs/jbd/revoke.c b/fs/jbd/revoke.c
index 25c713e..4642e55 100644
--- a/fs/jbd/revoke.c
+++ b/fs/jbd/revoke.c
@@ -81,6 +81,7 @@
  */
 
 #ifndef __KERNEL__
+#include <linux/sched.h>
 #include "jfs_user.h"
 #else
 #include <linux/time.h>
diff --git a/fs/jbd2/revoke.c b/fs/jbd2/revoke.c
index 198c9c1..b406894 100644
--- a/fs/jbd2/revoke.c
+++ b/fs/jbd2/revoke.c
@@ -81,6 +81,7 @@
  */
 
 #ifndef __KERNEL__
+#include <linux/sched.h>
 #include "jfs_user.h"
 #else
 #include <linux/time.h>
diff --git a/fs/locks.c b/fs/locks.c
index b27a300..b8a6709 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -114,6 +114,7 @@
  *  Stephen Rothwell <sfr@canb.auug.org.au>, June, 2000.
  */
 
+#include <linux/sched.h>
 #include <linux/capability.h>
 #include <linux/file.h>
 #include <linux/fdtable.h>
diff --git a/fs/nfs/nfs4filelayoutdev.c b/fs/nfs/nfs4filelayoutdev.c
index 95604f6..c26be3b 100644
--- a/fs/nfs/nfs4filelayoutdev.c
+++ b/fs/nfs/nfs4filelayoutdev.c
@@ -29,6 +29,7 @@
  */
 
 #include <linux/nfs_fs.h>
+#include <linux/sched.h>
 #include <linux/vmalloc.h>
 #include <linux/module.h>
 #include <linux/sunrpc/addr.h>
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index cf11799..90319a3 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -35,6 +35,7 @@
  *  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  */
 
+#include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/delay.h>
 #include <linux/errno.h>
diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index e22862f..c9acdbc 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -39,6 +39,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/fs.h>
 #include <linux/nfs_fs.h>
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 94c451c..462be53 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -21,6 +21,7 @@
  *
  */
 
+#include <linux/sched.h>
 #include <linux/buffer_head.h>
 #include <linux/slab.h>
 #include <linux/blkdev.h>
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 2b0ba35..eb9ba15 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -15,6 +15,7 @@
  * along with this program; if not, write the Free Software Foundation,
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
+#include <linux/sched.h>
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_types.h"
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index bde6469..17114e0 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -2,6 +2,7 @@
 #define _ASM_GENERIC_GPIO_H
 
 #include <linux/kernel.h>
+#include <linux/sched.h>
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/of.h>
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 91fa9a9..432e212 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -8,6 +8,7 @@
 #define _LINUX_BUFFER_HEAD_H
 
 #include <linux/types.h>
+#include <linux/sched.h>
 #include <linux/fs.h>
 #include <linux/linkage.h>
 #include <linux/pagemap.h>
diff --git a/include/linux/clk.h b/include/linux/clk.h
index 9a6d045..8b440a2 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -14,6 +14,7 @@
 
 #include <linux/err.h>
 #include <linux/kernel.h>
+#include <linux/sched.h>
 #include <linux/notifier.h>
 
 struct device;
diff --git a/include/linux/gpio.h b/include/linux/gpio.h
index 552e3f4..be83d05 100644
--- a/include/linux/gpio.h
+++ b/include/linux/gpio.h
@@ -2,6 +2,7 @@
 #define __LINUX_GPIO_H
 
 #include <linux/errno.h>
+#include <linux/sched.h>
 
 /* see Documentation/gpio.txt */
 
diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index 7fb31da..435de87 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -2,6 +2,7 @@
 #define _LINUX_HIGHMEM_H
 
 #include <linux/fs.h>
+#include <linux/sched.h>
 #include <linux/kernel.h>
 #include <linux/bug.h>
 #include <linux/mm.h>
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index e3dea75..a409785 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -5,6 +5,7 @@
  * Copyright 1995 Linus Torvalds
  */
 #include <linux/mm.h>
+#include <linux/sched.h>
 #include <linux/fs.h>
 #include <linux/list.h>
 #include <linux/highmem.h>
diff --git a/kernel/fork.c b/kernel/fork.c
index 403d2bb..f12e417 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -11,6 +11,7 @@
  * management can be a bitch. See 'mm/memory.c': 'copy_page_range()'
  */
 
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/unistd.h>
diff --git a/kernel/freezer.c b/kernel/freezer.c
index b462fa1..1d975d1 100644
--- a/kernel/freezer.c
+++ b/kernel/freezer.c
@@ -4,6 +4,7 @@
  * Originally from kernel/power/process.c
  */
 
+#include <linux/sched.h>
 #include <linux/interrupt.h>
 #include <linux/suspend.h>
 #include <linux/export.h>
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index a3bb14f..9948f28 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -10,6 +10,7 @@
  * Detailed information is available in Documentation/DocBook/genericirq
  */
 
+#include <linux/sched.h>
 #include <linux/irq.h>
 #include <linux/msi.h>
 #include <linux/module.h>
diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index 364ceab..d018644 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -13,6 +13,7 @@
  *             Pavel Emelianov <xemul@openvz.org>
  */
 
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/export.h>
 #include <linux/nsproxy.h>
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 5b5a708..c97c144 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -17,6 +17,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/tty.h>
 #include <linux/tty_driver.h>
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b7c32cb..74d7c04 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -26,6 +26,7 @@
  *              Thomas Gleixner, Mike Kravetz
  */
 
+#include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/nmi.h>
diff --git a/kernel/smp.c b/kernel/smp.c
index fe9f773..5b58226 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -9,6 +9,7 @@
 #include <linux/export.h>
 #include <linux/percpu.h>
 #include <linux/init.h>
+#include <linux/sched.h>
 #include <linux/gfp.h>
 #include <linux/smp.h>
 #include <linux/cpu.h>
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 83aff0a..e342674 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2,6 +2,7 @@
  * Generic hugetlb support.
  * (C) Nadia Yvette Chambers, April 2004
  */
+#include <linux/sched.h>
 #include <linux/list.h>
 #include <linux/init.h>
 #include <linux/module.h>
diff --git a/mm/memory.c b/mm/memory.c
index 1ce2e2a..61add89 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -38,6 +38,7 @@
  * Aug/Sep 2004 Changed to four level page tables (Andi Kleen)
  */
 
+#include <linux/sched.h>
 #include <linux/kernel_stat.h>
 #include <linux/mm.h>
 #include <linux/hugetlb.h>
diff --git a/mm/mmap.c b/mm/mmap.c
index 1edbaa3..1fda64c 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/backing-dev.h>
 #include <linux/mm.h>
diff --git a/mm/rmap.c b/mm/rmap.c
index cd356df..ca1c188 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -42,6 +42,7 @@
  *     pte map lock
  */
 
+#include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/pagemap.h>
 #include <linux/swap.h>
diff --git a/net/caif/cfcnfg.c b/net/caif/cfcnfg.c
index fa39fc2..2809fd5 100644
--- a/net/caif/cfcnfg.c
+++ b/net/caif/cfcnfg.c
@@ -6,6 +6,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ":%s(): " fmt, __func__
 
+#include <linux/sched.h>
 #include <linux/kernel.h>
 #include <linux/stddef.h>
 #include <linux/slab.h>
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index b931c96..f6de52c 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1,6 +1,7 @@
 #ifndef __MAC80211_DRIVER_OPS
 #define __MAC80211_DRIVER_OPS
 
+#include <linux/sched.h>
 #include <net/mac80211.h>
 #include "ieee80211_i.h"
 #include "trace.h"
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index e39cc91..9ae77d9 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -9,6 +9,7 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/sched.h>
 #include <linux/if_ether.h>
 #include <linux/etherdevice.h>
 #include <linux/list.h>
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 091088a..53db5ee 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -8,6 +8,7 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/sched.h>
 #include <net/mac80211.h>
 #include <linux/module.h>
 #include <linux/init.h>
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index aeb967a..5a5ae34 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -7,6 +7,7 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/etherdevice.h>
diff --git a/net/phonet/pep.c b/net/phonet/pep.c
index e774117..76bb2dc 100644
--- a/net/phonet/pep.c
+++ b/net/phonet/pep.c
@@ -22,6 +22,7 @@
  * 02110-1301 USA
  */
 
+#include <linux/sched.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/socket.h>
diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 74f6a70..6efea48 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -19,6 +19,7 @@
 
 
 #include <linux/module.h>
+#include <linux/sched.h>
 #include <linux/types.h>
 #include <linux/kallsyms.h>
 #include <linux/mm.h>
diff --git a/net/wimax/op-msg.c b/net/wimax/op-msg.c
index 0694d62..2d48d26 100644
--- a/net/wimax/op-msg.c
+++ b/net/wimax/op-msg.c
@@ -71,6 +71,7 @@
  *   wimax_msg_alloc()
  *   wimax_msg_send()
  */
+#include <linux/sched.h>
 #include <linux/device.h>
 #include <linux/slab.h>
 #include <net/genetlink.h>
diff --git a/net/wimax/op-reset.c b/net/wimax/op-reset.c
index 7ceffe3..30af0ee 100644
--- a/net/wimax/op-reset.c
+++ b/net/wimax/op-reset.c
@@ -28,6 +28,7 @@
  * disconnect and reconnect the device).
  */
 
+#include <linux/sched.h>
 #include <net/wimax.h>
 #include <net/genetlink.h>
 #include <linux/wimax.h>
diff --git a/net/wimax/op-rfkill.c b/net/wimax/op-rfkill.c
index 7ab60ba..6efe0bd 100644
--- a/net/wimax/op-rfkill.c
+++ b/net/wimax/op-rfkill.c
@@ -60,6 +60,7 @@
  * wimax_rfkill_rm()            [called by wimax_dev_add/rm()]
  */
 
+#include <linux/sched.h>
 #include <net/wimax.h>
 #include <net/genetlink.h>
 #include <linux/wimax.h>
diff --git a/net/wireless/wext-proc.c b/net/wireless/wext-proc.c
index e98a01c..e771c39 100644
--- a/net/wireless/wext-proc.c
+++ b/net/wireless/wext-proc.c
@@ -16,6 +16,7 @@
  * The content of the file is basically the content of "struct iw_statistics".
  */
 
+#include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
diff --git a/sound/core/info.c b/sound/core/info.c
index e79baa1..719a8ef 100644
--- a/sound/core/info.c
+++ b/sound/core/info.c
@@ -19,6 +19,7 @@
  *
  */
 
+#include <linux/sched.h>
 #include <linux/init.h>
 #include <linux/time.h>
 #include <linux/mm.h>
diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
index ea475cd..b44cea0 100644
--- a/virt/kvm/async_pf.c
+++ b/virt/kvm/async_pf.c
@@ -20,6 +20,7 @@
  * Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA.
  */
 
+#include <linux/sched.h>
 #include <linux/kvm_host.h>
 #include <linux/slab.h>
 #include <linux/module.h>
-- 
1.8.3.1

