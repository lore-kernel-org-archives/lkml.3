Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209Ab3GEKDG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 06:03:06 -0400
Received: from multi.imgtec.com ([194.200.65.239]:4523 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756596Ab3GEKDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 06:03:05 -0400
Message-ID: <51D699BD.7000402@imgtec.com>
Date: Fri, 5 Jul 2013 11:02:37 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Markos <markos.chandras@imgtec.com>
Subject: [GIT PULL] metag architecture changes for v3.11
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="----enig2HRAMBASJFWNSJSTCLVVP"
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_07_05_11_02_45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2HRAMBASJFWNSJSTCLVVP
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

The following changes since commit 317ddd256b9c24b0d78fa8018f80f1e495481a=
10:

  Linux 3.10-rc5 (2013-06-08 17:41:04 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jhogan/metag.git tags/met=
ag-for-v3.11

for you to fetch changes up to c20eb0f1d0918c019fb2674a104e6ab59d8e62ac:

  metag: move EXPORT_SYMBOL(csum_partial) to metag_ksyms.c (2013-07-04 10=
:00:02 +0100)

----------------------------------------------------------------
Metag architecture changes for v3.11

- Infrastructure and DT files for TZ1090 SoC (pin control drivers
  already merged via pinctrl tree).
- Panic on boot instead of just warning if cache aliasing possible.
- Various SMP/hotplug fixes.
- Various other randconfig/sparse fixes.

----------------------------------------------------------------
James Hogan (16):
      metag: of_platform_populate from arch generic code
      metag: minimal TZ1090 (Comet) SoC infrastructure
      metag: init common clk and use "core" clk
      metag: log core and timer frequencies from arch code
      metag: add <dt-bindings/> symlink
      metag: *.dts: include using preprocessor
      metag: panic if cache aliasing possible
      metag: don't check for cache aliasing on smp cpu boot
      metag: tz1090: select and instantiate pinctrl-tz1090
      metag: tz1090: select and instantiate pinctrl-tz1090-pdc
      metag: use clear_tasks_mm_cpumask()
      metag: smp: enable irqs after set_cpu_online
      metag: smp: don't spin waiting for CPU to start
      metag: kick: add missing irq_enter/exit to kick_handler()
      metag: cpu hotplug: route_irq: preserve irq mask
      metag: move EXPORT_SYMBOL(csum_partial) to metag_ksyms.c

Markos Chandras (8):
      metag/kernel/irq.c: Declare root_domain as static
      metag/asm/irq.h: Declare init_IRQ
      metag/mm/cache: Restrict scope for metag_lnkget_probe
      metag/setup: Restrict scope for the capabilities variable
      metag/processor.h: Add missing cpuinfo_op declaration.
      metag/traps: Mark die() as __noreturn to match the declaration.
      metag/traps: include setup.h for the per_cpu_trap_init declaration
      metag/.gitignore: Extend the *.dtb pattern to match the dtb.S files=


 Documentation/devicetree/bindings/metag/meta.txt   | 30 +++++++++++
 .../devicetree/bindings/vendor-prefixes.txt        |  1 +
 arch/metag/Kconfig.soc                             | 12 +++++
 arch/metag/Makefile                                |  2 +-
 arch/metag/boot/.gitignore                         |  2 +-
 arch/metag/boot/dts/Makefile                       |  2 +
 arch/metag/boot/dts/include/dt-bindings            |  1 +
 arch/metag/boot/dts/skeleton.dts                   |  2 +-
 arch/metag/boot/dts/tz1090.dtsi                    | 41 +++++++++++++++
 arch/metag/boot/dts/tz1090_generic.dts             | 10 ++++
 arch/metag/configs/tz1090_defconfig                | 42 +++++++++++++++
 arch/metag/include/asm/bug.h                       |  4 +-
 arch/metag/include/asm/clock.h                     |  8 +++
 arch/metag/include/asm/irq.h                       |  1 +
 arch/metag/include/asm/processor.h                 |  2 +
 arch/metag/kernel/cachepart.c                      | 13 ++---
 arch/metag/kernel/clock.c                          | 59 ++++++++++++++++=
+++++-
 arch/metag/kernel/irq.c                            |  7 +--
 arch/metag/kernel/kick.c                           |  9 ++++
 arch/metag/kernel/metag_ksyms.c                    |  5 ++
 arch/metag/kernel/setup.c                          | 16 +++---
 arch/metag/kernel/smp.c                            | 35 ++++---------
 arch/metag/kernel/time.c                           | 14 ++++-
 arch/metag/kernel/traps.c                          |  5 +-
 arch/metag/lib/checksum.c                          |  1 -
 arch/metag/mm/cache.c                              |  2 +-
 drivers/clocksource/metag_generic.c                |  2 +
 27 files changed, 276 insertions(+), 52 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/metag/meta.txt
 create mode 120000 arch/metag/boot/dts/include/dt-bindings
 create mode 100644 arch/metag/boot/dts/tz1090.dtsi
 create mode 100644 arch/metag/boot/dts/tz1090_generic.dts
 create mode 100644 arch/metag/configs/tz1090_defconfig


------enig2HRAMBASJFWNSJSTCLVVP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJR1pnEAAoJEKHZs+irPybfeqcQAI4mV19EkT4zpcaOZnAPx05e
98ZeJOVVTeTos/Qt5Mu33WCK8KtdZ7/v6IIYSm01RBplSRM5A0OEE1i5L72gDNX6
VqKMSYV5EH5SbmzdRkFK/gczwLevLxqr9aYdeoQww5AhehWmHchmBH/Np34vaOi/
AIxUFr/LDz32VtZln87tJPd9YxH7fyLcRViX1TiAFkhqu0wz/wQZCcQkQjyY4zGt
ZT7JWZ9LU0L26sLk8jaMJPy/jK3/CDxSfCYIVAO6ct2SfjscM6jWSoJ4GeTsBPFV
q2DdUKzmw54IAnYjZ3cIbLspPkW17BuCRLYc5FA6q5zK5iWv+/KoV/D/VCvauGfu
HdgeplYKUdeeUxCDQJDr3MfNRxVjvUTuad8154qzty9nszzABnPR9umUQrpE5ZH+
dyQB3YyGssu5G124AXkdOTPmMu23cD3es85tH8OUiGVnZulR+D6ucXoTHAFH8KoD
cAh2fAebwsdU0sxAPdOu8oDF3h56ztt7HZSAAUL9uuxJkya1oxG/PqxJoL3gnwJz
5hisoJsNPK9PJGsTtJ+HMIFtViH+7eQyd6gyLaN7HaVpxHBPCnpJiS0Eec4t41iO
oZvvoepZphvsnND8HCnNXSmenkfNsdjsgZHGTcEIOTerYteMgKH3Eq6RfXSpABsI
gA/Z15McA/igcJACwph+
=eZL4
-----END PGP SIGNATURE-----

------enig2HRAMBASJFWNSJSTCLVVP--

