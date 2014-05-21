Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469AbaEUX31 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 19:29:27 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:54465 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbaEUX3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 19:29:25 -0400
Message-ID: <537D36CF.8080301@gmail.com>
Date: Thu, 22 May 2014 07:29:19 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Guan Xuetao <gxt@mprc.pku.edu.cn>
CC: akpm@linux-foundation.org, holt@sgi.com, rmk+kernel@arm.linux.org.uk,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] arch: unicore32: ksyms: export several implemeted symbols
 to avoid compiling failure
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

unicore32 has implemented 'find_first_bit', 'find_first_zero_bit',
'pm_power_off', and '__cpuc_coherent_kern_range', need export them to
avoid compiling failure.

The related error (with allmodconfig under unicore32):

    MODPOST 4039 modules
  ERROR: "find_first_bit" [sound/soc/codecs/snd-soc-uda1380.ko] undefined!
  ERROR: "find_first_zero_bit" [net/sctp/sctp.ko] undefined!
  ERROR: "find_first_bit" [net/phonet/phonet.ko] undefined!
  ERROR: "find_first_zero_bit" [net/nfc/nfc.ko] undefined!
  ERROR: "find_first_zero_bit" [net/netfilter/nf_tables.ko] undefined!
  ERROR: "find_first_bit" [net/mac80211/mac80211.ko] undefined!
  ERROR: "find_first_zero_bit" [net/bridge/bridge.ko] undefined!
  ERROR: "find_first_bit" [net/bridge/bridge.ko] undefined!
  ERROR: "find_first_zero_bit" [fs/reiserfs/reiserfs.ko] undefined!
  ERROR: "find_first_bit" [fs/ocfs2/ocfs2.ko] undefined!
  ERROR: "find_first_zero_bit" [fs/ocfs2/cluster/ocfs2_nodemanager.ko] undefined!
  ERROR: "find_first_bit" [fs/ocfs2/cluster/ocfs2_nodemanager.ko] undefined!
  ERROR: "find_first_zero_bit" [fs/nfs/nfsv4.ko] undefined!
  ERROR: "find_first_zero_bit" [fs/minix/minix.ko] undefined!
  ERROR: "find_first_bit" [fs/hfsplus/hfsplus.ko] undefined!
  ERROR: "find_first_zero_bit" [fs/gfs2/gfs2.ko] undefined!
  ERROR: "find_first_zero_bit" [fs/bfs/bfs.ko] undefined!
  ERROR: "find_first_zero_bit" [drivers/uwb/uwb.ko] undefined!
  ERROR: "find_first_zero_bit" [drivers/usb/wusbcore/wusbcore.ko] undefined!
  ERROR: "find_first_bit" [drivers/usb/serial/usbserial.ko] undefined!
  ERROR: "find_first_bit" [drivers/usb/serial/option.ko] undefined!
  ERROR: "find_first_bit" [drivers/usb/host/fusbh200-hcd.ko] undefined!
  ERROR: "find_first_bit" [drivers/usb/host/fotg210-hcd.ko] undefined!
  ERROR: "find_first_bit" [drivers/usb/host/ehci-hcd.ko] undefined!
  ERROR: "find_first_bit" [drivers/tty/serial/rp2.ko] undefined!
  ERROR: "find_first_zero_bit" [drivers/tty/serial/jsm/jsm.ko] undefined!
  ERROR: "find_first_zero_bit" [drivers/staging/line6/line6usb.ko] undefined!
  ERROR: "find_first_bit" [drivers/staging/iio/meter/ade7758.ko] undefined!
  ERROR: "find_first_bit" [drivers/staging/iio/adc/mxs-lradc.ko] undefined!
  ERROR: "find_first_bit" [drivers/staging/iio/accel/sca3000.ko] undefined!
  ERROR: "find_first_zero_bit" [drivers/spi/spidev.ko] undefined!
  ERROR: "find_first_zero_bit" [drivers/scsi/ufs/ufshcd.ko] undefined!
  ERROR: "find_first_zero_bit" [drivers/scsi/sr_mod.ko] undefined!
  ERROR: "find_first_zero_bit" [drivers/scsi/qla4xxx/qla4xxx.ko] undefined!
  ERROR: "find_first_zero_bit" [drivers/scsi/qla2xxx/qla2xxx.ko] undefined!
  ERROR: "find_first_bit" [drivers/scsi/qla2xxx/qla2xxx.ko] undefined!
  ERROR: "find_first_zero_bit" [drivers/scsi/pmcraid.ko] undefined!
  ERROR: "find_first_zero_bit" [drivers/scsi/pm8001/pm80xx.ko] undefined!
  ERROR: "find_first_bit" [drivers/scsi/mvumi.ko] undefined!
  ERROR: "find_first_zero_bit" [drivers/scsi/mvsas/mvsas.ko] undefined!
  ERROR: "find_first_bit" [drivers/scsi/mpt3sas/mpt3sas.ko] undefined!
  ERROR: "find_first_bit" [drivers/scsi/mpt2sas/mpt2sas.ko] undefined!
  ERROR: "find_first_bit" [drivers/scsi/megaraid/megaraid_sas.ko] undefined!
  ERROR: "find_first_bit" [drivers/scsi/lpfc/lpfc.ko] undefined!
  ERROR: "find_first_zero_bit" [drivers/scsi/ipr.ko] undefined!
  ERROR: "find_first_zero_bit" [drivers/scsi/hpsa.ko] undefined!
  ERROR: "find_first_zero_bit" [drivers/scsi/aic94xx/aic94xx.ko] undefined!
  ERROR: "find_first_zero_bit" [drivers/net/wireless/ti/wlcore/wlcore.ko] undefined!
  ERROR: "find_first_bit" [drivers/net/wireless/ti/wlcore/wlcore.ko] undefined!
  ERROR: "find_first_zero_bit" [drivers/net/wireless/iwlwifi/mvm/iwlmvm.ko] undefined!
  ERROR: "find_first_bit" [drivers/net/wireless/iwlwifi/mvm/iwlmvm.ko] undefined!
  ERROR: "find_first_bit" [drivers/net/wireless/iwlwifi/dvm/iwldvm.ko] undefined!
  ERROR: "find_first_bit" [drivers/net/wireless/ath/carl9170/carl9170.ko] undefined!
  ERROR: "find_first_bit" [drivers/net/wireless/ath/ath9k/ath9k_hw.ko] undefined!
  ERROR: "find_first_zero_bit" [drivers/net/wireless/ath/ath9k/ath9k_htc.ko] undefined!
  ERROR: "find_first_zero_bit" [drivers/net/wireless/ath/ath10k/ath10k_core.ko] undefined!
  ERROR: "find_first_bit" [drivers/net/vmxnet3/vmxnet3.ko] undefined!
  ERROR: "find_first_bit" [drivers/net/ethernet/via/via-velocity.ko] undefined!
  ERROR: "find_first_bit" [drivers/net/ethernet/via/via-rhine.ko] undefined!
  ERROR: "find_first_bit" [drivers/net/ethernet/sfc/sfc.ko] undefined!
  ERROR: "find_first_bit" [drivers/net/ethernet/qlogic/qlge/qlge.ko] undefined!
  ERROR: "find_first_bit" [drivers/net/ethernet/qlogic/qlcnic/qlcnic.ko] undefined!
  ERROR: "find_first_bit" [drivers/net/ethernet/neterion/vxge/vxge.ko] undefined!
  ERROR: "find_first_bit" [drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.ko] undefined!
  ERROR: "find_first_bit" [drivers/net/ethernet/intel/ixgbevf/ixgbevf.ko] undefined!
  ERROR: "find_first_zero_bit" [drivers/net/ethernet/intel/ixgbe/ixgbe.ko] undefined!
  ERROR: "find_first_bit" [drivers/net/ethernet/intel/ixgbe/ixgbe.ko] undefined!
  ERROR: "find_first_bit" [drivers/net/ethernet/intel/ixgb/ixgb.ko] undefined!
  ERROR: "find_first_bit" [drivers/net/ethernet/intel/igbvf/igbvf.ko] undefined!
  ERROR: "find_first_bit" [drivers/net/ethernet/intel/igb/igb.ko] undefined!
  ERROR: "find_first_bit" [drivers/net/ethernet/intel/i40e/i40e.ko] undefined!
  ERROR: "find_first_bit" [drivers/net/ethernet/intel/e1000e/e1000e.ko] undefined!
  ERROR: "find_first_bit" [drivers/net/ethernet/intel/e1000/e1000.ko] undefined!
  ERROR: "find_first_bit" [drivers/net/ethernet/emulex/benet/be2net.ko] undefined!
  ERROR: "find_first_zero_bit" [drivers/net/ethernet/chelsio/cxgb4/cxgb4.ko] undefined!
  ERROR: "find_first_bit" [drivers/net/ethernet/brocade/bna/bna.ko] undefined!
  ERROR: "find_first_zero_bit" [drivers/net/ethernet/broadcom/cnic.ko] undefined!
  ERROR: "find_first_bit" [drivers/net/ethernet/adaptec/starfire.ko] undefined!
  ERROR: "find_first_bit" [drivers/mtd/sm_ftl.ko] undefined!
  ERROR: "find_first_bit" [drivers/mtd/nand/docg4.ko] undefined!
  ERROR: "find_first_zero_bit" [drivers/mtd/chips/cfi_cmdset_0001.ko] undefined!
  ERROR: "find_first_zero_bit" [drivers/mmc/card/mmc_block.ko] undefined!
  ERROR: "__cpuc_coherent_kern_range" [drivers/misc/lkdtm.ko] undefined!
  ERROR: "pm_power_off" [drivers/mfd/retu-mfd.ko] undefined!
  ERROR: "find_first_zero_bit" [drivers/media/v4l2-core/videodev.ko] undefined!
  ERROR: "find_first_zero_bit" [drivers/media/usb/tm6000/tm6000.ko] undefined!
  ERROR: "find_first_zero_bit" [drivers/media/usb/em28xx/em28xx.ko] undefined!
  ERROR: "find_first_zero_bit" [drivers/media/usb/cx231xx/cx231xx.ko] undefined!
  ERROR: "find_first_zero_bit" [drivers/media/rc/rc-core.ko] undefined!
  ERROR: "find_first_zero_bit" [drivers/media/platform/soc_camera/soc_camera.ko] undefined!
  ERROR: "find_first_zero_bit" [drivers/md/bcache/bcache.ko] undefined!
  ERROR: "find_first_zero_bit" [drivers/isdn/mISDN/mISDN_core.ko] undefined!
  ERROR: "find_first_bit" [drivers/input/keyboard/st-keyscan.ko] undefined!
  ERROR: "find_first_zero_bit" [drivers/infiniband/hw/nes/iw_nes.ko] undefined!
  ERROR: "find_first_zero_bit" [drivers/infiniband/hw/mthca/ib_mthca.ko] undefined!
  ERROR: "find_first_bit" [drivers/infiniband/hw/mthca/ib_mthca.ko] undefined!
  ERROR: "find_first_bit" [drivers/infiniband/hw/mlx5/mlx5_ib.ko] undefined!
  ERROR: "find_first_zero_bit" [drivers/infiniband/hw/cxgb4/iw_cxgb4.ko] undefined!
  ERROR: "find_first_zero_bit" [drivers/infiniband/hw/amso1100/iw_c2.ko] undefined!
  ERROR: "find_first_zero_bit" [drivers/infiniband/core/ib_uverbs.ko] undefined!
  ERROR: "find_first_zero_bit" [drivers/infiniband/core/ib_umad.ko] undefined!
  ERROR: "find_first_zero_bit" [drivers/infiniband/core/ib_ucm.ko] undefined!
  ERROR: "find_first_bit" [drivers/infiniband/core/ib_mad.ko] undefined!
  ERROR: "find_first_zero_bit" [drivers/infiniband/core/ib_core.ko] undefined!
  ERROR: "find_first_bit" [drivers/iio/light/tcs3472.ko] undefined!
  ERROR: "find_first_bit" [drivers/iio/light/gp2ap020a00f.ko] undefined!
  ERROR: "find_first_bit" [drivers/iio/light/adjd_s311.ko] undefined!
  ERROR: "find_first_bit" [drivers/iio/industrialio.ko] undefined!
  ERROR: "find_first_zero_bit" [drivers/iio/frequency/ad9523.ko] undefined!
  ERROR: "find_first_bit" [drivers/iio/adc/xilinx-xadc.ko] undefined!
  ERROR: "find_first_bit" [drivers/iio/adc/ti_am335x_adc.ko] undefined!
  ERROR: "find_first_bit" [drivers/iio/adc/max1363.ko] undefined!
  ERROR: "find_first_bit" [drivers/iio/adc/ad_sigma_delta.ko] undefined!
  ERROR: "find_first_bit" [drivers/iio/adc/ad7923.ko] undefined!
  ERROR: "find_first_bit" [drivers/iio/adc/ad7266.ko] undefined!
  ERROR: "find_first_bit" [drivers/iio/accel/bma180.ko] undefined!
  ERROR: "find_first_bit" [drivers/i2c/busses/i2c-designware-core.ko] undefined!
  ERROR: "find_first_zero_bit" [drivers/gpu/drm/radeon/radeon.ko] undefined!
  ERROR: "find_first_bit" [drivers/gpio/gpio-pcf857x.ko] undefined!
  ERROR: "pm_power_off" [drivers/char/ipmi/ipmi_poweroff.ko] undefined!
  ERROR: "find_first_zero_bit" [drivers/block/nvme.ko] undefined!
  ERROR: "find_first_bit" [drivers/block/nvme.ko] undefined!
  ERROR: "find_first_zero_bit" [drivers/block/null_blk.ko] undefined!
  ERROR: "find_first_zero_bit" [drivers/block/cciss.ko] undefined!
  ERROR: "find_first_zero_bit" [drivers/block/aoe/aoe.ko] undefined!
  ERROR: "find_first_bit" [drivers/bcma/bcma.ko] undefined!
  ERROR: "find_first_bit" [drivers/atm/lanai.ko] undefined!
  ERROR: "find_first_zero_bit" [drivers/atm/he.ko] undefined!
  make[1]: *** [__modpost] Error 1
  make: *** [modules] Error 2


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 arch/unicore32/kernel/ksyms.c   | 2 ++
 arch/unicore32/kernel/process.c | 1 +
 arch/unicore32/mm/proc-syms.c   | 2 ++
 3 files changed, 5 insertions(+)

diff --git a/arch/unicore32/kernel/ksyms.c b/arch/unicore32/kernel/ksyms.c
index e78911a..0323528 100644
--- a/arch/unicore32/kernel/ksyms.c
+++ b/arch/unicore32/kernel/ksyms.c
@@ -23,6 +23,8 @@
 
 #include "ksyms.h"
 
+EXPORT_SYMBOL(find_first_bit);
+EXPORT_SYMBOL(find_first_zero_bit);
 EXPORT_SYMBOL(find_next_zero_bit);
 EXPORT_SYMBOL(find_next_bit);
 
diff --git a/arch/unicore32/kernel/process.c b/arch/unicore32/kernel/process.c
index 778ebba..b008e99 100644
--- a/arch/unicore32/kernel/process.c
+++ b/arch/unicore32/kernel/process.c
@@ -60,6 +60,7 @@ void machine_halt(void)
  * Function pointers to optional machine specific functions
  */
 void (*pm_power_off)(void) = NULL;
+EXPORT_SYMBOL(pm_power_off);
 
 void machine_power_off(void)
 {
diff --git a/arch/unicore32/mm/proc-syms.c b/arch/unicore32/mm/proc-syms.c
index f30071e..21c00fc 100644
--- a/arch/unicore32/mm/proc-syms.c
+++ b/arch/unicore32/mm/proc-syms.c
@@ -19,5 +19,7 @@
 EXPORT_SYMBOL(cpu_dcache_clean_area);
 EXPORT_SYMBOL(cpu_set_pte);
 
+EXPORT_SYMBOL(__cpuc_coherent_kern_range);
+
 EXPORT_SYMBOL(__cpuc_dma_flush_range);
 EXPORT_SYMBOL(__cpuc_dma_clean_range);
-- 
1.9.2.459.g68773ac
