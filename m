Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253AbaJINnh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 09:43:37 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:56845 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbaJINnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 09:43:31 -0400
Message-ID: <543690F9.2090001@cantab.net>
Date: Thu, 09 Oct 2014 14:43:21 +0100
From: David Vrabel <dvrabel@cantab.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "Xen-devel@lists.xen.org" <Xen-devel@lists.xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] xen: features and fixes for 3.18-rc0
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Linus,

Please git pull the following tag:

 git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip.git stable/for-linus-3.18-rc0-tag

xen: features and fixes for 3.18-rc0

- - Add pvscsi frontend and backend drivers.
- - Remove x86 _PAGE_IOMAP PTE flag, freeing it for alternate uses.
- - Try and keep memory contiguous during PV memory setup (reduces
  SWIOTLB usage).
- - Allow front/back drivers to use threaded irqs.
- - Support large initrds in PV guests.
- - Fix PVH guests in preparation for Xen 4.5.

Thanks.

David

 MAINTAINERS                                |    9 +
 arch/arm/Kconfig                           |    2 +-
 arch/arm64/Kconfig                         |    2 +-
 arch/x86/include/asm/pgtable_types.h       |   11 +-
 arch/x86/mm/fault.c                        |   22 +-
 arch/x86/mm/init_32.c                      |    2 +-
 arch/x86/mm/init_64.c                      |    2 +-
 arch/x86/pci/i386.c                        |    2 -
 arch/x86/xen/efi.c                         |    2 +
 arch/x86/xen/enlighten.c                   |   19 +-
 arch/x86/xen/mmu.c                         |   48 +-
 arch/x86/xen/p2m.c                         |   23 +-
 arch/x86/xen/p2m.h                         |   15 +
 arch/x86/xen/setup.c                       |  370 ++++-
 arch/x86/xen/smp.c                         |   29 +-
 arch/x86/xen/smp.h                         |    8 +
 arch/x86/xen/xen-head.S                    |   36 +
 drivers/block/xen-blkback/xenbus.c         |   11 +-
 drivers/block/xen-blkfront.c               |    5 +-
 drivers/char/tpm/xen-tpmfront.c            |   13 +-
 drivers/input/misc/xen-kbdfront.c          |    5 +-
 drivers/net/xen-netback/xenbus.c           |   10 +-
 drivers/net/xen-netfront.c                 |   16 +-
 drivers/pci/xen-pcifront.c                 |    6 +-
 drivers/scsi/Kconfig                       |   10 +
 drivers/scsi/Makefile                      |    1 +
 drivers/scsi/xen-scsifront.c               | 1026 ++++++++++++++
 drivers/tty/hvc/hvc_xen.c                  |    9 +-
 drivers/video/fbdev/xen-fbfront.c          |    5 +-
 drivers/xen/Kconfig                        |    9 +
 drivers/xen/Makefile                       |    1 +
 drivers/xen/efi.c                          |    2 +
 drivers/xen/events/events_base.c           |    5 +-
 drivers/xen/grant-table.c                  |    2 +-
 drivers/xen/xen-pciback/xenbus.c           |    6 +-
 drivers/xen/xen-scsiback.c                 | 2126 ++++++++++++++++++++++++++++
 drivers/xen/xenbus/xenbus_client.c         |    9 +-
 drivers/xen/xenbus/xenbus_probe.c          |    6 +-
 drivers/xen/xenbus/xenbus_probe.h          |    4 +-
 drivers/xen/xenbus/xenbus_probe_backend.c  |    8 +-
 drivers/xen/xenbus/xenbus_probe_frontend.c |    8 +-
 include/xen/events.h                       |    2 +
 include/xen/interface/elfnote.h            |   48 +-
 include/xen/interface/io/vscsiif.h         |  229 +++
 include/xen/interface/xen.h                |  272 +++-
 include/xen/xenbus.h                       |   21 +-
 46 files changed, 4214 insertions(+), 263 deletions(-)

Chen Gang (3):
      xen/grant-table: refactor error cleanup in grow_gnttab_list()
      xen/xenbus: Correct the comments for xenbus_grant_ring()
      xen/xenbus: Remove BUG_ON() when error string trucated

Dan Carpenter (2):
      xen-scsifront: use GFP_ATOMIC under spin_lock
      xen-scsiback: clean up a type issue in scsiback_make_tpg()

Daniel Kiper (1):
      xen/efi: Directly include needed headers

David Vrabel (5):
      x86: skip check for spurious faults for non-present faults
      x86/xen: do not use _PAGE_IOMAP PTE flag for I/O mappings
      x86: remove the Xen-specific _PAGE_IOMAP PTE flag
      xen-scsifront: don't deadlock if the ring becomes full
      xen: remove DEFINE_XENBUS_DRIVER() macro

Juergen Gross (8):
      xen/events: support threaded irqs for interdomain event channels
      xen: Add Xen pvSCSI protocol description
      xen-scsifront: Add Xen PV SCSI frontend driver
      xen-scsiback: Add Xen PV SCSI backend driver
      MAINTAINERS: Add xen pvscsi maintainer
      xen: make pvscsi frontend dependant on xenbus frontend
      xen: sync some headers with xen tree
      xen: eliminate scalability issues from initrd handling

Julien Grall (1):
      arm{,64}/xen: Remove "EXPERIMENTAL" in the description of the Xen options

Matt Rushton (1):
      xen/setup: Remap Xen Identity Mapped RAM

Mukesh Rathor (1):
      x86/xen: Set EFER.NX and EFER.SCE in PVH guests
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iQEcBAEBAgAGBQJUNpDxAAoJEFxbo/MsZsTRiVkH/1yCUaLyWeh8+ABF3gQixaAe
KN5eAKmJtyS1CQy8Gg55xn6wJVKlw30r1tlV2yxEYUBtt1oreoROG+Wl0nuLt+96
MgiKj84wwaSSWmB5o2WaheWY4c4gyNL4AqfuQ3eeJGcheXowwtSXYDj/Y2Ln6q8H
Sia4hGaRGG3lP24OmfLC0qRkwRUq6t5Hz5n5Lg8WpZMi4lZsUngu7n+78XkwnyRL
4xfUXqae07YMxyhO6vmM2GtDQ4COqonLFnqK5KTdbzecfyLG7nE+WJH+VUvYdTas
8mx562QJaxvqyNczVfISm9wzk9jQcCKznDZZ0BjsXrSpMZDgIsww0LjCg3aSoNE=
=3yLn
-----END PGP SIGNATURE-----
