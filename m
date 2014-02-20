Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950AbaBTXuS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 18:50:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45244 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037AbaBTXuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:50:15 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [PATCH 3.4 00/25] 3.4.82-stable review
Date: Thu, 20 Feb 2014 15:51:16 -0800
Message-Id: <20140220234842.483343851@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.82 release.
There are 25 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat Feb 22 23:48:32 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.82-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.82-rc1

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

Dan Carpenter <dan.carpenter@oracle.com>
    KVM: return an error code in kvm_vm_ioctl_register_coalesced_mmio()

Mike Marciniszyn <mike.marciniszyn@intel.com>
    IB/qib: Add missing serdes init sequence

Jens Axboe <axboe@fb.com>
    block: add cond_resched() to potentially long running ioctl discard loop

Jan Moskyto Matejka <mq@suse.cz>
    Modpost: fixed USB alias generation for ranges including 0x9 and 0xA

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

Hartmut Knaack <knaack.h@gmx.de>
    staging:iio:ad799x fix error_free_irq which was freeing an irq that may not have been requested

Lars Poeschel <poeschel@lemonage.de>
    tty: n_gsm: Fix for modems with brk in modem status control

NeilBrown <neilb@suse.de>
    lockd: send correct lock when granting a delayed lock.

Paul Bolle <pebolle@tiscali.nl>
    raw: test against runtime value of max_raw_minors

Geert Uytterhoeven <geert+renesas@linux-m68k.org>
    spi: Fix crash with double message finalisation on error handling

Martin Schwidefsky <schwidefsky@de.ibm.com>
    s390: fix kernel crash due to linkage stack instructions

Michael Holzheu <holzheu@linux.vnet.ibm.com>
    s390/dump: Fix dump memory detection

Johannes Berg <johannes.berg@intel.com>
    mac80211: fix fragmentation code, particularly for encryption

Eric W. Biederman <ebiederm@xmission.com>
    fs/file.c:fdtable: avoid triggering OOMs from alloc_fdmem

David Vrabel <david.vrabel@citrix.com>
    xen-blkfront: handle backend CLOSED without CLOSING


-------------

Diffstat:

 Makefile                                |  4 +-
 arch/s390/kernel/head64.S               |  7 ++-
 arch/s390/mm/page-states.c              | 10 ++++
 block/blk-lib.c                         |  8 +++
 drivers/block/xen-blkfront.c            |  5 +-
 drivers/char/raw.c                      |  2 +-
 drivers/infiniband/hw/qib/qib_iba7322.c |  5 ++
 drivers/md/raid5.c                      | 90 ++++++++++++++++-----------------
 drivers/power/max17040_battery.c        |  5 +-
 drivers/spi/spi.c                       |  4 +-
 drivers/staging/iio/adc/ad799x_core.c   |  3 +-
 drivers/tty/n_gsm.c                     | 11 ++++
 drivers/usb/serial/ftdi_sio.c           |  3 ++
 drivers/usb/serial/ftdi_sio_ids.h       |  7 +++
 drivers/usb/serial/option.c             |  3 +-
 drivers/usb/storage/Kconfig             |  4 +-
 drivers/usb/storage/scsiglue.c          |  6 +++
 drivers/usb/storage/unusual_cypress.h   |  2 +-
 drivers/usb/storage/unusual_devs.h      |  7 +++
 fs/file.c                               |  2 +-
 fs/lockd/svclock.c                      |  8 +++
 kernel/irq/irqdesc.c                    |  1 +
 kernel/time/jiffies.c                   |  6 +++
 kernel/trace/ring_buffer.c              |  7 +++
 net/mac80211/tx.c                       |  2 +-
 scripts/mod/file2alias.c                |  4 +-
 virt/kvm/coalesced_mmio.c               |  8 +--
 27 files changed, 153 insertions(+), 71 deletions(-)


