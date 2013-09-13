Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538Ab3IMTA0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 15:00:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25528 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612Ab3IMTAS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 15:00:18 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=eIhxMilvRf8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=DfNHnWVPAAAA:8 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=XJ73DR3wAAAA:8 a=4OQvUKzGJ80WtCEZd1UA:9 a=QEXdDO2ut3YA:10 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=lBRciGGoxdUA:10 a=dGJ0OcVc7YAA:10 a=g3Y4LtA3PwEA:10 a=QOiWTXhdIhwbm5YG:21 a=RC4LAK-xlPgcxCZ3:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Fri, 13 Sep 2013 15:00:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: stable <stable@vger.kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>,
        "Berg, Johannes" <johannes.berg@intel.com>
Subject: Linux 3.6.11.9
Message-ID: <20130913150014.4df0e264@gandalf.local.home>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



I'm announcing the release of the 3.6.11.9 kernel.

Changes from 3.6.11.9-rc1:

Added:
  radeon kms: fix uninitialised hotplug work usage in r100_irq_process()
    (Sergey Senozhatsky <sergey.senozhatsky@gmail.com>)

  iwl4965: fix rfkill set state regression
    (Stanislaw Gruszka <sgruszka@redhat.com>)

Reverted:
  zram: use zram->lock to protect zram_free_page() in swap free notify path
    (Luis Henriques <luis.henriques@canonical.com>)

  genetlink: fix family dump race
    ("Berg, Johannes" <johannes.berg@intel.com>)

The updated 3.6.11.y git tree can be found at:

        git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git v3.6-stable

The patch can be downloaded at:
	https://www.kernel.org/pub/linux/kernel/projects/rt/3.6/stable/patch-3.6.11.9.xz

thanks,

-- Steve

 Documentation/i2c/busses/i2c-piix4                 |    2 +-
 Makefile                                           |    2 +-
 arch/arm/Kconfig                                   |    3 +-
 arch/arm/boot/compressed/atags_to_fdt.c            |   44 ++++-
 arch/arm/boot/dts/at91sam9n12ek.dts                |    4 +-
 arch/arm/include/asm/mmu.h                         |    2 +
 arch/arm/include/asm/mmu_context.h                 |   20 ++-
 arch/arm/include/asm/page.h                        |    2 +
 arch/arm/include/asm/thread_info.h                 |    1 -
 arch/arm/kernel/entry-armv.S                       |  103 ++++++------
 arch/arm/kernel/fiq.c                              |   19 ++-
 arch/arm/kernel/perf_event.c                       |   10 +-
 arch/arm/kernel/process.c                          |    7 +-
 arch/arm/kernel/traps.c                            |   37 +++--
 arch/arm/kernel/vmlinux.lds.S                      |   17 ++
 arch/arm/mach-davinci/board-dm355-leopard.c        |    1 +
 arch/arm/mach-davinci/board-dm644x-evm.c           |    1 +
 arch/arm/mach-davinci/board-dm646x-evm.c           |    1 +
 arch/arm/mach-davinci/board-neuros-osd2.c          |    1 +
 arch/arm/mm/Kconfig                                |   37 +++++
 arch/arm/mm/mmu.c                                  |   14 +-
 arch/m68k/emu/natfeat.c                            |   23 ++-
 arch/mips/Kconfig                                  |    2 +-
 arch/mips/cavium-octeon/setup.c                    |    3 +-
 arch/mips/include/asm/io.h                         |    5 +
 arch/powerpc/Kconfig                               |    1 +
 arch/powerpc/include/asm/module.h                  |    5 +-
 arch/powerpc/include/asm/page.h                    |   10 ++
 arch/powerpc/kernel/lparcfg.c                      |   23 +--
 arch/powerpc/kernel/setup_64.c                     |    2 +-
 arch/powerpc/kernel/vmlinux.lds.S                  |    3 -
 arch/x86/kernel/cpu/mtrr/generic.c                 |   21 +--
 arch/x86/kernel/cpu/mtrr/main.c                    |   16 +-
 arch/x86/kernel/cpu/perf_event_intel_uncore.c      |    4 +-
 arch/x86/kernel/early-quirks.c                     |   14 +-
 arch/x86/kernel/i387.c                             |    2 +-
 arch/x86/kernel/sys_x86_64.c                       |    2 +-
 arch/x86/mm/mmap.c                                 |    2 +-
 arch/x86/xen/setup.c                               |   22 +++
 arch/x86/xen/smp.c                                 |   11 +-
 block/cfq-iosched.c                                |   17 +-
 block/deadline-iosched.c                           |   16 +-
 block/elevator.c                                   |   25 +--
 block/noop-iosched.c                               |   17 +-
 drivers/acpi/acpi_memhotplug.c                     |    1 +
 drivers/acpi/battery.c                             |    2 +
 drivers/acpi/glue.c                                |    6 +-
 drivers/ata/Kconfig                                |    2 +-
 drivers/ata/ata_piix.c                             |    2 +
 drivers/ata/libata-pmp.c                           |   45 ++---
 drivers/ata/sata_fsl.c                             |    5 +-
 drivers/ata/sata_inic162x.c                        |   14 ++
 drivers/base/memory.c                              |    2 +
 drivers/block/xen-blkback/blkback.c                |   13 +-
 drivers/bluetooth/ath3k.c                          |   38 ++++-
 drivers/bluetooth/btusb.c                          |    3 +
 drivers/char/virtio_console.c                      |   47 +++---
 drivers/clocksource/dw_apb_timer_of.c              |    2 +-
 drivers/gpu/drm/ast/ast_ttm.c                      |    1 +
 drivers/gpu/drm/cirrus/cirrus_ttm.c                |    1 +
 drivers/gpu/drm/i915/i915_dma.c                    |   10 +-
 drivers/gpu/drm/i915/i915_reg.h                    |    4 +-
 drivers/gpu/drm/i915/intel_ringbuffer.c            |   12 ++
 drivers/gpu/drm/mgag200/mgag200_ttm.c              |    1 +
 drivers/gpu/drm/radeon/atom.c                      |    5 +
 drivers/gpu/drm/radeon/atombios_dp.c               |   43 ++++-
 drivers/gpu/drm/radeon/radeon_combios.c            |  151 +++++------------
 drivers/gpu/drm/radeon/radeon_irq_kms.c            |   11 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_gmr.c                |   58 ++++---
 drivers/hwmon/adt7470.c                            |    2 +-
 drivers/i2c/busses/Kconfig                         |    1 +
 drivers/i2c/busses/i2c-piix4.c                     |    3 +-
 drivers/iommu/amd_iommu.c                          |    6 +-
 drivers/macintosh/windfarm_rm31.c                  |   18 +-
 drivers/md/dm-mpath.c                              |    8 +-
 drivers/md/dm-verity.c                             |    5 +-
 drivers/md/dm.c                                    |    9 +-
 drivers/md/raid10.c                                |   12 +-
 drivers/md/raid5.c                                 |   15 +-
 drivers/md/raid5.h                                 |    1 +
 drivers/mtd/nand/Kconfig                           |    2 +-
 drivers/net/arcnet/arcnet.c                        |    2 +-
 drivers/net/can/usb/peak_usb/pcan_usb.c            |    2 +-
 drivers/net/dummy.c                                |    4 +
 drivers/net/ethernet/atheros/atl1c/atl1c.h         |    3 +
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c    |   40 ++++-
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c    |   28 +++-
 drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_82598.c |    3 +-
 drivers/net/ethernet/realtek/8139cp.c              |   48 +++++-
 drivers/net/ethernet/sun/sunvnet.c                 |    2 +
 drivers/net/ifb.c                                  |    8 +-
 drivers/net/macvtap.c                              |   66 +++++---
 drivers/net/tun.c                                  |   69 +++++---
 drivers/net/virtio_net.c                           |    5 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c     |    8 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.h        |    2 +
 drivers/net/wireless/ath/ath9k/calib.c             |    1 -
 drivers/net/wireless/ath/ath9k/htc_drv_init.c      |    1 +
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c      |   10 ++
 drivers/net/wireless/ath/ath9k/main.c              |    3 +-
 drivers/net/wireless/b43/Kconfig                   |    4 +-
 drivers/net/wireless/hostap/hostap_ioctl.c         |    4 +-
 drivers/net/wireless/iwlegacy/4965-mac.c           |   18 +-
 drivers/net/wireless/iwlegacy/common.c             |    1 +
 drivers/net/wireless/iwlwifi/dvm/mac80211.c        |    5 +-
 drivers/net/wireless/iwlwifi/pcie/drv.c            |    1 +
 drivers/net/wireless/iwlwifi/pcie/trans.c          |   10 +-
 drivers/net/wireless/mwifiex/sdio.c                |    4 +-
 drivers/net/wireless/rt2x00/rt2800lib.c            |    4 +-
 drivers/net/wireless/rt2x00/rt2x00queue.c          |   18 +-
 drivers/net/wireless/rt2x00/rt61pci.c              |    3 +-
 drivers/net/wireless/rt2x00/rt73usb.c              |    3 +-
 drivers/net/wireless/zd1201.c                      |    4 +-
 drivers/net/xen-netfront.c                         |   50 ++----
 drivers/of/fdt.c                                   |    2 +
 drivers/platform/olpc/olpc-ec.c                    |    2 +-
 drivers/rapidio/switches/idt_gen2.c                |    2 +
 drivers/s390/scsi/zfcp_aux.c                       |    5 +-
 drivers/s390/scsi/zfcp_erp.c                       |   29 +++-
 drivers/s390/scsi/zfcp_fsf.c                       |   27 ++-
 drivers/s390/scsi/zfcp_qdio.c                      |    8 +-
 drivers/s390/scsi/zfcp_scsi.c                      |   10 +-
 drivers/scsi/aacraid/src.c                         |    3 +
 drivers/scsi/isci/task.c                           |    9 +-
 drivers/scsi/megaraid/megaraid_sas_base.c          |   30 +++-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c               |    6 +-
 drivers/scsi/nsp32.c                               |    2 +-
 drivers/scsi/qla2xxx/qla_iocb.c                    |   11 +-
 drivers/scsi/scsi.c                                |    3 +
 drivers/scsi/sd.c                                  |   22 +--
 drivers/staging/android/logger.c                   |    4 +-
 drivers/staging/comedi/comedi_fops.c               |    7 +-
 drivers/staging/line6/pcm.c                        |    5 +-
 drivers/staging/zram/zram_drv.c                    |   36 ++--
 drivers/staging/zram/zram_sysfs.c                  |    2 +
 drivers/target/iscsi/iscsi_target_configfs.c       |    2 +-
 drivers/target/target_core_spc.c                   |    9 +-
 drivers/tty/hvc/hvsi_lib.c                         |    4 +-
 drivers/tty/serial/mxs-auart.c                     |   38 +++--
 drivers/usb/core/hub.c                             |    9 +
 drivers/usb/core/quirks.c                          |    6 +
 drivers/usb/dwc3/core.h                            |    4 +-
 drivers/usb/dwc3/gadget.c                          |    1 +
 drivers/usb/host/ehci-hub.c                        |    1 +
 drivers/usb/host/xhci-pci.c                        |    1 -
 drivers/usb/host/xhci-ring.c                       |    2 +-
 drivers/usb/host/xhci.c                            |   13 +-
 drivers/usb/misc/sisusbvga/sisusb.c                |    1 +
 drivers/usb/serial/cp210x.c                        |    4 +
 drivers/usb/serial/ftdi_sio.c                      |   31 +++-
 drivers/usb/serial/ftdi_sio_ids.h                  |   34 +++-
 drivers/usb/serial/keyspan.c                       |    2 +-
 drivers/usb/serial/mos7720.c                       |   21 ++-
 drivers/usb/serial/mos7840.c                       |  175 ++++++++++++--------
 drivers/usb/serial/option.c                        |   14 +-
 drivers/usb/serial/ti_usb_3410_5052.c              |   11 +-
 drivers/usb/serial/usb_wwan.c                      |   20 +--
 drivers/usb/storage/unusual_devs.h                 |    7 +
 drivers/usb/wusbcore/wa-xfer.c                     |    9 +-
 drivers/vhost/vhost.c                              |    2 +-
 drivers/vhost/vhost.h                              |    2 +-
 drivers/virtio/virtio_ring.c                       |   54 ++++--
 drivers/xen/events.c                               |    2 +-
 drivers/xen/evtchn.c                               |   21 +--
 fs/bio.c                                           |   20 ++-
 fs/block_dev.c                                     |    9 +-
 fs/btrfs/extent-tree.c                             |   13 ++
 fs/cifs/cifsencrypt.c                              |    2 +-
 fs/cifs/cifsglob.h                                 |    1 +
 fs/cifs/connect.c                                  |    7 +-
 fs/cifs/sess.c                                     |    6 +-
 fs/debugfs/inode.c                                 |   69 +++-----
 fs/ext4/ext4_jbd2.c                                |    8 +-
 fs/ext4/ialloc.c                                   |   10 +-
 fs/ext4/super.c                                    |   19 ++-
 fs/jfs/jfs_dtree.c                                 |   31 +++-
 fs/lockd/svclock.c                                 |    4 +
 fs/nfsd/vfs.c                                      |    5 +-
 fs/nilfs2/segbuf.c                                 |    5 +-
 fs/notify/fanotify/fanotify_user.c                 |    1 +
 fs/proc/task_mmu.c                                 |    8 +-
 fs/reiserfs/procfs.c                               |   92 +++-------
 fs/reiserfs/super.c                                |    3 +-
 fs/super.c                                         |   25 ++-
 include/linux/elevator.h                           |    6 +-
 include/linux/ftrace_event.h                       |    4 +-
 include/linux/if_vlan.h                            |    3 +-
 include/linux/regmap.h                             |    2 +
 include/linux/sched.h                              |    1 +
 include/linux/skbuff.h                             |    4 +-
 include/linux/user_namespace.h                     |    1 +
 include/linux/virtio.h                             |    4 +
 include/linux/wait.h                               |   57 +++++++
 include/net/ndisc.h                                |    2 +-
 include/net/udp.h                                  |    1 +
 kernel/cgroup.c                                    |    9 +-
 kernel/events/core.c                               |   28 +++-
 kernel/hrtimer.c                                   |   28 ++--
 kernel/power/autosleep.c                           |    3 +-
 kernel/printk.c                                    |    2 +-
 kernel/time/tick-broadcast.c                       |   10 +-
 kernel/trace/trace.c                               |    1 +
 kernel/trace/trace_syscalls.c                      |   21 ++-
 kernel/trace/trace_uprobe.c                        |    4 +-
 kernel/user_namespace.c                            |    4 +
 kernel/workqueue.c                                 |    9 +
 lib/Kconfig.debug                                  |    2 +-
 mm/memory.c                                        |    9 +-
 net/8021q/vlan_core.c                              |    2 +-
 net/8021q/vlan_dev.c                               |    7 +
 net/9p/trans_common.c                              |   10 +-
 net/core/dev.c                                     |   11 +-
 net/core/neighbour.c                               |   12 +-
 net/core/skbuff.c                                  |    4 +-
 net/ipv4/ip_vti.c                                  |    7 -
 net/ipv4/sysctl_net_ipv4.c                         |    6 +-
 net/ipv4/udp.c                                     |    3 +-
 net/ipv6/ip6_output.c                              |   16 +-
 net/ipv6/ip6mr.c                                   |    5 +
 net/ipv6/route.c                                   |    9 +-
 net/ipv6/udp.c                                     |    7 +-
 net/key/af_key.c                                   |    4 +
 net/l2tp/l2tp_ppp.c                                |    3 +-
 net/mac80211/cfg.c                                 |    2 +
 net/mac80211/rx.c                                  |   10 +-
 net/sched/sch_atm.c                                |    1 +
 net/sched/sch_cbq.c                                |    1 +
 net/sunrpc/svcsock.c                               |    5 +-
 net/sunrpc/xdr.c                                   |    9 +-
 net/sunrpc/xprtrdma/svc_rdma_marshal.c             |   20 ++-
 net/wireless/core.c                                |    1 +
 net/wireless/nl80211.c                             |    7 +-
 net/x25/af_x25.c                                   |   15 +-
 sound/arm/pxa2xx-pcm-lib.c                         |    2 +
 sound/core/compress_offload.c                      |    2 +-
 sound/core/seq/oss/seq_oss_init.c                  |   16 +-
 sound/core/seq/oss/seq_oss_midi.c                  |    2 +-
 sound/isa/opti9xx/opti92x-ad1848.c                 |    8 +-
 sound/pci/asihpi/asihpi.c                          |    3 +
 sound/pci/atiixp.c                                 |    2 +
 sound/pci/atiixp_modem.c                           |    2 +
 sound/pci/hda/patch_hdmi.c                         |    4 +-
 sound/pci/hda/patch_realtek.c                      |    2 +
 sound/soc/codecs/cs42l52.c                         |    2 +-
 sound/soc/codecs/max98088.c                        |    2 +-
 sound/soc/codecs/sgtl5000.h                        |    2 +-
 sound/soc/codecs/wm8962.c                          |   24 +--
 sound/soc/s6000/s6000-pcm.c                        |    2 +
 sound/soc/tegra/tegra30_i2s.c                      |    2 +-
 sound/usb/6fire/comm.c                             |   38 ++++-
 sound/usb/6fire/comm.h                             |    2 +-
 sound/usb/6fire/midi.c                             |   16 +-
 sound/usb/6fire/midi.h                             |    6 +-
 sound/usb/6fire/pcm.c                              |   55 +++++-
 sound/usb/6fire/pcm.h                              |    2 +-
 sound/usb/endpoint.c                               |   13 +-
 sound/usb/misc/ua101.c                             |   14 +-
 sound/usb/usx2y/usbusx2yaudio.c                    |    4 +
 258 files changed, 2144 insertions(+), 1107 deletions(-)
---------------------------
Aaro Koskinen (1):
      powerpc/windfarm: Fix noisy slots-fan on Xserve (rm31)

Aaron Plattner (1):
      ALSA: hda - Add new GPU codec ID to snd-hda

Al Viro (2):
      livelock avoidance in sget()
      reiserfs: fix deadlock in umount

Alex Deucher (3):
      drm/radeon: fix endian issues with DP handling (v3)
      drm/radeon: improve dac adjust heuristics for legacy pdac
      drm/radeon/atom: initialize more atom interpretor elements to 0

Alex Williamson (1):
      iommu/amd: Only unmap large pages from the first pte

Alexandr \\\"Sky\\\" Ivanov (1):
      USB: option: add D-Link DWM-152/C1 and DWM-156/C1

Amit Shah (5):
      virtio: console: fix race with port unplug and open/close
      virtio: console: fix race in port_fops_open() and port unplug
      virtio: console: clean up port data immediately at time of unplug
      virtio: console: fix raising SIGIO after port unplug
      virtio: console: return -ENODEV on all read operations after unplug

Andrew Vagin (1):
      tracing: Fix fields of struct trace_iterator that are zeroed by mistake

Anthony Foiani (1):
      sata_fsl: save irqs while coalescing

Anton Blanchard (1):
      powerpc/modules: Module CRC relocation fix causes perf issues

Arnd Bergmann (2):
      nsp32: use mdelay instead of large udelay constants
      mtd: omap2: allow bulding as a module

Barry Grussling (1):
      usb: cp210x support SEL C662 Vendor/Device

Baruch Siach (1):
      clocksource: dw_apb: Fix error check

Benjamin Herrenschmidt (1):
      powerpc: Don't Oops when accessing /proc/powerpc/lparcfg without hypervisor

Bjørn Mork (1):
      megaraid_sas: fix memory leak if SGL has zero length entries

Brian Austin (1):
      ASoC: cs42l52: Reorder Min/Max and update to SX_TLV for Beep Volume

Bu, Yitian (1):
      printk: Fix rq->lock vs logbuf_lock unlock lock inversion

Catalin Marinas (1):
      ARM: 7790/1: Fix deferred mm switch on VIVT processors

Chen Gang (2):
      powerpc/smp: Section mismatch from smp_release_cpus to __initdata spinning_secondaries
      cifs: extend the buffer length enought for sprintf() using

Chih-Chung Chang (1):
      ASoC: max98088 - fix element type of the register cache.

Cho, Yu-Chen (1):
      Bluetooth: Add support for Mediatek Bluetooth device [0e8d:763f]

Chris Wilson (1):
      drm/i915: Invalidate TLBs for the rings after a reset

Chuck Anderson (1):
      xen/smp: initialize IPI vectors before marking CPU online

Clemens Ladisch (1):
      ALSA: usb-audio: do not trust too-big wMaxPacketSize values

Cong Wang (1):
      vti: remove duplicated code to fix a memory leak

Curt Brune (1):
      hwmon: (adt7470) Fix incorrect return code check

Dan Carpenter (6):
      svcrdma: underflow issue in decode_write_list()
      fanotify: info leak in copy_event_to_user()
      arcnet: cleanup sizeof parameter
      af_key: more info leaks in pfkey messages
      net_sched: info leak in atm_tc_dump_class()
      Hostap: copying wrong data prism2_ioctl_giwaplist()

Dan Williams (1):
      usb: serial: option: add Olivetti Olicard 200

Daniel Drake (1):
      drivers/platform/olpc/olpc-ec.c: initialise earlier

Daniel Hansel (1):
      zfcp: fix adapter (re)open recovery while link to SAN is down

Dave Airlie (1):
      drm/ast: invalidate page tables when pinning a BO

Dave Jones (1):
      x25: Fix broken locking in ioctl error paths.

Dave Kleikamp (2):
      sunvnet: vnet_port_remove must call unregister_netdev
      jfs: fix readdir cookie incompatibility with NFSv4

David Jeffery (1):
      lockd: protect nlm_blocked access in nlmsvc_retry_blocked

David S. Miller (1):
      net_sched: Fix stack info leak in cbq_dump_wrr().

David Vrabel (3):
      xen/evtchn: avoid a deadlock when unbinding an event channel
      xen/events: initialize local per-cpu mask for all possible events
      x86/xen: do not identity map UNUSABLE regions in the machine E820

Egbert Eich (1):
      drm/mgag200: Invalidate page tables when pinning a BO

Eldad Zack (1):
      ALSA: usb-audio: 6fire: return correct XRUN indication

Emmanuel Grumbach (2):
      iwlwifi: add DELL SKU for 5150 HMC
      iwlwifi: pcie: disable L1 Active after pci_enable_device

Enrico Mioso (2):
      usb: serial: option: blacklist ONDA MT689DC QMI interface
      usb: serial: option.c: remove ONDA MT825UP product ID fromdriver

Eric Dumazet (4):
      neighbour: fix a race in neigh_destroy()
      vlan: mask vlan prio bits
      vlan: fix a race in egress prio management
      atl1c: Fix misuse of netdev_alloc_skb in refilling rx ring

Eugene Surovegin (1):
      powerpc/hvsi: Increase handshake timeout from 200ms to 400ms.

Ewan D. Milne (1):
      sd: fix crash when UA received on DIF enabled device

Fabio Estevam (1):
      ASoC: sglt5000: Fix SGTL5000_PLL_FRAC_DIV_MASK

Felipe Balbi (1):
      usb: dwc3: gadget: don't prevent gadget from being probed if we fail

Gabor Juhos (1):
      rt2x00: read 5GHz TX power values from the correct offset

Geert Uytterhoeven (1):
      m68k/atari: ARAnyM - Fix NatFeat module support

George Cherian (1):
      usb: host: xhci: Enable XHCI_SPURIOUS_SUCCESS for all controllers with xhci 1.0

Gregory CLEMENT (1):
      ARM: 7722/1: zImage: Convert 32bits memory size and address from ATAG to 64bits DTB

H.J. Lu (1):
      x86, fpu: correct the asm constraints for fxsave, unbreak mxcsr.daz

Hannes Frederic Sowa (4):
      ipv6: call udp_push_pending_frames when uncorking a socket with AF_INET pending data
      ipv6: ip6_append_data_mtu did not care about pmtudisc and frag_size
      ipv6: in case of link failure remove route directly instead of letting it expire
      ipv6: take rtnl_lock and mark mrt6 table as freed on namespace cleanup

Hannes Reinecke (1):
      dm mpath: fix ioctl deadlock when no paths

Harshula Jayasuriya (1):
      nfsd: nfsd_open: when dentry_open returns an error do not propagate as struct file

Hauke Mehrtens (1):
      b43: ensue that BCMA is "y" when B43 is "y"

Helmut Schaa (1):
      ath9k_htc: Restore skb headroom when returning skb to mac80211

Huang Rui (1):
      usb: dwc3: fix wrong bit mask in dwc3_event_type

Ian Abbott (1):
      staging: comedi: COMEDI_CANCEL ioctl should wake up read/write

Imre Deak (1):
      drm/i915: ivb: fix edp voltage swing reg val

J. Bruce Fields (1):
      svcrpc: fix handling of too-short rpc's

Jacob Keller (1):
      ixgbe: Fix Tx Hang issue with lldpad on 82598EB

Jakob Bornecrantz (1):
      drm/vmwgfx: Split GMR2_REMAP commands if they are to large

Jan Beulich (1):
      xen-netfront: pull on receive skb may need to happen earlier

Jan Kara (2):
      writeback: Fix periodic writeback after fs mount
      jbd2: Fix use after free after error in jbd2_journal_dirty_metadata()

Jason Wang (4):
      tuntap: correctly linearize skb when zerocopy is used
      macvtap: correctly linearize skb when zerocopy is used
      tuntap: do not zerocopy if iov needs more pages than MAX_SKB_FRAGS
      macvtap: do not zerocopy if iov needs more pages than MAX_SKB_FRAGS

Jeff Skirvin (1):
      isci: Fix a race condition in the SSP task management path

Jeff Wu (1):
      ACPI: add _STA evaluation at do_acpi_find_child()

Jiang Liu (5):
      zram: avoid invalid memory access in zram_exit()
      zram: destroy all devices on error recovery path in zram_init()
      zram: avoid double free in function zram_bvec_write()
      zram: avoid access beyond the zram device
      zram: protect sysfs handler from invalid memory access

Jianpeng Ma (1):
      elevator: Fix a race in elevator switching

Jiri Olsa (2):
      perf: Clone child context from parent context pmu
      perf: Remove WARN_ON_ONCE() check in __perf_event_enable() for valid scenario

Joe Perches (1):
      ndisc: Add missing inline to ndisc_addr_option_pad

Johan Hovold (10):
      USB: mos7840: fix memory leak in open
      USB: ti_usb_3410_5052: fix dynamic-id matching
      USB: mos7840: fix race in register handling
      USB: mos7840: fix device-type detection
      USB: mos7840: fix race in led handling
      USB: mos7840: fix pointer casts
      USB: ti_usb_3410_5052: fix big-endian firmware handling
      USB: mos7840: fix big-endian probe
      USB: mos7720: fix broken control requests
      USB: keyspan: fix null-deref at disconnect and release

Johannes Berg (3):
      mac80211: fix duplicate retransmission detection
      mac80211: fix ethtool stats for non-station interfaces
      cfg80211: fix P2P GO interface teardown

Josef Bacik (2):
      Btrfs: fix lock leak when resuming snapshot deletion
      Btrfs: re-add root to dead root list if we stop dropping it

Jussi Kivilinna (2):
      ALSA: 6fire: fix DMA issues with URB transfer_buffer usage
      zd1201: do not use stack as URB transfer_buffer

Jóhann B. Guðmundsson (1):
      USB: misc: Add Manhattan Hi-Speed USB DVI Converter to sisusbvga

Jörn Engel (1):
      iscsi-target: Fix tfc_tpg_nacl_auth_cit configfs length overflow

Karlis Ogsts (1):
      staging: android: logger: Correct write offset reset on error

Kevin Hilman (1):
      regmap: Add another missing header for !CONFIG_REGMAP stubs

Konrad Rzeszutek Wilk (1):
      xen/blkback: Check device permissions before allowing OP_DISCARD

Konstantin Khlebnikov (1):
      drm/i915: fix long-standing SNB regression in power consumption after resume v2

Lan Tianyu (1):
      ACPI / battery: Fix parsing _BIX return value

Li Zefan (1):
      cgroup: fix umount vs cgroup_cfts_commit() race

Liu ShuoX (1):
      PM / Sleep: avoid 'autosleep' in shutdown progress

Luiz Angelo Daros de Luca (1):
      usb: serial: cp210x: Add USB ID for Netgear Switches embedded serial adapter

Mahesh Rajashekhara (1):
      aacraid: Fix for arrays are going offline in the system. System hangs

Mark Kettenis (1):
      drm/radeon: fix combios tables on older cards

Markos Chandras (2):
      lib/Kconfig.debug: Restrict FRAME_POINTER for MIPS
      MIPS: Expose missing pci_io{map,unmap} declarations

Martin K. Petersen (1):
      Don't attempt to send extended INQUIRY command if skip_vpd_pages is set

Martin Peschke (2):
      zfcp: fix lock imbalance by reworking request queue locking
      zfcp: fix schedule-inside-lock in scsi_device list loops

Mateusz Krawczuk (1):
      regmap: Add missing header for !CONFIG_REGMAP stubs

Matt Burtch (1):
      USB-Serial: Fix error handling of usb_wwan

Michael S. Tsirkin (3):
      virtio: support unlocked queue poll
      virtio_net: fix race in RX VQ processing
      skb: report completion status for zero copy skbs

Michal Kazior (1):
      nl80211: fix mgmt tx status and testmode reporting for netns

Michal Srb (1):
      drm/cirrus: Invalidate page tables when pinning a BO

Michal Tesar (1):
      sysctl net: Keep tcp_syn_retries inside the boundary

Mikulas Patocka (1):
      dm verity: fix inability to use a few specific devices sizes

Neil Horman (3):
      atl1e: fix dma mapping warnings
      x86/iommu/vt-d: Expand interrupt remapping quirk to cover x58 chipset
      8139cp: Add dma_mapping_error checking

NeilBrown (3):
      md/raid10: fix two bugs affecting RAID10 reshape.
      md/raid5: fix interaction of 'replace' and 'recovery'.
      md/raid10: remove use-after-free bug.

Nicholas Bellinger (1):
      target: Fix trailing ASCII space usage in INQUIRY vendor+model

Nicolas Ferre (1):
      ARM: at91/DT: fix at91sam9n12ek memory node

Nicolas Pitre (1):
      ARM: 7816/1: CONFIG_KUSER_HELPERS: fix help text

Nicolin Chen (1):
      ASoC: wm8962: Remove remaining direct register cache accesses

Oleg Nesterov (2):
      userns: limit the maximum depth of user_namespace->parent chain
      debugfs: debugfs_remove_recursive() must not rely on list_empty(d_subdirs)

Oleksij Rempel (2):
      xhci: fix null pointer dereference on ring_doorbell_for_active_rings
      ath9k_htc: do some initial hardware configuration

Oliver Neukum (1):
      usb: add two quirky touchscreen

Paul Mackerras (1):
      powerpc: Work around gcc miscompilation of __pa() on 64-bit

Peter Zijlstra (1):
      perf: Fix perf_lock_task_context() vs RCU

Piotr Sarna (1):
      ext4: fix mount/remount error messages for incompatible mount options

Radu Caragea (1):
      x86 get_unmapped_area(): use proper mmap base for bottom-up direction

Ralf Baechle (2):
      MIPS: Oceton: Fix build error.
      RAPIDIO: IDT_GEN2: Fix build error.

Ren Bigcren (1):
      USB: storage: Add MicroVault Flash Drive to unusual_devs

Rick Farina (Zero_Chaos) (1):
      USB: serial: ftdi_sio: add more RT Systems ftdi devices

Roger Quadros (1):
      USB: EHCI: Fix resume signalling on remote wakeup

Roland Dreier (1):
      sg: Fix user memory corruption when SG_IO is interrupted by a signal

Russ Anderson (1):
      drivers/base/memory.c: fix show_mem_removable() to handle missing sections

Russell King (7):
      ARM: poison the vectors page
      ARM: poison memory between kuser helpers
      ARM: move vector stubs
      ARM: use linker magic for vectors and vector stubs
      ARM: update FIQ support for relocation of vectors
      ARM: allow kuser helpers to be removed from the vector page
      ARM: make vectors page inaccessible from userspace

Sami Rahman (1):
      USB: cp210x: add MMB and PI ZigBee USB Device Support

Sarah Sharp (1):
      xhci: Avoid NULL pointer deref when host dies.

Sasha Levin (1):
      9p: fix off by one causing access violations and memory corruption

Saurav Kashyap (1):
      qla2xxx: Properly set the tagging for commands.

Sekhar Nori (1):
      ARM: davinci: nand: specify ecc strength

Sergey Senozhatsky (3):
      radeon kms: do not flush uninitialized hotplug work
      zram: allow request end to coincide with disksize
      radeon kms: fix uninitialised hotplug work usage in r100_irq_process()

Seth Heasley (1):
      ata_piix: IDE-mode SATA patch for Intel Coleto Creek DeviceIDs

Shane Huang (1):
      i2c-piix4: Add AMD CZ SMBus device ID

Sreekanth Reddy (1):
      mpt2sas: fix firmware failure with wrong task attribute

Stanislaw Gruszka (6):
      Bluetooth: ath3k: don't use stack memory for DMA
      rt2x00: fix stop queue
      iwl4965: set power mode early
      iwl4965: reset firmware after rfkill off
      iwlwifi: dvm: fix calling ieee80211_chswitch_done() with NULL
      iwl4965: fix rfkill set state regression

Steffen Maier (2):
      zfcp: block queue limits with data router
      zfcp: status read buffers on first adapter open with link down

Stephane Grosjean (1):
      can: pcan_usb: fix wrong memcpy() bytes length

Stephen Boyd (1):
      perf/arm: Fix armpmu_map_hw_event()

Stephen Warren (1):
      ASoC: tegra: fix Tegra30 I2S capture parameter setup

Steven Rostedt (Red Hat) (1):
      Linux 3.6.11.9

Sujith Manoharan (3):
      ath9k_hw: Assign default xlna config for AR9485
      ath9k: Do not assign noise for NULL caldata
      ath9k: Enable PLL fix only for AR9340/AR9330

Sumit.Saxena@lsi.com (1):
      megaraid_sas: megaraid_sas driver init fails in kdump kernel

Takashi Iwai (13):
      ALSA: hda - Cache the MUX selection for generic HDMI
      ALSA: seq-oss: Initialize MIDI clients asynchronously
      ALSA: 6fire: Fix unlocked snd_pcm_stop() call
      ALSA: ua101: Fix unlocked snd_pcm_stop() call
      ALSA: pxa2xx: Fix unlocked snd_pcm_stop() call
      ALSA: atiixp: Fix unlocked snd_pcm_stop() call
      ALSA: asihpi: Fix unlocked snd_pcm_stop() call
      ALSA: usx2y: Fix unlocked snd_pcm_stop() call
      ASoC: s6000: Fix unlocked snd_pcm_stop() call
      staging: line6: Fix unlocked snd_pcm_stop() call
      ALSA: hda - Add a fixup for Gateway LT27
      ALSA: hda - Add inverted digital mic fixup for Acer Aspire One
      ALSA: opti9xx: Fix conflicting driver object name

Tejun Heo (3):
      libata: skip SRST for all SIMG [34]7x port-multipliers
      libata: make it clear that sata_inic162x is experimental
      workqueue: cond_resched() after processing each work item

Terry Suereth (1):
      libata: apply behavioral quirks to sil3826 PMP

Theodore Ts'o (2):
      ext4: make sure group number is bumped after a inode allocation race
      ext4: allow the mount options nodelalloc and data=journal

Thomas Gleixner (2):
      tick: Prevent uncontrolled switch to oneshot mode
      hrtimers: Move SMP function call to thread context

Thomas Pugliese (1):
      wusbcore: fix kernel panic when disconnecting a wireless USB->serial device

Tomasz Moń (1):
      mwifiex: Add missing endian conversion.

Torsten Schenk (2):
      ALSA: 6fire: make buffers DMA-able (pcm)
      ALSA: 6fire: make buffers DMA-able (midi)

Toshi Kani (1):
      ACPI / memhotplug: Fix a stale pointer in error path

Trond Myklebust (1):
      SUNRPC: Fix memory corruption issue on 32-bit highmem systems

Uwe Kleine-König (2):
      serial/mxs-auart: fix race condition in interrupt handler
      serial/mxs-auart: increase time to wait for transmitter to become idle

Vince Weaver (1):
      perf/x86: Fix intel QPI uncore event definitions

Vineet Gupta (1):
      mm: fix the TLB range flushed when __tlb_remove_page() runs out of slots

Vinod Koul (1):
      ALSA: compress: fix the return value for SNDRV_COMPRESS_VERSION

Vyacheslav Dubeyko (2):
      nilfs2: remove double bio_put() in nilfs_end_bio_write() for BIO_EOPNOTSUPP error
      nilfs2: fix issue with counting number of bio requests for BIO_EOPNOTSUPP error detection

Wei Yongjun (1):
      l2tp: add missing .owner to struct pppox_proto

Will Deacon (1):
      ARM: 7809/1: perf: fix event validation for software group leaders

William Gulland (1):
      usb: Clear both buffers when clearing a control transfer TT buffer.

Wladislav Wiebe (1):
      of: fdt: fix memory initialization for expanded DT

Yinghai Lu (1):
      x86: Fix /proc/mtrr with base/size more than 44bits

dingtianhong (3):
      ifb: fix rcu_sched self-detected stalls
      dummy: fix oops when loading the dummy failed
      ifb: fix oops when loading the ifb failed

yonghua zheng (1):
      fs/proc/task_mmu.c: fix buffer overflow in add_page_map()

zhangwei(Jovi) (2):
      uprobes: Fix return value in error handling path
      tracing: Fix irqs-off tag display in syscall tracing

----
