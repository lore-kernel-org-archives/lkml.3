Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358Ab3FCBXC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 21:23:02 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:43405 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755323Ab3FCBW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 21:22:58 -0400
Date: Mon, 3 Jun 2013 11:22:44 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Bolle <pebolle@tiscali.nl>,
        Jesper Nilsson <jesper.nilsson@axis.com>
Subject: linux-next: manual merge of the m68k tree with the cris tree
Message-Id: <20130603112244.d2ffadc701b5c1e549b0efb9@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__3_Jun_2013_11_22_44_+1000_zrs+ww.BB3xzM4DG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__3_Jun_2013_11_22_44_+1000_zrs+ww.BB3xzM4DG
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Geert,

Today's linux-next merge of the m68k tree got a conflict in
arch/cris/arch-v32/drivers/Kconfig between commit aca30fdc0fb6 ("CRIS:
drop unused Kconfig symbols") from the cris tree and commit 6b8faf979bca
("cris: Switch cris to drivers/Kconfig") from the m68k tree.

Thanks for the heads up Geert.  I fixed it up (see below) and can carry
the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/cris/arch-v32/drivers/Kconfig
index c1e21fc,f64779c..0000000
--- a/arch/cris/arch-v32/drivers/Kconfig
+++ b/arch/cris/arch-v32/drivers/Kconfig
@@@ -440,9 -785,51 +438,4 @@@ config ETRAX_SPI_GPI
  	  Say m to build it as a module, which will be called spi_crisv32_gpio.
  	  (You need to select MMC separately.)
 =20
- # Avoid choices causing non-working configs by conditionalizing the inclu=
sion.
- if ETRAX_SPI_MMC
- source drivers/spi/Kconfig
- endif
-=20
 -# The default match that of sser0, only because that's how it was tested.
 -config ETRAX_SPI_CS_PIN
 -	string "SPI chip select pin"
 -	depends on ETRAX_SPI_GPIO
 -	default "pc3"
 -	help
 -	  The pin to use for SPI chip select.
 -
 -config ETRAX_SPI_CLK_PIN
 -	string "SPI clock pin"
 -	depends on ETRAX_SPI_GPIO
 -	default "pc1"
 -	help
 -	  The pin to use for the SPI clock.
 -
 -config ETRAX_SPI_DATAIN_PIN
 -	string "SPI MISO (data in) pin"
 -	depends on ETRAX_SPI_GPIO
 -	default "pc16"
 -	help
 -	  The pin to use for SPI data in from the device.
 -
 -config ETRAX_SPI_DATAOUT_PIN
 -	string "SPI MOSI (data out) pin"
 -	depends on ETRAX_SPI_GPIO
 -	default "pc0"
 -	help
 -	  The pin to use for SPI data out to the device.
 -
 -config ETRAX_SPI_MMC_CD_GPIO_PIN
 -	string "MMC/SD card detect pin for SPI using gpio (space for none)"
 -	depends on ETRAX_SPI_GPIO && MMC_SPI
 -	default "pd11"
 -	help
 -	  The pin to use for SD/MMC card detect.  This pin should be pulled up
 -	  and grounded when a card is present.  If defined as " " (space), no
 -	  pin is selected.  A card must then always be inserted for proper
 -	  action.
 -
 -config ETRAX_SPI_MMC_WP_GPIO_PIN
 -	string "MMC/SD card write-protect pin for SPI using gpio (space for none=
)"
 -	depends on ETRAX_SPI_GPIO && MMC_SPI
 -	default "pd10"
 -	help
 -	  The pin to use for the SD/MMC write-protect signal for a memory
 -	  card.  If defined as " " (space), the card is considered writable.
 -
  endif

--Signature=_Mon__3_Jun_2013_11_22_44_+1000_zrs+ww.BB3xzM4DG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRq+/pAAoJEECxmPOUX5FEG0kP/ja75FCxLsrBo3W03jCSoxvt
53Qy2uIDvQF8rLRvkVZ+3aQ/QJo52gv9PL180Zb0lcYUaK9vlw/HSOf4nwDLcnrQ
fiRpuz6RUh21TPggPs3GNIWRdZ7A1GTFUR74roS4LSFHHWiQlSvbIVKyjqh+srMz
hy16vuLA82VwZV2n6VlpSXH/NzJ5wapX4bsOSPRC2kppOMJX86dWHm9ulouNS+po
kFfvKoxhvSTZ18Im/yL+bkEgWfCv9UMug2RhOMmY14j7rq66Hgbi4Jyrz9VdA0k/
2o65jFtasbhXSTl2+k/CSH7PHlKJoJ6CvEJYgiaWje7qKjs6TIP4pL+95YFLCJOX
Yonu8O/c4TTBVuNxgvlmE2ZW5HvZ95evgh3TZUwFVJkKLQKt1vWKfXNHoUaUppVJ
Dgxs3ecoEAICMdSPjuj3XK4jcNnwdXoK/1WuyoqpB6eM09iYoElpJ45F8175btgG
e/oQjN5noaSRiA2WYXd4BP4y0gIv/xsY5ijk8SBKATTmt7dx7oMxKsg0tqn3jISn
ExlsCSAPgwOIs999bGFMrK3io/kvuvNwyst2GUigXb8Kr35140IKbfHGp2DG5Ja5
YwJ7FCVAYaPZWBsnRJuCALGMo4qlJcRnWl2PZJNMJnAxboaS9TzS/OtzHRV8M4b/
TOq4TQR/KYHx4NNbxrCR
=M2Ob
-----END PGP SIGNATURE-----

--Signature=_Mon__3_Jun_2013_11_22_44_+1000_zrs+ww.BB3xzM4DG--
