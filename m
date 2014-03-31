Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176AbaCaNX3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 09:23:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35502 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994AbaCaNXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 09:23:23 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Luis Henriques <luis.henriques@canonical.com>
Subject: [3.5.y.z extended stable] Linux 3.5.7.33 stable review
Date: Mon, 31 Mar 2014 14:22:06 +0100
Message-Id: <1396272197-13394-1-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
X-Extended-Stable: 3.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the review cycle for the Linux 3.5.7.33 stable kernel.

PLEASE NOTE: this will be the LAST 3.5.y.z extended stable kernel release.

This version contains 71 new patches, summarized below.  The new patches are
posted as replies to this message and also available in this git branch:

http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=linux-3.5.y-review;a=shortlog

git://kernel.ubuntu.com/ubuntu/linux.git  linux-3.5.y-review

The review period for version 3.5.7.33 will be open for the next three days.
To report a problem, please reply to the relevant follow-up patch message.

For more information about the Linux 3.5.y.z extended stable kernel version,
see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable .

 -Luis

--
 arch/arm/mach-sa1100/include/mach/collie.h         |   2 +
 arch/powerpc/kernel/reloc_64.S                     |   1 +
 arch/x86/include/asm/topology.h                    |   3 +-
 arch/x86/kernel/head_32.S                          |   7 +-
 arch/x86/kernel/head_64.S                          |   6 +-
 arch/x86/kernel/quirks.c                           |   2 +-
 arch/x86/kvm/svm.c                                 |   6 +-
 arch/x86/net/bpf_jit.S                             |   2 +-
 drivers/ata/libata-core.c                          |  28 ++
 drivers/ata/libata-scsi.c                          |  18 +-
 drivers/cpufreq/acpi-cpufreq.c                     |   2 +-
 drivers/dma/ioat/dma.c                             |  46 ++-
 drivers/dma/ioat/dma.h                             |   1 +
 drivers/dma/ioat/dma_v2.c                          |  11 +-
 drivers/dma/ioat/dma_v3.c                          |   3 +
 drivers/firewire/core-device.c                     |  22 +-
 drivers/firewire/net.c                             |   6 +-
 drivers/firewire/sbp2.c                            |  17 +-
 drivers/gpu/drm/radeon/atombios_encoders.c         |   2 +-
 drivers/gpu/drm/radeon/radeon_ttm.c                |   3 +
 drivers/gpu/drm/ttm/ttm_bo.c                       |   8 +-
 drivers/idle/intel_idle.c                          |   3 +-
 drivers/input/mouse/synaptics.c                    |  55 ++++
 drivers/mmc/host/sdhci.c                           |  17 +-
 drivers/net/can/flexcan.c                          |  13 +-
 drivers/net/ethernet/broadcom/tg3.c                |   3 +-
 drivers/net/ethernet/broadcom/tg3.h                |   6 +-
 drivers/net/ethernet/ibm/ibmveth.c                 |  25 +-
 drivers/net/ethernet/ibm/ibmveth.h                 |   1 -
 drivers/net/virtio_net.c                           |   3 +-
 drivers/net/vmxnet3/vmxnet3_drv.c                  |  19 +-
 .../net/wireless/ath/ath9k/ar9462_2p0_initvals.h   |   4 +-
 drivers/net/wireless/ath/ath9k/xmit.c              |   8 +-
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c         |   1 +
 drivers/net/wireless/mwifiex/11n.c                 |   3 +-
 drivers/net/wireless/mwifiex/usb.c                 |   8 -
 drivers/net/wireless/p54/txrx.c                    |   2 +-
 drivers/of/address.c                               |   9 +-
 drivers/pci/pci.c                                  |   3 +
 drivers/rapidio/devices/tsi721.h                   |   1 +
 drivers/rapidio/devices/tsi721_dma.c               |  27 +-
 drivers/scsi/isci/host.h                           |   5 +-
 drivers/scsi/isci/port_config.c                    |   7 -
 drivers/scsi/isci/task.c                           |   2 +-
 drivers/scsi/qla2xxx/qla_def.h                     |   3 +-
 drivers/scsi/storvsc_drv.c                         |   3 +
 drivers/staging/speakup/i18n.c                     |  12 +-
 drivers/staging/speakup/i18n.h                     |  12 +-
 drivers/staging/speakup/keyhelp.c                  |  36 +-
 drivers/staging/speakup/kobjects.c                 |  80 ++---
 drivers/staging/speakup/main.c                     | 366 ++++++++++-----------
 drivers/staging/speakup/selection.c                |  14 +-
 drivers/staging/speakup/serialio.c                 |   6 +-
 drivers/staging/speakup/speakup.h                  |  72 ++--
 drivers/staging/speakup/speakup_acntpc.c           |   6 +-
 drivers/staging/speakup/speakup_acntsa.c           |   2 +-
 drivers/staging/speakup/speakup_apollo.c           |   8 +-
 drivers/staging/speakup/speakup_audptr.c           |   2 +-
 drivers/staging/speakup/speakup_bns.c              |   2 +-
 drivers/staging/speakup/speakup_decext.c           |   6 +-
 drivers/staging/speakup/speakup_decpc.c            |   4 +-
 drivers/staging/speakup/speakup_dectlk.c           |   6 +-
 drivers/staging/speakup/speakup_dtlk.c             |   4 +-
 drivers/staging/speakup/speakup_dummy.c            |   2 +-
 drivers/staging/speakup/speakup_keypc.c            |   6 +-
 drivers/staging/speakup/speakup_ltlk.c             |   2 +-
 drivers/staging/speakup/speakup_spkout.c           |   2 +-
 drivers/staging/speakup/speakup_txprt.c            |   2 +-
 drivers/staging/speakup/spk_priv.h                 |   8 +-
 drivers/staging/speakup/synth.c                    |  38 +--
 drivers/staging/speakup/thread.c                   |   4 +-
 drivers/staging/speakup/varhandlers.c              |  66 ++--
 drivers/usb/core/config.c                          |   4 +
 drivers/usb/core/quirks.c                          |   4 +
 drivers/usb/dwc3/dwc3-pci.c                        |   2 +
 drivers/usb/host/ehci.h                            |  18 +-
 drivers/usb/serial/pl2303.c                        |  33 +-
 fs/btrfs/compression.c                             |   2 +
 fs/ext4/inode.c                                    |  15 +-
 fs/hpfs/dir.c                                      |  10 +-
 fs/nfs/delegation.c                                |  11 +-
 fs/ocfs2/file.c                                    |   8 +-
 fs/ocfs2/quota_global.c                            |  27 +-
 fs/ocfs2/quota_local.c                             |   4 -
 fs/proc/base.c                                     |   1 +
 include/linux/bitops.h                             |  15 +
 include/linux/firewire.h                           |   1 +
 include/linux/jiffies.h                            |   8 +-
 include/linux/libata.h                             |   2 +
 include/linux/tracepoint.h                         |   6 +
 ipc/msg.c                                          |   2 +
 kernel/cpuset.c                                    |   2 +-
 kernel/irq/manage.c                                |   3 +-
 kernel/sched/fair.c                                |   8 +-
 kernel/trace/trace_events.c                        |  10 +
 kernel/tracepoint.c                                |   7 +-
 net/mac80211/sta_info.c                            |   5 +
 net/mac80211/sta_info.h                            |   7 +-
 net/mac80211/tx.c                                  |  15 +
 net/sctp/sm_statefuns.c                            |   7 +
 net/unix/af_unix.c                                 |   3 +-
 scripts/package/builddeb                           |   9 +-
 sound/core/compress_offload.c                      |   2 +-
 sound/pci/hda/patch_realtek.c                      |   3 +
 sound/pci/oxygen/xonar_dg.c                        |  12 +-
 sound/usb/mixer.c                                  |   1 +
 106 files changed, 894 insertions(+), 568 deletions(-)

Aisheng Dong (1):
      mmc: sdhci: fix lockdep error in tuning routine

Al Viro (2):
      ocfs2 syncs the wrong range...
      hpfs: deadlock and race in directory lseek()

Ales Novak (1):
      [SCSI] storvsc: NULL pointer dereference fix

Alex Deucher (1):
      drm/radeon/atom: select the proper number of lanes in transmitter setup

Alexandre Bounine (1):
      rapidio/tsi721: fix tasklet termination in dma channel release

Alexei Starovoitov (1):
      x86: bpf_jit: support negative offsets

Amitkumar Karwar (1):
      mwifiex: copy AP's HT capability info correctly

Anton Blanchard (3):
      powerpc: Align p_dyn, p_rela and p_st symbols
      net: unix socket code abuses csum_partial
      ibmveth: Fix endian issues with MAC addresses

Arnd Bergmann (1):
      vmxnet3: fix building without CONFIG_PCI_MSI

Artem Fetishev (2):
      fs/proc/base.c: fix GPF in /proc/$PID/map_files
      x86: fix boot on uniprocessor systems

Ben Hutchings (2):
      deb-pkg: Fix cross-building linux-headers package
      ioat: fix tasklet tear down

Benjamin Herrenschmidt (1):
      of: Fix address decoding on Bimini and js2x machines

Benjamin Tissoires (1):
      Input: synaptics - add manual min/max quirk

Bing Zhao (1):
      mwifiex: do not advertise usb autosuspend support

Bjorn Helgaas (1):
      PCI: Enable INTx in pci_reenable_device() only when MSI/MSI-X not enabled

Charles Keepax (1):
      ALSA: compress: Pass through return value of open ops callback

Chuansheng Liu (1):
      genirq: Remove racy waitqueue_active check

Clemens Ladisch (1):
      ALSA: oxygen: Xonar DG(X): modify DAC routing

Dan Carpenter (1):
      p54: clamp properly instead of just truncating

Dan Williams (1):
      [SCSI] isci: fix reset timeout handling

Daniel Borkmann (1):
      net: sctp: fix sctp_sf_do_5_1D_ce to verify if we/peer is AUTH capable

Daniel J Blueman (1):
      x86/amd/numa: Fix northbridge quirk to assign correct NUMA node

David Cohen (1):
      usb: dwc3: add support for Merrifield

Emmanuel Grumbach (2):
      mac80211: fix AP powersave TX vs. wakeup race
      iwlwifi: dvm: clear IWL_STA_UCODE_INPROGRESS when assoc fails

Filipe David Borba Manana (1):
      Btrfs: fix data corruption when reading/updating compressed extents

George McCollister (1):
      sched: Fix double normalization of vruntime

Giridhar Malavali (1):
      [SCSI] qla2xxx: Poll during initialization for ISP25xx and ISP83xx

H. Peter Anvin (1):
      x86: Ignore NMIs that come in during early boot

Hans de Goede (1):
      Input: synaptics - add manual min/max quirk for ThinkPad X240

Jan Kara (1):
      ocfs2: fix quota file corruption

Jason Wang (1):
      virtio-net: alloc big buffers also when guest can receive UFO

Johan Hovold (1):
      USB: pl2303: fix data corruption on termios updates

Johannes Berg (1):
      mac80211: clear sequence/fragment number in QoS-null frames

Julius Werner (2):
      usb: Add device quirk for Logitech HD Pro Webcams C920 and C930e
      usb: Make DELAY_INIT quirk wait 100ms between Get Configuration requests

Kleber Sacilotto de Souza (1):
      of: fix PCI bus match for PCIe slots

Konrad Rzeszutek Wilk (1):
      intel_idle: Check cpu_idle_get_driver() for NULL before dereferencing it.

Konstantin Khlebnikov (1):
      ipc/msg: fix race around refcount

Lauri Kasanen (1):
      drm/radeon: TTM must be init with cpu-visible VRAM, v2

Li Zefan (1):
      cpuset: fix a race condition in __cpuset_node_allowed_softwall()

Linus Torvalds (1):
      x86: fix compile error due to X86_TRAP_NMI use in asm files

Linus Walleij (1):
      ARM: 7991/1: sa1100: fix compile problem on Collie

Lukasz Dorau (1):
      [SCSI] isci: correct erroneous for_each_isci_host macro

Marc Kleine-Budde (2):
      can: flexcan: fix shutdown: first disable chip, then all interrupts
      can: flexcan: flexcan_open(): fix error path if flexcan_chip_start() fails

Michael Chan (1):
      tg3: Don't check undefined error bits in RXBD

Michele Baldessari (1):
      libata: add ATA_HORKAGE_BROKEN_FPDMA_AA quirk for Seagate Momentus SpinPoint M8 (2BA30001)

Neil Horman (1):
      vmxnet3: fix netpoll race condition

Paul E. McKenney (1):
      jiffies: Avoid undefined behavior from signed overflow

Peter Chen (1):
      usb: ehci: add freescale imx28 special write register method

Radim Krčmář (1):
      KVM: SVM: fix cr8 intercept window

Rob Clark (1):
      drm/ttm: don't oops if no invalidate_caches()

Roman Volkov (1):
      ALSA: oxygen: Xonar DG(X): capture from I2S channel 1, not 2

Ross Lagerwall (1):
      acpi-cpufreq: set current frequency based on target P-State

Samuel Thibault (1):
      staging: speakup: Prefix externally-visible symbols

Stanislaw Gruszka (1):
      ath9k: protect tid->sched check

Stefan Richter (1):
      firewire: net: fix use after free

Steven Rostedt (Red Hat) (1):
      tracing: Do not add event files for modules that fail tracepoints

Sujith Manoharan (1):
      ath9k: Fix ETSI compliance for AR9462 2.0

Takashi Iwai (2):
      ALSA: usb-audio: Add quirk for Logitech Webcam C500
      ALSA: hda/realtek - Avoid invalid COEFs for ALC271X

Tejun Heo (2):
      firewire: don't use PREPARE_DELAYED_WORK
      libata: disable LPM for some WD SATA-I devices

Theodore Ts'o (1):
      ext4: atomically set inode->i_flags in ext4_set_inode_flags()

Trond Myklebust (1):
      NFS: Fix a delegation callback race
