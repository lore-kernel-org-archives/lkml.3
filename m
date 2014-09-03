Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935511AbaICXMd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 19:12:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46028 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933645AbaICWSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:18:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.16 000/125] 3.16.2-stable review
Date: Wed,  3 Sep 2014 15:05:57 -0700
Message-Id: <20140903220623.649748296@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------------------
Note, there are a _lot_ of patches submitted for stable kernels that
have yet to be applied, well over 200+ at the moment.  Given that this
series is already over 100 patches, I figured it was a good as a time as
any to push this out.  Don't worry, if you have emailed/marked patches
to be included, and they aren't here, wait a few more releases for me to
catch up, thanks.
--------------------------

This is the start of the stable review cycle for the 3.16.2 release.
There are 125 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri Sep  5 22:06:09 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.16.2-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.16.2-rc1

Oleg Nesterov <oleg@redhat.com>
    vm_is_stack: use for_each_thread() rather then buggy while_each_thread()

Trond Myklebust <trond.myklebust@primarydata.com>
    NFSv4: Fix problems with close in the presence of a delegation

Trond Myklebust <trond.myklebust@primarydata.com>
    NFSv4: Don't clear the open state when we just did an OPEN_DOWNGRADE

Trond Myklebust <trond.myklebust@primarydata.com>
    NFSv3: Fix another acl regression

Chuck Lever <chuck.lever@oracle.com>
    svcrdma: Select NFSv4.1 backchannel transport based on forward channel

Scott Mayhew <smayhew@redhat.com>
    nfs: reject changes to resvport and sharecache during remount

Andrey Utkin <andrey.krieger.utkin@gmail.com>
    nfs3_list_one_acl(): check get_acl() result with IS_ERR_OR_NULL

Eric W. Biederman <ebiederm@xmission.com>
    NFS: Fix /proc/fs/nfsfs/servers and /proc/fs/nfsfs/volumes

Kinglong Mee <kinglongmee@gmail.com>
    NFSD: Decrease nfsd_users in nfsd_startup_generic fail

Takashi Iwai <tiwai@suse.de>
    usbcore: Fix wrong device in an error message in hub_port_connect()

Roger Quadros <rogerq@ti.com>
    usb: hub: Prevent hub autosuspend if usbcore.autosuspend is -1

Peter Chen <peter.chen@freescale.com>
    usb: ehci: using wIndex + 1 for hub port

James Forshaw <forshaw@google.com>
    USB: whiteheat: Added bounds checking for bulk command response

Jaša Bartelj <jasa.bartelj@gmail.com>
    USB: ftdi_sio: Added PID for new ekey device

Johan Hovold <johan@kernel.org>
    USB: ftdi_sio: add Basic Micro ATOM Nano USB2Serial PID

Tony Lindgren <tony@atomide.com>
    ARM: OMAP2+: hwmod: Rearm wake-up interrupts for DT when MUSB is idled

Hans de Goede <hdegoede@redhat.com>
    xhci: Disable streams on Via XHCI with device-id 0x3432

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: rework cycle bit checking for new dequeue pointers

Huang Rui <ray.huang@amd.com>
    usb: xhci: amd chipset also needs short TX quirk

Hans de Goede <hdegoede@redhat.com>
    xhci: Treat not finding the event_seg on COMP_STOP the same as COMP_STOP_INVAL

Larry Finger <Larry.Finger@lwfinger.net>
    staging: r8188eu: Add new USB ID

Holger Paradies <retabell@gmx.de>
    staging/rtl8188eu: add 0df6:0076 Sitecom Europe B.V.

Mark Einon <mark.einon@gmail.com>
    staging: et131x: Fix errors caused by phydev->addr accesses before initialisation

Pranith Kumar <bobby.prani@gmail.com>
    staging: lustre: Remove circular dependency on header

Darrick J. Wong <darrick.wong@oracle.com>
    jbd2: fix descriptor block size handling errors with journal_csum

Darrick J. Wong <darrick.wong@oracle.com>
    jbd2: fix infinite loop when recovering corrupt journal blocks

Darrick J. Wong <darrick.wong@oracle.com>
    ext4: fix same-dir rename when inline data directory overflows

Dmitry Monakhov <dmonakhov@openvz.org>
    ext4: update i_disksize coherently with block allocation on error path

Dmitry Monakhov <dmonakhov@openvz.org>
    ext4: fix transaction issues for ext4_fallocate and ext_zero_range

Dmitry Monakhov <dmonakhov@openvz.org>
    ext4: fix incorect journal credits reservation in ext4_zero_range

Dmitry Monakhov <dmonakhov@openvz.org>
    ext4: move i_size,i_disksize update routines to helper function

Theodore Ts'o <tytso@mit.edu>
    ext4: propagate errors up to ext4_find_entry()'s callers

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: nfc: fix memory leak in error path

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: reset client state on queued connect request

Liu Bo <bo.li.liu@oracle.com>
    Btrfs: fix task hang under heavy compressed write

Chris Mason <clm@fb.com>
    Btrfs: fix filemap_flush call in btrfs_file_release

Liu Bo <bo.li.liu@oracle.com>
    Btrfs: fix crash on endio of reading corrupted block

Chris Mason <clm@fb.com>
    btrfs: disable strict file flushes for renames and truncates

Liu Bo <bo.li.liu@oracle.com>
    Btrfs: fix compressed write corruption on enospc

Filipe Manana <fdmanana@suse.com>
    Btrfs: read lock extent buffer while walking backrefs

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix csum tree corruption, duplicate and outdated checksums

Takashi Iwai <tiwai@suse.de>
    Btrfs: Fix memory corruption by ulist_add_merge() on 32bit arch

Stephen M. Cameron <scameron@beardog.cce.hp.com>
    hpsa: fix bad -ENOMEM return value in hpsa_big_passthru_ioctl

Hugh Dickins <hughd@google.com>
    x86,mm: fix pte_special versus pte_numa

David Vrabel <david.vrabel@citrix.com>
    x86/xen: resume timer irqs early

David Vrabel <david.vrabel@citrix.com>
    x86/xen: use vmap() to map grant table pages in PVH guests

Matt Fleming <matt.fleming@intel.com>
    x86/efi: Enforce CONFIG_RELOCATABLE for EFI boot stub

David Vrabel <david.vrabel@citrix.com>
    xen/events/fifo: ensure all bitops are properly aligned even on x86

Thomas Gleixner <tglx@linutronix.de>
    x86: MCE: Add raw_lock conversion again

Arnd Bergmann <arnd@arndb.de>
    hpsa: fix non-x86 builds

Andy Lutomirski <luto@amacapital.net>
    x86_64/vsyscall: Fix warn_bad_vsyscall log output

Brian W Hart <hartb@linux.vnet.ibm.com>
    powerpc/powernv: Update dev->dma_mask in pci_set_dma_mask() path

Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
    powerpc/pci: Reorder pci bus/bridge unregistration during PHB removal

Mike Qiu <qiudayu@linux.vnet.ibm.com>
    powerpc/eeh: Wrong place to call pci_get_slot()

Christoph Schulz <develop@kristov.de>
    x86: don't exclude low BIOS area when allocating address space for non-PCI cards

Simone Gotti <simone.gotti@gmail.com>
    ACPI / PCI: Fix sysfs acpi_index and label errors

Myron Stowe <myron.stowe@redhat.com>
    PCI: pciehp: Clear Data Link Layer State Changed during init

Guo Chao <yan@linux.vnet.ibm.com>
    PCI: Keep original resource if we fail to expand it

Vidya Sagar <sagar.tv@gmail.com>
    PCI: Configure ASPM when enabling device

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: add additional SI pci ids

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: add new bonaire pci ids

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: add new KV pci id

Theodore Ts'o <tytso@mit.edu>
    ext4: fix BUG_ON in mb_free_blocks()

Michael S. Tsirkin <mst@redhat.com>
    kvm: iommu: fix the third parameter of kvm_iommu_put_pages (CVE-2014-3601)

Paolo Bonzini <pbonzini@redhat.com>
    Revert "KVM: x86: Increase the number of fixed MTRR regs to 10"

Wanpeng Li <wanpeng.li@linux.intel.com>
    KVM: nVMX: fix "acknowledge interrupt on exit" when APICv is in use

Alexey Kardashevskiy <aik@ozlabs.ru>
    KVM: PPC: Book3S: Fix LPCR one_reg interface

Christian Borntraeger <borntraeger@de.ibm.com>
    KVM: s390/mm: Fix page table locking vs. split pmd lock

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: always exit on EOIs for interrupts listed in the IOAPIC redir table

Nadav Amit <namit@cs.technion.ac.il>
    KVM: x86: Inter-privilege level ret emulation is not implemeneted

Steven Rostedt <rostedt@goodmis.org>
    debugfs: Fix corrupted loop in debugfs_remove_recursive

Arnd Bergmann <arnd@arndb.de>
    crypto: ux500 - make interrupt mode plausible

Peter Hurley <peter@hurleysoftware.com>
    serial: core: Preserve termios c_cflag for console resume

Theodore Ts'o <tytso@mit.edu>
    ext4: fix ext4_discard_allocated_blocks() if we can't allocate the pa struct

Lukas Czerner <lczerner@redhat.com>
    ext4: fix punch hole on files with indirect mapping

addy ke <addy.ke@rock-chips.com>
    i2c: rk3x: fix interrupt handling issue

Wolfram Sang <wsa@the-dreams.de>
    drivers/i2c/busses: use correct type for dma_map/unmap

Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
    tpm: Add missing tpm_do_selftest to ST33 I2C driver

Axel Lin <axel.lin@ingics.com>
    hwmon: (lm92) Prevent overflow problem when writing large limits

Axel Lin <axel.lin@ingics.com>
    hwmon: (dme1737) Prevent overflow problem when writing large limits

Axel Lin <axel.lin@ingics.com>
    hwmon: (ads1015) Fix out-of-bounds array access

Guenter Roeck <linux@roeck-us.net>
    hwmon: (lm85) Fix various errors on attribute writes

Axel Lin <axel.lin@ingics.com>
    hwmon: (ads1015) Fix off-by-one for valid channel index checking

Axel Lin <axel.lin@ingics.com>
    hwmon: (gpio-fan) Prevent overflow problem when writing large limits

Guenter Roeck <linux@roeck-us.net>
    hwmon: (lm78) Fix overflow problems seen when writing large temperature limits

Axel Lin <axel.lin@ingics.com>
    hwmon: (amc6821) Fix possible race condition bug

Axel Lin <axel.lin@ingics.com>
    hwmon: (sis5595) Prevent overflow problem when writing large limits

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: mmci: Move all CMD irq handling to mmci_cmd_irq()

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: mmci: Remove redundant check of status for DATA irq

Russell King <rmk+kernel@arm.linux.org.uk>
    drm: omapdrm: fix compiler errors

Jeremy Vial <jvial@adeneo-embedded.com>
    ARM: OMAP3: Fix choice of omap3_restore_es function in OMAP34XX rev3.1.2 case.

Baruch Siach <baruch@tkos.co.il>
    ARM: 8097/1: unistd.h: relocate comments back to place

Suman Anna <s-anna@ti.com>
    ARM: dts: AM4372: Correct mailbox node data

Semen Protsenko <semen.protsenko@linaro.org>
    efi/arm64: Store Runtime Services revision

Will Deacon <will.deacon@arm.com>
    arm64: don't call break hooks for BRK exceptions from EL0

Catalin Marinas <catalin.marinas@arm.com>
    arm64: Fix barriers used for page table modifications

Daniel Bristot de Oliveira <bristot@redhat.com>
    sched: Fix sched_setparam() policy == -1 logic

Hans de Goede <hdegoede@redhat.com>
    xhci: Blacklist using streams on the Etron EJ168 controller

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: fix return value on disconnect timeout

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: don't schedule suspend in pm idle

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: start disconnect request timer consistently

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: reset client connection state on timeout

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek - Avoid setting wrong COEF on ALC269 & co

Hui Wang <hui.wang@canonical.com>
    ALSA: hda - restore the gpio led after resume

David Henningsson <david.henningsson@canonical.com>
    ALSA: hda - Add mute LED pin quirk for HP 15 touchsmart

Clemens Ladisch <clemens@ladisch.de>
    ALSA: usb-audio: fix BOSS ME-25 MIDI regression

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/ca0132 - Don't try loading firmware at resume when already failed

Clemens Ladisch <clemens@ladisch.de>
    ALSA: virtuoso: add Xonar Essence STX II support

Paul S McSpadden <fisch602@gmail.com>
    ALSA: usb-audio: Adjust Gamecom 780 volume level

Hui Wang <hui.wang@canonical.com>
    ALSA: hda - fix an external mic jack problem on a HP machine

Pratyush Anand <pratyush.anand@st.com>
    USB: Fix persist resume of some SS USB devices

Bryan O'Donoghue <bryan.odonoghue@intel.com>
    USB: ehci-pci: USB host controller support for Intel Quark X1000

Patrick Riphagen <patrick.riphagen@xsens.com>
    USB: serial: ftdi_sio: Add support for new Xsens devices

Patrick Riphagen <patrick.riphagen@xsens.com>
    USB: serial: ftdi_sio: Annotate the current Xsens PID assignments

Oliver Neukum <oneukum@suse.de>
    USB: devio: fix issue with log flooding

Oliver Neukum <oneukum@suse.de>
    usbcore: don't log on consecutive debounce failures of the same port

Alan Stern <stern@rowland.harvard.edu>
    USB: OHCI: don't lose track of EDs when a controller dies

Alan Stern <stern@rowland.harvard.edu>
    USB: OHCI: fix bugs in debug routines

Hans de Goede <hdegoede@redhat.com>
    uas: Limit qdepth to 32 when connected over usb-2

Jan Kara <jack@suse.cz>
    isofs: Fix unbounded recursion when processing relocated directories

Jiri Kosina <jkosina@suse.cz>
    HID: fix a couple of off-by-ones

Jiri Kosina <jkosina@suse.cz>
    HID: logitech: perform bounds checking on device_id early enough

Jiri Kosina <jkosina@suse.cz>
    HID: logitech: fix bounds checking on LED report size

Rob Kendrick <rob.kendrick@codethink.co.uk>
    MIPS: math-emu: Fix instruction decoding.

Dave Chiluk <chiluk@canonical.com>
    stable_kernel_rules: Add pointer to netdev-FAQ for network patches


-------------

Diffstat:

 Documentation/sound/alsa/ALSA-Configuration.txt    |   4 +-
 Documentation/stable_kernel_rules.txt              |   3 +
 Documentation/virtual/kvm/api.txt                  |   3 +-
 Makefile                                           |   4 +-
 arch/arm/boot/dts/am4372.dtsi                      |   3 -
 arch/arm/include/asm/unistd.h                      |  10 +
 arch/arm/include/uapi/asm/unistd.h                 |  11 -
 arch/arm/mach-omap2/control.c                      |   3 +-
 arch/arm/mach-omap2/omap_hwmod.c                   |   4 +
 arch/arm64/include/asm/cacheflush.h                |  11 +-
 arch/arm64/include/asm/pgtable.h                   |  13 +
 arch/arm64/include/asm/tlbflush.h                  |   5 +-
 arch/arm64/kernel/debug-monitors.c                 |  22 +-
 arch/arm64/kernel/efi.c                            |   2 +
 arch/mips/math-emu/cp1emu.c                        |   2 +-
 arch/powerpc/include/uapi/asm/kvm.h                |   1 +
 arch/powerpc/kernel/eeh_pe.c                       |  46 +---
 arch/powerpc/kvm/book3s_hv.c                       |  13 +-
 arch/powerpc/kvm/book3s_pr.c                       |   2 +
 arch/powerpc/platforms/powernv/pci-ioda.c          |   1 +
 arch/powerpc/platforms/pseries/pci_dlpar.c         |   4 +-
 arch/s390/mm/pgtable.c                             |   5 +-
 arch/x86/Kconfig                                   |   1 +
 arch/x86/include/asm/kvm_host.h                    |   2 +-
 arch/x86/include/asm/pgtable.h                     |   9 +-
 arch/x86/kernel/cpu/mcheck/mce_intel.c             |  18 +-
 arch/x86/kernel/resource.c                         |   8 +-
 arch/x86/kernel/vsyscall_64.c                      |   8 +-
 arch/x86/kvm/emulate.c                             |   4 +
 arch/x86/kvm/irq.c                                 |   2 +-
 arch/x86/kvm/lapic.c                               |  52 +++-
 arch/x86/pci/i386.c                                |   4 +
 arch/x86/xen/grant-table.c                         |  10 +-
 arch/x86/xen/time.c                                |   2 +-
 drivers/char/tpm/tpm_i2c_stm_st33.c                |   1 +
 drivers/crypto/ux500/cryp/cryp_core.c              |  25 +-
 drivers/gpu/drm/omapdrm/omap_dmm_tiler.c           |   6 +-
 drivers/gpu/drm/omapdrm/omap_gem.c                 |  10 +-
 drivers/gpu/drm/omapdrm/omap_plane.c               |   4 +-
 drivers/gpu/drm/radeon/cik.c                       |   1 +
 drivers/hid/hid-cherry.c                           |   2 +-
 drivers/hid/hid-kye.c                              |   2 +-
 drivers/hid/hid-lg.c                               |   4 +-
 drivers/hid/hid-logitech-dj.c                      |  15 +-
 drivers/hid/hid-monterey.c                         |   2 +-
 drivers/hid/hid-petalynx.c                         |   2 +-
 drivers/hid/hid-sunplus.c                          |   2 +-
 drivers/hwmon/ads1015.c                            |   4 +-
 drivers/hwmon/amc6821.c                            |  17 +-
 drivers/hwmon/dme1737.c                            |  33 +--
 drivers/hwmon/gpio-fan.c                           |   2 +-
 drivers/hwmon/lm78.c                               |   2 +-
 drivers/hwmon/lm85.c                               |   9 +-
 drivers/hwmon/lm92.c                               |  13 +-
 drivers/hwmon/sis5595.c                            |   2 +-
 drivers/i2c/busses/i2c-at91.c                      |   4 +-
 drivers/i2c/busses/i2c-rk3x.c                      |   2 +-
 drivers/misc/mei/client.c                          |  18 +-
 drivers/misc/mei/nfc.c                             |  11 +-
 drivers/misc/mei/pci-me.c                          |   2 +-
 drivers/misc/mei/pci-txe.c                         |   2 +-
 drivers/mmc/host/mmci.c                            |  33 +--
 drivers/pci/hotplug/pciehp_hpc.c                   |   2 +-
 drivers/pci/pci-label.c                            |  18 +-
 drivers/pci/pci.c                                  |  12 +-
 drivers/pci/setup-res.c                            |   7 +
 drivers/scsi/hpsa.c                                |   6 +-
 drivers/staging/et131x/et131x.c                    |  68 ++---
 drivers/staging/lustre/lustre/obdclass/class_obd.c |   2 +-
 drivers/staging/rtl8188eu/os_dep/usb_intf.c        |   2 +
 drivers/tty/serial/serial_core.c                   |   3 +
 drivers/usb/core/devio.c                           |   2 +-
 drivers/usb/core/hub.c                             |  56 +++-
 drivers/usb/host/ehci-hub.c                        |   2 +-
 drivers/usb/host/ehci-pci.c                        |  25 ++
 drivers/usb/host/ohci-dbg.c                        |   9 +-
 drivers/usb/host/ohci-hcd.c                        |  10 +-
 drivers/usb/host/ohci-q.c                          |  46 ++--
 drivers/usb/host/xhci-pci.c                        |  13 +-
 drivers/usb/host/xhci-ring.c                       | 104 +++-----
 drivers/usb/host/xhci.c                            |   6 +-
 drivers/usb/host/xhci.h                            |   2 +
 drivers/usb/serial/ftdi_sio.c                      |   5 +
 drivers/usb/serial/ftdi_sio_ids.h                  |  20 +-
 drivers/usb/serial/whiteheat.c                     |   7 +-
 drivers/usb/storage/uas.c                          |   2 +-
 drivers/xen/events/events_fifo.c                   |   5 +-
 fs/btrfs/async-thread.c                            |  44 +++-
 fs/btrfs/async-thread.h                            |  28 +-
 fs/btrfs/backref.c                                 |  14 +-
 fs/btrfs/btrfs_inode.h                             |   6 -
 fs/btrfs/delayed-inode.c                           |   4 +-
 fs/btrfs/disk-io.c                                 |  85 +++----
 fs/btrfs/extent-tree.c                             |   7 +-
 fs/btrfs/extent_io.c                               |   1 +
 fs/btrfs/file-item.c                               |   2 +-
 fs/btrfs/file.c                                    |  22 +-
 fs/btrfs/inode.c                                   |  94 +++----
 fs/btrfs/ordered-data.c                            | 124 +--------
 fs/btrfs/ordered-data.h                            |   5 -
 fs/btrfs/qgroup.c                                  |   1 +
 fs/btrfs/raid56.c                                  |   9 +-
 fs/btrfs/reada.c                                   |   3 +-
 fs/btrfs/scrub.c                                   |  14 +-
 fs/btrfs/transaction.c                             |  33 +--
 fs/btrfs/transaction.h                             |   1 -
 fs/btrfs/ulist.h                                   |  15 ++
 fs/btrfs/volumes.c                                 |   3 +-
 fs/debugfs/inode.c                                 |  33 ++-
 fs/ext4/ext4.h                                     |  22 +-
 fs/ext4/extents.c                                  |  88 +++----
 fs/ext4/indirect.c                                 | 281 +++++++++++++++------
 fs/ext4/inode.c                                    |  46 ++--
 fs/ext4/mballoc.c                                  |  26 +-
 fs/ext4/namei.c                                    |  56 +++-
 fs/ext4/super.c                                    |   5 +-
 fs/isofs/inode.c                                   |  15 +-
 fs/isofs/isofs.h                                   |  23 +-
 fs/isofs/rock.c                                    |  39 ++-
 fs/jbd2/commit.c                                   |  21 +-
 fs/jbd2/journal.c                                  |  56 ++--
 fs/jbd2/recovery.c                                 |  33 ++-
 fs/jbd2/revoke.c                                   |   6 +-
 fs/nfs/client.c                                    |  95 ++++---
 fs/nfs/inode.c                                     |   3 +-
 fs/nfs/internal.h                                  |   9 +
 fs/nfs/netns.h                                     |   3 +
 fs/nfs/nfs3acl.c                                   |   7 +-
 fs/nfs/nfs4proc.c                                  |  26 +-
 fs/nfs/super.c                                     |   9 +-
 fs/nfsd/nfs4callback.c                             |   3 +-
 fs/nfsd/nfssvc.c                                   |   5 +-
 include/drm/drm_pciids.h                           |   7 +
 include/linux/jbd2.h                               |  30 ++-
 include/linux/sunrpc/svc_xprt.h                    |   1 +
 kernel/sched/core.c                                |   5 +-
 mm/memory.c                                        |   7 +-
 mm/util.c                                          |   9 +-
 net/sunrpc/svcsock.c                               |   2 +
 net/sunrpc/xprt.c                                  |   2 +-
 net/sunrpc/xprtrdma/svc_rdma_transport.c           |   1 +
 sound/pci/Kconfig                                  |   4 +-
 sound/pci/hda/patch_ca0132.c                       |   7 +-
 sound/pci/hda/patch_realtek.c                      |  28 +-
 sound/pci/hda/patch_sigmatel.c                     |  12 +
 sound/pci/oxygen/virtuoso.c                        |   1 +
 sound/pci/oxygen/xonar_pcm179x.c                   |  12 +-
 sound/usb/quirks-table.h                           |  29 +++
 sound/usb/quirks.c                                 |   2 +-
 virt/kvm/ioapic.c                                  |   7 +-
 virt/kvm/iommu.c                                   |  19 +-
 151 files changed, 1505 insertions(+), 1061 deletions(-)


