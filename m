Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757772Ab3GZBTK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 21:19:10 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:45021 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756829Ab3GZBTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 21:19:08 -0400
Date: Fri, 26 Jul 2013 11:18:54 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: linux-next: manual merge of the ia64 tree with the pci-current tree
Message-Id: <20130726111854.62b21016903683608d1ba423@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__26_Jul_2013_11_18_54_+1000_kx3AsKBFKr//9Q/D"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__26_Jul_2013_11_18_54_+1000_kx3AsKBFKr//9Q/D
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the ia64 tree got conflicts in
arch/ia64/configs/generic_defconfig,
arch/ia64/configs/gensparse_defconfig, arch/ia64/configs/tiger_defconfig
and arch/ia64/configs/xen_domu_defconfig between commit eeaa9b427947
("PCI: hotplug: Convert to be builtin only, not modular") from the
pci-current tree and commit 5da8f68fb699 ("[IA64] Change
CONFIG_HOTPLUG_PCI_ACPI=3Dm to =3Dy") from the ia64 tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/ia64/configs/generic_defconfig
index efbd292,a4bd0ef..0000000
--- a/arch/ia64/configs/generic_defconfig
+++ b/arch/ia64/configs/generic_defconfig
@@@ -31,8 -31,8 +31,8 @@@ CONFIG_ACPI_FAN=3D
  CONFIG_ACPI_DOCK=3Dy
  CONFIG_ACPI_PROCESSOR=3Dm
  CONFIG_ACPI_CONTAINER=3Dm
 -CONFIG_HOTPLUG_PCI=3Dm
 +CONFIG_HOTPLUG_PCI=3Dy
- CONFIG_HOTPLUG_PCI_ACPI=3Dm
+ CONFIG_HOTPLUG_PCI_ACPI=3Dy
  CONFIG_PACKET=3Dy
  CONFIG_UNIX=3Dy
  CONFIG_INET=3Dy
diff --cc arch/ia64/configs/gensparse_defconfig
index f64980d,5e5f074..0000000
--- a/arch/ia64/configs/gensparse_defconfig
+++ b/arch/ia64/configs/gensparse_defconfig
@@@ -25,8 -25,8 +25,8 @@@ CONFIG_ACPI_BUTTON=3D
  CONFIG_ACPI_FAN=3Dm
  CONFIG_ACPI_PROCESSOR=3Dm
  CONFIG_ACPI_CONTAINER=3Dm
 -CONFIG_HOTPLUG_PCI=3Dm
 +CONFIG_HOTPLUG_PCI=3Dy
- CONFIG_HOTPLUG_PCI_ACPI=3Dm
+ CONFIG_HOTPLUG_PCI_ACPI=3Dy
  CONFIG_PACKET=3Dy
  CONFIG_UNIX=3Dy
  CONFIG_INET=3Dy
diff --cc arch/ia64/configs/tiger_defconfig
index 0f4e9e4,7049c3d..0000000
--- a/arch/ia64/configs/tiger_defconfig
+++ b/arch/ia64/configs/tiger_defconfig
@@@ -31,8 -31,8 +31,8 @@@ CONFIG_ACPI_BUTTON=3D
  CONFIG_ACPI_FAN=3Dm
  CONFIG_ACPI_PROCESSOR=3Dm
  CONFIG_ACPI_CONTAINER=3Dm
 -CONFIG_HOTPLUG_PCI=3Dm
 +CONFIG_HOTPLUG_PCI=3Dy
- CONFIG_HOTPLUG_PCI_ACPI=3Dm
+ CONFIG_HOTPLUG_PCI_ACPI=3Dy
  CONFIG_PACKET=3Dy
  CONFIG_UNIX=3Dy
  CONFIG_INET=3Dy
diff --cc arch/ia64/configs/xen_domu_defconfig
index b025acf,7dc6ed7..0000000
--- a/arch/ia64/configs/xen_domu_defconfig
+++ b/arch/ia64/configs/xen_domu_defconfig
@@@ -32,8 -32,8 +32,8 @@@ CONFIG_ACPI_BUTTON=3D
  CONFIG_ACPI_FAN=3Dm
  CONFIG_ACPI_PROCESSOR=3Dm
  CONFIG_ACPI_CONTAINER=3Dm
 -CONFIG_HOTPLUG_PCI=3Dm
 +CONFIG_HOTPLUG_PCI=3Dy
- CONFIG_HOTPLUG_PCI_ACPI=3Dm
+ CONFIG_HOTPLUG_PCI_ACPI=3Dy
  CONFIG_PACKET=3Dy
  CONFIG_UNIX=3Dy
  CONFIG_INET=3Dy

--Signature=_Fri__26_Jul_2013_11_18_54_+1000_kx3AsKBFKr//9Q/D
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR8c6FAAoJEECxmPOUX5FE4PAP/jMkJM5vx+ZQy+E5IAsp8f51
szzrOgSMB0DTh5SH2QSXUNWFT7od01tUYVc6gRediXFAH96PLeykJimkCXuhlRC/
RX7qpcj3LV4CW6ftAkTkInOGP4K2camsfc4RuTwOFsWYkbZXYllTlybVYMqIjWBh
nCjRKAeHnzDW5/9whpdNUxe6tD7RxyeUa5cMa5k3slFMPhSOTkvCY9TZzusu6ucX
U6o0aDAaPh0chx1E0Jf84V0WcL52EcLGTfbrSX78ZancG0bSl3gL3NH3uoA7kzHd
4RJf2T2DZPahnxKlE3yFOEfvIcT8rQZRXX8MAd85W04hDgHYaLWogMyXw/R5L9DH
naRFALTR6qZg9RuHap8z0qeJvsx+vbVQtqBbxpK0x4DMkCRSjpWA3MLLEo5lWWFF
ChP55R9gAJGYE6WgvF47QSEp1w7ESY1ok+VbKC7Y1uULIC/aLWx901QEMXRiu5Tq
bx6Z9CaeOhV732/RiXzQuGZkC5lILmGl2bXsYGhKMy73Po0PgZThHrn0j5p9uoGn
PWAQeVgt+UyRMrjI2ds9a0Umud71NAbB1QxqsChr3nms5Fbp9wTVbDjNl+SxsaT4
erCgqlI9bGVYlfLV2d2Bib9vTuCB5h8UALXn1yQJzcztkTEfU7AXAvLP1iKcnblx
VTOz9DWK/f6QYkkbe6pw
=kzWf
-----END PGP SIGNATURE-----

--Signature=_Fri__26_Jul_2013_11_18_54_+1000_kx3AsKBFKr//9Q/D--
