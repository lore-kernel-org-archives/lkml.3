Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751298AbaDALP5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:15:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42056 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbaDALPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:15:53 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Luis Henriques <luis.henriques@canonical.com>
Subject: [3.11.y.z extended stable] Linux 3.11.10.7 stable review
Date: Tue,  1 Apr 2014 12:13:24 +0100
Message-Id: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
X-Extended-Stable: 3.11
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the review cycle for the Linux 3.11.10.7 stable kernel.

This version contains 144 new patches, summarized below.  The new patches are
posted as replies to this message and also available in this git branch:

http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=linux-3.11.y-review;a=shortlog

git://kernel.ubuntu.com/ubuntu/linux.git  linux-3.11.y-review

The review period for version 3.11.10.7 will be open for the next three days.
To report a problem, please reply to the relevant follow-up patch message.

For more information about the Linux 3.11.y.z extended stable kernel version,
see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable .

 -Luis

--
 arch/arm/Kconfig                                   |   2 +
 arch/arm/include/asm/memory.h                      |   9 +-
 arch/arm/include/asm/outercache.h                  |   4 +-
 arch/arm/kernel/setup.c                            |  30 +++-
 arch/arm/mach-highbank/highbank.c                  |  13 +-
 arch/arm/mach-sa1100/include/mach/collie.h         |   2 +
 arch/mips/include/asm/mipsregs.h                   |   1 +
 arch/powerpc/kernel/process.c                      |   9 ++
 arch/powerpc/kernel/reloc_64.S                     |   1 +
 arch/x86/include/asm/topology.h                    |   3 +-
 arch/x86/kernel/head_32.S                          |   7 +-
 arch/x86/kernel/head_64.S                          |   6 +-
 arch/x86/kernel/i387.c                             |  15 +-
 arch/x86/kernel/quirks.c                           |   2 +-
 arch/x86/kvm/mmu.c                                 |   9 ++
 arch/x86/kvm/paging_tmpl.h                         |   8 +
 arch/x86/kvm/svm.c                                 |   6 +-
 arch/x86/net/bpf_jit.S                             |   2 +-
 drivers/acpi/ec.c                                  |   2 +-
 drivers/acpi/resource.c                            |  10 ++
 drivers/acpi/sleep.c                               |  32 ++--
 drivers/ata/libata-core.c                          |   1 +
 drivers/clocksource/vf_pit_timer.c                 |   2 +-
 drivers/firewire/core-device.c                     |  22 ++-
 drivers/firewire/net.c                             |   6 +-
 drivers/firewire/ohci.c                            |  31 ++--
 drivers/firewire/sbp2.c                            |  17 ++-
 drivers/gpu/drm/i915/i915_drv.c                    |  23 ++-
 drivers/gpu/drm/i915/i915_gem_stolen.c             |   7 +
 drivers/gpu/drm/i915/intel_hdmi.c                  |   6 +-
 drivers/gpu/drm/i915/intel_pm.c                    |   6 +-
 drivers/gpu/drm/radeon/atombios_encoders.c         |   2 +-
 drivers/gpu/drm/radeon/cik.c                       |  61 ++++----
 drivers/gpu/drm/radeon/evergreen.c                 |  33 ++--
 drivers/gpu/drm/radeon/evergreen_smc.h             |   2 +-
 drivers/gpu/drm/radeon/ni.c                        |  36 ++---
 drivers/gpu/drm/radeon/r600.c                      |  16 +-
 drivers/gpu/drm/radeon/radeon_ttm.c                |   3 +
 drivers/gpu/drm/radeon/rv770.c                     |  16 +-
 drivers/gpu/drm/radeon/si.c                        |  18 +--
 drivers/gpu/drm/ttm/ttm_bo.c                       |   8 +-
 drivers/hid/hid-lg4ff.c                            |  22 +--
 drivers/i2c/busses/Kconfig                         |   2 +-
 drivers/i2c/busses/i2c-cpm.c                       |   2 +
 drivers/infiniband/ulp/isert/ib_isert.c            | 125 +++++++--------
 drivers/infiniband/ulp/isert/ib_isert.h            |   4 +-
 drivers/input/mouse/synaptics.c                    |  55 +++++++
 drivers/input/mousedev.c                           |  73 +++++----
 drivers/md/dm-cache-target.c                       |  11 +-
 drivers/media/pci/cx18/cx18-driver.c               |   5 +-
 drivers/media/usb/dvb-usb/cxusb.c                  |  21 ++-
 drivers/media/usb/dvb-usb/dw2102.c                 |  52 +++++--
 drivers/mmc/host/sdhci.c                           |  17 +--
 drivers/net/can/flexcan.c                          | 168 ++++++++++++++++-----
 drivers/net/ethernet/broadcom/tg3.c                |   3 +-
 drivers/net/ethernet/broadcom/tg3.h                |   6 +-
 drivers/net/ethernet/ibm/ibmveth.c                 |  25 +--
 drivers/net/ethernet/ibm/ibmveth.h                 |   1 -
 drivers/net/ethernet/marvell/mvneta.c              |  43 ++----
 drivers/net/ethernet/sfc/ptp.c                     |   7 +
 drivers/net/ethernet/ti/davinci_emac.c             |  25 ++-
 drivers/net/virtio_net.c                           |   3 +-
 drivers/net/vmxnet3/vmxnet3_drv.c                  |  19 ++-
 .../net/wireless/ath/ath9k/ar9462_2p0_initvals.h   |   4 +-
 drivers/net/wireless/ath/ath9k/xmit.c              |   8 +-
 drivers/net/wireless/iwlwifi/dvm/mac80211.c        |  22 ++-
 drivers/net/wireless/iwlwifi/dvm/sta.c             |   1 +
 drivers/net/wireless/iwlwifi/dvm/tx.c              |  14 +-
 drivers/net/wireless/iwlwifi/iwl-drv.c             |   2 +-
 drivers/net/wireless/iwlwifi/iwl-modparams.h       |  11 +-
 drivers/net/wireless/iwlwifi/mvm/bt-coex.c         |   7 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c        |  22 ++-
 drivers/net/wireless/iwlwifi/mvm/mvm.h             |   2 +-
 drivers/net/wireless/iwlwifi/mvm/tx.c              |  18 +--
 drivers/net/wireless/mwifiex/11ac.c                |   3 +-
 drivers/net/wireless/mwifiex/11n.c                 |   3 +-
 drivers/net/wireless/mwifiex/pcie.c                |  34 ++---
 drivers/net/wireless/mwifiex/scan.c                |   8 +-
 drivers/net/wireless/mwifiex/usb.c                 |   8 -
 drivers/net/wireless/mwifiex/wmm.c                 |   3 +-
 drivers/net/wireless/p54/txrx.c                    |   2 +-
 drivers/pci/pci.c                                  |   3 +
 drivers/pinctrl/pinctrl-sunxi.c                    |   4 +
 drivers/pnp/pnpacpi/rsparser.c                     |  15 +-
 drivers/rapidio/devices/tsi721.h                   |   1 +
 drivers/rapidio/devices/tsi721_dma.c               |  27 ++--
 drivers/regulator/core.c                           |  48 +++---
 drivers/s390/block/dasd.c                          |   8 +-
 drivers/scsi/isci/host.h                           |   5 +-
 drivers/scsi/isci/port_config.c                    |   7 -
 drivers/scsi/isci/task.c                           |   2 +-
 drivers/scsi/qla2xxx/qla_def.h                     |   3 +-
 drivers/scsi/storvsc_drv.c                         |   3 +
 drivers/spi/spi-ath79.c                            |   4 +-
 drivers/staging/zram/zram_drv.c                    |   2 +
 drivers/target/iscsi/iscsi_target.c                |  21 ++-
 drivers/target/iscsi/iscsi_target_erl2.c           |  16 +-
 drivers/target/iscsi/iscsi_target_tpg.c            |   2 +-
 drivers/usb/core/config.c                          |   4 +
 drivers/usb/core/quirks.c                          |   4 +
 fs/btrfs/compression.c                             |   2 +
 fs/ext4/inode.c                                    |  15 +-
 fs/namei.c                                         |   1 +
 fs/nfs/delegation.c                                |  11 +-
 fs/nfs/nfs4proc.c                                  |   5 +-
 fs/ocfs2/file.c                                    |   8 +-
 fs/ocfs2/quota_global.c                            |  27 ++--
 fs/ocfs2/quota_local.c                             |   4 -
 fs/proc/base.c                                     |   1 +
 include/linux/bitops.h                             |  15 ++
 include/linux/ceph/messenger.h                     |   2 +-
 include/linux/ceph/osd_client.h                    |   1 +
 include/linux/firewire.h                           |   1 +
 include/linux/ftrace_event.h                       |   4 -
 include/linux/jiffies.h                            |   8 +-
 include/linux/mm.h                                 |   2 +-
 include/linux/tracepoint.h                         |   6 +
 include/net/tcp.h                                  |   3 +-
 include/target/iscsi/iscsi_transport.h             |   1 +
 include/trace/ftrace.h                             |   7 +-
 ipc/msg.c                                          |   2 +
 kernel/cpuset.c                                    |  10 +-
 kernel/irq/manage.c                                |   3 +-
 kernel/printk/printk.c                             |   2 -
 kernel/sched/fair.c                                |   8 +-
 kernel/trace/trace_events.c                        |  16 +-
 kernel/trace/trace_export.c                        |   7 +-
 kernel/tracepoint.c                                |   7 +-
 mm/compaction.c                                    |  20 ++-
 mm/huge_memory.c                                   |   2 +-
 mm/memcontrol.c                                    |  14 ++
 net/ceph/messenger.c                               |   7 +-
 net/ceph/mon_client.c                              |   8 +-
 net/ceph/osd_client.c                              |  66 ++++++--
 net/core/neighbour.c                               |   6 +-
 net/ipv4/tcp.c                                     |   8 +-
 net/ipv4/tcp_output.c                              |   7 +-
 net/ipv6/exthdrs_core.c                            |   2 +-
 net/ipv6/udp_offload.c                             |   2 +-
 net/mac80211/mesh_ps.c                             |   1 +
 net/mac80211/mlme.c                                |  23 +++
 net/mac80211/sta_info.c                            |   5 +
 net/mac80211/sta_info.h                            |   7 +-
 net/mac80211/tx.c                                  |  15 ++
 net/mac80211/wme.c                                 |   5 +
 net/sctp/sm_statefuns.c                            |   7 +
 net/unix/af_unix.c                                 |   3 +-
 scripts/package/builddeb                           |   9 +-
 sound/core/compress_offload.c                      |   2 +-
 sound/pci/hda/patch_analog.c                       |   1 +
 sound/pci/hda/patch_realtek.c                      |   1 +
 sound/pci/oxygen/xonar_dg.c                        |  12 +-
 sound/soc/codecs/max98090.c                        |   1 +
 sound/usb/mixer.c                                  |   1 +
 154 files changed, 1242 insertions(+), 701 deletions(-)

Aisheng Dong (1):
      mmc: sdhci: fix lockdep error in tuning routine

Al Viro (1):
      ocfs2 syncs the wrong range...

Ales Novak (1):
      [SCSI] storvsc: NULL pointer dereference fix

Alex Deucher (6):
      drm/radeon/dpm: fix typo in EVERGREEN_SMC_FIRMWARE_HEADER_softRegisters
      drm/radeon/atom: select the proper number of lanes in transmitter setup
      drm/radeon: re-order firmware loading in preparation for dpm rework
      drm/radeon/cik: properly set sdma ring status on disable
      drm/radeon/cik: stop the sdma engines in the enable() function
      drm/radeon/cik: properly set compute ring status on disable

Alexandre Bounine (1):
      rapidio/tsi721: fix tasklet termination in dma channel release

Alexei Starovoitov (1):
      x86: bpf_jit: support negative offsets

Amitkumar Karwar (4):
      mwifiex: add NULL check for PCIe Rx skb
      mwifiex: fix cmd and Tx data timeout issue for PCIe cards
      mwifiex: copy AP's HT capability info correctly
      mwifiex: save and copy AP's VHT capability info correctly

Anton Blanchard (3):
      powerpc: Align p_dyn, p_rela and p_st symbols
      net: unix socket code abuses csum_partial
      ibmveth: Fix endian issues with MAC addresses

Arnd Bergmann (1):
      vmxnet3: fix building without CONFIG_PCI_MSI

Artem Fetishev (2):
      fs/proc/base.c: fix GPF in /proc/$PID/map_files
      x86: fix boot on uniprocessor systems

Avinash Patil (1):
      mwifiex: clean pcie ring only when device is present

Ben Hutchings (1):
      deb-pkg: Fix cross-building linux-headers package

Benjamin Tissoires (1):
      Input: synaptics - add manual min/max quirk

Bing Zhao (1):
      mwifiex: do not advertise usb autosuspend support

Bjorn Helgaas (1):
      PCI: Enable INTx in pci_reenable_device() only when MSI/MSI-X not enabled

Charles Keepax (1):
      ALSA: compress: Pass through return value of open ops callback

Chen-Yu Tsai (1):
      pinctrl: sunxi: use chained_irq_{enter, exit} for GIC compatibility

Chris Wilson (1):
      drm/i915: Disable stolen memory when DMAR is active

Christian Riesch (1):
      net: davinci_emac: Replace devm_request_irq with request_irq

Chuansheng Liu (1):
      genirq: Remove racy waitqueue_active check

Clemens Ladisch (1):
      ALSA: oxygen: Xonar DG(X): modify DAC routing

Dan Carpenter (4):
      [media] cxusb: unlock on error in cxusb_i2c_xfer()
      [media] cx18: check for allocation failure in cx18_read_eeprom()
      [media] dw2102: some missing unlocks on error
      p54: clamp properly instead of just truncating

Dan Williams (1):
      [SCSI] isci: fix reset timeout handling

Daniel Borkmann (1):
      net: sctp: fix sctp_sf_do_5_1D_ce to verify if we/peer is AUTH capable

Daniel J Blueman (1):
      x86/amd/numa: Fix northbridge quirk to assign correct NUMA node

Dmitry Torokhov (1):
      Input: mousedev - fix race when creating mixed device

Duan Jiong (1):
      neigh: recompute reachabletime before returning from neigh_periodic_work()

Edward Cree (1):
      sfc: check for NULL efx->ptp_data in efx_ptp_event

Emmanuel Grumbach (4):
      mac80211: fix AP powersave TX vs. wakeup race
      iwlwifi: dvm: clear IWL_STA_UCODE_INPROGRESS when assoc fails
      iwlwifi: mvm: don't WARN when statistics are handled late
      iwlwifi: disable TX AMPDU by default for iwldvm

Eric Dumazet (1):
      net-tcp: fastopen: fix high order allocations

Fabio Estevam (1):
      can: flexcan: Check the return value from clk_prepare_enable()

Felix Fietkau (1):
      mac80211: send control port protocol frames to the VO queue

Filipe Brandenburger (1):
      memcg: reparent charges of children before processing parent

Filipe David Borba Manana (1):
      Btrfs: fix data corruption when reading/updating compressed extents

Gabor Juhos (1):
      spi: spi-ath79: fix initial GPIO CS line setup

George McCollister (1):
      sched: Fix double normalization of vruntime

Giridhar Malavali (1):
      [SCSI] qla2xxx: Poll during initialization for ISP25xx and ISP83xx

H. Peter Anvin (1):
      x86: Ignore NMIs that come in during early boot

Hannes Frederic Sowa (1):
      ipv6: reuse ip6_frag_id from ip6_ufo_append_data

Hans Schillstrom (1):
      ipv6: ipv6_find_hdr restore prev functionality

Hans de Goede (1):
      Input: synaptics - add manual min/max quirk for ThinkPad X240

Heiko Carstens (1):
      s390/dasd: hold request queue sysfs lock when calling elevator_init()

Heinz Mauelshagen (2):
      dm cache: fix truncation bug when copying a block to/from >2TB fast device
      dm cache: fix access beyond end of origin device

Ilya Dryomov (3):
      libceph: rename ceph_msg::front_max to front_alloc_len
      libceph: rename front to front_len in get_reply()
      libceph: fix preallocation check in get_reply()

Imre Deak (2):
      drm/i915: fix pch pci device enumeration
      drm/i915: vlv: reserve GT power context early

Jan Kara (1):
      ocfs2: fix quota file corruption

Jason Wang (1):
      virtio-net: alloc big buffers also when guest can receive UFO

Johannes Berg (4):
      mac80211: don't validate unchanged AP bandwidth while tracking
      iwlwifi: fix TX status for aggregated packets
      mac80211: fix association to 20/40 MHz VHT networks
      mac80211: clear sequence/fragment number in QoS-null frames

Josh Durgin (2):
      libceph: block I/O when PAUSE or FULL osd map flags are set
      libceph: resend all writes after the osdmap loses the full flag

Julius Werner (2):
      usb: Add device quirk for Logitech HD Pro Webcams C920 and C930e
      usb: Make DELAY_INIT quirk wait 100ms between Get Configuration requests

Laura Abbott (1):
      mm/compaction: break out of loop on !PageBuddy in isolate_freepages_block

Lauri Kasanen (1):
      drm/radeon: TTM must be init with cpu-visible VRAM, v2

Li Zefan (2):
      cpuset: fix a locking issue in cpuset_migrate_mm()
      cpuset: fix a race condition in __cpuset_node_allowed_softwall()

Linus Torvalds (2):
      x86: fix compile error due to X86_TRAP_NMI use in asm files
      printk: fix syslog() overflowing user buffer

Linus Walleij (1):
      ARM: 7991/1: sa1100: fix compile problem on Collie

Lukasz Dorau (1):
      [SCSI] isci: correct erroneous for_each_isci_host macro

Magnus Damm (1):
      ARM: 7864/1: Handle 64-bit memory in case of 32-bit phys_addr_t

Marc Kleine-Budde (6):
      can: flexcan: fix shutdown: first disable chip, then all interrupts
      can: flexcan: flexcan_open(): fix error path if flexcan_chip_start() fails
      can: flexcan: fix transition from and to low power mode in chip_{en,dis}able
      can: flexcan: factor out transceiver {en,dis}able into seperate functions
      can: flexcan: fix transition from and to freeze mode in chip_{,un}freeze
      can: flexcan: flexcan_remove(): add missing netif_napi_del()

Marcelo Tosatti (1):
      KVM: x86: handle invalid root_hpa everywhere

Marius Knaust (1):
      ALSA: hda - Added inverted digital-mic handling for Acer TravelMate 8371

Markus Pargmann (2):
      regulator: core: Replace direct ops->enable usage
      regulator: core: Replace direct ops->disable usage

Max Stepanov (1):
      iwlwifi: mvm: change of listen interval from 70 to 10

Michael Chan (1):
      tg3: Don't check undefined error bits in RXBD

Michael Kerrisk (1):
      ipc: Fix 2 bugs in msgrcv() MSG_COPY implementation

Michael Neuling (1):
      powerpc/tm: Fix crash when forking inside a transaction

Michele Baldessari (1):
      libata: add ATA_HORKAGE_BROKEN_FPDMA_AA quirk for Seagate Momentus SpinPoint M8 (2BA30001)

Minchan Kim (1):
      zram: avoid null access when fail to alloc meta

Neil Horman (1):
      vmxnet3: fix netpoll race condition

Nicholas Bellinger (5):
      iscsi-target: Fix iscsit_get_tpg_from_np tpg_state bug
      iscsi-target: Perform release of acknowledged tags from RX context
      iscsi/iser-target: Use list_del_init for ->i_conn_node
      iscsi/iser-target: Fix isert_conn->state hung shutdown issues
      iser-target: Fix post_send_buf_count for RDMA READ/WRITE

Oleg Drokin (1):
      Fix mountpoint reference leakage in linkat

Paul E. McKenney (1):
      jiffies: Avoid undefined behavior from signed overflow

Qais Yousef (1):
      MIPS: include linux/types.h

Radim Krčmář (1):
      KVM: SVM: fix cr8 intercept window

Rafael J. Wysocki (1):
      ACPI / sleep: Add extra checks for HW Reduced ACPI mode sleep states

Richard Weinberger (1):
      i2c: Remove usage of orphaned symbol OF_I2C

Rob Clark (1):
      drm/ttm: don't oops if no invalidate_caches()

Rob Herring (2):
      ARM: highbank: avoid L2 cache smc calls when PL310 is not present
      ARM: move outer_cache declaration out of ifdef

Roman Volkov (1):
      ALSA: oxygen: Xonar DG(X): capture from I2S channel 1, not 2

Russell King (2):
      ARM: fix noMMU kallsyms symbol filtering
      ARM: ignore memory below PHYS_OFFSET

Sachin Kamat (1):
      ACPI / EC: Fix incorrect placement of __initdata

Scott Wood (1):
      i2c: cpm: Fix build by adding of_address.h and of_irq.h

Simon Wood (1):
      HID:hid-lg4ff: Initialize device properties before we touch autocentering.

Stanislaw Gruszka (1):
      ath9k: protect tid->sched check

Stefan Agner (1):
      clocksource: vf_pit_timer: use complement for sched_clock reading

Stefan Richter (3):
      firewire: net: fix use after free
      firewire: ohci: beautify some macro definitions
      firewire: ohci: fix probe failure with Agere/LSI controllers

Stephen Warren (1):
      ASoC: max98090: make REVISION_ID readable

Steven Rostedt (Red Hat) (1):
      tracing: Do not add event files for modules that fail tracepoints

Sujith Manoharan (1):
      ath9k: Fix ETSI compliance for AR9462 2.0

Suresh Siddha (1):
      x86, fpu: Check tsk_used_math() in kernel_fpu_end() for eager FPU

Takashi Iwai (2):
      ALSA: hda - Add missing loopback merge path for AD1884/1984 codecs
      ALSA: usb-audio: Add quirk for Logitech Webcam C500

Tejun Heo (1):
      firewire: don't use PREPARE_DELAYED_WORK

Theodore Ts'o (1):
      ext4: atomically set inode->i_flags in ext4_set_inode_flags()

Thomas Petazzoni (2):
      net: mvneta: rename MVNETA_GMAC2_PSC_ENABLE to MVNETA_GMAC2_PCS_ENABLE
      net: mvneta: fix usage as a module on RGMII configurations

Trond Myklebust (2):
      NFS: Fix a delegation callback race
      NFSv4: nfs4_stateid_is_current should return 'true' for an invalid stateid

Vaibhav Nagarnaik (1):
      tracing: Fix array size mismatch in format string

Ville Syrjälä (1):
      drm/i915: Reject >165MHz modes w/ DVI monitors

Vlastimil Babka (1):
      mm: include VM_MIXEDMAP flag in the VM_SPECIAL list to avoid m(un)locking

Zhang Rui (2):
      ACPI / resources: ignore invalid ACPI device resources
      PNP / ACPI: proper handling of ACPI IO/Memory resource parsing failures
