Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761731Ab3ECDJZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 23:09:25 -0400
Received: from intranet.asianux.com ([58.214.24.6]:14939 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729Ab3ECDJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 23:09:23 -0400
X-Spam-Score: -100.6
Message-ID: <51832A2A.4040003@asianux.com>
Date: Fri, 03 May 2013 11:08:26 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "'Jiri Kosina'" <trivial@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] trivial: beautify code, let 'inline' in front of 'void'
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Let 'inline' in front of 'void' to make code more beautiful.

It also can avoid the related warnings when EXTRA_CFLAGS=-W.


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/ia64/kernel/mca.c                         |    2 +-
 arch/ia64/sn/pci/pcibr/pcibr_ate.c             |    2 +-
 arch/ia64/sn/pci/tioce_provider.c              |    4 ++--
 arch/mips/emma/markeins/setup.c                |    2 +-
 arch/mips/sgi-ip32/ip32-irq.c                  |    4 ++--
 arch/sh/mm/cache-sh5.c                         |    2 +-
 arch/sparc/include/asm/spinlock_32.h           |    2 +-
 arch/sparc/include/asm/spinlock_64.h           |    8 ++++----
 arch/xtensa/platforms/iss/network.c            |    2 +-
 drivers/edac/amd64_edac.h                      |    2 +-
 drivers/net/ethernet/freescale/gianfar.c       |    2 +-
 drivers/net/wireless/ipw2x00/ipw2200.c         |    2 +-
 drivers/platform/x86/thinkpad_acpi.c           |    2 +-
 drivers/scsi/tmscsim.c                         |    2 +-
 drivers/video/omap/lcdc.c                      |    6 +++---
 fs/btrfs/delayed-ref.c                         |    2 +-
 include/linux/platform_data/usb-ohci-s3c2410.h |    2 +-
 sound/drivers/opl4/opl4_lib.c                  |    2 +-
 18 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/arch/ia64/kernel/mca.c b/arch/ia64/kernel/mca.c
index d7396db..f34627f 100644
--- a/arch/ia64/kernel/mca.c
+++ b/arch/ia64/kernel/mca.c
@@ -332,7 +332,7 @@ static void ia64_mlogbuf_dump_from_init(void)
 	ia64_mlogbuf_dump();
 }
 
-static void inline
+static inline void
 ia64_mca_spin(const char *func)
 {
 	if (monarch_cpu == smp_processor_id())
diff --git a/arch/ia64/sn/pci/pcibr/pcibr_ate.c b/arch/ia64/sn/pci/pcibr/pcibr_ate.c
index 5bc34ea..b67bb4c 100644
--- a/arch/ia64/sn/pci/pcibr/pcibr_ate.c
+++ b/arch/ia64/sn/pci/pcibr/pcibr_ate.c
@@ -140,7 +140,7 @@ static inline u64 __iomem *pcibr_ate_addr(struct pcibus_info *pcibus_info,
 /*
  * Update the ate.
  */
-void inline
+inline void
 ate_write(struct pcibus_info *pcibus_info, int ate_index, int count,
 	  volatile u64 ate)
 {
diff --git a/arch/ia64/sn/pci/tioce_provider.c b/arch/ia64/sn/pci/tioce_provider.c
index 46d3df4..3bd9abc 100644
--- a/arch/ia64/sn/pci/tioce_provider.c
+++ b/arch/ia64/sn/pci/tioce_provider.c
@@ -52,7 +52,7 @@
  * All registers defined in struct tioce will meet that criteria.
  */
 
-static void inline
+static inline void
 tioce_mmr_war_pre(struct tioce_kernel *kern, void __iomem *mmr_addr)
 {
 	u64 mmr_base;
@@ -78,7 +78,7 @@ tioce_mmr_war_pre(struct tioce_kernel *kern, void __iomem *mmr_addr)
 	}
 }
 
-static void inline
+static inline void
 tioce_mmr_war_post(struct tioce_kernel *kern, void __iomem *mmr_addr)
 {
 	u64 mmr_base;
diff --git a/arch/mips/emma/markeins/setup.c b/arch/mips/emma/markeins/setup.c
index d710058..a965266 100644
--- a/arch/mips/emma/markeins/setup.c
+++ b/arch/mips/emma/markeins/setup.c
@@ -90,7 +90,7 @@ void __init plat_time_init(void)
 static void markeins_board_init(void);
 extern void markeins_irq_setup(void);
 
-static void inline __init markeins_sio_setup(void)
+static inline void __init markeins_sio_setup(void)
 {
 }
 
diff --git a/arch/mips/sgi-ip32/ip32-irq.c b/arch/mips/sgi-ip32/ip32-irq.c
index e0c7d9e..838d858 100644
--- a/arch/mips/sgi-ip32/ip32-irq.c
+++ b/arch/mips/sgi-ip32/ip32-irq.c
@@ -28,12 +28,12 @@
 #include <asm/ip32/ip32_ints.h>
 
 /* issue a PIO read to make sure no PIO writes are pending */
-static void inline flush_crime_bus(void)
+static inline void flush_crime_bus(void)
 {
 	crime->control;
 }
 
-static void inline flush_mace_bus(void)
+static inline void flush_mace_bus(void)
 {
 	mace->perif.ctrl.misc;
 }
diff --git a/arch/sh/mm/cache-sh5.c b/arch/sh/mm/cache-sh5.c
index d1bffbc..dca8cf5 100644
--- a/arch/sh/mm/cache-sh5.c
+++ b/arch/sh/mm/cache-sh5.c
@@ -234,7 +234,7 @@ static void sh64_icache_inv_current_user_range(unsigned long start, unsigned lon
 #define DUMMY_ALLOCO_AREA_SIZE ((L1_CACHE_BYTES << 10) + (1024 * 4))
 static unsigned char dummy_alloco_area[DUMMY_ALLOCO_AREA_SIZE] __cacheline_aligned = { 0, };
 
-static void inline sh64_dcache_purge_sets(int sets_to_purge_base, int n_sets)
+static inline void sh64_dcache_purge_sets(int sets_to_purge_base, int n_sets)
 {
 	/* Purge all ways in a particular block of sets, specified by the base
 	   set number and number of sets.  Can handle wrap-around, if that's
diff --git a/arch/sparc/include/asm/spinlock_32.h b/arch/sparc/include/asm/spinlock_32.h
index bcc98fc..56637a2 100644
--- a/arch/sparc/include/asm/spinlock_32.h
+++ b/arch/sparc/include/asm/spinlock_32.h
@@ -131,7 +131,7 @@ static inline void arch_write_lock(arch_rwlock_t *rw)
 	*(volatile __u32 *)&lp->lock = ~0U;
 }
 
-static void inline arch_write_unlock(arch_rwlock_t *lock)
+static inline void arch_write_unlock(arch_rwlock_t *lock)
 {
 	__asm__ __volatile__(
 "	st		%%g0, [%0]"
diff --git a/arch/sparc/include/asm/spinlock_64.h b/arch/sparc/include/asm/spinlock_64.h
index 9689176..88ea252 100644
--- a/arch/sparc/include/asm/spinlock_64.h
+++ b/arch/sparc/include/asm/spinlock_64.h
@@ -92,7 +92,7 @@ static inline void arch_spin_lock_flags(arch_spinlock_t *lock, unsigned long fla
 
 /* Multi-reader locks, these are much saner than the 32-bit Sparc ones... */
 
-static void inline arch_read_lock(arch_rwlock_t *lock)
+static inline void arch_read_lock(arch_rwlock_t *lock)
 {
 	unsigned long tmp1, tmp2;
 
@@ -136,7 +136,7 @@ static int inline arch_read_trylock(arch_rwlock_t *lock)
 	return tmp1;
 }
 
-static void inline arch_read_unlock(arch_rwlock_t *lock)
+static inline void arch_read_unlock(arch_rwlock_t *lock)
 {
 	unsigned long tmp1, tmp2;
 
@@ -152,7 +152,7 @@ static void inline arch_read_unlock(arch_rwlock_t *lock)
 	: "memory");
 }
 
-static void inline arch_write_lock(arch_rwlock_t *lock)
+static inline void arch_write_lock(arch_rwlock_t *lock)
 {
 	unsigned long mask, tmp1, tmp2;
 
@@ -177,7 +177,7 @@ static void inline arch_write_lock(arch_rwlock_t *lock)
 	: "memory");
 }
 
-static void inline arch_write_unlock(arch_rwlock_t *lock)
+static inline void arch_write_unlock(arch_rwlock_t *lock)
 {
 	__asm__ __volatile__(
 "	stw		%%g0, [%0]"
diff --git a/arch/xtensa/platforms/iss/network.c b/arch/xtensa/platforms/iss/network.c
index 7d0fea6..3dce03e 100644
--- a/arch/xtensa/platforms/iss/network.c
+++ b/arch/xtensa/platforms/iss/network.c
@@ -173,7 +173,7 @@ static void dev_ip_addr(void *d, char *buf, char *bin_buf)
 
 /* Set Ethernet address of the specified device. */
 
-static void inline set_ether_mac(void *d, unsigned char *addr)
+static inline void set_ether_mac(void *d, unsigned char *addr)
 {
 	struct net_device *dev = d;
 	memcpy(dev->dev_addr, addr, ETH_ALEN);
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index 2c6f113..c116864 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -436,7 +436,7 @@ static inline int amd64_create_sysfs_dbg_files(struct mem_ctl_info *mci)
 {
 	return 0;
 }
-static void inline amd64_remove_sysfs_dbg_files(struct mem_ctl_info *mci)
+static inline void amd64_remove_sysfs_dbg_files(struct mem_ctl_info *mci)
 {
 }
 #endif
diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index 2375a01..7d20095 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -2029,7 +2029,7 @@ static inline void gfar_tx_checksum(struct sk_buff *skb, struct txfcb *fcb,
 	fcb->flags = flags;
 }
 
-void inline gfar_tx_vlan(struct sk_buff *skb, struct txfcb *fcb)
+inline void gfar_tx_vlan(struct sk_buff *skb, struct txfcb *fcb)
 {
 	fcb->flags |= TXFCB_VLN;
 	fcb->vlctl = vlan_tx_tag_get(skb);
diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c b/drivers/net/wireless/ipw2x00/ipw2200.c
index d96257b..4eb9fda 100644
--- a/drivers/net/wireless/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/ipw2x00/ipw2200.c
@@ -4092,7 +4092,7 @@ static const char *ipw_get_status_code(u16 status)
 	return "Unknown status value.";
 }
 
-static void inline average_init(struct average *avg)
+static inline void average_init(struct average *avg)
 {
 	memset(avg, 0, sizeof(*avg));
 }
diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 54d31c0..d20d5dc 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -7091,7 +7091,7 @@ static struct ibm_struct volume_driver_data = {
 
 #define alsa_card NULL
 
-static void inline volume_alsa_notify_change(void)
+static inline void volume_alsa_notify_change(void)
 {
 }
 
diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
index 9327f5f..f6419c4 100644
--- a/drivers/scsi/tmscsim.c
+++ b/drivers/scsi/tmscsim.c
@@ -352,7 +352,7 @@ static u8  dc390_clock_speed[] = {100,80,67,57,50, 40, 31, 20};
  * (DCBs, SRBs, Queueing)
  *
  **********************************************************************/
-static void inline dc390_start_segment(struct dc390_srb* pSRB)
+static inline void dc390_start_segment(struct dc390_srb* pSRB)
 {
 	struct scatterlist *psgl = pSRB->pSegmentList;
 
diff --git a/drivers/video/omap/lcdc.c b/drivers/video/omap/lcdc.c
index b52f625..bce59bc 100644
--- a/drivers/video/omap/lcdc.c
+++ b/drivers/video/omap/lcdc.c
@@ -80,12 +80,12 @@ static struct omap_lcd_controller {
 	unsigned long		vram_size;
 } lcdc;
 
-static void inline enable_irqs(int mask)
+static inline void enable_irqs(int mask)
 {
 	lcdc.irq_mask |= mask;
 }
 
-static void inline disable_irqs(int mask)
+static inline void disable_irqs(int mask)
 {
 	lcdc.irq_mask &= ~mask;
 }
@@ -467,7 +467,7 @@ static void calc_ck_div(int is_tft, int pck, int *pck_div)
 	}
 }
 
-static void inline setup_regs(void)
+static inline void setup_regs(void)
 {
 	u32 l;
 	struct lcd_panel *panel = lcdc.fbdev->panel;
diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index b7a0641..3deb1c5 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -237,7 +237,7 @@ int btrfs_delayed_ref_lock(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
-static void inline drop_delayed_ref(struct btrfs_trans_handle *trans,
+static inline void drop_delayed_ref(struct btrfs_trans_handle *trans,
 				    struct btrfs_delayed_ref_root *delayed_refs,
 				    struct btrfs_delayed_ref_node *ref)
 {
diff --git a/include/linux/platform_data/usb-ohci-s3c2410.h b/include/linux/platform_data/usb-ohci-s3c2410.h
index 7fa1fbe..cc7554a 100644
--- a/include/linux/platform_data/usb-ohci-s3c2410.h
+++ b/include/linux/platform_data/usb-ohci-s3c2410.h
@@ -31,7 +31,7 @@ struct s3c2410_hcd_info {
 	void		(*report_oc)(struct s3c2410_hcd_info *, int ports);
 };
 
-static void inline s3c2410_usb_report_oc(struct s3c2410_hcd_info *info, int ports)
+static inline void s3c2410_usb_report_oc(struct s3c2410_hcd_info *info, int ports)
 {
 	if (info->report_oc != NULL) {
 		(info->report_oc)(info, ports);
diff --git a/sound/drivers/opl4/opl4_lib.c b/sound/drivers/opl4/opl4_lib.c
index b953fb4..1999c01 100644
--- a/sound/drivers/opl4/opl4_lib.c
+++ b/sound/drivers/opl4/opl4_lib.c
@@ -29,7 +29,7 @@ MODULE_AUTHOR("Clemens Ladisch <clemens@ladisch.de>");
 MODULE_DESCRIPTION("OPL4 driver");
 MODULE_LICENSE("GPL");
 
-static void inline snd_opl4_wait(struct snd_opl4 *opl4)
+static inline void snd_opl4_wait(struct snd_opl4 *opl4)
 {
 	int timeout = 10;
 	while ((inb(opl4->fm_port) & OPL4_STATUS_BUSY) && --timeout > 0)
-- 
1.7.7.6
