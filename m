Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751127AbaJIVDS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:03:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58856 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbaJIVDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:03:14 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kamal Mostafa <kamal@canonical.com>
Subject: [3.13.y.z extended stable] Linux 3.13.11.9 stable review
Date: Thu,  9 Oct 2014 14:00:25 -0700
Message-Id: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
X-Extended-Stable: 3.13
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the review cycle for the Linux 3.13.11.9 stable kernel.

This version contains 163 new patches, summarized below.  The new patches are
posted as replies to this message and also available in this git branch:

http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=linux-3.13.y-review;a=shortlog

git://kernel.ubuntu.com/ubuntu/linux.git  linux-3.13.y-review

The review period for version 3.13.11.9 will be open for the next three days.
To report a problem, please reply to the relevant follow-up patch message.

For more information about the Linux 3.13.y.z extended stable kernel version,
see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable .

 -Kamal

--
 arch/arm/include/asm/tls.h                         |  64 ++++++
 arch/arm/kernel/irq.c                              |   2 +-
 arch/arm/kernel/process.c                          |   2 +
 arch/arm/kernel/thumbee.c                          |   2 +-
 arch/arm/kernel/traps.c                            |  17 +-
 arch/arm/mm/alignment.c                            |   3 +
 arch/arm64/kernel/irq.c                            |   2 +-
 arch/arm64/kernel/process.c                        |  18 ++
 arch/arm64/kernel/sys_compat.c                     |   6 +
 arch/ia64/pci/fixup.c                              |   3 +-
 arch/mips/boot/compressed/decompress.c             |   1 +
 arch/mips/kernel/mcount.S                          |  12 ++
 arch/parisc/Makefile                               |   7 +-
 arch/parisc/kernel/syscall.S                       | 233 ++++++++++++++++++++-
 arch/x86/include/asm/vga.h                         |   6 -
 arch/x86/kernel/smpboot.c                          |   3 +
 arch/x86/pci/fixup.c                               |   4 +-
 block/genhd.c                                      |  24 ++-
 block/partition-generic.c                          |   2 +-
 drivers/acpi/acpi_cmos_rtc.c                       |   2 +-
 drivers/ata/ahci.c                                 |  10 +
 drivers/ata/ata_piix.c                             |   8 +
 drivers/cpufreq/integrator-cpufreq.c               |   4 +-
 drivers/gpu/drm/ast/ast_main.c                     |   3 +-
 drivers/gpu/drm/i915/i915_gem.c                    |  11 +-
 drivers/gpu/drm/i915/i915_gem_gtt.c                |  14 +-
 drivers/gpu/drm/i915/i915_reg.h                    |  12 +-
 drivers/gpu/drm/i915/intel_ringbuffer.c            |  66 +++---
 drivers/gpu/drm/i915/intel_tv.c                    |   4 +
 drivers/gpu/drm/nouveau/core/subdev/bar/nvc0.c     |   1 -
 drivers/gpu/drm/nouveau/core/subdev/fb/nvc0.c      |   1 +
 drivers/gpu/drm/nouveau/nouveau_vga.c              |   9 +
 drivers/gpu/drm/radeon/cik.c                       |   4 +-
 drivers/gpu/drm/radeon/cik_sdma.c                  |   7 -
 drivers/gpu/drm/radeon/ni_dma.c                    |   6 -
 drivers/gpu/drm/radeon/r600_dma.c                  |   9 -
 drivers/gpu/drm/radeon/radeon_atombios.c           |  33 ++-
 drivers/gpu/drm/radeon/radeon_device.c             |  11 +-
 drivers/gpu/drm/radeon/radeon_semaphore.c          |   2 +-
 drivers/gpu/vga/vga_switcheroo.c                   |   6 +
 drivers/gpu/vga/vgaarb.c                           |  38 +++-
 drivers/iio/accel/bma180.c                         |   2 +-
 drivers/iio/adc/ad_sigma_delta.c                   |   2 +-
 drivers/iio/adc/at91_adc.c                         |  10 +-
 .../iio/common/hid-sensors/hid-sensor-trigger.c    |   3 +-
 drivers/iio/common/st_sensors/st_sensors_trigger.c |   2 +-
 drivers/iio/gyro/itg3200_buffer.c                  |   2 +-
 drivers/iio/imu/inv_mpu6050/inv_mpu_trigger.c      |   2 +-
 drivers/iio/inkern.c                               |   2 +-
 drivers/iio/magnetometer/st_magn_core.c            |  52 +++--
 drivers/infiniband/hw/qib/qib_debugfs.c            |   3 +-
 drivers/infiniband/hw/qib/qib_qp.c                 |   8 -
 drivers/infiniband/ulp/isert/ib_isert.c            |   7 +-
 drivers/input/keyboard/atkbd.c                     |   8 -
 drivers/input/mouse/elantech.c                     |   7 +
 drivers/input/serio/i8042-x86ia64io.h              |  15 ++
 drivers/input/serio/serport.c                      |  45 +++-
 drivers/iommu/arm-smmu.c                           |  12 +-
 drivers/iommu/fsl_pamu_domain.c                    |  10 +-
 drivers/md/dm-cache-target.c                       |   4 +-
 drivers/md/raid1.c                                 |  40 ++--
 drivers/md/raid5.c                                 |  18 +-
 drivers/media/i2c/adv7604.c                        |   2 +-
 drivers/media/pci/cx18/cx18-driver.c               |   1 +
 drivers/media/v4l2-core/videobuf2-core.c           |   2 +-
 drivers/media/v4l2-core/videobuf2-dma-sg.c         |   2 +-
 drivers/net/can/at91_can.c                         |   8 +-
 drivers/net/can/flexcan.c                          |  41 +++-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c   |  25 ++-
 drivers/net/wireless/iwlwifi/dvm/rxon.c            |  12 ++
 drivers/net/wireless/iwlwifi/iwl-config.h          |   2 +
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c       |   4 +-
 drivers/net/wireless/iwlwifi/mvm/tx.c              |   8 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c        |   1 +
 drivers/phy/phy-twl4030-usb.c                      |  33 +--
 drivers/scsi/libiscsi.c                            |  10 +
 drivers/spi/spi-dw.c                               |   1 +
 drivers/spi/spi-fsl-espi.c                         |  15 +-
 drivers/spi/spi-fsl-spi.c                          |  10 +-
 drivers/spi/spi-sirf.c                             |   4 +-
 drivers/staging/iio/meter/ade7758_trigger.c        |   2 +-
 drivers/staging/imx-drm/ipuv3-plane.c              |   3 +-
 drivers/target/iscsi/iscsi_target.c                |   4 +-
 drivers/target/iscsi/iscsi_target_parameters.c     |   2 +-
 drivers/usb/core/hub.c                             |   4 +-
 drivers/usb/dwc3/core.c                            |  13 +-
 drivers/usb/dwc3/dwc3-omap.c                       |   2 +-
 drivers/usb/gadget/fusb300_udc.h                   |   2 +-
 drivers/usb/host/ehci-hcd.c                        |   2 -
 drivers/usb/host/xhci-hub.c                        |   8 +-
 drivers/usb/host/xhci-mem.c                        |   3 +-
 drivers/usb/host/xhci.c                            |  12 +-
 drivers/usb/phy/phy-tegra-usb.c                    |   4 +-
 drivers/usb/serial/ftdi_sio.c                      |   3 +
 drivers/usb/serial/ftdi_sio_ids.h                  |  12 ++
 drivers/usb/serial/sierra.c                        |   9 +-
 drivers/usb/serial/zte_ev.c                        |   8 +
 drivers/usb/storage/unusual_devs.h                 |  38 ++++
 drivers/uwb/lc-dev.c                               |  13 +-
 drivers/video/efifb.c                              |  39 ----
 drivers/xen/manage.c                               |   7 -
 fs/buffer.c                                        |   6 +-
 fs/cifs/cifsglob.h                                 |   5 -
 fs/cifs/inode.c                                    |   5 +-
 fs/cifs/readdir.c                                  |   4 +-
 fs/cifs/smb1ops.c                                  |   2 +-
 fs/cifs/smb2file.c                                 |   2 +-
 fs/cifs/smb2inode.c                                |   2 +-
 fs/cifs/smb2maperror.c                             |   2 +
 fs/cifs/smb2ops.c                                  |   2 +-
 fs/cifs/smb2pdu.c                                  |   2 +-
 fs/eventpoll.c                                     |   3 +-
 fs/lockd/svc.c                                     |   4 +-
 fs/namei.c                                         |  71 ++++---
 fs/nfs/client.c                                    |  12 +-
 fs/nfs/nfs4client.c                                |  38 ++--
 fs/nfs/nfs4proc.c                                  |  30 +--
 fs/nilfs2/inode.c                                  |   7 +-
 fs/notify/fdinfo.c                                 |   4 +-
 fs/ocfs2/dlm/dlmmaster.c                           |  18 +-
 include/linux/dcache.h                             |   7 +-
 include/linux/iio/trigger.h                        |   4 +-
 include/linux/jiffies.h                            |  12 --
 include/linux/vga_switcheroo.h                     |   2 +
 include/linux/workqueue.h                          |   2 +-
 include/net/regulatory.h                           |   2 +-
 init/Kconfig                                       |   2 +
 kernel/cgroup.c                                    |   5 +
 kernel/events/core.c                               |  14 +-
 kernel/fork.c                                      |   5 +-
 kernel/futex.c                                     |   1 +
 kernel/kcmp.c                                      |   7 +-
 kernel/time.c                                      |  54 ++---
 kernel/time/alarmtimer.c                           |  34 ++-
 lib/lzo/lzo1x_decompress_safe.c                    | 103 +++++----
 mm/huge_memory.c                                   |   7 +-
 mm/memcontrol.c                                    |  33 ++-
 mm/memory.c                                        |   2 +-
 mm/migrate.c                                       |   5 +-
 mm/page_alloc.c                                    |   7 +-
 mm/percpu-vm.c                                     |  22 +-
 mm/percpu.c                                        |   2 +
 mm/shmem.c                                         |   4 +-
 mm/slab.c                                          |  11 +-
 net/ceph/mon_client.c                              |   8 +
 net/mac80211/mlme.c                                |   3 +-
 sound/core/pcm_lib.c                               |   8 +-
 sound/pci/hda/patch_sigmatel.c                     |  17 +-
 sound/soc/davinci/davinci-mcasp.c                  |  11 +-
 sound/soc/samsung/i2s.c                            |  16 +-
 sound/soc/soc-core.c                               |   2 +-
 151 files changed, 1345 insertions(+), 583 deletions(-)

Al Cooper (1):
      usb: xhci: Fix OOPS in xhci error handling code

Al Viro (2):
      don't bugger nd->seq on set_root_rcu() from follow_dotdot_rcu()
      be careful with nd->inode in path_init() and follow_dotdot_rcu()

Alan Stern (1):
      USB: EHCI: unlink QHs even after the controller has stopped

Alban Crequy (1):
      cgroup: reject cgroup names with '\n'

Alex Deucher (9):
      drm/radeon: add connector quirk for fujitsu board
      drm/radeon/dpm: set the thermal type properly for special configs
      drm/radeon: don't reset dma on NI/SI init
      drm/radeon: don't reset sdma on CIK init
      drm/radeon: don't reset dma on r6xx-evergreen init
      vgaswitcheroo: add vga_switcheroo_fini_domain_pm_ops
      drm/radeon/px: fix module unload
      drm/nouveau/runpm: fix module unload
      drm/radeon/cik: use a separate counter for CP init timeout

Andreas Rohner (1):
      nilfs2: fix data loss with mmap()

Andrew Hunter (1):
      jiffies: Fix timeval conversion to jiffies

Andrey Vagin (2):
      fsnotify/fdinfo: use named constants instead of hardcoded values
      fs/notify: don't show f_handle if exportfs_encode_inode_fh failed

Anssi Hannula (1):
      dm cache: fix race causing dirty blocks to be marked as clean

Anton Altaparmakov (1):
      Fix nasty 32-bit overflow bug in buffer i/o code.

Arnd Bergmann (1):
      cpufreq: integrator: fix integrator_cpufreq_remove return type

Aurelien Jarno (1):
      MIPS: ZBOOT: add missing <linux/string.h> include

Axel Lin (2):
      spi: fsl: Don't use devm_kzalloc in master->setup callback
      spi: dw: Don't use devm_kzalloc in master->setup callback

Ben Skeggs (1):
      drm/nouveau: ltc/gf100-: fix cbc issues on certain boards

Bjørn Mork (2):
      USB: sierra: avoid CDC class functions on "68A3" devices
      USB: sierra: add 1199:68AA device ID

Bruno Prémont (2):
      x86, ia64: Move EFI_FB vga_default_device() initialization to pci_vga_fixup()
      vgaarb: Don't default exclusively to first video device with mem+io

Charles Keepax (1):
      ASoC: samsung-i2s: Check secondary DAI exists before referencing

Chris Wilson (3):
      drm/i915: Evict CS TLBs between batches
      drm/i915: Fix SRC_COPY width on 830/845g
      drm/i915: Flush the PTEs after updating them before suspend

Christian König (1):
      drm/radeon: fix semaphore value init

Clemens Ladisch (1):
      ALSA: pcm: fix fifo_size frame calculation

Cong Wang (2):
      nfs: fix kernel warning when removing proc entry
      perf: Fix a race condition in perf_remove_from_context()

Daniel Vetter (1):
      drm/i915: Fix EIO/wedged handling in gem fault handler

David Dueck (1):
      can: at91_can: add missing prepare and unprepare of the clock

David Jander (2):
      can: flexcan: correctly initialize mailboxes
      can: flexcan: implement workaround for errata ERR005829

David Rientjes (1):
      mm, slab: initialize object alignment on cache creation

Denis CIOCCA (1):
      iio:magnetometer: bugfix magnetometers gain values

Dmitry Torokhov (1):
      Input: atkbd - do not try 'deactivate' keyboard on any LG laptops

Eliad Peller (2):
      regulatory: add NUL to alpha2
      iwlwifi: increase DEFAULT_MAX_TX_POWER

Emmanuel Grumbach (1):
      Revert "iwlwifi: dvm: don't enable CTS to self"

Eyal Shapira (1):
      iwlwifi: mvm: treat EAPOLs like mgmt frames wrt rate

Felipe Balbi (4):
      usb: dwc3: core: fix order of PM runtime calls
      usb: dwc3: core: fix ordering for PHY suspend
      usb: dwc3: omap: fix ordering for runtime pm calls
      usb: host: xhci: fix compliance mode workaround

Guy Martin (1):
      parisc: Implement new LWS CAS supporting 64 bit operations.

Hans Verkuil (3):
      [media] cx18: fix kernel oops with tda8290 tuner
      [media] videobuf2-dma-sg: fix for wrong GFP mask to sg_alloc_table_from_pages
      [media] adv7604: fix inverted condition

Hans de Goede (3):
      Input: elantech - fix detection of touchpad on ASUS s301l
      Input: i8042 - add Fujitsu U574 to no_timeout dmi table
      Input: i8042 - add nomux quirk for Avatar AVIU-145A6

Honggang Li (1):
      percpu: free percpu allocation info for uniprocessor system

J. Bruce Fields (1):
      lockd: fix rpcbind crash on lockd startup failure

James Ralston (2):
      ahci: Add Device IDs for Intel 9 Series PCH
      ata_piix: Add Device IDs for Intel 9 Series PCH

Joe Lawrence (1):
      usb: hub: take hub->hdev reference when processing from eventlist

Joern Engel (1):
      iscsi-target: avoid NULL pointer in iscsi_copy_param_list failure

Johan Hovold (2):
      USB: zte_ev: fix removed PIDs
      USB: ftdi_sio: add support for NOVITUS Bono E thermal printer

Johannes Berg (1):
      Revert "mac80211: disable uAPSD if all ACs are under ACM"

Johannes Pointner (1):
      iio:inkern: fix overwritten -EPROBE_DEFER in of_iio_channel_get_by_name

Johannes Weiner (2):
      mm: memcontrol: do not iterate uninitialized memcgs
      mm: page_alloc: fix zone allocation fairness on UP

John David Anglin (1):
      parisc: Only use -mfast-indirect-calls option for 32-bit kernel builds

John Sung (1):
      Input: serport - add compat handling for SPIOCSTYPE ioctl

Joseph Qi (1):
      ocfs2/dlm: do not get resource spinlock if lockres is new

Josh Triplett (2):
      init/Kconfig: Hide printk log config if CONFIG_PRINTK=n
      init/Kconfig: Fix HAVE_FUTEX_CMPXCHG to not break up the EXPERT menu

Keith Busch (1):
      block: Fix dev_t minor allocation lifetime

Larry Finger (1):
      rtlwifi: rtl8192cu: Add new ID

Lee, Chun-Yi (1):
      ACPI / RTC: Fix CMOS RTC opregion handler accesses to wrong addresses

Ludovic Desroches (1):
      iio: adc: at91: don't use the last converted data register

Marc Kleine-Budde (2):
      can: flexcan: mark TX mailbox as TX_INACTIVE
      can: flexcan: put TX mailbox into TX_INACTIVE mode after tx-complete

Mark (4):
      storage: Add single-LUN quirk for Jaz USB Adapter
      USB: storage: Add quirk for Adaptec USBConnect 2000 USB-to-SCSI Adapter
      USB: storage: Add quirk for Ariston Technologies iConnect USB to SCSI adapter
      USB: storage: Add quirks for Entrega/Xircom USB to SCSI converters

Markos Chandras (1):
      MIPS: mcount: Adjust stack pointer for static trace in MIPS32

Mathias Nyman (2):
      xhci: Fix null pointer dereference if xhci initialization fails
      xhci: fix oops when xhci resumes from hibernate with hw lpm capable devices

Mel Gorman (2):
      mm: migrate: Close race between migration completion and mprotect
      mm: numa: Do not mark PTEs pte_numa when splitting huge pages

Mike Christie (1):
      [SCSI] libiscsi: fix potential buffer overrun in __iscsi_conn_send_pdu

Mike Marciniszyn (1):
      IB/qib: Correct reference counting in debugfs qp_stats

Miklos Szeredi (2):
      vfs: add d_is_dir()
      shmem: fix nlink for rename overwrite directory

Murali Karicheri (1):
      ahci: add pcid for Marvel 0x9182 controller

Nathan Lynch (2):
      ARM: 8148/1: flush TLS and thumbee register state during exec
      ARM: 8178/1: fix set_tls for !CONFIG_KUSER_HELPERS

NeilBrown (9):
      md/raid1: intialise start_next_window for READ case to avoid hang
      md/raid1:  be more cautious where we read-balance during resync.
      md/raid1: clean up request counts properly in close_sync()
      md/raid1: make sure resync waits for conflicting writes to complete.
      md/raid1: Don't use next_resync to determine how far resync has progressed
      md/raid1: update next_resync under resync_lock.
      md/raid1: count resync requests in nr_pending.
      md/raid1: fix_read_error should act on all non-faulty devices.
      md/raid5: disable 'DISCARD' by default due to safety concerns.

Nicholas Bellinger (1):
      iscsi-target: Fix memory corruption in iscsit_logout_post_handler_diffcid

Nicolas Iooss (1):
      eventpoll: fix uninitialized variable in epoll_ctl

Olav Haugan (1):
      iommu/arm-smmu: fix programming of SMMU_CBn_TCR for stage 1

Pavel Shilovsky (3):
      CIFS: Fix directory rename error
      CIFS: Fix wrong restart readdir for SMB1
      CIFS: Fix wrong filename length for SMB2

Peter Feiner (1):
      mm: softdirty: keep bit when zapping file pte

Peter Ujfalusi (1):
      ASoC: davinci-mcasp: Correct rx format unit configuration

Peter Zijlstra (1):
      perf: fix perf bug in fork()

Qipan Li (1):
      spi: sirf: enable RX_IO_DMA_INT interrupt

Rasmus Villemoes (2):
      usb: gadget: fusb300_udc.h: Fix typo in include guard
      kcmp: fix standard comparison bug

Richard Larocque (3):
      alarmtimer: Return relative times in timer_gettime
      alarmtimer: Do not signal SIGEV_NONE timers
      alarmtimer: Lock k_itimer during timer callback

Robin Murphy (1):
      ARM: 8165/1: alignment: don't break misaligned NEON load/store

Ross Lagerwall (1):
      xen/manage: Always freeze/thaw processes when suspend/resuming

Russell King (1):
      imx-drm: ipuv3-plane: fix ipu_plane_dpms()

Sage Weil (1):
      libceph: gracefully handle large reply messages from the mon

Sagi Grimberg (2):
      Target/iser: Get isert_conn reference once got to connected_handler
      Target/iser: Don't put isert_conn inside disconnected handler

Srinivas Pandruvada (8):
      iio:trigger: modify return value for iio_trigger_get
      iio: accel: bma180: Fix indio_dev->trig assignment
      iio: adc: ad_sigma_delta: Fix indio_dev->trig assignment
      iio: hid_sensor_hub: Fix indio_dev->trig assignment
      iio: st_sensors: Fix indio_dev->trig assignment
      iio: gyro: itg3200: Fix indio_dev->trig assignment
      iio: inv_mpu6050: Fix indio_dev->trig assignment
      iio: meter: ade7758: Fix indio_dev->trig assignment

Steve Dickson (1):
      NFSv4: nfs4_state_manager() vs. nfs_server_remove_lists()

Steve French (1):
      Fix problem recognizing symlinks

Sudeep Holla (2):
      arm64: use irq_set_affinity with force=false when migrating irqs
      ARM: 8133/1: use irq_set_affinity with force=false when migrating irqs

Sylwester Nawrocki (1):
      ASoC: samsung-i2s: Maintain CDCLK settings across i2s_{shutdown/startup}

Takashi Iwai (1):
      ALSA: hda - Fix invalid pin powermap without jack detection

Taylor Braun-Jones (1):
      USB: ftdi_sio: Add support for GE Healthcare Nemo Tracker device

Tejun Heo (3):
      percpu: fix pcpu_alloc_pages() failure path
      percpu: perform tlb flush after pcpu_map_pages() failure
      workqueue: apply __WQ_ORDERED to create_singlethread_workqueue()

Thierry Reding (1):
      usb: phy: tegra: Avoid use of sizeof(void)

Thomas Gleixner (1):
      futex: Unlock hb->lock in futex_wait_requeue_pi() error path

Thomas Pugliese (1):
      uwb: init beacon cache entry before registering uwb device

Tony Lindgren (1):
      usb: phy: twl4030-usb: Fix lost interrupts after ID pin goes down

Trond Myklebust (1):
      NFSv4: Fix another bug in the close/open_downgrade code

Varun Sethi (1):
      iommu/fsl: Fix warning resulting from adding PCI device twice

Ville Syrjälä (1):
      drm/i915: Wait for vblank before enabling the TV encoder

Vladimir Murzin (1):
      iommu/arm-smmu: remove pgtable_page_{c,d}tor()

Wanpeng Li (1):
      sched: Fix unreleased llc_shared_mask bit during CPU hotplug

Will Deacon (1):
      arm64: flush TLS registers during exec

Willy Tarreau (2):
      Revert "lzo: properly check for overruns"
      lzo: check for length overrun in variable length encoding.

Xiubo Li (1):
      ASoC: core: fix possible ZERO_SIZE_PTR pointer dereferencing error.

Y.C. Chen (2):
      drm/ast: open key before detect chips
      drm/ast: AST2000 cannot be detected correctly

Yaniv Rosner (1):
      bnx2x: Fix link for KR with swapped polarity lane

Zhaowei Yuan (1):
      [media] vb2: fix plane index sanity check in vb2_plane_cookie()
