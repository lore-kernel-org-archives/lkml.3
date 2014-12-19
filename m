Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172AbaLSJQu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 04:16:50 -0500
Received: from ozlabs.org ([103.22.144.67]:59718 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553AbaLSJQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 04:16:46 -0500
Message-ID: <1418980604.30631.1.camel@ellerman.id.au>
Subject: [git pull] Please pull mpe/linux.git powerpc-3.19-2 tag
From: Michael Ellerman <mpe@ellerman.id.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: anton@samba.org, benh@kernel.crashing.org, gkurz@linux.vnet.ibm.com,
        imunsie@au1.ibm.com, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, mst@redhat.com,
        neelegup@linux.vnet.ibm.com, paul@paul-moore.com, paulus@samba.org,
        rgb@redhat.com, shreyas@linux.vnet.ibm.com, sukadev@linux.vnet.ibm.com,
        wsa@the-dreams.de
Date: Fri, 19 Dec 2014 20:16:44 +1100
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-/sqi0TfDFCdNGi9tnwki"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-/sqi0TfDFCdNGi9tnwki
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull the second batch of powerpc updates for 3.19:

The following changes since commit 56548fc0e86cb9156af7a7e1f15ba78f251dafaf=
:

  powerpc/powernv: Return to cpu offline loop when finished in KVM guest (2=
014-12-08 13:16:31 +1100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mpe/linux.git tags/powerpc-=
3.19-2

for you to fetch changes up to d70a54e2d08510a99b1f10eceeae6f2f7086e226:

  powerpc/powernv: Ignore smt-enabled on Power8 and later (2014-12-18 19:59=
:21 +1100)

----------------------------------------------------------------
powerpc updates for 3.19 batch 2

The highlight is the series that reworks the idle management on powernv, wh=
ich
allows us to use deeper idle states on those machines.

There's the fix from Anton for the "BUG at kernel/smpboot.c:134!" problem.

An i2c driver for powernv. This is acked by Wolfram Sang, and he asked that=
 we
take it through the powerpc tree.

A fix for audit from rgb at Red Hat, acked by Paul Moore who is one of the =
audit
maintainers.

A patch from Ben to export the symbol map of our OPAL firmware as a sysfs f=
ile,
so that tools can use it.

Also some CXL fixes, a couple of powerpc perf fixes, a fix for smt-enabled,=
 and
the patch to add __force to get_user() so we can use bitwise types.
----------------------------------------------------------------

Anton Blanchard (1):
      powerpc: Secondary CPUs must set cpu_callin_map after setting active =
and online

Benjamin Herrenschmidt (1):
      powerpc/powernv: Expose OPAL firmware symbol map

Greg Kurz (1):
      powerpc/powernv: Ignore smt-enabled on Power8 and later

Ian Munsie (3):
      cxl: Change contexts_lock to a mutex to fix sleep while atomic bug
      cxl: Add timeout to process element commands
      cxl: Unmap MMIO regions when detaching a context

Michael S. Tsirkin (1):
      powerpc/uaccess: Allow get_user() with bitwise types

Neelesh Gupta (1):
      i2c: Driver to expose PowerNV platform i2c busses

Paul Mackerras (1):
      powerpc/powernv: Switch off MMU before entering nap/sleep/rvwinkle mo=
de

Richard Guy Briggs (1):
      powerpc: add little endian flag to syscall_get_arch()

Shreyas B. Prabhu (3):
      powerpc/powernv: Enable Offline CPUs to enter deep idle states
      powernv/cpuidle: Redesign idle states management
      powernv/powerpc: Add winkle support for offline cpus

Sukadev Bhattiprolu (1):
      power/perf/hv-24x7: Use kmem_cache_free() instead of kfree

sukadev@linux.vnet.ibm.com (1):
      powerpc/perf/hv-24x7: Use per-cpu page buffer

 Documentation/devicetree/bindings/i2c/i2c-opal.txt |  37 +++
 arch/powerpc/include/asm/cpuidle.h                 |  20 ++
 arch/powerpc/include/asm/opal.h                    |  42 +++
 arch/powerpc/include/asm/paca.h                    |  10 +
 arch/powerpc/include/asm/ppc-opcode.h              |   2 +
 arch/powerpc/include/asm/processor.h               |   3 +-
 arch/powerpc/include/asm/reg.h                     |   4 +
 arch/powerpc/include/asm/syscall.h                 |   6 +-
 arch/powerpc/include/asm/uaccess.h                 |   6 +-
 arch/powerpc/kernel/asm-offsets.c                  |  11 +
 arch/powerpc/kernel/exceptions-64s.S               |  35 ++-
 arch/powerpc/kernel/idle_power7.S                  | 344 +++++++++++++++++=
+---
 arch/powerpc/kernel/smp.c                          |   9 +-
 arch/powerpc/perf/hv-24x7.c                        |  23 +-
 arch/powerpc/platforms/powernv/opal-wrappers.S     |  39 +++
 arch/powerpc/platforms/powernv/opal.c              |  50 ++-
 arch/powerpc/platforms/powernv/powernv.h           |   2 +
 arch/powerpc/platforms/powernv/setup.c             | 166 ++++++++++
 arch/powerpc/platforms/powernv/smp.c               |  29 +-
 arch/powerpc/platforms/powernv/subcore.c           |  34 ++
 arch/powerpc/platforms/powernv/subcore.h           |   9 +-
 drivers/cpuidle/cpuidle-powernv.c                  |  10 +-
 drivers/i2c/busses/Kconfig                         |  11 +
 drivers/i2c/busses/Makefile                        |   1 +
 drivers/i2c/busses/i2c-opal.c                      | 294 +++++++++++++++++=
+
 drivers/misc/cxl/context.c                         |  26 +-
 drivers/misc/cxl/cxl.h                             |   9 +-
 drivers/misc/cxl/file.c                            |   6 +-
 drivers/misc/cxl/native.c                          |  12 +-
 drivers/misc/cxl/pci.c                             |   2 +-
 drivers/misc/cxl/sysfs.c                           |  10 +-
 include/uapi/linux/audit.h                         |   2 +
 32 files changed, 1156 insertions(+), 108 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/i2c/i2c-opal.txt
 create mode 100644 arch/powerpc/include/asm/cpuidle.h
 create mode 100644 drivers/i2c/busses/i2c-opal.c


--=-/sqi0TfDFCdNGi9tnwki
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJUk+z8AAoJEFHr6jzI4aWAAPEQAJmFf013Konzwul1a6XCmlcy
TaSd5UfXa2FVrmjuTykSyyCEOhmYPdqPNg6Rl40t3iXHvOhV3nvMDCqwa3sxPFtp
v4c8RclQR4Gvj1vNbDzivp1WleWlOvleE06DdCqx1xTgAm8zoOl3h4xMKQ8fERXR
0ZmYw834AsyfkxpHnUi41XFvCaHDw5fVctfVD5IZ+1kGB8PungFvpEx51OZAY5td
u6UWcEowi4etnsbFHTzyWhOd2jAbh1rftUbpqrDJWACb0KlAXNmh8JBGVLj06JSN
Ztxg3MOm3H21U3++LmxC5OwFMVIZoOf7Rb+HY7+3atz6q0HXayL3ug8DUjJHwKp+
XLIvN8qi1g03nzopp0so9T0eRK1TXaw7uNH+5QAalLsaU1PnUZb8pgz/qPNXKRp+
xfXIZnnsbSIWewR/jPeu1xz299e36l5LfEkrrF4BFXncg+52gmbhSiqcILBZUYJV
4sL+ph3u+ATsAupV2v6Rp9XSSchJt/MuiqukWpy461o0OaG2ank9t+Pqqd30X2QH
7IjcKlTK4gDAROEcl8M18lD/QwQVJ+OxEz0U1i8zNo7h5hJzuMegw3lWyhc/B1zS
yV0NbiuhOBmGmUX7jSqGKW6dIKJXf7j5XX7kXOoHu4zc5dYziCdaSPOENPWBma/a
lUKmPhXzxQn4scRN5mhZ
=sPzf
-----END PGP SIGNATURE-----

--=-/sqi0TfDFCdNGi9tnwki--

