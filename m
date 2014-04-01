Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751753AbaDAQIv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 12:08:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44275 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbaDAQIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 12:08:46 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kamal Mostafa <kamal@canonical.com>
Subject: [3.8.y.z extended stable] Linux 3.8.13.21 stable review
Date: Tue,  1 Apr 2014 09:07:13 -0700
Message-Id: <1396368519-12728-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
X-Extended-Stable: 3.8
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the review cycle for the Linux 3.8.13.21 stable kernel.

This version contains 86 new patches, summarized below.  The new patches are
posted as replies to this message and also available in this git branch:

http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=linux-3.8.y-review;a=shortlog

git://kernel.ubuntu.com/ubuntu/linux.git  linux-3.8.y-review

The review period for version 3.8.13.21 will be open for the next three days.
To report a problem, please reply to the relevant follow-up patch message.

For more information about the Linux 3.8.y.z extended stable kernel version,
see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable .

 -Kamal

--
 arch/arm/Kconfig                                   |   2 +
 arch/arm/include/asm/memory.h                      |   9 +-
 arch/arm/mach-sa1100/include/mach/collie.h         |   2 +
 arch/powerpc/kernel/reloc_64.S                     |   1 +
 arch/x86/include/asm/topology.h                    |   3 +-
 arch/x86/kernel/head_32.S                          |   7 +-
 arch/x86/kernel/head_64.S                          |   6 +-
 arch/x86/kernel/quirks.c                           |   2 +-
 arch/x86/kvm/svm.c                                 |   6 +-
 drivers/acpi/resource.c                            |  10 +
 drivers/ata/libata-core.c                          |   1 +
 drivers/dma/ioat/dma.c                             |  46 ++-
 drivers/dma/ioat/dma.h                             |   1 +
 drivers/dma/ioat/dma_v2.c                          |  11 +-
 drivers/dma/ioat/dma_v3.c                          |   3 +
 drivers/firewire/net.c                             |   6 +-
 drivers/gpu/drm/i915/i915_gem_stolen.c             |   7 +
 drivers/gpu/drm/radeon/atombios_encoders.c         |   2 +-
 drivers/gpu/drm/radeon/radeon_ttm.c                |   3 +
 drivers/gpu/drm/ttm/ttm_bo.c                       |   8 +-
 drivers/i2c/busses/Kconfig                         |   2 +-
 drivers/i2c/busses/i2c-cpm.c                       |   2 +
 drivers/input/mouse/synaptics.c                    |  55 ++++
 drivers/input/mousedev.c                           |  73 ++--
 drivers/net/bonding/bond_3ad.c                     |   6 +-
 drivers/net/bonding/bond_3ad.h                     |   1 +
 drivers/net/can/flexcan.c                          |  63 +++-
 drivers/net/ethernet/broadcom/tg3.c                |   7 +-
 drivers/net/ethernet/broadcom/tg3.h                |   6 +-
 drivers/net/ethernet/ibm/ibmveth.c                 |  25 +-
 drivers/net/ethernet/ibm/ibmveth.h                 |   1 -
 drivers/net/ethernet/marvell/mvneta.c              |   4 +-
 drivers/net/ethernet/sfc/ptp.c                     |   7 +
 drivers/net/usb/asix_devices.c                     |   3 +-
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/net/virtio_net.c                           |   3 +-
 drivers/net/vmxnet3/vmxnet3_drv.c                  |  19 +-
 .../net/wireless/ath/ath9k/ar9462_2p0_initvals.h   |   4 +-
 drivers/net/wireless/ath/ath9k/xmit.c              |   8 +-
 drivers/net/wireless/iwlwifi/dvm/sta.c             |   1 +
 drivers/net/wireless/iwlwifi/dvm/tx.c              |  14 +-
 drivers/net/wireless/mwifiex/11n.c                 |   3 +-
 drivers/net/wireless/mwifiex/usb.c                 |   8 -
 drivers/rapidio/devices/tsi721.h                   |   1 +
 drivers/rapidio/devices/tsi721_dma.c               |  27 +-
 drivers/scsi/isci/host.h                           |   5 +-
 drivers/scsi/isci/port_config.c                    |   7 -
 drivers/scsi/isci/task.c                           |   2 +-
 drivers/scsi/qla2xxx/qla_def.h                     |   3 +-
 drivers/scsi/storvsc_drv.c                         |   3 +
 drivers/spi/spi-coldfire-qspi.c                    |   6 +-
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
 fs/ext4/inode.c                                    |  15 +-
 fs/nfs/delegation.c                                |  11 +-
 fs/ocfs2/file.c                                    |   8 +-
 fs/ocfs2/quota_global.c                            |  27 +-
 fs/ocfs2/quota_local.c                             |   4 -
 fs/proc/base.c                                     |   1 +
 include/linux/bitops.h                             |  15 +
 include/linux/netdevice.h                          |   7 +-
 include/linux/skbuff.h                             |  19 ++
 include/linux/tracepoint.h                         |   6 +
 include/net/tcp.h                                  |   3 +-
 ipc/msg.c                                          |   2 +
 kernel/cpuset.c                                    |   2 +-
 kernel/irq/manage.c                                |   3 +-
 kernel/sched/fair.c                                |   8 +-
 kernel/trace/trace_events.c                        |  10 +
 kernel/tracepoint.c                                |   7 +-
 mm/compaction.c                                    |  20 +-
 net/9p/trans_virtio.c                              |   5 +-
 net/core/dev.c                                     |  27 +-
 net/core/fib_rules.c                               |   7 +
 net/core/skbuff.c                                  |  25 ++
 net/core/sock.c                                    |   2 +-
 net/ieee802154/6lowpan.c                           |  20 ++
 net/ipv4/devinet.c                                 |   3 +-
 net/ipv4/ip_forward.c                              |  71 +++-
 net/ipv4/route.c                                   |   4 +-
 net/ipv4/tcp.c                                     |   8 +-
 net/ipv4/tcp_output.c                              |  20 +-
 net/ipv6/exthdrs_core.c                            |   2 +-
 net/ipv6/ip6_output.c                              |  17 +-
 net/ipv6/udp_offload.c                             |   2 +-
 net/mac80211/mlme.c                                |   1 +
 net/mac80211/sta_info.c                            |   5 +
 net/mac80211/sta_info.h                            |   7 +-
 net/mac80211/tx.c                                  |  15 +
 net/mac80211/wme.c                                 |   5 +
 net/sctp/sm_statefuns.c                            |   7 +
 net/sctp/socket.c                                  |  41 ++-
 net/unix/af_unix.c                                 |   3 +-
 sound/core/compress_offload.c                      |   2 +-
 sound/pci/hda/patch_realtek.c                      |   1 +
 sound/soc/soc-pcm.c                                |   3 +
 sound/usb/mixer.c                                  |   1 +
 123 files changed, 1128 insertions(+), 626 deletions(-)

Al Viro (1):
      ocfs2 syncs the wrong range...

Ales Novak (1):
      [SCSI] storvsc: NULL pointer dereference fix

Alex Deucher (1):
      drm/radeon/atom: select the proper number of lanes in transmitter setup

Alexandre Bounine (1):
      rapidio/tsi721: fix tasklet termination in dma channel release

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

Axel Lin (1):
      spi: coldfire-qspi: Fix getting correct address for *mcfqspi

Benjamin Tissoires (1):
      Input: synaptics - add manual min/max quirk

Bing Zhao (1):
      mwifiex: do not advertise usb autosuspend support

Bjørn Mork (1):
      net: qmi_wwan: add Netgear Aircard 340U

Charles Keepax (1):
      ALSA: compress: Pass through return value of open ops callback

Chris Wilson (1):
      drm/i915: Disable stolen memory when DMAR is active

Chuansheng Liu (1):
      genirq: Remove racy waitqueue_active check

Dan Williams (2):
      [SCSI] isci: fix reset timeout handling
      ioat: fix tasklet tear down

Daniel Borkmann (2):
      net: sctp: fix sctp_connectx abi for ia32 emulation/compat mode
      net: sctp: fix sctp_sf_do_5_1D_ce to verify if we/peer is AUTH capable

Daniel J Blueman (1):
      x86/amd/numa: Fix northbridge quirk to assign correct NUMA node

Dmitry Torokhov (1):
      Input: mousedev - fix race when creating mixed device

Duan Jiong (1):
      ipv4: fix counter in_slow_tot

Edward Cree (1):
      sfc: check for NULL efx->ptp_data in efx_ptp_event

Emil Goode (1):
      net: asix: add missing flag to struct driver_info

Emmanuel Grumbach (2):
      mac80211: fix AP powersave TX vs. wakeup race
      iwlwifi: dvm: clear IWL_STA_UCODE_INPROGRESS when assoc fails

Eric Dumazet (3):
      6lowpan: fix lockdep splats
      net: use __GFP_NORETRY for high order allocations
      net-tcp: fastopen: fix high order allocations

Felix Fietkau (1):
      mac80211: send control port protocol frames to the VO queue

Florian Westphal (3):
      net: add and use skb_gso_transport_seglen()
      net: core: introduce netif_skb_dev_features
      net: ip, ipv6: handle gso skbs in forwarding path

Geert Uytterhoeven (1):
      ipv4: Fix runtime WARNING in rtmsg_ifa()

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

Jan Kara (1):
      ocfs2: fix quota file corruption

Jason Wang (1):
      virtio-net: alloc big buffers also when guest can receive UFO

Jiri Bohac (1):
      bonding: 802.3ad: make aggregator_identifier bond-private

Johannes Berg (3):
      iwlwifi: fix TX status for aggregated packets
      mac80211: fix association to 20/40 MHz VHT networks
      mac80211: clear sequence/fragment number in QoS-null frames

John Ogness (1):
      tcp: tsq: fix nonagle handling

Julius Werner (2):
      usb: Add device quirk for Logitech HD Pro Webcams C920 and C930e
      usb: Make DELAY_INIT quirk wait 100ms between Get Configuration requests

Laura Abbott (1):
      mm/compaction: break out of loop on !PageBuddy in isolate_freepages_block

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

Maciej Żenczykowski (1):
      net: fix 'ip rule' iif/oif device rename

Marc Kleine-Budde (4):
      can: flexcan: fix shutdown: first disable chip, then all interrupts
      can: flexcan: flexcan_open(): fix error path if flexcan_chip_start() fails
      can: flexcan: fix transition from and to low power mode in chip_{en,dis}able
      can: flexcan: flexcan_remove(): add missing netif_napi_del()

Marius Knaust (1):
      ALSA: hda - Added inverted digital-mic handling for Acer TravelMate 8371

Michael Chan (1):
      tg3: Don't check undefined error bits in RXBD

Michael Kerrisk (1):
      ipc: Fix 2 bugs in msgrcv() MSG_COPY implementation

Michele Baldessari (1):
      libata: add ATA_HORKAGE_BROKEN_FPDMA_AA quirk for Seagate Momentus SpinPoint M8 (2BA30001)

Neil Horman (1):
      vmxnet3: fix netpoll race condition

Nithin Sujir (1):
      tg3: Fix deadlock in tg3_change_mtu()

Patrick Lai (1):
      ASoC: pcm: free path list before exiting from error conditions

Radim Krčmář (1):
      KVM: SVM: fix cr8 intercept window

Richard Weinberger (1):
      i2c: Remove usage of orphaned symbol OF_I2C

Richard Yao (1):
      9p/trans_virtio.c: Fix broken zero-copy on vmalloc() buffers

Rob Clark (1):
      drm/ttm: don't oops if no invalidate_caches()

Russell King (1):
      ARM: fix noMMU kallsyms symbol filtering

Samuel Thibault (1):
      staging: speakup: Prefix externally-visible symbols

Scott Wood (1):
      i2c: cpm: Fix build by adding of_address.h and of_irq.h

Stanislaw Gruszka (1):
      ath9k: protect tid->sched check

Stefan Richter (1):
      firewire: net: fix use after free

Steven Rostedt (Red Hat) (1):
      tracing: Do not add event files for modules that fail tracepoints

Sujith Manoharan (1):
      ath9k: Fix ETSI compliance for AR9462 2.0

Takashi Iwai (1):
      ALSA: usb-audio: Add quirk for Logitech Webcam C500

Theodore Ts'o (1):
      ext4: atomically set inode->i_flags in ext4_set_inode_flags()

Thomas Petazzoni (1):
      net: mvneta: rename MVNETA_GMAC2_PSC_ENABLE to MVNETA_GMAC2_PCS_ENABLE

Trond Myklebust (1):
      NFS: Fix a delegation callback race

Zhang Rui (1):
      ACPI / resources: ignore invalid ACPI device resources
