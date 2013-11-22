Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939Ab3KVAMo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 19:12:44 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:38887 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508Ab3KVAMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 19:12:43 -0500
Date: Fri, 22 Nov 2013 00:12:37 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: torvalds@linux-foundation.org
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] x86 platform driver upates
Message-ID: <20131122001237.GA32643@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LQksG6bCIzRHxTLp"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

A moderate diffstat, but it's almost entirely just moving the chromebook=20
driver into its own directory in order to ease ARM support, adding back=20
rfkill support to the one Dell laptop model where it's expected to work,=20
updates to the Intel IPC driver for hardware I've never actually seen=20
and the usual set of small fixes.

The following changes since commit 527d1511310a89650000081869260394e20c7013:

  Merge branch 'next' of git://git.kernel.org/pub/scm/linux/kernel/git/benh=
/powerpc (2013-11-20 15:13:47 -0800)

are available in the git repository at:


  git://cavan.codon.org.uk/platform-drivers-x86.git for_linus

for you to fetch changes up to a80e1053aaa395d94fff5ab7c73c89bb0c28c3c5:

  x86, wmi fix modalias_show return values (2013-11-20 20:16:22 -0500)

----------------------------------------------------------------
Alex Hung (2):
      dell-wmi: Add KEY_MICMUTE to bios_to_linux_keycode
      hp-wmi: detect "2009 BIOS or later" flag by WMI 0x0d for wireless cmd

Hans de Goede (12):
      Revert "dell-laptop: Remove rfkill code"
      dell-laptop: Only enable rfkill on Latitudes
      dell-laptop: If there is no hwswitch, then clear all hw-controlled bi=
ts
      dell-laptop: Only get status from BIOS once when updating
      dell-laptop: Don't set sw_state from the query callback
      dell-laptop: Don't read-back sw_state on machines with a hardware swi=
tch
      dell-laptop: Allow changing the sw_state while the radio is blocked b=
y hw
      dell-laptop: Sync current block state to BIOS on hw switch change
      dell-laptop: Do not skip setting blocked bit rfkill_set while hw-bloc=
ked
      dell-laptop: Wait less long before updating rfkill after an rfkill ke=
ypress
      dell-laptop: Add a force_rfkill module parameter
      dell-laptop: Only enable rfkill functionality on laptops with a hw ki=
llswitch

Joe Perches (1):
      platform:x86: Remove OOM message after input_allocate_device

Kuppuswamy Sathyanarayanan (4):
      ipc: Added platform data structure
      ipc: Enabled ipc support for additional intel platforms
      ipc: Handle error conditions in ipc command
      ipc: Added support for IPC interrupt mode

Mattia Dongili (1):
      sony-laptop: warn on multiple KBD backlight handles

Olof Johansson (1):
      platform: add chrome platform directory

Prarit Bhargava (1):
      x86, wmi fix modalias_show return values

Stephen Gildea (1):
      sony-laptop: fixe typos in sony_laptop_input_keycode_map

Takashi Iwai (1):
      thinkpad_acpi: Fix build error when CONFIG_SND_MAX_CARDS > 32

 MAINTAINERS                                        |   5 +
 drivers/platform/Kconfig                           |   1 +
 drivers/platform/Makefile                          |   1 +
 drivers/platform/chrome/Kconfig                    |  28 ++
 drivers/platform/chrome/Makefile                   |   2 +
 drivers/platform/{x86 =3D> chrome}/chromeos_laptop.c |   0
 drivers/platform/x86/Kconfig                       |  11 -
 drivers/platform/x86/Makefile                      |   1 -
 drivers/platform/x86/asus-laptop.c                 |   5 +-
 drivers/platform/x86/dell-laptop.c                 | 288 +++++++++++++++++=
++++
 drivers/platform/x86/dell-wmi.c                    |   7 +-
 drivers/platform/x86/eeepc-laptop.c                |   4 +-
 drivers/platform/x86/hp-wmi.c                      |  14 +-
 drivers/platform/x86/ideapad-laptop.c              |   4 +-
 drivers/platform/x86/intel_mid_powerbtn.c          |   4 +-
 drivers/platform/x86/intel_scu_ipc.c               | 117 ++++++++-
 drivers/platform/x86/panasonic-laptop.c            |   5 +-
 drivers/platform/x86/sony-laptop.c                 |  20 +-
 drivers/platform/x86/thinkpad_acpi.c               |   8 +-
 drivers/platform/x86/topstar-laptop.c              |   4 +-
 drivers/platform/x86/toshiba_acpi.c                |   4 +-
 drivers/platform/x86/wmi.c                         |   6 +-
 22 files changed, 477 insertions(+), 62 deletions(-)
 create mode 100644 drivers/platform/chrome/Kconfig
 create mode 100644 drivers/platform/chrome/Makefile
 rename drivers/platform/{x86 =3D> chrome}/chromeos_laptop.c (100%)


--LQksG6bCIzRHxTLp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlKOoXUACgkQ7Hkv8l1YiTtFywCfbuiV9ZmpjaLxeVh7K1TedBaH
B0oAnRHtCeH/Dbzoo3c8aMC9FKBAEzlk
=r0N7
-----END PGP SIGNATURE-----

--LQksG6bCIzRHxTLp--
