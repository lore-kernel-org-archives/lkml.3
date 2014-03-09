Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340AbaCIMOs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 08:14:48 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:44139 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbaCIMOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 08:14:46 -0400
Date: Sun, 9 Mar 2014 12:14:39 +0000
From: Mark Brown <broonie@kernel.org>
To: Stephen Warren <swarren@wwwdotorg.org>, Rob Herring <robh@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20140309121439.7da8f5ac65985cebdbf19f05@kernel.org>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__9_Mar_2014_12_14_39_+0000_Xos3G7sOXw8QUuRr"
X-SA-Exim-Connect-IP: 94.175.89.236
X-SA-Exim-Mail-From: broonie@kernel.org
Subject: linux-next: manual merge of the bcm2835 tree with the arm-soc tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__9_Mar_2014_12_14_39_+0000_Xos3G7sOXw8QUuRr
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Stephen/Rob,

Today's linux-next merge of the bcm2835 tree got a conflict in  between com=
mit  ddb902cc34593ecb ("ARM: centralize common multi-platform kconfig optio=
ns") from the arm-soc tree and commit d30fe6272183f3cc8b ("ARM: bcm2835: Mo=
ve to mach-bcm directory") from the bcm2835 tree. Commit 0676b21fffd17baeff=
589 ("ARM: bcm2835: enable V6K instead of plain V6") also collided.

I've fixed up as below and can carry:

diff --cc arch/arm/mach-bcm/Kconfig
index af4f2dfda40c,4e466e9eef44..7de3282a8613
--- a/arch/arm/mach-bcm/Kconfig
+++ b/arch/arm/mach-bcm/Kconfig
@@@ -27,6 -32,22 +27,18 @@@ config ARCH_BCM_MOBIL
  	  BCM11130, BCM11140, BCM11351, BCM28145 and
  	  BCM28155 variants.
 =20
+ config ARCH_BCM2835
+ 	bool "Broadcom BCM2835 family" if ARCH_MULTI_V6
+ 	select ARCH_REQUIRE_GPIOLIB
+ 	select ARM_AMBA
+ 	select ARM_ERRATA_411920
+ 	select ARM_TIMER_SP804
 -	select CLKDEV_LOOKUP
 -	select CLKSRC_OF
 -	select CPU_V6
 -	select GENERIC_CLOCKEVENTS
+ 	select PINCTRL
+ 	select PINCTRL_BCM2835
+ 	help
+ 	  This enables support for the Broadcom BCM2835 SoC. This SoC is
+ 	  used in the Raspberry Pi and Roku 2 devices.
+=20
  endmenu
 =20
  endif

--Signature=_Sun__9_Mar_2014_12_14_39_+0000_Xos3G7sOXw8QUuRr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTHFsvAAoJELSic+t+oim9OHQP/2wgqZcVqdWTG0hSMg6AFPf8
A6qETCTup5i9qIpKvvWxldKqaSUbVRGOn/UJRwydXeno3rnQcvm16gL1vVA+vnQs
p8YNSEHNmkKDamvUpV/9vQwQ9nZHwZyhj7bFtmgQ0hKNIc4I/R9EJdSFx8RLY0Nh
7+GKPuKY0dpVF5yJCu3ywA8nyst347aYRO7ueel3QmH4N+YzAf8QVltXwjIkFbJ2
tACSXlGneQy4tACZOcczWN8A66FJXLZK3sauGtUFOSAtdhYQFx8ziiiAPvb55Ukc
6NoDXx1jq2zcjB3t8IjxmQnYMbwACeUwZa2ABbYy9qeTiRGoqNtQiosAv5nFx02X
iIKJCWXbauPE+Cvf/m3APKLiU9RKhgr4kXVakyj+azBcyNpm1V0mfv08ohioS50e
voWRaMyT9a4A8wwEoNebKriHWosp2NE9zajUzHZ5vxVYtJWu3aytbn3GR/AGnS8L
KGOsusxwuhQZzY2JBEXLOPB/kvoq8dzN1jgXQoa5x9ps1RZVGazMJ5UhZPWDbxn9
ykJJ9/19KqB9Ey1V1fmVIGkfvO4mjRUMSollEMM0H/IjxNi8Zf0c+gY8vBVNr83t
Lc2mTmUi3qZYHP1LPdawMrPq2xoTbP3Byqy28eY/fdM18u7r7s3NHG/wWMfcTKS7
vIA8uchqpcC93E6lNDKs
=wIE7
-----END PGP SIGNATURE-----

--Signature=_Sun__9_Mar_2014_12_14_39_+0000_Xos3G7sOXw8QUuRr--
