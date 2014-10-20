Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409AbaJTJQQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 05:16:16 -0400
Received: from ozlabs.org ([103.22.144.67]:51700 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753115AbaJTJQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 05:16:15 -0400
Message-ID: <1413796558.8828.5.camel@concordia>
Subject: [git pull] Please pull mpe.git for-linus branch (for powerpc)
From: Michael Ellerman <mpe@ellerman.id.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 20 Oct 2014 20:15:58 +1100
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-7w44MxwH2gTD2diWRpzA"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-7w44MxwH2gTD2diWRpzA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Here's some more updates for powerpc for 3.18.

They are a bit late I know, though must are actually bug fixes. In my defen=
ce I
nearly cut the top of my finger off last weekend in a gruesome bike mainten=
ance
accident, so I spent a good part of the week waiting around for doctors. Tr=
ue
story, I can send photos if you like :)


Probably the most interesting fix is the sys_call_table one, which enables
syscall tracing for powerpc. There's a fix for HMI handling for old firmwar=
e,
more endian fixes for firmware interfaces, more EEH fixes, Anton fixed our
routine that gets the current stack pointer, and a few other misc bits.


The following changes since commit d53ba6b3bba33432cc37b7101a86f8f3392c46e7=
:

  cxl: Fix afu_read() not doing finish_wait() on signal or non-blocking (20=
14-10-09 11:29:57 +1100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mpe/linux.git for-linus

for you to fetch changes up to e89dafb5ca5022d3bc63602018adfc766c73bc2b:

  powerpc: Only do dynamic DMA zone limits on platforms that need it (2014-=
10-17 09:21:44 +1100)

----------------------------------------------------------------
Anton Blanchard (5):
      powerpc: Reimplement __get_SP() as a function not a define
      powerpc: Rename __get_SP() to current_stack_pointer()
      powerpc/pseries: Use dump_stack instead of show_stack
      powerpc: Add printk levels to setup_system output
      powerpc: sync pseries_le_defconfig with pseries_defconfig

Bharata B Rao (1):
      powerpc/pseries: Make CPU hotplug path endian safe

Gavin Shan (7):
      powerpc/eeh: Fix condition for isolated state
      powerpc/eeh: Rename flag EEH_PE_RESET to EEH_PE_CFG_BLOCKED
      powerpc/powernv: Drop config requests in EEH accessors
      powerpc/pseries: Drop config requests in EEH accessors
      powerpc/eeh: Block PCI config access upon frozen PE
      powerpc/eeh: Don't collect logs on PE with blocked config space
      powerpc/eeh: Block CFG upon frozen Shiner adapter

Greg Kurz (1):
      powerpc/vphn: NUMA node code expects big-endian

Mahesh Salgaonkar (2):
      powerpc/book3s: Don't clear MSR_RI in hmi handler.
      powerpc/powernv: Fallback to old HMI handling behavior for old firmwa=
re

Michael Ellerman (3):
      powerpc/msi: Fix the msi bitmap alignment tests
      powerpc/msi: Use WARN_ON() in msi bitmap selftests
      powerpc: Only do dynamic DMA zone limits on platforms that need it

Nishanth Aravamudan (2):
      powerpc/numa: check error return from proc_create
      powerpc/numa: Add ability to disable and debug topology updates

Romeo Cane (1):
      powerpc: Fix sys_call_table declaration to enable syscall tracing

 Documentation/kernel-parameters.txt          |  6 +++
 arch/powerpc/configs/pseries_le_defconfig    |  7 ++-
 arch/powerpc/include/asm/eeh.h               |  3 +-
 arch/powerpc/include/asm/perf_event.h        |  2 +-
 arch/powerpc/include/asm/reg.h               |  3 +-
 arch/powerpc/include/asm/syscall.h           |  2 +-
 arch/powerpc/kernel/dma.c                    |  8 ++++
 arch/powerpc/kernel/eeh.c                    | 19 +++++---
 arch/powerpc/kernel/eeh_driver.c             | 12 ++---
 arch/powerpc/kernel/eeh_pe.c                 | 10 ++++-
 arch/powerpc/kernel/exceptions-64s.S         |  5 ---
 arch/powerpc/kernel/irq.c                    |  2 +-
 arch/powerpc/kernel/misc.S                   |  4 ++
 arch/powerpc/kernel/ppc_ksyms.c              |  2 +
 arch/powerpc/kernel/process.c                |  2 +-
 arch/powerpc/kernel/rtas_pci.c               | 30 +++++--------
 arch/powerpc/kernel/setup_64.c               | 32 +++++++-------
 arch/powerpc/kernel/stacktrace.c             |  2 +-
 arch/powerpc/mm/numa.c                       | 41 ++++++++++++++++-
 arch/powerpc/platforms/powernv/eeh-ioda.c    |  2 +-
 arch/powerpc/platforms/powernv/eeh-powernv.c | 57 +++++++++++++++++++++++-
 arch/powerpc/platforms/powernv/opal.c        | 21 +++++++++
 arch/powerpc/platforms/powernv/pci.c         |  2 +-
 arch/powerpc/platforms/pseries/dlpar.c       | 22 +++++-----
 arch/powerpc/platforms/pseries/hotplug-cpu.c |  4 +-
 arch/powerpc/platforms/pseries/iommu.c       | 11 +++--
 arch/powerpc/platforms/pseries/pseries.h     |  3 +-
 arch/powerpc/sysdev/msi_bitmap.c             | 66 +++++++++++++++---------=
----
 28 files changed, 261 insertions(+), 119 deletions(-)



--=-7w44MxwH2gTD2diWRpzA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAABAgAGBQJURNLcAAoJEFHr6jzI4aWAtjEQAJ4XhYOEIfARMJ32P8XQ2dbX
4ISt/N1H7C71Xter4uaeQ5hTjaDZnuQNt8QIXkemCOIHPm8/XhVwvEWJ+Oiq0bYl
8fGXNEJpZ8naRGcO+jqHDZ1762hcYl6ut+lyV8yYjkjzzLiKdB/rDAwqfOKkKoUo
Nd/BoVUSTcQVB7clY32Xe+km9+5LIIlu4UdVetf6u9/IQQJm45Jcy41hqFhaENa4
PkmV+j32yQaKO4XAhnWeypJldFJrjbbW1GD7KZ+c2xk3vzGtCgs6o1Sy8/87HwUH
LiYHB9r7xvOVJ9pG21OKl5OUYhahgL0J71YYu0fjL255JRmPlcoTOKZu7vN/gawi
bQ316xv4F232tB8P+/Yyi7YDJNhfYg3+zLdO4RVPlh3/usNWg6W2hLuZDNlSS0Xs
GbAc7rsAbdRL5ydYytpHg2cH7o1kr8PNe7W1O+xCahuYp4ida9PrOcWDhfv/C3Q5
Uwo6VWESpsZqPtjv2mLcZP+UBi+4DZtL2SpZNXXrbzfIfwL13FpPvpvJcx8fy2QT
AZmcMklWKwostXy3esBF4IgACos/jkA+5kh2qIcEIb7F93APj2F5o1wO28UrLQZJ
UZqT2PPc370WQZBHhjsP6bshEGDa68M4xCuHJmuXDqlRJXVMnuLLz+EXlGzQO3oC
CsgHN2LtE2KI6VIKbaED
=1lzm
-----END PGP SIGNATURE-----

--=-7w44MxwH2gTD2diWRpzA--

