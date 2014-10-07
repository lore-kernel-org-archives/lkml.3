Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701AbaJGBjf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 21:39:35 -0400
Received: from ozlabs.org ([103.22.144.67]:58455 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213AbaJGBje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 21:39:34 -0400
Date: Tue, 7 Oct 2014 12:39:26 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Michal Marek <mmarek@suse.cz>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Masahiro Yamada <yamada.m@jp.panasonic.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: linux-next: manual merge of the kbuild tree with the arm-soc tree
Message-ID: <20141007123926.0e14810b@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/+W4x89nc9=D05=apSN6n0y+"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/+W4x89nc9=D05=apSN6n0y+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Michal,

Today's linux-next merge of the kbuild tree got a conflict in
arch/arm/mach-at91/Makefile between commit 91a55d4f6900 ("ARM: at91:
introduce OLD_IRQ_AT91 Kconfig option") from the arm-soc tree and
commit ac84eb47cc19 ("kbuild: remove unnecessary variable
initializaions") from the kbuild tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-at91/Makefile
index ac99d87ffefe,75033839fc08..000000000000
--- a/arch/arm/mach-at91/Makefile
+++ b/arch/arm/mach-at91/Makefile
@@@ -2,13 -2,12 +2,10 @@@
  # Makefile for the linux kernel.
  #
 =20
 -obj-y		:=3D irq.o gpio.o setup.o sysirq_mask.o
 +obj-y		:=3D gpio.o setup.o sysirq_mask.o
- obj-m		:=3D
- obj-n		:=3D
- obj-		:=3D
 =20
 +obj-$(CONFIG_OLD_IRQ_AT91)	+=3D irq.o
  obj-$(CONFIG_OLD_CLK_AT91)	+=3D clock.o
 -obj-$(CONFIG_AT91_SAM9_ALT_RESET) +=3D at91sam9_alt_reset.o
 -obj-$(CONFIG_AT91_SAM9G45_RESET) +=3D at91sam9g45_reset.o
 -obj-$(CONFIG_AT91_SAM9_TIME)	+=3D at91sam926x_time.o
  obj-$(CONFIG_SOC_AT91SAM9)	+=3D sam9_smc.o
 =20
  # CPU-specific support

--Sig_/+W4x89nc9=D05=apSN6n0y+
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUM0RSAAoJEMDTa8Ir7ZwVYxkP/1MFmY9NknTqf2Tlcq4wkpbp
YWgnWQN3Nq//1/hxiVvIuHIlNUJS308TEd3KI6lV7pls8cIWIny732EGZBYbJCxd
A56KtkOSKA2lOqqIrmqWTbOh1RMkUFmi34Gj98XSt0HzL6HUPBEthc9BT/UfJ5PF
hCyV8VuXERYlSUsfDyjZGY5nSphgP5uoX40ChWA9zYfpZEQe6TunlkzbXDBL5ozk
ky5d4IGacHMSTpWw+kDOZRxVbWx+dfrn8U9mI7egQSDhWmzaoe5250R8g0jTOOVZ
EkRjwauvBRbkeG7qA/NFIiGDB2fQnu9YDOWb1LxDjDoDUp27ESUCkdKpP+IV6qWx
g0z2/l22v4zPXm5OcOak8SMnTybk+ZJpJmvVseKOKzO1GI6Z+ZZKKhk7AKIEajTq
gH9DAw/q1xcsUxU8EmMmpYUJWmYrUcaVL5NynDhti32ObUMriNfha1dRiK+43tLr
kheBGIurvdNukF4nXf5WHF4hqYnFimtG+oFtA/QkG7zeN5g+6Bv9W4QEu5LzAOOF
lUd6a9j+GgdiTpKK3u1FjuU4/ipYl5TOtTzyjWOFtxbKluK1FzbiUiCA+jp1EQkp
z/sQuMnLITfYrezB7TKI+kIKgRgu4M0Ih/OEHxWgA9w2r0NI6xr2fAg6nn06Zvd7
Hjhwxs2hw4foLYq60lHF
=CYoF
-----END PGP SIGNATURE-----

--Sig_/+W4x89nc9=D05=apSN6n0y+--
