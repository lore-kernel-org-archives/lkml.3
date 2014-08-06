Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589AbaHFLTL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 07:19:11 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754828AbaHFLTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 07:19:09 -0400
Message-ID: <53E20F1E.2080606@nod.at>
Date: Wed, 06 Aug 2014 13:18:54 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>
Subject: [GIT PULL] Global signal cleanup
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="Iaa75aQddUb0aoDAUhxhj5tbpKfp16Jax"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Iaa75aQddUb0aoDAUhxhj5tbpKfp16Jax
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Linus,

the following changes since commit 19583ca584d6f574384e17fe7613dfaeadcdc4=
a6:

  Linux 3.16 (2014-08-03 15:25:02 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rw/misc.git signal-cleanu=
p

for you to fetch changes up to 059ade650ae57cfd371af690fdba887af04aded8:

  powerpc: Use sigsp() (2014-08-06 13:04:32 +0200)

----------------------------------------------------------------
This patch series moves all remaining archs to the get_signal(), signal_s=
etup_done()
and sigsp() functions. Currently these archs use open coded
variants of the said functions. Further, unused parameters get removed
from get_signal_to_deliver(), tracehook_signal_handler() and signal_deliv=
ered().
At the end of the day we save around 500 lines of code.
----------------------------------------------------------------
Richard Weinberger (43):
      arc: Use get_signal() signal_setup_done()
      arm64: Use get_signal() signal_setup_done()
      avr32: Use get_signal() signal_setup_done()
      blackfin: Use get_signal() signal_setup_done()
      c6x: Use get_signal() signal_setup_done()
      cris: Use get_signal() signal_setup_done()
      frv: Use get_signal() signal_setup_done()
      hexagon: Use get_signal() signal_setup_done()
      ia64: Use get_signal() signal_setup_done()
      m32r: Use get_signal() signal_setup_done()
      m68k: Use get_signal() signal_setup_done()
      microblaze: Use get_signal() signal_setup_done()
      mips: Use get_signal() signal_setup_done()
      mn10300: Use get_signal() signal_setup_done()
      parisc: Use get_signal() signal_setup_done()
      powerpc: Use get_signal() signal_setup_done()
      s390: Use get_signal() signal_setup_done()
      score: Use get_signal() signal_setup_done()
      sh: Use get_signal() signal_setup_done()
      tile: Use get_signal() signal_setup_done()
      um: Use get_signal() signal_setup_done()
      unicore32: Use get_signal() signal_setup_done()
      xtensa: Use get_signal() signal_setup_done()
      tracehook_signal_handler: Remove sig, info, ka and regs
      Clean up signal_delivered()
      Rip out get_signal_to_deliver()
      sas_ss_flags: Remove nested ternary if
      arc: Use sigsp()
      arm64: Use sigsp()
      avr32: Use sigsp()
      blackfin: Use sigsp()
      c6x: Use sigsp()
      cris: Use sigsp()
      frv: Use sigsp()
      hexagon: Use sigsp()
      m32r: Use sigsp()
      m68k: Use sigsp()
      metag: Use sigsp()
      microblaze: Use sigsp()
      mips: Use sigsp()
      mn10300: Use sigsp()
      openrisc: Use sigsp()
      powerpc: Use sigsp()

 arch/arc/kernel/signal.c            |  47 ++++++---------
 arch/arm64/include/asm/signal32.h   |  11 ++--
 arch/arm64/kernel/signal.c          |  58 +++++++------------
 arch/arm64/kernel/signal32.c        |  24 +++-----
 arch/avr32/kernel/signal.c          |  50 +++++++---------
 arch/blackfin/kernel/signal.c       |  51 ++++++----------
 arch/c6x/kernel/signal.c            |  53 +++++++----------
 arch/cris/arch-v10/kernel/signal.c  |  89 +++++++++++-----------------
 arch/cris/arch-v32/kernel/signal.c  |  89 +++++++++++-----------------
 arch/frv/kernel/signal.c            | 112 ++++++++++++++----------------=
------
 arch/hexagon/kernel/signal.c        |  57 +++++++-----------
 arch/ia64/kernel/signal.c           |  46 +++++++--------
 arch/m32r/kernel/signal.c           |  57 +++++++-----------
 arch/m68k/kernel/signal.c           |  75 +++++++++---------------
 arch/metag/kernel/signal.c          |  10 +---
 arch/microblaze/kernel/signal.c     |  55 ++++++------------
 arch/mips/include/asm/abi.h         |  10 ++--
 arch/mips/kernel/signal-common.h    |   2 +-
 arch/mips/kernel/signal.c           |  72 +++++++++--------------
 arch/mips/kernel/signal32.c         |  39 +++++--------
 arch/mips/kernel/signal_n32.c       |  20 +++----
 arch/mn10300/kernel/signal.c        | 102 ++++++++++++------------------=
--
 arch/openrisc/kernel/signal.c       |  20 +------
 arch/parisc/kernel/signal.c         |  58 ++++++++-----------
 arch/powerpc/kernel/signal.c        |  41 +++++--------
 arch/powerpc/kernel/signal.h        |  14 ++---
 arch/powerpc/kernel/signal_32.c     |  36 ++++++------
 arch/powerpc/kernel/signal_64.c     |  28 +++++----
 arch/s390/kernel/compat_signal.c    |  79 +++++++++++--------------
 arch/s390/kernel/entry.h            |   4 +-
 arch/s390/kernel/signal.c           |  78 +++++++++++--------------
 arch/score/kernel/signal.c          |  43 ++++++--------
 arch/sh/kernel/signal_32.c          |  79 +++++++++++--------------
 arch/sh/kernel/signal_64.c          |  82 +++++++++++---------------
 arch/tile/include/asm/compat.h      |   3 +-
 arch/tile/kernel/compat_signal.c    |  29 +++++-----
 arch/tile/kernel/signal.c           |  54 ++++++++---------
 arch/um/include/shared/frame_kern.h |  12 ++--
 arch/um/kernel/signal.c             |  27 ++++-----
 arch/unicore32/kernel/signal.c      |  48 +++++++---------
 arch/x86/um/signal.c                |  45 +++++++--------
 arch/xtensa/kernel/signal.c         |  43 ++++++--------
 include/linux/sched.h               |   6 +-
 include/linux/signal.h              |  15 +----
 include/linux/tracehook.h           |   8 +--
 kernel/signal.c                     |  46 +++++++--------
 46 files changed, 789 insertions(+), 1238 deletions(-)

Thanks,
//richard


--Iaa75aQddUb0aoDAUhxhj5tbpKfp16Jax
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJT4g8oAAoJEPmeIjfg4Uaaz0YP/j/1poiy8CKKlTq54NqVXa3p
3CwjOJo4qUY6gTUpSHlIsDKd/RjjiQ6Ud6tV8Gp0Z4zrhyfBhdMFOoFh2skOdfQO
K0YxyB88wLzu4S4y5uEaeq4hOjba0pMqcmdAlJpo3eg9+Up0vHxamyOZBebKu0KI
Q+xusIblvZ4yNSUBfVH67gplDtuTnV1IrsZ55lhdKQO5hvUBBbYskAFhIbfpcH34
pjIC8GpHyl6ORjbPiUsBA7mmLxKfrE242iFIAI2PQ18ebhtN8ETmpEsMopgay1xA
t7kNI1hlRZ/L+CWfISrGYqPgIQih4uKwPi3GACTtGi2K9adKsVdgpEsA/oYB4kBw
E/4VyYrmTwfNEkchh8CY1TWzmYuaPw1hW7eMyknrVo6AYiJMBN5ab26xZhC6xg1q
NnVTu6imPPKL5mXFRMyoRmuq2eMZtH0lvpmOACU7spytqVMeGd+/Hqh5FQ8tP8F6
ozUwayzeQgOoxE7bsjBLEEFYovzKCG/PJ6sz0AMHfQWVT9bABq1gy28baF5b0JLM
0ku5tDrrzsFJcw//Hlcvr4zSnMGe9Q7UIp78NgBGl2J6/gM9qmx/vzLG6T9HRYW1
IoURx/9IAgYNDKWnUKLnNfwz3HPM0ZvRcMm+N51YeMLINuwPGD4rgz8nRB8/t9wI
POTG7EDrhRf9HJsBzOoj
=1rOw
-----END PGP SIGNATURE-----

--Iaa75aQddUb0aoDAUhxhj5tbpKfp16Jax--
