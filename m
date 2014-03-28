Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757523AbaC1DkB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 23:40:01 -0400
Received: from ozlabs.org ([203.10.76.45]:55025 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757221AbaC1DkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 23:40:00 -0400
Date: Fri, 28 Mar 2014 14:39:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Carlo Caione <carlo@caione.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: linux-next: manual merge of the tip tree with the arm-soc tree
Message-Id: <20140328143952.7a77bc128f4affc3efd48ddf@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__28_Mar_2014_14_39_52_+1100_MY+fwB=1zg6Gt1oJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__28_Mar_2014_14_39_52_+1100_MY+fwB=1zg6Gt1oJ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
arch/arm/boot/dts/sun7i-a20.dtsi between commit 36ab3e73b7ac ("ARM: dt:
sun7i: Add A20 SPI controller nodes") from the arm-soc tree and commit
8ff973a26763 ("ARM: sun7i/sun6i: dts: Add NMI irqchip support") from the
tip tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/boot/dts/sun7i-a20.dtsi
index 024a01ce4f0c,cadcf2f9881d..000000000000
--- a/arch/arm/boot/dts/sun7i-a20.dtsi
+++ b/arch/arm/boot/dts/sun7i-a20.dtsi
@@@ -401,28 -339,14 +401,36 @@@
  		#size-cells =3D <1>;
  		ranges;
 =20
 +		spi0: spi@01c05000 {
 +			compatible =3D "allwinner,sun4i-a10-spi";
 +			reg =3D <0x01c05000 0x1000>;
 +			interrupts =3D <0 10 4>;
 +			clocks =3D <&ahb_gates 20>, <&spi0_clk>;
 +			clock-names =3D "ahb", "mod";
 +			status =3D "disabled";
 +			#address-cells =3D <1>;
 +			#size-cells =3D <0>;
 +		};
 +
 +		spi1: spi@01c06000 {
 +			compatible =3D "allwinner,sun4i-a10-spi";
 +			reg =3D <0x01c06000 0x1000>;
 +			interrupts =3D <0 11 4>;
 +			clocks =3D <&ahb_gates 21>, <&spi1_clk>;
 +			clock-names =3D "ahb", "mod";
 +			status =3D "disabled";
 +			#address-cells =3D <1>;
 +			#size-cells =3D <0>;
 +		};
 +
+ 		nmi_intc: interrupt-controller@01c00030 {
+ 			compatible =3D "allwinner,sun7i-a20-sc-nmi";
+ 			interrupt-controller;
+ 			#interrupt-cells =3D <2>;
+ 			reg =3D <0x01c00030 0x0c>;
+ 			interrupts =3D <0 0 4>;
+ 		};
+=20
  		emac: ethernet@01c0b000 {
  			compatible =3D "allwinner,sun4i-a10-emac";
  			reg =3D <0x01c0b000 0x1000>;

--Signature=_Fri__28_Mar_2014_14_39_52_+1100_MY+fwB=1zg6Gt1oJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTNO8NAAoJEMDTa8Ir7ZwVY/AP/2SIWbozXxOj2pyResQvHTdr
Yq+VnQTINMGLaGWcie7jQNHIlZIk1APffccJcV8FKI3TM74QaUKO7Yj2xfpHfPsF
9xNi9VEet85mOkS5xHvY9imXUcvFM/h23uDTyH8tg7QoJdet8a3Xmi+yC9BsRNAt
IYJWCp+Kj+9C+2kZtKPRAKFLxYfKXa/fRytj/GgCF9xEV+dZYBC9+y+qF0D0/JTy
Ccoi0qIG1NqRNnp2FkpBdTmma+g3RRoKgJzt+A71b6IqH3KXcrLI8UuNTXqfYgbf
VX2yjnMNvZNgg3ur6Hjd8ieU2eKyW18FLMwKySCUrm0Sn4TGBLl+3kz6l8lTRycH
NGDgxrUUZ6YtXZFx8z4PK5iSBtoUfEvutNn3s6OLQUJ2cNZVW2UQvE8JaPada+gW
iC2z9zSRnhfy9tKqtXmpZ7lv46K5SNzGDzdXKo4Z0M6VmQKMtzy/PnVlXWlFPlAq
6hMYQ8uW9eayAXyYPd071kuasZRksWLiXe8NY/aC9E3kgxt0OOhPUm3X4qPFky8b
oMyOa/9Fub0bwgYf6K3JHjw4J3run87NO+zN16D+/ZNnAga++RACzhr1AQf2eJ1w
9wHIX+AUfvSOMjKyb4T+NkcQrNUZBYt4d3Uf0w6cbo95jhFWJm843zSGqbzmwjBs
fuVOGl0pAnpqKJWkPeeP
=YheQ
-----END PGP SIGNATURE-----

--Signature=_Fri__28_Mar_2014_14_39_52_+1100_MY+fwB=1zg6Gt1oJ--
