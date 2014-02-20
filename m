Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936AbaBTXvD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 18:51:03 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45415 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754837AbaBTXvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:51:00 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [PATCH 3.10 00/66] 3.10.32-stable review
Date: Thu, 20 Feb 2014 15:50:59 -0800
Message-Id: <20140220234909.482516304@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.10.32 release.
There are 66 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat Feb 22 23:48:52 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.32-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.10.32-rc1

Borislav Petkov <bp@suse.de>
    EDAC: Correct workqueue setup path

Borislav Petkov <bp@suse.de>
    EDAC: Poll timeout cannot be zero, p2

Prarit Bhargava <prarit@redhat.com>
    drivers/edac/edac_mc_sysfs.c: poll timeout cannot be zero

Jingoo Han <jg1.han@samsung.com>
    EDAC: Replace strict_strtol() with kstrtol()

Paul Gortmaker <paul.gortmaker@windriver.com>
    genirq: Add missing irq_to_desc export for CONFIG_SPARSE_IRQ=n

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    ring-buffer: Fix first commit on sub-buffer having non-zero delta

Krzysztof Kozlowski <k.kozlowski@samsung.com>
    power: max17040: Fix NULL pointer dereference when there is no platform_data

Mikulas Patocka <mpatocka@redhat.com>
    time: Fix overflow when HZ is smaller than 60

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

Marcus Folkesson <marcus.folkesson@gmail.com>
    iio: adis16400: Set timestamp as the last element in chan_spec

Guenter Roeck <linux@roeck-us.net>
    iio: max1363: Use devm_regulator_get_optional for optional regulator

Hartmut Knaack <knaack.h@gmx.de>
    staging:iio:ad799x fix error_free_irq which was freeing an irq that may not have been requested

H Hartley Sweeten <hsweeten@visionengravers.com>
    staging: comedi: adv_pci1710: fix analog output readback value

Bjørn Mork <bjorn@mork.no>
    usb: qcserial: add Netgear Aircard 340U

Petr Písař <petr.pisar@atlas.cz>
    vt: Fix secure clear screen

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

Martin Schwidefsky <schwidefsky@de.ibm.com>
    s390: fix kernel crash due to linkage stack instructions

Michael Holzheu <holzheu@linux.vnet.ibm.com>
    s390/dump: Fix dump memory detection

Oleksij Rempel <linux@rempel-privat.de>
    ar5523: fix usb id for Gigaset.

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

Eric W. Biederman <ebiederm@xmission.com>
    fs/file.c:fdtable: avoid triggering OOMs from alloc_fdmem

Frediano Ziglio <frediano.ziglio@citrix.com>
    xen: Fix possible user space selector corruption

David Vrabel <david.vrabel@citrix.com>
    xen/p2m: check MFN is in range before using the m2p table

David Vrabel <david.vrabel@citrix.com>
    xen-blkfront: handle backend CLOSED without CLOSING


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-tty           |  3 +-
 Makefile                                      |  4 +-
 arch/s390/kernel/head64.S                     |  7 ++-
 arch/s390/mm/page-states.c                    | 10 +++
 arch/x86/include/asm/xen/page.h               | 31 +++++----
 arch/x86/kernel/cpu/common.c                  |  7 ++-
 arch/x86/kernel/ftrace.c                      | 83 +++++++++++++-----------
 arch/x86/mm/fault.c                           | 14 +++--
 arch/x86/xen/p2m.c                            | 10 ++-
 arch/x86/xen/smp.c                            |  9 +++
 block/blk-lib.c                               |  8 +++
 block/blk.h                                   |  2 +-
 drivers/block/xen-blkfront.c                  |  5 +-
 drivers/char/raw.c                            |  2 +-
 drivers/edac/edac_mc.c                        | 13 ++--
 drivers/edac/edac_mc_sysfs.c                  | 12 ++--
 drivers/edac/edac_module.h                    |  2 +-
 drivers/gpu/drm/radeon/r600.c                 |  4 ++
 drivers/gpu/drm/radeon/si.c                   |  4 ++
 drivers/hv/connection.c                       | 11 +---
 drivers/hwmon/ntc_thermistor.c                |  6 +-
 drivers/iio/adc/max1363.c                     |  2 +-
 drivers/iio/imu/adis16400.h                   |  1 +
 drivers/iio/imu/adis16400_core.c              | 10 +--
 drivers/infiniband/hw/qib/qib_iba7322.c       |  5 ++
 drivers/md/raid1.c                            | 13 +++-
 drivers/md/raid5.c                            | 90 +++++++++++++--------------
 drivers/misc/mei/client.c                     | 11 +++-
 drivers/net/wireless/ath/ar5523/ar5523.c      |  2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c | 25 ++++----
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c  |  5 ++
 drivers/net/wireless/iwlwifi/mvm/scan.c       |  3 +-
 drivers/net/wireless/iwlwifi/mvm/utils.c      |  2 +
 drivers/of/address.c                          |  5 +-
 drivers/power/max17040_battery.c              |  5 +-
 drivers/spi/spi.c                             |  4 +-
 drivers/staging/comedi/drivers/adv_pci1710.c  | 17 +++--
 drivers/staging/iio/adc/ad799x_core.c         |  3 +-
 drivers/tty/n_gsm.c                           | 11 ++++
 drivers/tty/tty_io.c                          | 25 +++++---
 drivers/tty/vt/vt.c                           |  2 +
 drivers/usb/core/hcd.c                        |  1 -
 drivers/usb/core/hub.c                        |  7 +--
 drivers/usb/core/usb.h                        |  1 -
 drivers/usb/serial/ftdi_sio.c                 |  3 +
 drivers/usb/serial/ftdi_sio_ids.h             |  7 +++
 drivers/usb/serial/option.c                   |  3 +-
 drivers/usb/serial/qcserial.c                 |  3 +
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
 include/linux/compiler-gcc4.h                 |  6 +-
 kernel/irq/irqdesc.c                          |  1 +
 kernel/time/jiffies.c                         |  6 ++
 kernel/time/tick-broadcast.c                  |  1 +
 kernel/trace/ring_buffer.c                    |  7 +++
 mm/memory-failure.c                           |  6 +-
 net/mac80211/cfg.c                            | 41 ++++++------
 net/mac80211/tx.c                             |  2 +-
 scripts/mod/file2alias.c                      |  4 +-
 sound/pci/hda/patch_realtek.c                 |  1 +
 virt/kvm/coalesced_mmio.c                     |  8 +--
 73 files changed, 502 insertions(+), 264 deletions(-)


