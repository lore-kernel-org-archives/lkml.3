Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909Ab3H0I1D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 04:27:03 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:36975 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889Ab3H0I1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 04:27:00 -0400
Date: Tue, 27 Aug 2013 18:26:58 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: linux-next: manual merge of the arm-soc tree with Linus' tree
Message-Id: <20130827182658.a82bec791f85c98c69751388@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__27_Aug_2013_18_26_58_+1000_phZKq.4Es=_6mhk4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__27_Aug_2013_18_26_58_+1000_phZKq.4Es=_6mhk4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/boot/dts/tegra20-seaboard.dts between commit 30ca2226bea6 ("ARM:
tegra: always enable USB VBUS regulators") from Linus' tree and commit
23f95ef2d951 ("ARM: tegra: use TEGRA_GPIO() in a couple more places")
from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/boot/dts/tegra20-seaboard.dts
index c824253,f44a9b8..0000000
--- a/arch/arm/boot/dts/tegra20-seaboard.dts
+++ b/arch/arm/boot/dts/tegra20-seaboard.dts
@@@ -828,9 -829,7 +828,9 @@@
  			regulator-min-microvolt =3D <5000000>;
  			regulator-max-microvolt =3D <5000000>;
  			enable-active-high;
- 			gpio =3D <&gpio 24 0>; /* PD0 */
+ 			gpio =3D <&gpio TEGRA_GPIO(D, 0) 0>;
 +			regulator-always-on;
 +			regulator-boot-on;
  		};
  	};
 =20

--Signature=_Tue__27_Aug_2013_18_26_58_+1000_phZKq.4Es=_6mhk4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSHGLSAAoJEECxmPOUX5FETHUP/18cNPI/FwsQfX0+pLUkmzEG
a1pHASO6XM+pk2mbqPVn/vQfs9pt7LBiKA8LgGHmqCN8gB/qy0PfsDSmCsdLcOe0
dh9qgPFU1RlDljhCP5TNyrSCLlm1kRFrG/1XzbqMMHs20xwLZbhGTqN495tFhYBV
4Ti9LB48AGSLE2Amptg+52azupyHyEErOjVUNYlJwev+LvOMRFqqTaVaUKH788Og
fzWxlhe9las2VxneLjXTwwOroDme38eQGHgN2cXETp5qO/ek/J1AQhUo/zoyXvBk
DXYc7celYTy55sEmyFyCjBQ54GAPSfiI1WPXq7TIirUFdZSb4BjXBmWo9K3XdWQR
H2HqsUXTZncOGu7XsffNVKPiatLnX+bvhyXvZjTYVTQkH0FJp0DdVrGr6t71S19F
ZSh51NznlV6lHoZGBNbJa9I4c2weuGBjuAXnsx8vX6MyuqtkxU0+mOycUUsAzQzY
+DFpnUMI+g6tPYU/dNn+KOqhCyZrG3uqT4bn77bzcS6AyD9fkSWsD5jcNgERwwtT
3SghWukYT53aFAW4w3MDlTnqIULn16IjUeoBeWIJZcLsEKgwKVIZuqOWgiXQbw7g
avA2jVCgfzzmkKbADmXyCkfIZuDN5goDseOUG4qI43BA0P8EyaiPrYVhXFfx9KC3
7Aoq8Xz2YwErtwVo9tW1
=VOg3
-----END PGP SIGNATURE-----

--Signature=_Tue__27_Aug_2013_18_26_58_+1000_phZKq.4Es=_6mhk4--
