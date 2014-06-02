Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614AbaFBK1T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 06:27:19 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:64666 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963AbaFBK1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 06:27:18 -0400
Message-ID: <538C517C.5090702@cantab.net>
Date: Mon, 02 Jun 2014 11:27:08 +0100
From: David Vrabel <dvrabel@cantab.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "Xen-devel@lists.xen.org" <Xen-devel@lists.xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [GIT PULL] Xen features and fixes for 3.16-rc0
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Linus,

Please git pull the following tag:

 git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip.git stable/for-linus-3.16-rc0-tag

xen: features and fixes for 3.16-rc0

- - Support foreign mappings in PVH domains (needed when dom0 is PVH)

- - Fix mapping high MMIO regions in x86 PV guests (this is also the
  first half of removing the PAGE_IOMAP PTE flag).

- - ARM suspend/resume support.

- - ARM multicall support.

Thanks.

David

 arch/arm/include/asm/xen/hypercall.h |   16 +++-
 arch/arm/include/asm/xen/interface.h |    2 +
 arch/arm/xen/enlighten.c             |    9 ++
 arch/arm/xen/hypercall.S             |    1 +
 arch/arm64/xen/hypercall.S           |    1 +
 arch/x86/include/asm/xen/hypercall.h |    2 +-
 arch/x86/include/asm/xen/interface.h |    3 +
 arch/x86/xen/enlighten.c             |    1 +
 arch/x86/xen/mmu.c                   |  125 ++++++++++++++++++++++--
 arch/x86/xen/p2m.c                   |  174 ++++++++++++++++++++++------------
 arch/x86/xen/setup.c                 |   15 ++-
 arch/x86/xen/suspend.c               |   23 ++++-
 arch/x86/xen/xen-ops.h               |    2 +
 drivers/xen/manage.c                 |   45 ++-------
 drivers/xen/xen-acpi-processor.c     |    4 +-
 drivers/xen/xen-pciback/pci_stub.c   |   25 ++++-
 drivers/xen/xen-pciback/xenbus.c     |    4 +
 include/xen/interface/xen.h          |    6 +-
 include/xen/xen-ops.h                |    4 -
 19 files changed, 334 insertions(+), 128 deletions(-)

David Vrabel (7):
      xen: refactor suspend pre/post hooks
      x86/xen: rename early_p2m_alloc() and early_p2m_alloc_middle()
      x86/xen: fix set_phys_range_identity() if pfn_e > MAX_P2M_PFN
      x86/xen: compactly store large identity ranges in the p2m
      x86/xen: only warn once if bad MFNs are found during setup
      x86/xen: set regions above the end of RAM as 1:1
      x86/xen: do not use _PAGE_IOMAP in xen_remap_domain_mfn_range()

Ian Campbell (2):
      arm: xen: implement multicall hypercall support.
      arm: xen: export HYPERVISOR_multicall to modules.

Julien Grall (1):
      arm/xen: Remove definiition of virt_to_pfn in asm/xen/page.h

Konrad Rzeszutek Wilk (6):
      xen-pciback: Cleanup up pcistub_put_pci_dev
      xen-pciback: First reset, then free.
      xen-pciback: Document when we FLR an PCI device.
      xen/pciback: Document when the 'unbind' and 'bind' functions are called.
      xen/pciback: Document the entry points for 'pcistub_put_pci_dev'
      xen-acpi-processor: Don't display errors when we get -ENOSYS

Mukesh Rathor (1):
      x86/xen: map foreign pfns for autotranslated guests

Radim Krčmář (1):
      xen/x86: set panic notifier priority to minimum

Stefano Stabellini (2):
      arm64: introduce virt_to_pfn
      arm,arm64/xen: introduce HYPERVISOR_suspend()
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iQEcBAEBAgAGBQJTjFFzAAoJEFxbo/MsZsTRnnwIAKvKUfmdJoF+PIeAdk7fLq6n
scMNeZ6+Jii53+o2gbuC2P8deKCP7N9bFELdNWTkl76DROHu3YSd8h2iEgT3NmWI
Z9iUomutX3LQAb18PLDGk01ddUY+kDGHC+DTFgKyhQtddRwEuM6J1s3o9VHApvXH
U1HpqbuexMJZ0WRelGQB3EHoLeeW7h/LdEnCftRlNuSepXOF4QEi0psBSaDKHHRD
JqNiNRQRfJskRwfJj3IHJUa8ajFpVNGlX8ipgdRw7WOLBTpfxzCHlithQ18eSM80
6aDU5wK1QvO1CcGnugyZ4IGrTbW/x2b+gr3CIToUDeQcOIem5X1KHYX6jFsghbI=
=wcRi
-----END PGP SIGNATURE-----
