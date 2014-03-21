Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966474AbaCUAVR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:21:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37335 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966095AbaCUAJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:09:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.4 00/35] 3.4.84-stable review
Date: Thu, 20 Mar 2014 17:10:51 -0700
Message-Id: <20140321001054.038170009@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.84 release.
There are 35 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Mar 23 00:10:42 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.84-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.84-rc1

Paul E. McKenney <paulmck@linux.vnet.ibm.com>
    jiffies: Avoid undefined behavior from signed overflow

Roman Volkov <v1ron@mail.ru>
    ALSA: oxygen: modify adjust_dg_dac_routing function

Filipe David Borba Manana <fdmanana@gmail.com>
    Btrfs: fix data corruption when reading/updating compressed extents

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

Arnd Bergmann <arnd@arndb.de>
    vmxnet3: fix building without CONFIG_PCI_MSI

Neil Horman <nhorman@tuxdriver.com>
    vmxnet3: fix netpoll race condition

Radim Krčmář <rkrcmar@redhat.com>
    KVM: SVM: fix cr8 intercept window

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon/atom: select the proper number of lanes in transmitter setup

Artem Fetishev <artem_fetishev@epam.com>
    fs/proc/base.c: fix GPF in /proc/$PID/map_files

Trond Myklebust <trond.myklebust@primarydata.com>
    NFS: Fix a delegation callback race

Michele Baldessari <michele@acksyn.org>
    libata: add ATA_HORKAGE_BROKEN_FPDMA_AA quirk for Seagate Momentus SpinPoint M8 (2BA30001)

Tejun Heo <tj@kernel.org>
    firewire: don't use PREPARE_DELAYED_WORK

Stefan Richter <stefanr@s5r6.in-berlin.de>
    firewire: net: fix use after free

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    tracing: Do not add event files for modules that fail tracepoints

Li Zefan <lizefan@huawei.com>
    cpuset: fix a race condition in __cpuset_node_allowed_softwall()

Chuansheng Liu <chuansheng.liu@intel.com>
    genirq: Remove racy waitqueue_active check

Daniel J Blueman <daniel@numascale.com>
    x86/amd/numa: Fix northbridge quirk to assign correct NUMA node

Linus Walleij <linus.walleij@linaro.org>
    ARM: 7991/1: sa1100: fix compile problem on Collie

Anton Blanchard <anton@samba.org>
    powerpc: Align p_dyn, p_rela and p_st symbols

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Add quirk for Logitech Webcam C500

Roman Volkov <v1ron@mail.ru>
    ALSA: oxygen: Xonar DG(X): capture from I2S channel 1, not 2

Rob Clark <rclark@redhat.com>
    drm/ttm: don't oops if no invalidate_caches()

Amitkumar Karwar <akarwar@marvell.com>
    mwifiex: copy AP's HT capability info correctly

Sujith Manoharan <c_manoha@qca.qualcomm.com>
    ath9k: Fix ETSI compliance for AR9462 2.0

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    mac80211: fix AP powersave TX vs. wakeup race

Daniel Borkmann <dborkman@redhat.com>
    net: sctp: fix sctp_sf_do_5_1D_ce to verify if we/peer is AUTH capable

Michael Chan <mchan@broadcom.com>
    tg3: Don't check undefined error bits in RXBD

Jason Wang <jasowang@redhat.com>
    virtio-net: alloc big buffers also when guest can receive UFO

George McCollister <george.mccollister@gmail.com>
    sched: Fix double normalization of vruntime

Al Viro <viro@zeniv.linux.org.uk>
    ocfs2 syncs the wrong range...

Jan Kara <jack@suse.cz>
    ocfs2: fix quota file corruption


-------------

Diffstat:

 Makefile                                           |  4 ++--
 arch/arm/mach-sa1100/include/mach/collie.h         |  2 ++
 arch/powerpc/kernel/reloc_64.S                     |  1 +
 arch/x86/kernel/quirks.c                           |  2 +-
 arch/x86/kvm/svm.c                                 |  6 ++---
 drivers/ata/libata-core.c                          |  1 +
 drivers/firewire/core-device.c                     | 22 ++++++++++++------
 drivers/firewire/net.c                             |  6 ++---
 drivers/firewire/sbp2.c                            | 17 ++++++++++----
 drivers/gpu/drm/radeon/atombios_encoders.c         |  2 +-
 drivers/gpu/drm/ttm/ttm_bo.c                       |  8 ++++---
 drivers/net/can/flexcan.c                          |  4 +++-
 drivers/net/ethernet/broadcom/tg3.c                |  3 +--
 drivers/net/ethernet/broadcom/tg3.h                |  6 ++++-
 drivers/net/virtio_net.c                           |  3 ++-
 drivers/net/vmxnet3/vmxnet3_drv.c                  | 19 +++++++++++----
 .../net/wireless/ath/ath9k/ar9462_2p0_initvals.h   |  4 ++--
 drivers/net/wireless/mwifiex/11n.c                 |  3 +--
 drivers/scsi/isci/host.h                           |  5 ++--
 drivers/scsi/isci/port_config.c                    |  7 ------
 drivers/scsi/isci/task.c                           |  2 +-
 drivers/scsi/qla2xxx/qla_def.h                     |  3 +--
 drivers/scsi/storvsc_drv.c                         |  3 +++
 fs/btrfs/compression.c                             |  2 ++
 fs/nfs/delegation.c                                | 11 +++++----
 fs/ocfs2/file.c                                    |  8 +++----
 fs/ocfs2/quota_global.c                            | 27 ++++++++++++++--------
 fs/ocfs2/quota_local.c                             |  4 ----
 fs/proc/base.c                                     |  1 +
 include/linux/firewire.h                           |  1 +
 include/linux/jiffies.h                            |  8 +++----
 include/linux/tracepoint.h                         |  6 +++++
 kernel/cpuset.c                                    |  2 +-
 kernel/irq/manage.c                                |  3 +--
 kernel/sched/fair.c                                |  8 +++----
 kernel/trace/trace_events.c                        | 10 ++++++++
 kernel/tracepoint.c                                |  7 +++++-
 net/mac80211/sta_info.c                            |  4 ++++
 net/mac80211/sta_info.h                            |  7 +++---
 net/mac80211/tx.c                                  | 15 ++++++++++++
 net/sctp/sm_statefuns.c                            |  7 ++++++
 sound/pci/oxygen/xonar_dg.c                        | 12 +++++++++-
 sound/usb/mixer.c                                  |  1 +
 43 files changed, 187 insertions(+), 90 deletions(-)


