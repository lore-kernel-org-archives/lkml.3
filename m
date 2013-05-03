Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591Ab3ECAwz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 20:52:55 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:34218 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643Ab3ECAwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 20:52:53 -0400
Date: Fri, 3 May 2013 10:52:34 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Alex Courbot <acourbot@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>
Subject: Re: [GIT PULL] Removal of GENERIC_GPIO
Message-Id: <20130503105234.6e9c8aa5ed2784bbe084caa8@canb.auug.org.au>
In-Reply-To: <51823DDA.7010103@nvidia.com>
References: <51823DDA.7010103@nvidia.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__3_May_2013_10_52_34_+1000_nnMr/o.tVyfM5eC7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__3_May_2013_10_52_34_+1000_nnMr/o.tVyfM5eC7
Content-Type: multipart/mixed;
 boundary="Multipart=_Fri__3_May_2013_10_52_34_+1000_9GFY2zDGQ=6K_NpQ"


--Multipart=_Fri__3_May_2013_10_52_34_+1000_9GFY2zDGQ=6K_NpQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Grant,

On Thu, 2 May 2013 19:20:10 +0900 Alex Courbot <acourbot@nvidia.com> wrote:
>
> Here is the pull request for the GENERIC_GPIO removal. It is almost=20
> certain that a few fixups will be necessary - while I don't have precise=
=20
> patches, the following steps should ensure the state of the code is clean:
>=20
> * "git grep CONFIG_GENERIC_GPIO" should return 0 hits. Matches should be=
=20
> replaced with CONFIG_GPIOLIB
> * "git grep '\bGENERIC_GPIO\b'" should return 1 hit in the Chinese=20
> documentation. Selectors of GENERIC_GPIO should be turned into selectors=
=20
> of GPIOLIB, while definitions of the option in architecture code should=20
> be deleted.
>=20
> Please let me know if there is something more I can do to ease your task.
>=20
> Thanks,
> Alex.
>=20
> The following changes since commit 10b38669d64c757cfd927e3820292c580ed70a=
ae:
>=20
>    Merge tag 'for-linus-v3.9-rc4' of git://oss.sgi.com/xfs/xfs=20
> (2013-03-19 15:17:40 -0700)
>=20
> are available in the git repository at:
>=20
>    git://github.com/Gnurou/linux.git for_grant
>=20
> for you to fetch changes up to f4c54050640e7afa4749875cf9b900d42db361c0:
>=20
>    gpio: update gpio Chinese documentation (2013-04-16 18:47:22 +0900)

I currently have 3 merge fix patches for the gen-cpio tree:

gen-gpio: GPIOLIB merge fix up
merge fix for Convert selectors of GENERIC_GPIO to GPIOLIB
merge fix 2 for Convert selectors of GENERIC_GPIO to GPIOLIB

I have attached them.  All three are now applicable to Linus' tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Multipart=_Fri__3_May_2013_10_52_34_+1000_9GFY2zDGQ=6K_NpQ
Content-Type: text/x-diff;
 name="0001-gen-gpio-GPIOLIB-merge-fix-up.patch"
Content-Disposition: attachment;
 filename="0001-gen-gpio-GPIOLIB-merge-fix-up.patch"
Content-Transfer-Encoding: quoted-printable

>From 0cde69807ded83d280745b4d576d587c4bd9f16b Mon Sep 17 00:00:00 2001
From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 17 Apr 2013 15:44:53 +1000
Subject: [PATCH] gen-gpio: GPIOLIB merge fix up

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/usb/phy/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
index 3a7fec9..21153d1 100644
--- a/drivers/usb/phy/Kconfig
+++ b/drivers/usb/phy/Kconfig
@@ -128,7 +128,7 @@ config TWL6030_USB
=20
 config USB_GPIO_VBUS
 	tristate "GPIO based peripheral-only VBUS sensing 'transceiver'"
-	depends on GENERIC_GPIO
+	depends on GPIOLIB
 	help
 	  Provides simple GPIO VBUS sensing for controllers with an
 	  internal transceiver via the usb_phy interface, and
--=20
1.8.1


--Multipart=_Fri__3_May_2013_10_52_34_+1000_9GFY2zDGQ=6K_NpQ
Content-Type: text/x-diff;
 name="0001-merge-fix-for-Convert-selectors-of-GENERIC_GPIO-to-G.patch"
Content-Disposition: attachment;
 filename="0001-merge-fix-for-Convert-selectors-of-GENERIC_GPIO-to-G.patch"
Content-Transfer-Encoding: quoted-printable

>From aa67afd7caf9abff0bff965f95bf4dd0f04fc180 Mon Sep 17 00:00:00 2001
From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 18 Apr 2013 17:05:12 +1000
Subject: [PATCH] merge fix for Convert selectors of GENERIC_GPIO to GPIOLIB

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/powerpc/platforms/85xx/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/powerpc/platforms/85xx/Kconfig b/arch/powerpc/platforms/8=
5xx/Kconfig
index fbb3eb9..102c29e 100644
--- a/arch/powerpc/platforms/85xx/Kconfig
+++ b/arch/powerpc/platforms/85xx/Kconfig
@@ -327,7 +327,6 @@ config B4_QDS
 	select PPC_E500MC
 	select PHYS_64BIT
 	select SWIOTLB
-	select GENERIC_GPIO
 	select ARCH_REQUIRE_GPIOLIB
 	select HAS_RAPIDIO
 	select PPC_EPAPR_HV_PIC
--=20
1.8.1


--Multipart=_Fri__3_May_2013_10_52_34_+1000_9GFY2zDGQ=6K_NpQ
Content-Type: text/x-diff;
 name="0001-merge-fix-2-for-Convert-selectors-of-GENERIC_GPIO-to.patch"
Content-Disposition: attachment;
 filename="0001-merge-fix-2-for-Convert-selectors-of-GENERIC_GPIO-to.patch"
Content-Transfer-Encoding: quoted-printable

>From fca3f55cd845c7640ef80e85a169fa7225bfd8ed Mon Sep 17 00:00:00 2001
From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 18 Apr 2013 17:08:14 +1000
Subject: [PATCH] merge fix 2 for Convert selectors of GENERIC_GPIO to GPIOL=
IB

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/i2c/muxes/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/muxes/Kconfig b/drivers/i2c/muxes/Kconfig
index b5329b0..f7f9865 100644
--- a/drivers/i2c/muxes/Kconfig
+++ b/drivers/i2c/muxes/Kconfig
@@ -7,7 +7,7 @@ menu "Multiplexer I2C Chip support"
=20
 config I2C_ARB_GPIO_CHALLENGE
 	tristate "GPIO-based I2C arbitration"
-	depends on GENERIC_GPIO && OF
+	depends on GPIOLIB && OF
 	help
 	  If you say yes to this option, support will be included for an
 	  I2C multimaster arbitration scheme using GPIOs and a challenge &
--=20
1.8.1


--Multipart=_Fri__3_May_2013_10_52_34_+1000_9GFY2zDGQ=6K_NpQ--

--Signature=_Fri__3_May_2013_10_52_34_+1000_nnMr/o.tVyfM5eC7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRgwpSAAoJEECxmPOUX5FEOvMP/jTqmN8/fkwXCRKAcGKpbd9i
Cews5cLYbCiish/IL2O+zIETU3eVAF1kpsnjtzmfcF2m6UU8ua5GH5vxNBK8+nBc
BbF2zeBdqZp/Bu38eNEEUyx+6U7og+tjusX0/GkNjbbCy0OCYaHxealvNcKN2/xV
8JPMvm4CmE+Dq+2lY9wlXyqd8POgWEkJkkVauyI8Esv6GrAMa780+hUdUz+2Wzma
HJ8EX5XNho4kN4p5leMHKbVG2YuVzjx5Ki3J2ESfEMBFY9wXSCyQIJI/ze0XTn8G
srjZ7dYjM9R5C1BHQjp1/nmEcCcioJDvrpzOvGGb3BikOEYCh5V2IsJ9gkMgYUpV
ehh1SdCa6M3C1v5wRf6abJr41GL070yDBqx+Rh+43cd585RyVifoo4Sqsljpfsk0
DBrrBeU8p8lur4YvRrV7dhrarunAkWchZMzuFPSY3TlnNn6j4ulg42guLkRrZ+qH
D9FH/zoKS9wkj/xhu/hu3to7PbfKYDMAamQq/eEVeqtHF/gzRYMk/n9Ss8uacQZG
EUwNVl+aF3fqcrG8QNIvCmd/Whv4QlRdlyyuc9Fjf7DYImW0ODWzVe9fhcCuNm2B
F4M7xYC7GAFitUJudM8MGMSHY2ieXmbGnGbH97VAj6vybDBZqJKRzOMAF5RRp6Zz
4fQOMF1JHa8PnK35v0XI
=2dlw
-----END PGP SIGNATURE-----

--Signature=_Fri__3_May_2013_10_52_34_+1000_nnMr/o.tVyfM5eC7--
