Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600Ab3H2Hkj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 03:40:39 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:55195 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755324Ab3H2Hkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 03:40:37 -0400
Date: Thu, 29 Aug 2013 17:40:34 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vladimir Barinov <vladimir.barinov@cogentembedded.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Magnus Damm <damm@opensource.se>, Simon Horman <horms@verge.net.au>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Subject: linux-next: manual merge of the arm-soc tree with the v4l-dvb tree
Message-Id: <20130829174034.9594cef414d41a2943160ba3@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__29_Aug_2013_17_40_34_+1000_GGH=8Gv2bXAaNVu0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__29_Aug_2013_17_40_34_+1000_GGH=8Gv2bXAaNVu0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-shmobile/board-marzen.c between commit 7cef5e7fd1ab
("[media] ARM: shmobile: Marzen: add VIN and ADV7180 support") from the
v4l-dvb tree and commits 85469abe4930 ("ARM: shmobile: Remove Marzen use
of <mach/hardware.h>") and fee529df76ff ("ARM: shmobile: r8a7779: cleanup
registration of usb phy") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-shmobile/board-marzen.c
index ca7fb2e,3551b54..0000000
--- a/arch/arm/mach-shmobile/board-marzen.c
+++ b/arch/arm/mach-shmobile/board-marzen.c
@@@ -38,8 -38,6 +39,7 @@@
  #include <linux/mmc/host.h>
  #include <linux/mmc/sh_mobile_sdhi.h>
  #include <linux/mfd/tmio.h>
 +#include <media/soc_camera.h>
- #include <mach/hardware.h>
  #include <mach/r8a7779.h>
  #include <mach/common.h>
  #include <mach/irqs.h>
@@@ -212,8 -203,7 +231,9 @@@ static struct platform_device *marzen_d
  	&thermal_device,
  	&hspi_device,
  	&leds_device,
 +	&camera0_device,
 +	&camera1_device,
+ 	&usb_phy,
  };
 =20
  static const struct pinctrl_map marzen_pinctrl_map[] =3D {
@@@ -274,9 -254,6 +294,8 @@@ static void __init marzen_init(void
  	r8a7779_init_irq_extpin(1); /* IRQ1 as individual interrupt */
 =20
  	r8a7779_add_standard_devices();
- 	r8a7779_add_usb_phy_device(&usb_phy_platform_data);
 +	r8a7779_add_vin_device(1, &vin_platform_data);
 +	r8a7779_add_vin_device(3, &vin_platform_data);
  	platform_add_devices(marzen_devices, ARRAY_SIZE(marzen_devices));
  }
 =20

--Signature=_Thu__29_Aug_2013_17_40_34_+1000_GGH=8Gv2bXAaNVu0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSHvryAAoJEECxmPOUX5FE8OUP/3dDQQeJcBzSc6Xqb6qfNueo
x/wgM4R05jrYyoRQO5txB67kiDskBPupKE+CIwZ1ZTbp7R2tBliFy9dR2CIEEbHs
Z0d8BhqtZtjs2+IYlwgcXtPzXS0c0KTWARB1DiKNoTmymXtQcJnHqa2EIDdZ+aNY
nYvoukQdglzq1ovCAd1FEOF9el0ImGnAUFLyAU7lhOWO5hbKoG8UT+cEdYKtAjee
hrTZvUGEu/Fhr35xoP8NiCd8r2PCY12DIpbBfFjJldcQnL9KogOvETQx1GJ0yTGc
PQ8cYa5wRLm4NJOPfKkok/82+lDN5PA7BvWb9CgxtcZpO9fUJEUcg1OMRQOusXmF
/gQm/ojKtzmbJH+N65vHNGjgdfLbvSvkbQ078z0Dbuij+676WTzlidlJPrQkxQf0
KJMKfNq+AvIBYbfIM3ERFrKrgYQEfj1tWVaCWhL9x98eLHB7UUDcAzue145wVpSp
wlvfXwnFvFtJ24LC5hkleQt1WivzcQF+NwvG65U2w7fycwLFXe8GRvXIbGQ3nCHA
+j4lutWcS1p4+c+I367BTVKE0dJKH48jXyQLLnp54O0HQpkr9iaZZvLPQZDKCwZf
yaFM+aU8F9Xcb7Ao27njkFHjsZ0QAux7oeHhkJCwQNWbeezd9RPs0yJBCZCBnYiw
s0ZKpXTwIdgr8gXqO/U7
=VRhz
-----END PGP SIGNATURE-----

--Signature=_Thu__29_Aug_2013_17_40_34_+1000_GGH=8Gv2bXAaNVu0--
