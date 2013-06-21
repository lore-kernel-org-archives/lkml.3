Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161303Ab3FUFyN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 01:54:13 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:54106 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161096Ab3FUFyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 01:54:11 -0400
Date: Fri, 21 Jun 2013 15:54:08 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pantelis Antoniou <panto@antoniou-consulting.com>,
        "Patil, Rachna" <rachna@ti.com>, Felipe Balbi <balbi@ti.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Philip Avinash <avinashphilip@ti.com>, Pekon Gupta <pekon@ti.com>,
        Benoit Cousson <benoit.cousson@linaro.org>
Subject: linux-next: manual merge of the arm-soc tree with the mfd tree
Message-Id: <20130621155408.7e4a4c891ff4d74627b57a45@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__21_Jun_2013_15_54_08_+1000_kyWtlnJ.2c3f8EiO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__21_Jun_2013_15_54_08_+1000_kyWtlnJ.2c3f8EiO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/boot/dts/am33xx.dtsi between commit a82279dd6d3e ("arm: am33xx:
add TSC/ADC mfd device support") from the mfd tree and commit
15e8246bd61b ("ARM: dts: AM33XX: Add ELM node") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/boot/dts/am33xx.dtsi
index 37ef320,0d4df90..0000000
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@@ -404,24 -494,14 +494,32 @@@
  			ti,hwmods =3D "wkup_m3";
  		};
 =20
 +		tscadc: tscadc@44e0d000 {
 +			compatible =3D "ti,am3359-tscadc";
 +			reg =3D <0x44e0d000 0x1000>;
 +			interrupt-parent =3D <&intc>;
 +			interrupts =3D <16>;
 +			ti,hwmods =3D "adc_tsc";
 +			status =3D "disabled";
 +
 +			tsc {
 +				compatible =3D "ti,am3359-tsc";
 +			};
 +			am335x_adc: adc {
 +				#io-channel-cells =3D <1>;
 +				compatible =3D "ti,am3359-adc";
 +			};
 +
 +		};
 +
+ 		elm: elm@48080000 {
+ 			compatible =3D "ti,am3352-elm";
+ 			reg =3D <0x48080000 0x2000>;
+ 			interrupts =3D <4>;
+ 			ti,hwmods =3D "elm";
+ 			status =3D "disabled";
+ 		};
+=20
  		gpmc: gpmc@50000000 {
  			compatible =3D "ti,am3352-gpmc";
  			ti,hwmods =3D "gpmc";

--Signature=_Fri__21_Jun_2013_15_54_08_+1000_kyWtlnJ.2c3f8EiO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRw+qAAAoJEECxmPOUX5FEBO8QAKBSKPuKwALtFT1KpxyfTTgW
kuwHtaDlnFeQwazXMCmmpKNVU+cg2/klocAS2E/f/jklSWqZO+wPB4yPK0bYS9mJ
dP7sAuPC5KDNMfg+pEjQg+viWCtXys/Zp4BUuHR+h4D4EZCIUxkfmsOM/p3u9Rt1
luXf7UckGSObPoF/Viaua/URUr8i5BgNxUjF36HIirO3+y8KRSFGSYkNGWoufa3+
dTnYoqs1+t7u71OMWxIStLQgpzbGxdp1CRneOG/JS9L/njzbTy/SChH0MItiLbpr
lxhHiMi1n2g3wP9c56mJv3kJZ79klupK2M6dM6ikQYMEyFLh0KDpszOR0o2cQtyX
lzBBleai5ZGH3AmniOdHBgSHMDMdM9GLCvDIiTVRxW64wsKhtNJIBydAOFGhnO9J
H5V5ApnL6WbloPb88Zpx1muwXJMUKhu5MW4ufdWccGPv0drldzp2gBlXzoX+iozc
ZxCW1qoh9jPFcDg8aJdte4QJmDNTOYCumIBz31zijsz/kACt97qy2DzeOSyOj4ia
E1zdmK1dE9yCPcTLbgVnBOS8QNYb2x4S08kdo2ubPDDaaN6Sor/OWKACsAlidgOK
PmEy/N38FkJCWeKaH2diUHbsiWdRFgMvffIpjZ7JdA7NGs9MQz/wsRGKc1vimKDa
XivlUu6xsRXrkp8Tc7lH
=7sVF
-----END PGP SIGNATURE-----

--Signature=_Fri__21_Jun_2013_15_54_08_+1000_kyWtlnJ.2c3f8EiO--
