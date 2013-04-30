Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760699Ab3D3Nrx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 09:47:53 -0400
Received: from multi.imgtec.com ([194.200.65.239]:51127 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760460Ab3D3Nrv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 09:47:51 -0400
Message-ID: <517FCB2C.8090409@imgtec.com>
Date: Tue, 30 Apr 2013 14:46:20 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Paul Clothier <paul.clothier@imgtec.com>,
        Paul Bolle <pebolle@tiscali.nl>
Subject: [GIT PULL] arch/metag changes for v3.10
X-Enigmail-Version: 1.4.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enigB85A89989A0C0C8062C1CD74"
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_04_30_14_47_49
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------enigB85A89989A0C0C8062C1CD74
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull the following arch/metag changes (see tag message below for o=
verview).

Thanks
James

The following changes since commit f6161aa153581da4a3867a2d1a7caf4be19b6e=
c9:

  Linux 3.9-rc2 (2013-03-10 16:54:19 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jhogan/metag.git tags/met=
ag-for-v3.10-rc1

for you to fetch changes up to 164c013858a2e89b450cd8021a8be896f9e05697:

  metag: defconfigs: increase log buffer 8KiB =3D> 128KiB (2013-04-25 13:=
09:27 +0100)

----------------------------------------------------------------
Misc arch/metag changes for v3.10-rc1

 - Various fixes for the interrupting perf counter handling in metag's
   perf backend.
 - Add OProfile support based on perf.
 - Sets up cache partitions for SMP so bootloader doesn't have to.
 - Patch from Paul Bolle to remove ARCH_POPULATES_NODE_MAP again
   (touches microblaze too).
 - Add TLS pointer regset to metag ptrace api.
 - Add exported metag DSP extended context handling header <asm/ech.h>.
 - Increase defconfig log buffer size to 128KiB.
 - Various fixes, typos, missing exports.

----------------------------------------------------------------
James Hogan (16):
      metag: perf: fix core internal / perf channel mux
      metag: perf: fix wrap handling in delta calculation
      metag: perf: fixes for interrupting perf counters
      metag: perf: add missing prev_count updates
      metag: perf: fix frequency sampling (dynamic period)
      metag: perf: use hard_processor_id() to get thread
      metag: perf: don't reset TXTACTCYC
      metag: perf: prepare for use by oprofile
      metag: OProfile support
      metag: smp: copy cache partition and enable GCOn
      metag: cachepart: take into account small cache bits
      metag: cachepart: fix get_global_dcache_size() typo
      metag: export _metag_da_present and cpu_2_hwthread_id
      metag: add exported <asm/ech.h> for extended context handling
      metag: avoid unnecessary builtin dtb rebuilds
      metag: defconfigs: increase log buffer 8KiB =3D> 128KiB

Paul Bolle (1):
      memblock: Kill ARCH_POPULATES_NODE_MAP once more

Paul Clothier (1):
      metag: ptrace: Implement NT_METAG_TLS

 arch/metag/Kconfig                     |   4 ++
 arch/metag/Makefile                    |   2 +
 arch/metag/boot/dts/Makefile           |  10 ++-
 arch/metag/configs/meta1_defconfig     |   1 -
 arch/metag/configs/meta2_defconfig     |   1 -
 arch/metag/configs/meta2_smp_defconfig |   1 -
 arch/metag/include/asm/metag_mem.h     |   3 +
 arch/metag/include/uapi/asm/Kbuild     |   1 +
 arch/metag/include/uapi/asm/ech.h      |  15 +++++
 arch/metag/kernel/cachepart.c          |  16 +++--
 arch/metag/kernel/da.c                 |   2 +
 arch/metag/kernel/head.S               |   8 +++
 arch/metag/kernel/perf/perf_event.c    |  74 ++++++++++++++-------
 arch/metag/kernel/ptrace.c             |  34 ++++++++++
 arch/metag/kernel/setup.c              |   1 +
 arch/metag/kernel/smp.c                | 115 +++++++++++++++++++++++++++=
++++++
 arch/metag/mm/Kconfig                  |   3 -
 arch/metag/oprofile/Makefile           |  17 +++++
 arch/metag/oprofile/backtrace.c        |  63 ++++++++++++++++++
 arch/metag/oprofile/backtrace.h        |   6 ++
 arch/metag/oprofile/common.c           |  66 +++++++++++++++++++
 arch/microblaze/Kconfig                |   3 -
 include/uapi/linux/elf.h               |   1 +
 23 files changed, 407 insertions(+), 40 deletions(-)
 create mode 100644 arch/metag/include/uapi/asm/ech.h
 create mode 100644 arch/metag/oprofile/Makefile
 create mode 100644 arch/metag/oprofile/backtrace.c
 create mode 100644 arch/metag/oprofile/backtrace.h
 create mode 100644 arch/metag/oprofile/common.c


--------------enigB85A89989A0C0C8062C1CD74
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJRf8s3AAoJEKHZs+irPybfj2EP/RSPrvTMtzSDsZv5IK5eCYSf
OJTdQWr1kBh99Hm74w/Pz9WFYKNw70+J1e4+JgNZY6SfUQsTuUyuve01tSvO+ngw
6GVeLusQL36sf6ca0VoFVa0g/EOlGRT84Zjzze+iJsQnFnCB8QDHiF79LB414Mnw
sltrWugcG+1AqC0BYxT/vFol8HJsnEi+0cOtRBYG/srTxE3tWrN0SBdFG8c8p18f
gAxjtSECSwy7dlqSmlnSrOo5YM3iab4Lg9opQJ3wHB8Cg1UoJFCyKaNSNKOLtwXU
Tjlxi39gXP1h1nWcJ47ztV0l3amCBep79NrkadsqogCdNdF/T4nzYuM+TVpSfLd1
WztSth7rTrMAMlTi2Pni+hY06zQJuhd1EzgH+oNvhG5EFfbuTEcMZA3NdF8Iupaj
l5uwA1E04LAjLuwlZx6dhnUdDexQCrWkbZ0LoqZa+Uvj2Uar4+9uvRAl/FMPVu/s
tnDgH8k/e9ZtA8YEwQ7ixhFYEf3GwKoelvxFZ36au02ZHXD9kZX0hhC2sLpFlsB0
AYAGAQvV0EEdBliSpE77twxGZIQj3in1Lc+M1NsO3gMuFB/O5iJ4FSJZmS2o7yq+
CMTYEqPThfUVcSNIi5tMOJOk/wOKDDsF+8QzpBtoDya8ml1YKyCnH1vTXHrRrdan
fDzfXt1vm+q2ZxIDEWFg
=tVhe
-----END PGP SIGNATURE-----

--------------enigB85A89989A0C0C8062C1CD74--

