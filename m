Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575AbaBTXwO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 18:52:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45729 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755551AbaBTXwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:52:11 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [PATCH 3.12 00/82] 3.12.13-stable review
Date: Thu, 20 Feb 2014 15:51:43 -0800
Message-Id: <20140220235019.483734207@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.12.13 release.
There are 82 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat Feb 22 23:50:04 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.12.13-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.12.13-rc1

Borislav Petkov <bp@suse.de>
    EDAC: Correct workqueue setup path

Borislav Petkov <bp@suse.de>
    EDAC: Poll timeout cannot be zero, p2

Prarit Bhargava <prarit@redhat.com>
    drivers/edac/edac_mc_sysfs.c: poll timeout cannot be zero

Paul Gortmaker <paul.gortmaker@windriver.com>
    genirq: Add missing irq_to_desc export for CONFIG_SPARSE_IRQ=n

Nicholas Bellinger <nab@linux-iscsi.org>
    target: Fix free-after-use regression in PR unregister

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    ring-buffer: Fix first commit on sub-buffer having non-zero delta

Krzysztof Kozlowski <k.kozlowski@samsung.com>
    power: max17040: Fix NULL pointer dereference when there is no platform_data

Mikulas Patocka <mpatocka@redhat.com>
    time: Fix overflow when HZ is smaller than 60

Wolfram Sang <wsa@the-dreams.de>
    i2c: mv64xxx: refactor message start to ensure proper initialization

Oleg Nesterov <oleg@redhat.com>
    md/raid5: Fix CPU hotplug callback registration

NeilBrown <neilb@suse.de>
    md/raid1: restore ability for check and repair to fix read errors.

Thomas Gleixner <tglx@linutronix.de>
    tick: Clear broadcast pending bit when switching to oneshot

Dan Carpenter <dan.carpenter@oracle.com>
    KVM: return an error code in kvm_vm_ioctl_register_coalesced_mmio()

Mike Marciniszyn <mike.marciniszyn@intel.com>
    IB/qib: Add missing serdes init sequence

Steven Noonan <steven@uplinklabs.net>
    compiler/gcc4: Make quirk for asm_volatile_goto() unconditional

Mika Westerberg <mika.westerberg@linux.intel.com>
    ACPI / hotplug / PCI: Relax the checking of _STA return values

Jens Axboe <axboe@fb.com>
    block: add cond_resched() to potentially long running ioctl discard loop

Martin K. Petersen <martin.petersen@oracle.com>
    block: Fix nr_vecs for inline integrity vectors

Tejun Heo <tj@kernel.org>
    block: __elv_next_request() shouldn't call into the elevator if bypassing

Jan Moskyto Matejka <mq@suse.cz>
    Modpost: fixed USB alias generation for ranges including 0x9 and 0xA

Sarah Sharp <sarah.a.sharp@linux.intel.com>
    Revert "usbcore: set lpm_capable field for LPM capable root hubs"

Sarah Sharp <sarah.a.sharp@linux.intel.com>
    Revert "usb: xhci: Link TRB must not occur within a USB payload burst"

Sarah Sharp <sarah.a.sharp@linux.intel.com>
    Revert "xhci: Avoid infinite loop when sg urb requires too many trbs"

Sarah Sharp <sarah.a.sharp@linux.intel.com>
    Revert "xhci: Set scatter-gather limit to avoid failed block writes."

Sarah Sharp <sarah.a.sharp@linux.intel.com>
    xhci 1.0: Limit arbitrarily-aligned scatter gather.

Kristóf Ralovich <kristof.ralovich@gmail.com>
    USB: simple: add Dynastream ANT USB-m Stick device support

Raymond Wanyoike <raymond.wanyoike@gmail.com>
    usb: option: blacklist ZTE MF667 net interface

Alan Stern <stern@rowland.harvard.edu>
    usb-storage: enable multi-LUN scanning when needed

Alan Stern <stern@rowland.harvard.edu>
    usb-storage: restrict bcdDevice range for Super Top in Cypress ATACB

Alan Stern <stern@rowland.harvard.edu>
    usb-storage: add unusual-devs entry for BlackBerry 9000

Ulrich Hahn <uhahn@eanco.de>
    USB: ftdi_sio: add Tagsys RFID Reader IDs

Bjørn Mork <bjorn@mork.no>
    usb: ftdi_sio: add Mindstorms EV3 console adapter

K. Y. Srinivasan <kys@microsoft.com>
    Drivers: hv: vmbus: Don't timeout during the initial connection with host

Martyn Welch <martyn.welch@ge.com>
    VME: Correct read/write alignment algorithm

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: don't unset read cb ptr on reset

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: clear write cb from waiting list on reset

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Fix mic capture on Sony VAIO Pro 11

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    ftrace/x86: Use breakpoints for converting function graph caller

H. Peter Anvin <hpa@linux.intel.com>
    x86, smap: smap_violation() is bogus if CONFIG_X86_SMAP is off

H. Peter Anvin <hpa@linux.intel.com>
    x86, smap: Don't enable SMAP if CONFIG_X86_SMAP is disabled

Beomho Seo <beomho.seo@samsung.com>
    iio: ak8975: Fix calculation formula for convert micro tesla to gauss unit

Marcus Folkesson <marcus.folkesson@gmail.com>
    iio: adis16400: Set timestamp as the last element in chan_spec

Guenter Roeck <linux@roeck-us.net>
    iio: max1363: Use devm_regulator_get_optional for optional regulator

Hartmut Knaack <knaack.h@gmx.de>
    staging:iio:ad799x fix error_free_irq which was freeing an irq that may not have been requested

H Hartley Sweeten <hsweeten@visionengravers.com>
    staging: comedi: adv_pci1710: fix analog output readback value

Larry Finger <Larry.Finger@lwfinger.net>
    staging: r8188eu: Fix typo in USB_DEVICE list

Cédric Dufour <cedric.dufour@idiap.ch>
    staging: lustre: fix quotactl permission denied (LU-4530)

Bjørn Mork <bjorn@mork.no>
    usb: qcserial: add Netgear Aircard 340U

Petr Písař <petr.pisar@atlas.cz>
    vt: Fix secure clear screen

Mika Kuoppala <mika.kuoppala@linux.intel.com>
    drm/i915: Pair va_copy with va_end in i915_error_vprintf

Christian König <christian.koenig@amd.com>
    drm/radeon: fix UVD IRQ support on SI

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix UVD IRQ support on 7xx

Hannes Reinecke <hare@suse.de>
    tty: Set correct tty name in 'active' sysfs attribute

Lars Poeschel <poeschel@lemonage.de>
    tty: n_gsm: Fix for modems with brk in modem status control

NeilBrown <neilb@suse.de>
    lockd: send correct lock when granting a delayed lock.

Doug Anderson <dianders@chromium.org>
    hwmon: (ntc_thermistor) Avoid math overflow

Paul Bolle <pebolle@tiscali.nl>
    raw: test against runtime value of max_raw_minors

Qipan Li <Qipan.Li@csr.com>
    serial: sirf: fix kernel panic caused by unpaired spinlock

Axel Lin <axel.lin@ingics.com>
    spi: nuc900: Set SPI_LSB_FIRST for master->mode_bits if hw->pdata->lsb is true

Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
    of: fix PCI bus match for PCIe slots

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: mvm: BT Coex - disable BT when TXing probe request in scan

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: mvm: print the version of the firmware when it asserts

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: mvm: don't allow A band if SKU forbids it

Geert Uytterhoeven <geert+renesas@linux-m68k.org>
    spi: Fix crash with double message finalisation on error handling

Pontus Fuchs <pontus.fuchs@gmail.com>
    nl80211: Reset split_start when netlink skb is exhausted

Martin Schwidefsky <schwidefsky@de.ibm.com>
    s390: fix kernel crash due to linkage stack instructions

Michael Holzheu <holzheu@linux.vnet.ibm.com>
    s390/dump: Fix dump memory detection

Oleksij Rempel <linux@rempel-privat.de>
    ar5523: fix usb id for Gigaset.

Sujith Manoharan <c_manoha@qca.qualcomm.com>
    ath9k: Do not support PowerSave by default

Oleksij Rempel <linux@rempel-privat.de>
    ath9k_htc: Do not support PowerSave by default

Stanislaw Gruszka <sgruszka@redhat.com>
    ath9k_htc: make ->sta_rc_update atomic for most calls

Johannes Berg <johannes.berg@intel.com>
    mac80211: fix fragmentation code, particularly for encryption

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    mac80211: release the channel in error path in start_ap

Eliad Peller <eliad@wizery.com>
    mac80211: move roc cookie assignment earlier

Steve French <smfrench@gmail.com>
    retrieving CIFS ACLs when mounted with SMB2 fails dropping session

Steve French <smfrench@gmail.com>
    Add protocol specific operation for CIFS xattrs

Steve French <smfrench@gmail.com>
    CIFS: Fix SMB2 mounts so they don't try to set or get xattrs via cifs

Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
    mm/memory-failure.c: move refcount only in !MF_COUNT_INCREASED

Rafael Aquini <aquini@redhat.com>
    mm: fix page leak at nfs_symlink()

Eric W. Biederman <ebiederm@xmission.com>
    fs/file.c:fdtable: avoid triggering OOMs from alloc_fdmem

David Vrabel <david.vrabel@citrix.com>
    xen-blkfront: handle backend CLOSED without CLOSING

Mel Gorman <mgorman@suse.de>
    xen: properly account for _PAGE_NUMA during xen pte translations


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-tty           |  3 +-
 Makefile                                      |  4 +-
 arch/s390/kernel/head64.S                     |  7 ++-
 arch/s390/mm/page-states.c                    | 10 +++
 arch/x86/include/asm/pgtable.h                | 14 ++++-
 arch/x86/kernel/cpu/common.c                  |  7 ++-
 arch/x86/kernel/ftrace.c                      | 83 +++++++++++++-----------
 arch/x86/mm/fault.c                           | 14 +++--
 arch/x86/xen/mmu.c                            |  4 +-
 block/blk-lib.c                               |  8 +++
 block/blk.h                                   |  2 +-
 drivers/block/xen-blkfront.c                  |  5 +-
 drivers/char/raw.c                            |  2 +-
 drivers/edac/edac_mc.c                        | 13 ++--
 drivers/edac/edac_mc_sysfs.c                  | 10 +--
 drivers/edac/edac_module.h                    |  2 +-
 drivers/gpu/drm/i915/i915_gpu_error.c         |  5 +-
 drivers/gpu/drm/radeon/r600.c                 |  4 ++
 drivers/gpu/drm/radeon/si.c                   |  4 ++
 drivers/hv/connection.c                       | 11 +---
 drivers/hwmon/ntc_thermistor.c                |  6 +-
 drivers/i2c/busses/i2c-mv64xxx.c              | 33 +++++-----
 drivers/iio/adc/max1363.c                     |  2 +-
 drivers/iio/imu/adis16400.h                   |  1 +
 drivers/iio/imu/adis16400_core.c              | 10 +--
 drivers/iio/magnetometer/ak8975.c             | 16 ++---
 drivers/infiniband/hw/qib/qib_iba7322.c       |  5 ++
 drivers/md/raid1.c                            | 13 +++-
 drivers/md/raid5.c                            | 90 +++++++++++++--------------
 drivers/misc/mei/client.c                     | 11 +++-
 drivers/net/wireless/ath/ar5523/ar5523.c      |  2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |  8 ++-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c | 25 ++++----
 drivers/net/wireless/ath/ath9k/init.c         |  8 ++-
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c  |  5 ++
 drivers/net/wireless/iwlwifi/mvm/scan.c       |  3 +-
 drivers/net/wireless/iwlwifi/mvm/utils.c      |  2 +
 drivers/of/address.c                          |  5 +-
 drivers/pci/hotplug/acpiphp_glue.c            | 15 ++++-
 drivers/power/max17040_battery.c              |  5 +-
 drivers/spi/spi-nuc900.c                      |  2 +
 drivers/spi/spi.c                             |  4 +-
 drivers/staging/comedi/drivers/adv_pci1710.c  | 17 +++--
 drivers/staging/iio/adc/ad799x_core.c         |  3 +-
 drivers/staging/lustre/lustre/llite/dir.c     |  2 +-
 drivers/staging/rtl8188eu/os_dep/usb_intf.c   |  2 +-
 drivers/target/target_core_pr.c               | 11 ++--
 drivers/tty/n_gsm.c                           | 11 ++++
 drivers/tty/serial/sirfsoc_uart.c             |  4 +-
 drivers/tty/tty_io.c                          | 25 +++++---
 drivers/tty/vt/vt.c                           |  2 +
 drivers/usb/core/hcd.c                        |  1 -
 drivers/usb/core/hub.c                        |  7 +--
 drivers/usb/core/usb.h                        |  1 -
 drivers/usb/host/xhci-ring.c                  | 54 +---------------
 drivers/usb/host/xhci.c                       | 18 ++++--
 drivers/usb/host/xhci.h                       |  2 +-
 drivers/usb/serial/ftdi_sio.c                 |  3 +
 drivers/usb/serial/ftdi_sio_ids.h             |  7 +++
 drivers/usb/serial/option.c                   |  3 +-
 drivers/usb/serial/qcserial.c                 |  3 +
 drivers/usb/serial/usb-serial-simple.c        |  3 +-
 drivers/usb/storage/Kconfig                   |  4 +-
 drivers/usb/storage/scsiglue.c                |  6 ++
 drivers/usb/storage/unusual_cypress.h         |  2 +-
 drivers/usb/storage/unusual_devs.h            |  7 +++
 drivers/vme/bridges/vme_ca91cx42.c            |  4 +-
 drivers/vme/bridges/vme_tsi148.c              |  4 +-
 fs/bio-integrity.c                            | 10 ++-
 fs/cifs/cifsacl.c                             | 28 +++++++--
 fs/cifs/cifsglob.h                            | 10 +++
 fs/cifs/inode.c                               | 13 ++--
 fs/cifs/smb1ops.c                             |  8 +++
 fs/cifs/xattr.c                               | 64 ++++++++++++-------
 fs/file.c                                     |  2 +-
 fs/lockd/svclock.c                            |  8 +++
 fs/nfs/dir.c                                  |  5 ++
 include/linux/compiler-gcc4.h                 |  6 +-
 include/linux/usb.h                           |  2 -
 kernel/irq/irqdesc.c                          |  1 +
 kernel/time/jiffies.c                         |  6 ++
 kernel/time/tick-broadcast.c                  |  1 +
 kernel/trace/ring_buffer.c                    |  7 +++
 mm/memory-failure.c                           |  6 +-
 net/mac80211/cfg.c                            | 41 ++++++------
 net/mac80211/tx.c                             |  2 +-
 net/wireless/nl80211.c                        |  3 +-
 scripts/mod/file2alias.c                      |  4 +-
 sound/pci/hda/patch_realtek.c                 |  1 +
 virt/kvm/coalesced_mmio.c                     |  8 +--
 90 files changed, 574 insertions(+), 351 deletions(-)


