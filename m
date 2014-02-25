Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870AbaBYGKD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 01:10:03 -0500
Received: from ozlabs.org ([203.10.76.45]:53266 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751655AbaBYGJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 01:09:56 -0500
Date: Tue, 25 Feb 2014 17:09:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: linux-next: manual merge of the staging tree with the arm-soc tree
Message-Id: <20140225170953.673cf5073d5682a54c1a1771@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__25_Feb_2014_17_09_53_+1100_9EVCd_nS9a_NXNl8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__25_Feb_2014_17_09_53_+1100_9EVCd_nS9a_NXNl8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
arch/arm/boot/dts/imx53-mba53.dts between commit a4a2aa9b038c ("ARM: dts:
imx53-mba53: create a container for fixed regulators") from the arm-soc
tree and commit 17b5001b5143 ("imx-drm: convert to componentised device
support") from the staging tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/boot/dts/imx53-mba53.dts
index 55af11037a00,9b6e76980a74..000000000000
--- a/arch/arm/boot/dts/imx53-mba53.dts
+++ b/arch/arm/boot/dts/imx53-mba53.dts
@@@ -35,27 -43,18 +35,33 @@@
  		status =3D "disabled";
  	};
 =20
+ 	imx-drm {
+ 		compatible =3D "fsl,imx-drm";
+ 		crtcs =3D <&ipu 1>;
+ 		connectors =3D <&disp1>, <&tve>;
+ 	};
+=20
 -	reg_3p2v: 3p2v {
 -		compatible =3D "regulator-fixed";
 -		regulator-name =3D "3P2V";
 -		regulator-min-microvolt =3D <3200000>;
 -		regulator-max-microvolt =3D <3200000>;
 -		regulator-always-on;
 +	regulators {
 +		compatible =3D "simple-bus";
 +		#address-cells =3D <1>;
 +		#size-cells =3D <0>;
 +
 +		reg_backlight: regulator@0 {
 +			compatible =3D "regulator-fixed";
 +			reg =3D <0>;
 +			regulator-name =3D "lcd-supply";
 +			gpio =3D <&gpio2 5 0>;
 +			startup-delay-us =3D <5000>;
 +		};
 +
 +		reg_3p2v: regulator@1 {
 +			compatible =3D "regulator-fixed";
 +			reg =3D <1>;
 +			regulator-name =3D "3P2V";
 +			regulator-min-microvolt =3D <3200000>;
 +			regulator-max-microvolt =3D <3200000>;
 +			regulator-always-on;
 +		};
  	};
 =20
  	sound {

--Signature=_Tue__25_Feb_2014_17_09_53_+1100_9EVCd_nS9a_NXNl8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTDDOyAAoJEMDTa8Ir7ZwVo8YP/1/NjNv7CfydTZSWTURM+OwH
ls2Da54LhFy5pIBCjLIhWdg4+ZF7dZHZx+BoDInR5CJQgpX5fNzbT4ReuVBYExeF
2kp6Vv+e+oQDO+W3ozeP8xSnQLp/keI8DvSkSkGt/B0RU/CsrORjWYuBTtxcFbwT
k18kBoQ/rz3iqFuQj08WCdT8abqWQncIGmLU+hTODlfPf2GAvjZhJ1LON5RzZ8jP
7k5Iv+MsrZEPj75+RWVI0R352JfhOSwl2Co0Ip8ggokN1vb5A0iuXEyRkZFojRKB
APzvbizq5us5+/pxd1PvPXEvUwCLhVMyh1pWn54xO5QkZJ+53dmFH2qWGdXdZ51A
EyJGyNgAVYrRhgQ1cH0PI0ftLPa2Ern+HWhRMmvrWC5RXseDxjGlu6xG5OhJPodd
3Mj1yN4oYjTtkXwP8hCFfFldYMn15KoMaHOHAtOwDYaivFJv4VV7Iy9hKbWm3h1D
/17KcRCl9ugewYaMPBHW+Cz/IGfTNFW1z7QFaKroUtFdHUOn7DC1jJo6nY/dlt3t
lzfHTHQMFwAeizAJbJl3VbDYN+9xs4iqP5rvX+1EHkcv+Q+ObIkte88TBzR3/3Fh
PXNxgoQ/9gkARlp4xcw9fdA0npJh8NRj8y14FK9lLzyaEJW9gNbzQgvkdsKZ7Gib
FyjQxenMETBFOApEdUZo
=oIgj
-----END PGP SIGNATURE-----

--Signature=_Tue__25_Feb_2014_17_09_53_+1100_9EVCd_nS9a_NXNl8--
