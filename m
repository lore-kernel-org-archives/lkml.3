Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816AbaBYGKA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 01:10:00 -0500
Received: from ozlabs.org ([203.10.76.45]:57724 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751679AbaBYGJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 01:09:58 -0500
Date: Tue, 25 Feb 2014 17:09:55 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Shawn Guo <shawn.guo@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Liu Ying <Ying.Liu@freescale.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: linux-next: manual merge of the staging tree with the imx-mxs tree
Message-Id: <20140225170955.e0395e1c520a0b2fc4c2549c@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__25_Feb_2014_17_09_55_+1100_t3Icu58jrEPLeKaB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__25_Feb_2014_17_09_55_+1100_t3Icu58jrEPLeKaB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
arch/arm/boot/dts/imx51-babbage.dts between commit a198af2322a1 ("ARM:
dts: i.MX51 babbage: Support diagnostic LED") from the imx-mxs tree and
commit 17b5001b5143 ("imx-drm: convert to componentised device support")
from the staging tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/boot/dts/imx51-babbage.dts
index 121dadd125c0,6ff15a0eacb3..000000000000
--- a/arch/arm/boot/dts/imx51-babbage.dts
+++ b/arch/arm/boot/dts/imx51-babbage.dts
@@@ -81,17 -81,12 +81,23 @@@
  		};
  	};
 =20
 +	leds {
 +		compatible =3D "gpio-leds";
 +		pinctrl-names =3D "default";
 +		pinctrl-0 =3D <&pinctrl_gpio_leds>;
 +
 +		led-diagnostic {
 +			label =3D "diagnostic";
 +			gpios =3D <&gpio2 6 GPIO_ACTIVE_HIGH>;
 +		};
 +	};
 +
+ 	imx-drm {
+ 		compatible =3D "fsl,imx-drm";
+ 		crtcs =3D <&ipu 0>, <&ipu 1>;
+ 		connectors =3D <&display0>, <&display1>;
+ 	};
+=20
  	sound {
  		compatible =3D "fsl,imx51-babbage-sgtl5000",
  			     "fsl,imx-audio-sgtl5000";

--Signature=_Tue__25_Feb_2014_17_09_55_+1100_t3Icu58jrEPLeKaB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTDDOzAAoJEMDTa8Ir7ZwVtiAQAICypVTxY0AmUi1/57tGA9is
N7JqlTq2tNSbQ84098MCzh9XhA+91CU5CNgLqGrrTWi8vhE/WsoQpyTg/U0h6hbM
LkIHyQTR5WiZU+9961z/BUMmR3lrLrjI46+J/tv/c6ZNjY2DHYT+tPz8CQ5xq6fy
rSOS8X3wmgnn45hhc/7sZeQx31Be3tOatRYGzdwiLDLAR0RkU7Hah+h0Yo3hWIIN
5SHpe8Ay01RMDZvik3uSRw69lzId8C9fT0SAABq7I0tU4Oyx+pQ8IBWKWOWyZRxG
rdoP7nG6NRW78CZvmV03CqxrpsqvRjwL1SzP6N14PofYpRkbZpEukSg0/9qbJnvt
R6ObTRK3t8kUIsrQBZ1T1rUhlHgvXrL90vfRdwPBy2fWOerBHhgy3xGopQv7WJJX
IMtl/hdd8Dh56BOQrfQ1aNpAdyJNQ0NTjfbLM1BteZf7SpXdmaU+2U/KQhOssPsR
Aro8kvxk5KKfERVJaJu+8yYGDnXCovpvb5CAEL4/Ct7irqG7rtLcdI2FyWdGEicK
POOXSPeQs0Efx5saGfS29NtXdm/KMuI8Bp67UHNAWvmo+aOsD2vG8eJONNf707hu
9LlUIaQLbKkWbVrmGRjj/IC0CEwwJb8HC7uN0fZcM+AjXS/ZJygKSWsL7qQsgAVd
T/fkMRNmqTm5Tp08EUe7
=ZhAO
-----END PGP SIGNATURE-----

--Signature=_Tue__25_Feb_2014_17_09_55_+1100_t3Icu58jrEPLeKaB--
