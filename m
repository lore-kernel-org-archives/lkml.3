Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393AbaI3ErY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 00:47:24 -0400
Received: from ozlabs.org ([103.22.144.67]:45054 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945AbaI3ErT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 00:47:19 -0400
Date: Tue, 30 Sep 2014 14:46:56 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sebastian Reichel <sre@kernel.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Christophe Kerello <christophe.kerello@st.com>
Subject: linux-next: manual merge of the battery tree with the arm-soc tree
Message-ID: <20140930144656.35afeae4@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/j3mS2Vu7Y+VoJr3jhhTCtDG"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/j3mS2Vu7Y+VoJr3jhhTCtDG
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Sebastian,

Today's linux-next merge of the battery tree got conflicts in
drivers/power/reset/Kconfig and drivers/power/reset/Makefile between
commit 0e545f57b708 ("power: reset: driver for the Versatile syscon
reboot") from the arm-soc tree and commit f0745f3696e8 ("power: reset:
Add restart functionality for STiH41x platforms") from the battery tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/power/reset/Kconfig
index 527a0f47ef44,a178e9c50a20..000000000000
--- a/drivers/power/reset/Kconfig
+++ b/drivers/power/reset/Kconfig
@@@ -69,9 -59,16 +77,16 @@@ config POWER_RESET_MS
  	help
  	  Power off and restart support for Qualcomm boards.
 =20
+ config POWER_RESET_LTC2952
+ 	bool "LTC2952 PowerPath power-off driver"
+ 	depends on OF_GPIO && POWER_RESET
+ 	help
+ 	  This driver supports an external powerdown trigger and board power
+ 	  down via the LTC2952. Bindings are made in the device tree.
+=20
  config POWER_RESET_QNAP
  	bool "QNAP power-off driver"
 -	depends on OF_GPIO && POWER_RESET && PLAT_ORION
 +	depends on OF_GPIO && PLAT_ORION
  	help
  	  This driver supports turning off QNAP NAS devices by sending
  	  commands to the microcontroller which controls the main power.
@@@ -92,15 -89,13 +107,21 @@@ config POWER_RESET_SUN6
  	help
  	  Reboot support for the Allwinner A31 SoCs.
 =20
+ config POWER_RESET_ST
+ 	bool "ST restart power-off driver"
+ 	depends on POWER_RESET && ARCH_STI
+ 	help
+ 	  Power off and reset support for STMicroelectronics boards.
+=20
 +config POWER_RESET_VERSATILE
 +	bool "ARM Versatile family reboot driver"
 +	depends on ARM
 +	depends on MFD_SYSCON
 +	depends on OF
 +	help
 +	  Power off and restart support for ARM Versatile family of
 +	  reference boards.
 +
  config POWER_RESET_VEXPRESS
  	bool "ARM Versatile Express power-off and reset driver"
  	depends on ARM || ARM64
diff --cc drivers/power/reset/Makefile
index 73221009f2bf,ab8cd348a099..000000000000
--- a/drivers/power/reset/Makefile
+++ b/drivers/power/reset/Makefile
@@@ -9,7 -9,7 +11,8 @@@ obj-$(CONFIG_POWER_RESET_LTC2952) +=3D lt
  obj-$(CONFIG_POWER_RESET_QNAP) +=3D qnap-poweroff.o
  obj-$(CONFIG_POWER_RESET_RESTART) +=3D restart-poweroff.o
  obj-$(CONFIG_POWER_RESET_SUN6I) +=3D sun6i-reboot.o
+ obj-$(CONFIG_POWER_RESET_ST) +=3D st-poweroff.o
 +obj-$(CONFIG_POWER_RESET_VERSATILE) +=3D arm-versatile-reboot.o
  obj-$(CONFIG_POWER_RESET_VEXPRESS) +=3D vexpress-poweroff.o
  obj-$(CONFIG_POWER_RESET_XGENE) +=3D xgene-reboot.o
  obj-$(CONFIG_POWER_RESET_KEYSTONE) +=3D keystone-reset.o

--Sig_/j3mS2Vu7Y+VoJr3jhhTCtDG
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUKjXTAAoJEMDTa8Ir7ZwVvGoP/RFb+56rT4UJIluUNnIA72ZY
Y2D6JDCE9Qq2aoAKJ8VIPgIn7FBh0L/R+PQXVHhwZVTdrR+qJi5RINN3UXbZxqZ+
5VnzxgpLPsSaVz5y1Bk+9wENRkNdtCm6hDmPjEpxuUTxE7bf4/AObg9Hfp6ZW/Mj
MtfMcRvSC5VQmwM3PUkMGOo4Fa1C/FGNUa0oczDtJ1lGKU8bI6xWZ3k+on2DIqks
WFJ7auvr7jTiLgqut71skKWXiqBdE1u8PWAA0vBS8/pywGmXRJf12gzkAwVnAhFn
f/pgWXbZiIliOYBnxiR+HJ9oxkRPZpSP2g9fAyn8+QVftPKUHV+GOs9LMe8Hjkku
GfxOaSeavbpZPsmMwXS0ouiLPmnL+z4dJ9fI6H48ClvXOm8LkmvAvvrnWaKZdvVW
0AKjHx7E3u7iP++XXkODnyTOpme0GxdE3UzbvUL1h/shAOlO4KmosRlhraL0cvDM
dHj2D7MALS2dnz6/4rUL1QKAkFtfylmtsrmrUKQknGGlgHkGgY5VUzo4nxNDZi4C
2mNgt4Z0njB1Ceig+SWYLIXiRgqBrEgpUp3eeoISSI48jxOi9SUHnsYztUMsXXxa
a96GNmnAFlaQDr9ceGNIm/5PY3JQl3uqF/rzSuNf03NEX18nEqu1/z6mNGZ1uFIE
KsHTZruYi4t7FOhkyPSF
=SsnX
-----END PGP SIGNATURE-----

--Sig_/j3mS2Vu7Y+VoJr3jhhTCtDG--
