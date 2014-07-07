Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbaGHACa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 20:02:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55989 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368AbaGGXzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:55:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.10 00/53] 3.10.48-stable review
Date: Mon,  7 Jul 2014 16:57:45 -0700
Message-Id: <20140707235829.281783607@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.10.48 release.
There are 53 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed Jul  9 23:58:20 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.48-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.10.48-rc1

Mikulas Patocka <mpatocka@redhat.com>
    sym53c8xx_2: Set DID_REQUEUE return code when aborting squeue

Zhichuang SUN <sunzc522@gmail.com>
    drivers/video/fbdev/fb-puv3.c: Add header files for function unifb_mmap

Chen Gang <gang.chen.5i5j@gmail.com>
    arch/unicore32/mm/alignment.c: include "asm/pgtable.h" to avoid compiling error

Sander Eikelenboom <linux@eikelenboom.it>
    ALSA: usb-audio: Prevent printk ratelimiting from spamming kernel log while DEBUG not defined

Tim Gardner <tim.gardner@canonical.com>
    ALSA: usb-audio: Suppress repetitive debug messages from retire_playback_urb()

James Hogan <james.hogan@imgtec.com>
    serial: 8250_dw: Fix LCR workaround regression

Tim Kryger <tim.kryger@linaro.org>
    serial: 8250_dw: Improve unwritable LCR workaround

Tim Kryger <tim.kryger@linaro.org>
    serial: 8250_dw: Report CTS asserted for auto flow

Micky Ching <micky_ching@realsil.com.cn>
    mmc: rtsx: add R1-no-CRC mmc command type handle

Thomas Gleixner <tglx@linutronix.de>
    irqchip: spear_shirq: Fix interrupt offset

NeilBrown <neilb@suse.de>
    md: flush writes before starting a recovery.

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    tracing: Remove ftrace_stop/start() from reading the trace file

Michal Nazarewicz <mina86@mina86.com>
    tools: ffs-test: fix header values endianess

J. Bruce Fields <bfields@redhat.com>
    nfsd: fix rare symlink decoding bug

Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
    iio: of_iio_channel_get_by_name() returns non-null pointers for error legs

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: preserve the high 32-bits of the PAT register

Nadav Amit <namit@cs.technion.ac.il>
    KVM: x86: Increase the number of fixed MTRR regs to 10

Jan Kara <jack@suse.cz>
    ext4: Fix hole punching for files with indirect blocks

Jan Kara <jack@suse.cz>
    ext4: Fix buffer double free in ext4_alloc_branch()

Steve French <smfrench@gmail.com>
    CIFS: fix mount failure with broken pathnames when smb3 mount with mapchars option

Rafał Miłecki <zajec5@gmail.com>
    b43: fix frequency reported on G-PHY with /new/ firmware

ChiaHao <andy.jhshiu@gmail.com>
    arm64: Bug fix in stack alignment exception

David R. Piegdon <lkml@p23q.org>
    ARM: OMAP2+: Fix parser-bug in platform muxing code

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: pcie: try to get ownership several times

Felix Fietkau <nbd@openwrt.org>
    mac80211: fix a memory leak on sta rate selection table

Arik Nemtsov <arik@wizery.com>
    mac80211: don't check netdev state for debugfs read/write

Fabio Baltieri <fabio.baltieri@gmail.com>
    hwmon: (ina2xx) Cast to s16 on shunt and current regs

Ilya Dryomov <ilya.dryomov@inktank.com>
    rbd: handle parent_overlap on writes correctly

Alex Elder <elder@linaro.org>
    rbd: use reference counts for image requests

Lukas Czerner <lczerner@redhat.com>
    dm thin: update discard_granularity to reflect the thin-pool blocksize

Johan Hedberg <johan.hedberg@intel.com>
    Bluetooth: Fix locking of hdev when calling into SMP code

Johan Hedberg <johan.hedberg@intel.com>
    Bluetooth: Fix check for connection encryption

Johan Hedberg <johan.hedberg@intel.com>
    Bluetooth: Fix SSP acceptor just-works confirmation without MITM

Thomas Hellstrom <thellstrom@vmware.com>
    drm/vmwgfx: Fix incorrect write to read-only register v2:

Marek Olšák <marek.olsak@amd.com>
    drm/radeon: don't allow RADEON_GEM_DOMAIN_CPU for command submission

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon/atom: fix dithering on certain panels

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon/dp: fix lane/clock setup for dp 1.2 capable devices

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix typo in radeon_connector_is_dp12_capable()

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: only apply hdmi bpc pll flags when encoder mode is hdmi

pekon gupta <pekon@ti.com>
    mtd: nand: omap: fix BCHx ecc.correct to return detected bit-flips in erased-page

Pekon Gupta <pekon@ti.com>
    mtd: eLBC NAND: fix subpage write support

Stanislaw Gruszka <stf_xl@wp.pl>
    rt2x00: fix rfkill regression on rt2500pci

Stanislaw Gruszka <sgruszka@redhat.com>
    rt2x00: disable TKIP on USB

Michal Nazarewicz <mina86@mina86.com>
    usb: gadget: f_fs: fix NULL pointer dereference when there are no strings

Johan Hovold <johan@kernel.org>
    USB: ftdi_sio: fix null deref at port probe

Bjørn Mork <bjorn@mork.no>
    usb: option: add/modify Olivetti Olicard modems

Oliver Neukum <oneukum@suse.de>
    USB: option: add device ID for SpeedUp SU9800 usb 3g modem

Wang, Yu <yu.y.wang@intel.com>
    xhci: Fix runtime suspended xhci from blocking system suspend.

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: correct burst count field for isoc transfers on 1.0 xhci hosts

Paolo Bonzini <pbonzini@redhat.com>
    virtio-scsi: fix various bad behavior on aborted requests

Paolo Bonzini <pbonzini@redhat.com>
    virtio-scsi: avoid cancelling uninitialized work items

Brian King <brking@linux.vnet.ibm.com>
    ibmvscsi: Add memory barriers for send / receive

Brian King <brking@linux.vnet.ibm.com>
    ibmvscsi: Abort init sequence during error recovery


-------------

Diffstat:

 Makefile                                   |  4 +-
 arch/arm/mach-omap2/mux.c                  |  6 ++-
 arch/arm64/kernel/entry.S                  |  1 -
 arch/unicore32/mm/alignment.c              |  1 +
 arch/x86/include/asm/kvm_host.h            |  4 +-
 drivers/block/rbd.c                        | 19 +++++++-
 drivers/gpu/drm/radeon/atombios_crtc.c     | 48 ++++++++++---------
 drivers/gpu/drm/radeon/atombios_dp.c       | 17 ++++++-
 drivers/gpu/drm/radeon/atombios_encoders.c |  5 +-
 drivers/gpu/drm/radeon/radeon_connectors.c |  2 +-
 drivers/gpu/drm/radeon/radeon_cs.c         |  6 +++
 drivers/gpu/drm/vmwgfx/vmwgfx_fb.c         |  1 -
 drivers/hwmon/ina2xx.c                     |  7 +--
 drivers/iio/inkern.c                       |  6 ++-
 drivers/irqchip/spear-shirq.c              |  2 +-
 drivers/md/dm-thin.c                       |  3 +-
 drivers/md/md.c                            | 13 ++++++
 drivers/mmc/host/rtsx_pci_sdmmc.c          |  3 ++
 drivers/mtd/nand/fsl_elbc_nand.c           | 14 ++++++
 drivers/mtd/nand/omap2.c                   |  2 +-
 drivers/net/wireless/b43/xmit.c            | 10 ++--
 drivers/net/wireless/iwlwifi/pcie/trans.c  | 26 +++++++----
 drivers/net/wireless/rt2x00/rt2500pci.c    |  7 ++-
 drivers/net/wireless/rt2x00/rt2x00.h       |  1 +
 drivers/net/wireless/rt2x00/rt2x00dev.c    | 24 ++++++++--
 drivers/net/wireless/rt2x00/rt2x00mac.c    |  2 +
 drivers/scsi/ibmvscsi/ibmvscsi.c           | 13 +++++-
 drivers/scsi/sym53c8xx_2/sym_hipd.c        |  4 ++
 drivers/scsi/virtio_scsi.c                 | 26 ++++++++++-
 drivers/tty/serial/8250/8250_dw.c          | 74 +++++++++++++++++++++++-------
 drivers/usb/gadget/f_fs.c                  | 12 +++--
 drivers/usb/host/xhci-ring.c               |  2 +-
 drivers/usb/host/xhci.c                    | 10 ++--
 drivers/usb/serial/ftdi_sio.c              |  7 ++-
 drivers/usb/serial/option.c                | 26 ++++++++---
 drivers/video/fb-puv3.c                    |  2 +
 fs/cifs/cifs_unicode.c                     |  7 +--
 fs/ext4/indirect.c                         | 20 ++++++--
 fs/nfsd/nfs4proc.c                         |  9 ----
 fs/nfsd/nfs4xdr.c                          | 13 +++++-
 kernel/trace/trace.c                       |  2 -
 net/bluetooth/hci_conn.c                   |  2 +-
 net/bluetooth/hci_event.c                  |  7 ++-
 net/bluetooth/mgmt.c                       |  7 ++-
 net/mac80211/debugfs_netdev.c              |  6 +--
 net/mac80211/sta_info.c                    |  1 +
 sound/usb/pcm.c                            |  3 +-
 tools/usb/ffs-test.c                       |  4 +-
 48 files changed, 367 insertions(+), 124 deletions(-)


