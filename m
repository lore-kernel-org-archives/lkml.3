Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965776AbaCUAI3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:08:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36955 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965737AbaCUAIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:08:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.10 00/85] 3.10.34-stable review
Date: Thu, 20 Mar 2014 17:09:03 -0700
Message-Id: <20140321000558.606667505@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.10.34 release.
There are 85 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Mar 23 00:05:33 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.34-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.10.34-rc1

Nicholas Bellinger <nab@linux-iscsi.org>
    iser-target: Fix post_send_buf_count for RDMA READ/WRITE

Nicholas Bellinger <nab@linux-iscsi.org>
    iscsi/iser-target: Fix isert_conn->state hung shutdown issues

Nicholas Bellinger <nab@linux-iscsi.org>
    iscsi/iser-target: Use list_del_init for ->i_conn_node

Russell King <rmk+kernel@arm.linux.org.uk>
    ARM: ignore memory below PHYS_OFFSET

Magnus Damm <damm@opensource.se>
    ARM: 7864/1: Handle 64-bit memory in case of 32-bit phys_addr_t

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: mvm: don't WARN when statistics are handled late

Thomas Gleixner <tglx@linutronix.de>
    tick: Make oneshot broadcast robust vs. CPU offlining

Nicholas Bellinger <nab@linux-iscsi.org>
    bio-integrity: Fix bio_integrity_verify segment start bug

Qais Yousef <qais.yousef@imgtec.com>
    MIPS: include linux/types.h

Oleg Drokin <green@linuxhacker.ru>
    Fix mountpoint reference leakage in linkat

Heiko Carstens <heiko.carstens@de.ibm.com>
    s390/dasd: hold request queue sysfs lock when calling elevator_init()

Paul E. McKenney <paulmck@linux.vnet.ibm.com>
    jiffies: Avoid undefined behavior from signed overflow

Roman Volkov <v1ron@mail.ru>
    ALSA: oxygen: modify adjust_dg_dac_routing function

Filipe David Borba Manana <fdmanana@gmail.com>
    Btrfs: fix data corruption when reading/updating compressed extents

Suresh Siddha <sbsiddha@gmail.com>
    x86, fpu: Check tsk_used_math() in kernel_fpu_end() for eager FPU

Ales Novak <alnovak@suse.cz>
    SCSI: storvsc: NULL pointer dereference fix

Giridhar Malavali <giridhar.malavali@qlogic.com>
    SCSI: qla2xxx: Poll during initialization for ISP25xx and ISP83xx

Lukasz Dorau <lukasz.dorau@intel.com>
    SCSI: isci: correct erroneous for_each_isci_host macro

Dan Williams <dan.j.williams@intel.com>
    SCSI: isci: fix reset timeout handling

Marc Kleine-Budde <mkl@pengutronix.de>
    can: flexcan: flexcan_open(): fix error path if flexcan_chip_start() fails

Anton Blanchard <anton@samba.org>
    net: unix socket code abuses csum_partial

Heinz Mauelshagen <heinzm@redhat.com>
    dm cache: fix access beyond end of origin device

Heinz Mauelshagen <heinzm@redhat.com>
    dm cache: fix truncation bug when copying a block to/from >2TB fast device

Laura Abbott <lauraa@codeaurora.org>
    mm/compaction: break out of loop on !PageBuddy in isolate_freepages_block

Arnd Bergmann <arnd@arndb.de>
    vmxnet3: fix building without CONFIG_PCI_MSI

Neil Horman <nhorman@tuxdriver.com>
    vmxnet3: fix netpoll race condition

Bjorn Helgaas <bhelgaas@google.com>
    PCI: Enable INTx in pci_reenable_device() only when MSI/MSI-X not enabled

Radim Krčmář <rkrcmar@redhat.com>
    KVM: SVM: fix cr8 intercept window

Michael Kerrisk <mtk.manpages@gmail.com>
    ipc: Fix 2 bugs in msgrcv() MSG_COPY implementation

Patrick Lai <plai@codeaurora.org>
    ASoC: pcm: free path list before exiting from error conditions

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon/atom: select the proper number of lanes in transmitter setup

Artem Fetishev <artem_fetishev@epam.com>
    fs/proc/base.c: fix GPF in /proc/$PID/map_files

Nicholas Bellinger <nab@linux-iscsi.org>
    iscsi-target: Fix iscsit_get_tpg_from_np tpg_state bug

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI / sleep: Add extra checks for HW Reduced ACPI mode sleep states

Trond Myklebust <trond.myklebust@primarydata.com>
    NFSv4: nfs4_stateid_is_current should return 'true' for an invalid stateid

Trond Myklebust <trond.myklebust@primarydata.com>
    NFS: Fix a delegation callback race

Gabor Juhos <juhosg@openwrt.org>
    spi: spi-ath79: fix initial GPIO CS line setup

Michele Baldessari <michele@acksyn.org>
    libata: add ATA_HORKAGE_BROKEN_FPDMA_AA quirk for Seagate Momentus SpinPoint M8 (2BA30001)

Tejun Heo <tj@kernel.org>
    firewire: don't use PREPARE_DELAYED_WORK

Stefan Richter <stefanr@s5r6.in-berlin.de>
    firewire: net: fix use after free

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    tracing: Do not add event files for modules that fail tracepoints

Zhang Rui <rui.zhang@intel.com>
    ACPI / resources: ignore invalid ACPI device resources

Li Zefan <lizefan@huawei.com>
    cpuset: fix a race condition in __cpuset_node_allowed_softwall()

Chuansheng Liu <chuansheng.liu@intel.com>
    genirq: Remove racy waitqueue_active check

Julius Werner <jwerner@chromium.org>
    usb: Make DELAY_INIT quirk wait 100ms between Get Configuration requests

Julius Werner <jwerner@chromium.org>
    usb: Add device quirk for Logitech HD Pro Webcams C920 and C930e

Daniel J Blueman <daniel@numascale.com>
    x86/amd/numa: Fix northbridge quirk to assign correct NUMA node

Linus Torvalds <torvalds@linux-foundation.org>
    x86: fix compile error due to X86_TRAP_NMI use in asm files

H. Peter Anvin <hpa@linux.intel.com>
    x86: Ignore NMIs that come in during early boot

Markus Pargmann <mpa@pengutronix.de>
    regulator: core: Replace direct ops->enable usage

Linus Walleij <linus.walleij@linaro.org>
    ARM: 7991/1: sa1100: fix compile problem on Collie

Anton Blanchard <anton@samba.org>
    powerpc: Align p_dyn, p_rela and p_st symbols

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Add missing loopback merge path for AD1884/1984 codecs

Marius Knaust <marius.knaust@gmail.com>
    ALSA: hda - Added inverted digital-mic handling for Acer TravelMate 8371

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Add quirk for Logitech Webcam C500

Roman Volkov <v1ron@mail.ru>
    ALSA: oxygen: Xonar DG(X): capture from I2S channel 1, not 2

Rob Clark <rclark@redhat.com>
    drm/ttm: don't oops if no invalidate_caches()

Will Deacon <will.deacon@arm.com>
    ARM: 7811/1: locks: use early clobber in arch_spin_trylock

Amitkumar Karwar <akarwar@marvell.com>
    mwifiex: save and copy AP's VHT capability info correctly

Amitkumar Karwar <akarwar@marvell.com>
    mwifiex: copy AP's HT capability info correctly

Bing Zhao <bzhao@marvell.com>
    mwifiex: do not advertise usb autosuspend support

Amitkumar Karwar <akarwar@marvell.com>
    mwifiex: fix cmd and Tx data timeout issue for PCIe cards

Amitkumar Karwar <akarwar@marvell.com>
    mwifiex: add NULL check for PCIe Rx skb

Avinash Patil <patila@marvell.com>
    mwifiex: clean pcie ring only when device is present

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: disable TX AMPDU by default for iwldvm

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: fix TX status for aggregated packets

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: dvm: clear IWL_STA_UCODE_INPROGRESS when assoc fails

Sujith Manoharan <c_manoha@qca.qualcomm.com>
    ath9k: Fix ETSI compliance for AR9462 2.0

Johannes Berg <johannes.berg@intel.com>
    mac80211: clear sequence/fragment number in QoS-null frames

Johannes Berg <johannes.berg@intel.com>
    mac80211: fix association to 20/40 MHz VHT networks

Johannes Berg <johannes.berg@intel.com>
    mac80211: don't validate unchanged AP bandwidth while tracking

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    mac80211: fix AP powersave TX vs. wakeup race

Felix Fietkau <nbd@openwrt.org>
    mac80211: send control port protocol frames to the VO queue

Daniel Borkmann <dborkman@redhat.com>
    net: sctp: fix sctp_sf_do_5_1D_ce to verify if we/peer is AUTH capable

Michael Chan <mchan@broadcom.com>
    tg3: Don't check undefined error bits in RXBD

Hans Schillstrom <hans@schillstrom.com>
    ipv6: ipv6_find_hdr restore prev functionality

Edward Cree <ecree@solarflare.com>
    sfc: check for NULL efx->ptp_data in efx_ptp_event

Hannes Frederic Sowa <hannes@stressinduktion.org>
    ipv6: reuse ip6_frag_id from ip6_ufo_append_data

Jason Wang <jasowang@redhat.com>
    virtio-net: alloc big buffers also when guest can receive UFO

Duan Jiong <duanj.fnst@cn.fujitsu.com>
    neigh: recompute reachabletime before returning from neigh_periodic_work()

Eric Dumazet <edumazet@google.com>
    net-tcp: fastopen: fix high order allocations

Alexandre Bounine <alexandre.bounine@idt.com>
    rapidio/tsi721: fix tasklet termination in dma channel release

George McCollister <george.mccollister@gmail.com>
    sched: Fix double normalization of vruntime

Al Viro <viro@zeniv.linux.org.uk>
    ocfs2 syncs the wrong range...

Jan Kara <jack@suse.cz>
    ocfs2: fix quota file corruption


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/include/asm/spinlock.h                    |   2 +-
 arch/arm/kernel/setup.c                            |  30 ++++-
 arch/arm/mach-sa1100/include/mach/collie.h         |   2 +
 arch/mips/include/asm/mipsregs.h                   |   1 +
 arch/powerpc/kernel/reloc_64.S                     |   1 +
 arch/x86/kernel/head_32.S                          |   7 +-
 arch/x86/kernel/head_64.S                          |   6 +-
 arch/x86/kernel/i387.c                             |  15 ++-
 arch/x86/kernel/quirks.c                           |   2 +-
 arch/x86/kvm/svm.c                                 |   6 +-
 drivers/acpi/resource.c                            |  10 ++
 drivers/acpi/sleep.c                               |  32 +++---
 drivers/ata/libata-core.c                          |   1 +
 drivers/firewire/core-device.c                     |  22 ++--
 drivers/firewire/net.c                             |   6 +-
 drivers/firewire/sbp2.c                            |  17 ++-
 drivers/gpu/drm/radeon/atombios_encoders.c         |   2 +-
 drivers/gpu/drm/ttm/ttm_bo.c                       |   8 +-
 drivers/infiniband/ulp/isert/ib_isert.c            | 124 ++++++++++-----------
 drivers/infiniband/ulp/isert/ib_isert.h            |   4 +-
 drivers/md/dm-cache-target.c                       |  11 +-
 drivers/net/can/flexcan.c                          |   4 +-
 drivers/net/ethernet/broadcom/tg3.c                |   3 +-
 drivers/net/ethernet/broadcom/tg3.h                |   6 +-
 drivers/net/ethernet/sfc/ptp.c                     |   7 ++
 drivers/net/virtio_net.c                           |   3 +-
 drivers/net/vmxnet3/vmxnet3_drv.c                  |  19 +++-
 .../net/wireless/ath/ath9k/ar9462_2p0_initvals.h   |   4 +-
 drivers/net/wireless/iwlwifi/dvm/mac80211.c        |  22 +++-
 drivers/net/wireless/iwlwifi/dvm/sta.c             |   1 +
 drivers/net/wireless/iwlwifi/dvm/tx.c              |  14 ++-
 drivers/net/wireless/iwlwifi/iwl-drv.c             |   2 +-
 drivers/net/wireless/iwlwifi/iwl-modparams.h       |  11 +-
 drivers/net/wireless/iwlwifi/mvm/bt-coex.c         |   7 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c        |  22 +++-
 drivers/net/wireless/iwlwifi/mvm/tx.c              |  18 +--
 drivers/net/wireless/mwifiex/11ac.c                |   3 +-
 drivers/net/wireless/mwifiex/11n.c                 |   3 +-
 drivers/net/wireless/mwifiex/pcie.c                |  34 +++---
 drivers/net/wireless/mwifiex/scan.c                |   8 +-
 drivers/net/wireless/mwifiex/usb.c                 |   8 --
 drivers/net/wireless/mwifiex/wmm.c                 |   3 +-
 drivers/pci/pci.c                                  |   3 +
 drivers/rapidio/devices/tsi721.h                   |   1 +
 drivers/rapidio/devices/tsi721_dma.c               |  27 +++--
 drivers/regulator/core.c                           |  14 +--
 drivers/s390/block/dasd.c                          |   8 +-
 drivers/scsi/isci/host.h                           |   5 +-
 drivers/scsi/isci/port_config.c                    |   7 --
 drivers/scsi/isci/task.c                           |   2 +-
 drivers/scsi/qla2xxx/qla_def.h                     |   3 +-
 drivers/scsi/storvsc_drv.c                         |   3 +
 drivers/spi/spi-ath79.c                            |   4 +-
 drivers/target/iscsi/iscsi_target.c                |   8 +-
 drivers/target/iscsi/iscsi_target_erl2.c           |  16 +--
 drivers/target/iscsi/iscsi_target_tpg.c            |   2 +-
 drivers/usb/core/config.c                          |   4 +
 drivers/usb/core/quirks.c                          |   4 +
 fs/bio-integrity.c                                 |   2 +-
 fs/btrfs/compression.c                             |   2 +
 fs/namei.c                                         |   1 +
 fs/nfs/delegation.c                                |  11 +-
 fs/nfs/nfs4proc.c                                  |   5 +-
 fs/ocfs2/file.c                                    |   8 +-
 fs/ocfs2/quota_global.c                            |  27 +++--
 fs/ocfs2/quota_local.c                             |   4 -
 fs/proc/base.c                                     |   1 +
 include/linux/firewire.h                           |   1 +
 include/linux/jiffies.h                            |   8 +-
 include/linux/tracepoint.h                         |   6 +
 include/net/tcp.h                                  |   3 +-
 include/target/iscsi/iscsi_transport.h             |   1 +
 ipc/msg.c                                          |   2 +
 kernel/cpuset.c                                    |   2 +-
 kernel/irq/manage.c                                |   3 +-
 kernel/sched/fair.c                                |   8 +-
 kernel/time/tick-broadcast.c                       |  13 ++-
 kernel/trace/trace_events.c                        |  10 ++
 kernel/tracepoint.c                                |   7 +-
 mm/compaction.c                                    |  20 ++--
 net/core/neighbour.c                               |   6 +-
 net/ipv4/tcp.c                                     |   8 +-
 net/ipv4/tcp_output.c                              |   7 +-
 net/ipv6/exthdrs_core.c                            |   2 +-
 net/ipv6/udp_offload.c                             |   2 +-
 net/mac80211/mesh_ps.c                             |   1 +
 net/mac80211/mlme.c                                |  23 ++++
 net/mac80211/sta_info.c                            |   5 +
 net/mac80211/sta_info.h                            |   7 +-
 net/mac80211/tx.c                                  |  15 +++
 net/mac80211/wme.c                                 |   5 +
 net/sctp/sm_statefuns.c                            |   7 ++
 net/unix/af_unix.c                                 |   3 +-
 sound/pci/hda/patch_analog.c                       |   1 +
 sound/pci/hda/patch_realtek.c                      |   1 +
 sound/pci/oxygen/xonar_dg.c                        |  12 +-
 sound/soc/soc-pcm.c                                |   3 +
 sound/usb/mixer.c                                  |   1 +
 99 files changed, 574 insertions(+), 306 deletions(-)


