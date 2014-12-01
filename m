Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbaLAEWO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 23:22:14 -0500
Received: from ozlabs.org ([103.22.144.67]:59344 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752326AbaLAEWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 23:22:13 -0500
Date: Mon, 1 Dec 2014 15:22:02 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ulf Hansson <ulf.hansson@linaro.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>, Andreas Fenkart <afenkart@gmail.com>
Subject: linux-next: manual merge of the mmc-uh tree with the arm-soc tree
Message-ID: <20141201152202.5a1b4978@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/deITdhwIVWWOIqUJ9tExxUD"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/deITdhwIVWWOIqUJ9tExxUD
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Ulf,

Today's linux-next merge of the mmc-uh tree got a conflict in
arch/arm/mach-omap2/board-n8x0.c between commit e639cd5bfc03 ("ARM:
OMAP2+: Prepare to move GPMC to drivers by platform data header") from
the arm-soc tree and commit 826c71a06588 ("ARM: OMAP2: MMC: include
mmc-omap platform header directly") from the mmc-uh tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-omap2/board-n8x0.c
index 49c3c25808e7,e0ad64fde20e..000000000000
--- a/arch/arm/mach-omap2/board-n8x0.c
+++ b/arch/arm/mach-omap2/board-n8x0.c
@@@ -21,7 -21,10 +21,9 @@@
  #include <linux/i2c.h>
  #include <linux/spi/spi.h>
  #include <linux/usb/musb.h>
+ #include <linux/mmc/host.h>
  #include <linux/platform_data/spi-omap2-mcspi.h>
 -#include <linux/platform_data/mtd-onenand-omap2.h>
+ #include <linux/platform_data/mmc-omap.h>
  #include <linux/mfd/menelaus.h>
  #include <sound/tlv320aic3x.h>
 =20

--Sig_/deITdhwIVWWOIqUJ9tExxUD
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUe+zvAAoJEMDTa8Ir7ZwV2bkQAINBPo8tCi0c27K0hkfwBJ/Q
aAW7HHsswF2kf4pUkf940f23S3DGk8ep8zTIATM4iJBJuUG63uPF5T0xP+9LW301
lTQnxnpBMfv7OE0dRnMb1G8fliy6iR+bjhVrcQ1I3DUGGFmz8Ivlqest04rBIZEB
A7ou+WI4/EThKy4W27s2uKdHghYU9AkRFpsB+dQw6Q0SgKr8uMrSX0g4MjJfi2ck
SdOc3zhQmwxMxq+Yliy/pbxfeTCcBsHuaHpnpNGL5dS6Do7/LOuqNrtkMQiUit/q
DyHx88ALtC8Pgml+R0PAyC0elcfCAl9WzDNPngb1EPWFfY9DbpxtoAcl/gcQSRvD
jQ6amG3ZXGp67C0RiZVSV3zH4/2QSkoqYqtqSZq4aa5QmvcbBLP//ydnsxcL1s8w
8McsUJhaJ5URqWe5/LszZ1pwqfiv2sRyXtpV/9uhmV6fBN9oX63qDm34ulzsvOE6
u94S5/nBtcpctyNUzSNsyH65a6XoP3WOridbIuRS1s50/Q+mcmeLbr3BPXdWfdmo
VopTRXVv/GOFib4Eq2sVbgiJ0mXlNLz61WbpmUWbMa225+lDKPy87kKDYOVMYbeU
qJDzOpeFF5qTcnC+NpeYIkuAqM8mjjWY751lusjzc+1GZvq9OObg1lq+Kdry8fjV
dssBBmr6sNcTzdUuO/jl
=NQ8F
-----END PGP SIGNATURE-----

--Sig_/deITdhwIVWWOIqUJ9tExxUD--
