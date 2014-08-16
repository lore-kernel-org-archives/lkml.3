Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431AbaHPJN2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 05:13:28 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:33075 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbaHPJN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 05:13:26 -0400
X-Greylist: delayed 2483 seconds by postgrey-1.27 at vger.kernel.org; Sat, 16 Aug 2014 05:13:25 EDT
Date: Sat, 16 Aug 2014 09:31:59 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: torvalds@linux-foundation.org
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PATCH] x86 platform driver updates
Message-ID: <20140816083159.GA2986@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HcAYCG3uE/tztfnV"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

A moderate number of changes, but nothing awfully significant. A lot of=20
const cleanups, some reworking and additions to the rfkill quirks in the=20
asus driver, a new driver for generating falling laptop events on=20
Toshibas and some misc fixes. Maybe vendors have stopped inventing=20
things.

The following changes since commit 88ec63d6f85ccf40988ddae8b430dcb07355b29b:

  Merge tag 'scsi-misc' of git://git.kernel.org/pub/scm/linux/kernel/git/je=
jb/scsi (2014-08-15 18:28:58 -0600)

are available in the git repository at:


  git://cavan.codon.org.uk/platform-drivers-x86.git for_linus

for you to fetch changes up to 186e4e89a0922d75fba476f15b723e541cc34bea:

  platform/x86: Enable build support for toshiba_haps (2014-08-16 01:23:56 =
-0700)

----------------------------------------------------------------
AceLan Kao (2):
      asus-wmi: control wlan-led if wapf > 0
      asus-nb-wmi: Add ASUSTeK COMPUTER INC. X200CA

Andrey Utkin (1):
      drivers/platform/x86/thinkpad_acpi.c: don't test unsigned int for neg=
ativity

Azael Avalos (5):
      toshiba_acpi: Add extra check to backlight code
      toshiba_acpi: Add Qosmio X75-A to the alt keymap dmi list
      platform/x86: Toshiba HDD Active Protection Sensor
      Documentation: Add file about toshiba_haps module
      platform/x86: Enable build support for toshiba_haps

Hans de Goede (9):
      thinkpad_acpi: Update mapping for F12 hotkey on *40 models to KEY_FILE
      ideapad-laptop: Change Lenovo Yoga 2 series rfkill handling
      asus-wmi: Disable acpi-video backlight on desktop machines
      asus-wmi: backlight_init: Stop treating -ENODEV as if its not an error
      asus-nb-wmi: Add wapf4 quirk for the X550CL
      asus-nb-wmi: Add wapf4 quirk for the X550CC
      ideapad-laptop: Disable touchpad interface on Yoga models
      asus-nb-wmi.c: Rename x401u quirk to wapf4
      asus-nb-wmi: Add wapf4 quirk for the U32U

Himangi Saraogi (1):
      WMI: Remove unnecessary null test

Jean Delvare (1):
      fujitsu-laptop: Clear build warnings

Mario Limonciello (1):
      alienware-wmi: make hdmi_mux enabled on case-by-case basis

Martin Kepplinger (1):
      Fix log message about future removal of interface

Mathias Krause (15):
      MAINTAINERS: Update git URL for x86 platform drivers
      acer-wmi: Mark acer_wmi_keymap[] as __initconst
      acer-wmi: Hide acer_{suspend,resume} for !CONFIG_PM_SLEEP
      alienware-wmi: Mark DMI table as __initconst
      asus-nb-wmi: Constify asus_quirks[] DMI table
      acer-wmi: Mark init data and code as such
      eeepc-wmi: Constify asus_quirks[] DMI table
      dell-laptop: Mark dell_quirks[] DMI table as __initconst
      fujitsu-tablet: Mark DMI callbacks as __init code
      hp_accel: Constify ACPI and DMI tables
      hp-wmi: Add missing __init annotations to initialization code
      fujitsu-laptop: Mark fujitsu_dmi_table[] DMI table as __initconst
      thinkpad_acpi: Mark volume_alsa_control_{vol,mute} as __initdata
      intel_ips: Make ips_mcp_limits variables static
      ideapad-laptop: Constify DMI table and other r/o variables

Nick (1):
      platform/x86/toshiba-apci.c possible bad if test?

Paul Bolle (1):
      eeepc-laptop: rename _set and _get arguments in macro

Roald Frederickx (1):
      compal-laptop: correct invalid hwmon name

mog422 (1):
      sony-laptop: fix doesn't work lid resume settings on Vaio Pro

poma (1):
      WAPF 4 for ASUSTeK COMPUTER INC. X75VBP WLAN ON.

 Documentation/laptops/00-INDEX         |   2 +
 Documentation/laptops/toshiba_haps.txt |  76 ++++++++++
 MAINTAINERS                            |   2 +-
 drivers/platform/x86/Kconfig           |  19 +++
 drivers/platform/x86/Makefile          |   1 +
 drivers/platform/x86/acer-wmi.c        |  54 ++++---
 drivers/platform/x86/alienware-wmi.c   |  26 +++-
 drivers/platform/x86/asus-nb-wmi.c     |  80 ++++++++--
 drivers/platform/x86/asus-wmi.c        |  16 +-
 drivers/platform/x86/compal-laptop.c   |   2 +-
 drivers/platform/x86/dell-laptop.c     |   6 +-
 drivers/platform/x86/eeepc-laptop.c    |   8 +-
 drivers/platform/x86/eeepc-wmi.c       |   2 +-
 drivers/platform/x86/fujitsu-laptop.c  |  19 ++-
 drivers/platform/x86/fujitsu-tablet.c  |   6 +-
 drivers/platform/x86/hp-wmi.c          |   6 +-
 drivers/platform/x86/hp_accel.c        |   4 +-
 drivers/platform/x86/ideapad-laptop.c  |  72 +++++++--
 drivers/platform/x86/intel_ips.c       |   6 +-
 drivers/platform/x86/sony-laptop.c     |   2 +-
 drivers/platform/x86/thinkpad_acpi.c   |   8 +-
 drivers/platform/x86/toshiba_acpi.c    |  30 +++-
 drivers/platform/x86/toshiba_haps.c    | 265 +++++++++++++++++++++++++++++=
++++
 drivers/platform/x86/wmi.c             |   4 -
 24 files changed, 608 insertions(+), 108 deletions(-)
 create mode 100644 Documentation/laptops/toshiba_haps.txt
 create mode 100644 drivers/platform/x86/toshiba_haps.c


--=20
Matthew Garrett | mjg59@srcf.ucam.org

--HcAYCG3uE/tztfnV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlPvFv4ACgkQ7Hkv8l1YiTvBiQCgo0mSxKWkhb1jBkFSfQDtp1yb
QIkAnRPBsIQT0LGzGURIwayAhcgrSec9
=Ow0H
-----END PGP SIGNATURE-----

--HcAYCG3uE/tztfnV--
