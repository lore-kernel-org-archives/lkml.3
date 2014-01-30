Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338AbaA3Or5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 09:47:57 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:51917 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752636AbaA3Orz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 09:47:55 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: [GIT PULL] ACPI and power management fixes and cleanup for v3.14-rc1
Date: Thu, 30 Jan 2014 16:02:11 +0100
Message-ID: <1433567.UOmYA855OZ@vostro.rjw.lan>
User-Agent: KMail/4.11.4 (Linux/3.13.0+; KDE/4.11.4; x86_64; ; )
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart37615554.1OY4BG0P8c"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart37615554.1OY4BG0P8c
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Hi Linus,

Please pull from the git repository at

  git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm+=
acpi-3.14-rc1-2

to receive ACPI and power management fixes and cleaups for v3.14-rc1 wi=
th
top-most commit 88ea0f2c02f461613dd67664a79db525e9723609

  Merge branches 'pm-cpufreq' and 'pm-devfreq'

on top of commit 09da8dfa98682d871987145ed11e3232accac860

  Merge tag 'pm+acpi-3.14-rc1' of git://git.kernel.org/pub/scm/linux/ke=
rnel/git/rafael/linux-pm

These include three fixes for issues introduced recently, an initializa=
tion
fix working around a regression introduced during the 3.13 cycle, a dev=
freq
driver build fix and a couple of strarightforward cleanups.

Specifics:

 - ACPI device hotplug fix preventing ACPI drivers from binding to devi=
ce
   objects that acpi_bus_trim() has been called for and the devices
   represented by them may not be operational.

 - Recent cpufreq changes related to the "boost" (turbo) feature broke
   the acpi-cpufreq error code path causing a NULL pointer dereference
   to occur on some systems.  Fix from Konrad Rzeszutek Wilk.

 - The log level of a CPU initialization error message added recently
   needs to be reduced, because the particular BIOS issue indicated by
   it turns out to be widespread and doesn't really matter for the
   majority of systems having it.  From Jiang Liu.
  =20
 - The regulator API needs to be told to stay away from things on syste=
ms
   with ACPI BIOSes or it may conflict with the BIOS' own handling of
   voltage regulators.  Fix from Mark Brown that works around a 3.13
   regression in lm90 on PCs occuring if the regulator API is enabled.

 - Prevent the Exynos4 devfreq driver from being built on multiplatform=
,
   because it depends on things that aren't available during such build=
s.
   From Sachin Kamat.

 - Upstream ACPICA doesn't use the bool type as defined in the kernel,
   so modify the kernel's ACPICA code to follow the upstream in that
   respect (only one variable definition is affected) to reduce
   divergences between the two.  From Lv Zheng.

 - Make the ACPI device PM code use ACPI_COMPANION() instead of its own=

   routine doing the same thing (and invokng ACPI_COMPANION() in the
   process).

 - Modify some routines in the ACPI processor driver to follow the
   common convention and return negative integers on errors.  From
   Hanjun Guo.

Thanks!


=2D--------------

Hanjun Guo (1):
      ACPI / processor: Return specific error value when mapping lapic =
id

Jiang Liu (1):
      ACPI / scan: reduce log level of "ACPI: \_PR_.CPU4: failed to get=
 CPU APIC ID"

Konrad Rzeszutek Wilk (1):
      acpi-cpufreq: De-register CPU notifier and free struct msr on err=
or.

Lv Zheng (1):
      ACPICA: Remove bool usage from ACPICA.

Mark Brown (1):
      ACPI / init: Flag use of ACPI and ACPI idioms for power supplies =
to regulator API

Rafael J. Wysocki (2):
      ACPI / PM: Use ACPI_COMPANION() to get ACPI companions of devices=

      ACPI / scan: Clear match_driver flag in acpi_bus_trim()

Sachin Kamat (1):
      PM / devfreq: Disable Exynos4 driver build on multiplatform

=2D--------------

 drivers/acpi/acpi_processor.c  |    2 +-
 drivers/acpi/acpica/acglobal.h |    2 +-
 drivers/acpi/bus.c             |    9 +++++++++
 drivers/acpi/device_pm.c       |   24 ++++++------------------
 drivers/acpi/processor_core.c  |   26 +++++++++++++-------------
 drivers/acpi/scan.c            |    1 +
 drivers/acpi/sysfs.c           |    2 +-
 drivers/cpufreq/acpi-cpufreq.c |    7 ++++---
 drivers/devfreq/Kconfig        |    2 +-
 include/acpi/acpixf.h          |    2 +-
 10 files changed, 38 insertions(+), 39 deletions(-)

--nextPart37615554.1OY4BG0P8c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAABCAAGBQJS6ml4AAoJEILEb/54YlRxUrQP/jBSXUf8Qwvkha/FY3hMGedg
+nNu+Ld9tEb4SwhqxCzehBRdS+o+5x4PNNBcEU1r+KEtL/gjOt/EhCKQ+prdCe6l
ngN1Bi+194L56GFExs0rS4nIdfBUyHdT1Dzu4KT0qwQQQk4AQD9sE1caDKxwOYmW
EzJqB8S5kn6BB0HRiXgPlJlgYcA9qvAxMyjFxSJITYiwFaMpzKu5j9TLRzHRiarj
n7meVOfK7MRehSRz2oyAlxjqu3scP29zYMezHUifgw5SYOE5xeKGXpZxAfoGK6l6
UnqMku+1KXxuAJYrvoAbjOgcOtPRl/3coPD64FCHJpvBbJ2ebzkBHau19PppakYy
UL9diEpHA9au3tbmz/Pt07YXDGSjciuxZ2zK5PZeWHGXCLQHpwizEOqw9mfchfSb
rtoo0N0KmhH73xps7W21h85hOJUPYsbvnLRmtSBkeO7U+ojJJmsidH511Fxbl9uT
v0Hl147gHejRE0q9H8majWi0yRaG6tPhSzT7zPsZDGil4pBSNbMw9sPShZdf4fOI
oY+j7+LFDgKr1Bd/rOKS7Hlm1b4a5c2d94ip73VDhXrELdOL8nbgvax+u0exJJNP
ld39Ppy76o9xxjvMdaMJGtYPnH/kipc+uGYgVciwIEn+4L6QtCKbQgAmrqKtrC1J
dnLdRnIRlWplJmZoWqww
=Q2tV
-----END PGP SIGNATURE-----

--nextPart37615554.1OY4BG0P8c--

